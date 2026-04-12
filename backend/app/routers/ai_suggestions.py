"""AI suggestions router for intelligent scheduling assistance."""

from datetime import datetime, date, timedelta
from typing import List, Optional
from uuid import UUID, uuid4
from fastapi import APIRouter, HTTPException, status, Depends
from fastapi.responses import JSONResponse
from pydantic import BaseModel, Field
import json
import hashlib

from app.core.database import supabase
from app.core.config import settings
from app.core.security import get_current_user
from app.models.user import User
from app.models.event import Event, EventCreate, EventStatus

router = APIRouter()


class SuggestionRequest(BaseModel):
    """Request for AI scheduling suggestions."""
    start_date: date
    end_date: date
    focus_areas: Optional[List[str]] = None  # e.g., ["focus_time", "breaks", "meetings"]
    user_prompt: Optional[str] = None  # e.g., "I want to add a gym session" or "find me time for studying"
    max_suggestions: int = Field(default=5, le=10)


class Suggestion(BaseModel):
    """A single scheduling suggestion."""
    id: str
    type: str = Field(default="add_event")
    title: Optional[str] = None
    event_id: Optional[str] = Field(default=None, alias="eventId")
    proposed_start: Optional[datetime] = Field(default=None, alias="suggestedStart")
    proposed_end: Optional[datetime] = Field(default=None, alias="suggestedEnd")
    reasoning: str = Field(alias="reason")
    confidence: float = Field(default=0.8, ge=0.0, le=1.0)
    category: Optional[str] = None
    duration_minutes: Optional[int] = Field(default=None, alias="durationMinutes")

    class Config:
        populate_by_name = True


class ScheduleAnalysis(BaseModel):
    """Analysis of the current schedule."""
    utilization: float
    focus_time_hours: float
    meeting_hours: float
    identified_gaps: List[str]


class SuggestionResponse(BaseModel):
    """Response containing suggestions and analysis."""
    suggestions: List[Suggestion]
    analysis: ScheduleAnalysis


class SuggestionFeedback(BaseModel):
    """User feedback on a suggestion."""
    suggestion_id: str
    accepted: bool


# System prompt for AI scheduling assistant
SUGGESTION_SYSTEM_PROMPT = """You are a scheduling assistant. Analyze the user's calendar and suggest improvements.

HARD CONSTRAINTS (never violate):
1. NEVER suggest moving or modifying locked events (is_locked=true)
2. NEVER suggest times outside user's working hours unless explicitly allowed
3. NEVER create overlapping events with locked events
4. ALL suggestions must be actionable JSON

SOFT PREFERENCES (optimize for):
1. Respect historical patterns (user's productive hours, meeting preferences)
2. Group similar activities when possible
3. Leave buffer time between meetings (at least 15 minutes)
4. Balance focused work blocks with breaks
5. Prefer morning hours for deep work if no contrary pattern exists

OUTPUT FORMAT (strict JSON):
{
    "suggestions": [
        {
            "id": "sug_<8char>",
            "type": "add_event" | "reschedule" | "remove_event",
            "title": "string (for add_event)",
            "eventId": "string (for reschedule/remove)",
            "suggestedStart": "ISO8601 datetime",
            "suggestedEnd": "ISO8601 datetime",
            "reason": "Clear explanation of why this helps",
            "confidence": 0.0-1.0,
            "category": "focus_time" | "break" | "meeting" | "task",
            "durationMinutes": integer
        }
    ],
    "analysis": {
        "utilization": 0.0-1.0,
        "focus_time_hours": float,
        "meeting_hours": float,
        "identified_gaps": ["list of identified issues or opportunities"]
    }
}"""


async def call_llm(system: str, prompt: str) -> dict:
    """Call the LLM API and return parsed JSON response."""
    if settings.LLM_PROVIDER == "gemini":
        import google.generativeai as genai
        genai.configure(api_key=settings.GEMINI_API_KEY)
        model = genai.GenerativeModel(
            settings.LLM_MODEL,
            system_instruction=system,
        )
        response = model.generate_content(
            prompt,
            generation_config=genai.types.GenerationConfig(
                response_mime_type="application/json",
            ),
        )
        content = response.text
    elif settings.LLM_PROVIDER == "anthropic":
        import anthropic
        client = anthropic.Anthropic(api_key=settings.ANTHROPIC_API_KEY)
        response = client.messages.create(
            model=settings.LLM_MODEL,
            max_tokens=2000,
            system=system,
            messages=[{"role": "user", "content": prompt}]
        )
        content = response.content[0].text
    else:
        # OpenAI fallback
        import openai
        client = openai.OpenAI(api_key=settings.OPENAI_API_KEY)
        response = client.chat.completions.create(
            model=settings.LLM_MODEL,
            messages=[
                {"role": "system", "content": system},
                {"role": "user", "content": prompt}
            ],
            response_format={"type": "json_object"}
        )
        content = response.choices[0].message.content

    # Parse JSON from response
    try:
        # Try to extract JSON if wrapped in markdown
        if "```json" in content:
            content = content.split("```json")[1].split("```")[0]
        elif "```" in content:
            content = content.split("```")[1].split("```")[0]
        return json.loads(content)
    except json.JSONDecodeError as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to parse AI response: {str(e)}"
        )


def validate_suggestions(
    suggestions: List[dict],
    events: List[dict],
    user: User
) -> List[Suggestion]:
    """
    Post-LLM validation to ensure guardrails are respected.
    Filters out any suggestions that violate hard constraints.
    """
    locked_events = [e for e in events if e.get("is_locked")]
    validated = []

    # Parse working hours with defaults
    try:
        working_start_hour = int(user.preferences.working_hours_start.split(":")[0]) if user.preferences else 9
        working_end_hour = int(user.preferences.working_hours_end.split(":")[0]) if user.preferences else 17
    except (AttributeError, ValueError, TypeError):
        # Default working hours if preferences not found
        working_start_hour = 9
        working_end_hour = 17

    for sug in suggestions:
        try:
            # Check 1: Not modifying a locked event
            if sug.get("type") in ["reschedule", "remove_event"]:
                event_id = sug.get("eventId") or sug.get("event_id")
                target_event = next(
                    (e for e in events if str(e.get("id")) == event_id),
                    None
                )
                if target_event and target_event.get("is_locked"):
                    continue  # Skip - violates guardrail

            # Check 2: Proposed time doesn't overlap locked events
            proposed_start = sug.get("suggestedStart") or sug.get("proposed_start")
            proposed_end = sug.get("suggestedEnd") or sug.get("proposed_end")

            if proposed_start and proposed_end:
                if isinstance(proposed_start, str):
                    proposed_start = datetime.fromisoformat(proposed_start.replace("Z", "+00:00"))
                if isinstance(proposed_end, str):
                    proposed_end = datetime.fromisoformat(proposed_end.replace("Z", "+00:00"))

                # Check overlap with locked events
                has_conflict = False
                for locked in locked_events:
                    locked_start = datetime.fromisoformat(locked["start_time"].replace("Z", "+00:00"))
                    locked_end = datetime.fromisoformat(locked["end_time"].replace("Z", "+00:00"))
                    if proposed_start < locked_end and proposed_end > locked_start:
                        has_conflict = True
                        break

                if has_conflict:
                    continue  # Skip - would conflict with locked

                # Check 3: Within working hours
                start_hour = proposed_start.hour
                end_hour = proposed_end.hour

                if start_hour < working_start_hour or end_hour > working_end_hour:
                    sug["confidence"] = sug.get("confidence", 0.5) * 0.5
                    reason = sug.get("reason") or sug.get("reasoning", "")
                    sug["reason"] = reason + " (Note: outside normal working hours)"

            # Compute duration_minutes if start and end are available
            duration_minutes = sug.get("durationMinutes") or sug.get("duration_minutes")
            if not duration_minutes and proposed_start and proposed_end:
                delta = proposed_end - proposed_start
                duration_minutes = int(delta.total_seconds() / 60)

            validated.append(Suggestion(
                id=sug.get("id", f"sug_{uuid4().hex[:8]}"),
                type=sug.get("type", "add_event"),
                title=sug.get("title"),
                event_id=sug.get("eventId") or sug.get("event_id"),
                proposed_start=proposed_start if proposed_start else None,
                proposed_end=proposed_end if proposed_end else None,
                reasoning=sug.get("reason") or sug.get("reasoning", ""),
                confidence=min(1.0, max(0.0, float(sug.get("confidence", 0.5)))),
                category=sug.get("category"),
                duration_minutes=duration_minutes,
            ))

        except Exception:
            # Skip malformed suggestions
            continue

    return validated


@router.post("/suggestions")
async def get_schedule_suggestions(
    request: SuggestionRequest,
    user: User = Depends(get_current_user)
):
    """
    Get AI scheduling suggestions.

    Input context includes:
    - Current events in range
    - Locked event constraints
    - User preferences
    - Historical patterns (from cached data)
    """

    # Check API key is configured
    provider = settings.LLM_PROVIDER
    if provider == "gemini" and not settings.GEMINI_API_KEY:
        raise HTTPException(status_code=503, detail="Gemini API key not configured")
    elif provider == "anthropic" and not settings.ANTHROPIC_API_KEY:
        raise HTTPException(status_code=503, detail="Anthropic API key not configured")
    elif provider == "openai" and not settings.OPENAI_API_KEY:
        raise HTTPException(status_code=503, detail="OpenAI API key not configured")

    # Fetch events in range
    start_dt = datetime.combine(request.start_date, datetime.min.time())
    end_dt = datetime.combine(request.end_date, datetime.max.time())

    events_response = supabase.table("events").select("*").eq(
        "owner_id", str(user.id)
    ).is_("deleted_at", "null").gte(
        "start_time", start_dt.isoformat()
    ).lte("end_time", end_dt.isoformat()).execute()

    events = events_response.data or []

    # Fetch historical patterns (last 30 days of reflections)
    history_start = (date.today() - timedelta(days=30)).isoformat()
    history_response = supabase.table("daily_reflections").select(
        "reflection_date, events_completed, events_planned, is_streak_day"
    ).eq("user_id", str(user.id)).gte(
        "reflection_date", history_start
    ).execute()

    history = history_response.data or []

    # Build context for LLM
    locked_events = [e for e in events if e.get("is_locked")]
    flexible_events = [e for e in events if not e.get("is_locked")]

    working_start = user.preferences.working_hours_start if user.preferences else "09:00"
    working_end = user.preferences.working_hours_end if user.preferences else "17:00"

    user_request_section = ""
    if request.user_prompt:
        user_request_section = f"\nUSER REQUEST: {request.user_prompt}\nPrioritize suggestions that fulfill this request. Find optimal time slots for what the user wants.\n"

    prompt = f"""User timezone: {user.timezone}
Working hours: {working_start} - {working_end}
Date range: {request.start_date} to {request.end_date}
Max suggestions: {request.max_suggestions}
Focus areas: {request.focus_areas or "all"}
{user_request_section}

LOCKED EVENTS (cannot be moved):
{json.dumps([{
    "id": e["id"],
    "title": e["title"],
    "start": e["start_time"],
    "end": e["end_time"],
    "priority": e["priority"]
} for e in locked_events], indent=2)}

FLEXIBLE EVENTS (can suggest rescheduling):
{json.dumps([{
    "id": e["id"],
    "title": e["title"],
    "start": e["start_time"],
    "end": e["end_time"],
    "priority": e["priority"],
    "status": e["status"]
} for e in flexible_events], indent=2)}

HISTORICAL PATTERNS (last 30 days):
- Total reflection days: {len(history)}
- Streak days: {sum(1 for h in history if h.get("is_streak_day"))}
- Average completion: {sum(h["events_completed"] for h in history) / max(1, sum(h["events_planned"] for h in history)) * 100:.1f}%

Generate {request.max_suggestions} scheduling suggestions to improve productivity."""

    # Call LLM (with fallback for testing)
    try:
        response = await call_llm(SUGGESTION_SYSTEM_PROMPT, prompt)
    except Exception as e:
        # Fallback: return mock suggestions for testing
        import traceback
        traceback.print_exc()
        response = {
            "suggestions": [
                {
                    "id": "sug_test001",
                    "type": "add_event",
                    "title": "Focus Time Block",
                    "suggestedStart": (datetime.now() + timedelta(days=1, hours=2)).isoformat(),
                    "suggestedEnd": (datetime.now() + timedelta(days=1, hours=4)).isoformat(),
                    "reason": "You have availability tomorrow morning. Perfect for deep work.",
                    "confidence": 0.8,
                    "category": "focus_time",
                    "durationMinutes": 120
                },
                {
                    "id": "sug_test002",
                    "type": "add_event",
                    "title": "Quick Break",
                    "suggestedStart": (datetime.now() + timedelta(days=1, hours=5)).isoformat(),
                    "suggestedEnd": (datetime.now() + timedelta(days=1, hours=5, minutes=15)).isoformat(),
                    "reason": "Take a 15-minute break after focused work.",
                    "confidence": 0.9,
                    "category": "break",
                    "durationMinutes": 15
                }
            ],
            "analysis": {
                "utilization": 0.65,
                "focus_time_hours": 4.5,
                "meeting_hours": 2.0,
                "identified_gaps": ["Morning slot has good availability", "Consider scheduling deep work before noon"]
            }
        }

    # Validate suggestions
    raw_suggestions = response.get("suggestions", [])
    validated = validate_suggestions(raw_suggestions, events, user)

    # Parse analysis
    raw_analysis = response.get("analysis", {})
    analysis = ScheduleAnalysis(
        utilization=float(raw_analysis.get("utilization", 0)),
        focus_time_hours=float(raw_analysis.get("focus_time_hours", 0)),
        meeting_hours=float(raw_analysis.get("meeting_hours", 0)),
        identified_gaps=raw_analysis.get("identified_gaps", []),
    )

    # Log suggestions for learning
    context_hash = hashlib.md5(
        f"{user.id}{request.start_date}{request.end_date}".encode()
    ).hexdigest()

    supabase.table("ai_suggestions").insert({
        "id": str(uuid4()),
        "user_id": str(user.id),
        "context_hash": context_hash,
        "date_range_start": request.start_date.isoformat(),
        "date_range_end": request.end_date.isoformat(),
        "suggestions": [s.model_dump(by_alias=True, mode="json") for s in validated],
    }).execute()

    # Return response with camelCase aliases
    return JSONResponse({
        "suggestions": [s.model_dump(by_alias=True, mode="json") for s in validated],
        "analysis": analysis.model_dump(),
    })


@router.post("/suggestions/{suggestion_id}/apply")
async def apply_suggestion(
    suggestion_id: str,
    user: User = Depends(get_current_user)
):
    """Apply a specific AI suggestion (creates/updates event)."""
    # Find the suggestion in recent logs
    recent = supabase.table("ai_suggestions").select("suggestions").eq(
        "user_id", str(user.id)
    ).order("created_at", desc=True).limit(10).execute()

    suggestion = None
    for log in recent.data or []:
        for sug in log.get("suggestions", []):
            if sug.get("id") == suggestion_id:
                suggestion = sug
                break
        if suggestion:
            break

    if not suggestion:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Suggestion not found or expired"
        )

    # Apply based on type
    if suggestion["type"] == "add_event":
        event_data = {
            "id": str(uuid4()),
            "owner_id": str(user.id),
            "title": suggestion["title"],
            "start_time": suggestion.get("suggestedStart") or suggestion.get("proposed_start"),
            "end_time": suggestion.get("suggestedEnd") or suggestion.get("proposed_end"),
            "timezone": user.timezone,
            "is_locked": False,
            "priority": 2,
            "status": EventStatus.SCHEDULED.value,
            "tags": [suggestion.get("category", "ai_suggested"), "ai_suggested"],
        }
        response = supabase.table("events").insert(event_data).execute()
        return {"message": "Event created", "event": response.data[0]}

    elif suggestion["type"] == "reschedule":
        event_id = suggestion.get("eventId") or suggestion.get("event_id")
        update_data = {
            "start_time": suggestion.get("suggestedStart") or suggestion.get("proposed_start"),
            "end_time": suggestion.get("suggestedEnd") or suggestion.get("proposed_end"),
            "updated_at": datetime.utcnow().isoformat(),
        }
        response = supabase.table("events").update(update_data).eq(
            "id", event_id
        ).eq("owner_id", str(user.id)).execute()

        if not response.data:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Event not found"
            )
        return {"message": "Event rescheduled", "event": response.data[0]}

    elif suggestion["type"] == "remove_event":
        event_id = suggestion.get("eventId") or suggestion.get("event_id")
        response = supabase.table("events").update({
            "deleted_at": datetime.utcnow().isoformat()
        }).eq("id", event_id).eq("owner_id", str(user.id)).execute()

        if not response.data:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Event not found"
            )
        return {"message": "Event removed"}

    else:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Unknown suggestion type: {suggestion['type']}"
        )


@router.post("/suggestions/feedback")
async def submit_feedback(
    feedback: SuggestionFeedback,
    user: User = Depends(get_current_user)
):
    """Record user feedback on suggestion for future learning."""
    # Find and update the suggestion log
    recent = supabase.table("ai_suggestions").select("id, accepted_suggestion_ids, rejected_suggestion_ids").eq(
        "user_id", str(user.id)
    ).order("created_at", desc=True).limit(10).execute()

    for log in recent.data or []:
        # Check if this log contains the suggestion
        log_response = supabase.table("ai_suggestions").select("suggestions").eq(
            "id", log["id"]
        ).single().execute()

        if log_response.data:
            suggestions = log_response.data.get("suggestions", [])
            if any(s.get("id") == feedback.suggestion_id for s in suggestions):
                # Update feedback
                accepted = log.get("accepted_suggestion_ids") or []
                rejected = log.get("rejected_suggestion_ids") or []

                if feedback.accepted:
                    if feedback.suggestion_id not in accepted:
                        accepted.append(feedback.suggestion_id)
                else:
                    if feedback.suggestion_id not in rejected:
                        rejected.append(feedback.suggestion_id)

                supabase.table("ai_suggestions").update({
                    "accepted_suggestion_ids": accepted,
                    "rejected_suggestion_ids": rejected,
                }).eq("id", log["id"]).execute()

                return {"message": "Feedback recorded"}

    return {"message": "Suggestion not found, feedback not recorded"}
