"""Reflections and streaks router."""

from datetime import datetime, date, timedelta
from typing import Optional
from uuid import UUID, uuid4
from fastapi import APIRouter, HTTPException, status, Depends, Query

from app.core.database import supabase
from app.core.security import get_current_user
from app.models.user import User
from app.models.reflection import (
    DailyReflection, DailyReflectionCreate, Streak, StreakUpdate, ReflectionStats
)
from app.models.event import EventStatus

router = APIRouter()


@router.get("")
async def list_reflections(
    start_date: date,
    end_date: date,
    user: User = Depends(get_current_user)
):
    """Get daily reflections in date range."""
    response = supabase.table("daily_reflections").select("*").eq(
        "user_id", str(user.id)
    ).gte("reflection_date", start_date.isoformat()).lte(
        "reflection_date", end_date.isoformat()
    ).order("reflection_date", desc=True).execute()

    return {"reflections": response.data or []}


@router.post("/{reflection_date}")
async def create_or_update_reflection(
    reflection_date: date,
    reflection: DailyReflectionCreate,
    user: User = Depends(get_current_user)
):
    """
    Create or update daily reflection.

    Auto-calculates completion stats from events.
    Updates streak accordingly.
    """
    # Calculate event stats for the day
    day_start = datetime.combine(reflection_date, datetime.min.time())
    day_end = datetime.combine(reflection_date, datetime.max.time())

    events_response = supabase.table("events").select("status").eq(
        "owner_id", str(user.id)
    ).is_("deleted_at", "null").gte(
        "start_time", day_start.isoformat()
    ).lt("start_time", day_end.isoformat()).execute()

    events = events_response.data or []

    stats = {
        "events_planned": len(events),
        "events_completed": sum(1 for e in events if e["status"] == EventStatus.COMPLETED.value),
        "events_skipped": sum(1 for e in events if e["status"] == EventStatus.SKIPPED.value),
        "events_partial": sum(1 for e in events if e["status"] == EventStatus.PARTIAL.value),
    }

    # Calculate completion rate
    completion_rate = 0.0
    if stats["events_planned"] > 0:
        completed_weight = stats["events_completed"] + (stats["events_partial"] * 0.5)
        completion_rate = completed_weight / stats["events_planned"]

    # Get user's streak settings
    streak_response = supabase.table("streaks").select("*").eq(
        "user_id", str(user.id)
    ).eq("streak_type", "daily_completion").single().execute()

    streak = streak_response.data
    threshold = streak["completion_threshold"] if streak else 0.80

    is_streak_day = completion_rate >= threshold and stats["events_planned"] > 0

    # Check if reflection exists
    existing = supabase.table("daily_reflections").select("id").eq(
        "user_id", str(user.id)
    ).eq("reflection_date", reflection_date.isoformat()).execute()

    reflection_data = {
        "user_id": str(user.id),
        "reflection_date": reflection_date.isoformat(),
        "events_planned": stats["events_planned"],
        "events_completed": stats["events_completed"],
        "events_skipped": stats["events_skipped"],
        "events_partial": stats["events_partial"],
        "notes": reflection.notes,
        "mood": reflection.mood,
        "is_streak_day": is_streak_day,
        "updated_at": datetime.utcnow().isoformat(),
    }

    if existing.data:
        # Update existing
        supabase.table("daily_reflections").update(reflection_data).eq(
            "id", existing.data[0]["id"]
        ).execute()
        reflection_data["id"] = existing.data[0]["id"]
    else:
        # Create new
        reflection_data["id"] = str(uuid4())
        supabase.table("daily_reflections").insert(reflection_data).execute()

    # Update streak
    await _update_streak(user.id, reflection_date, is_streak_day, streak)

    reflection_data["completion_rate"] = completion_rate
    return reflection_data


async def _update_streak(
    user_id: UUID,
    reflection_date: date,
    is_streak_day: bool,
    streak: Optional[dict]
):
    """Update user's streak based on reflection."""
    if not streak:
        return

    last_completed = streak.get("last_completed_date")
    if last_completed:
        last_completed = date.fromisoformat(last_completed)

    current_count = streak["current_count"]
    longest_count = streak["longest_count"]

    if is_streak_day:
        if last_completed is None:
            # First streak day
            current_count = 1
        elif reflection_date == last_completed:
            # Same day, no change
            pass
        elif reflection_date == last_completed + timedelta(days=1):
            # Consecutive day
            current_count += 1
        elif reflection_date > last_completed + timedelta(days=1):
            # Streak broken, start new
            current_count = 1
        else:
            # Past date update, recalculate streak
            current_count = await _recalculate_streak(user_id, streak["id"])

        # Update longest if needed
        longest_count = max(longest_count, current_count)

        supabase.table("streaks").update({
            "current_count": current_count,
            "longest_count": longest_count,
            "last_completed_date": reflection_date.isoformat(),
            "updated_at": datetime.utcnow().isoformat(),
        }).eq("id", streak["id"]).execute()

    elif last_completed and reflection_date > last_completed + timedelta(days=1):
        # Non-streak day and we missed days - reset streak
        supabase.table("streaks").update({
            "current_count": 0,
            "updated_at": datetime.utcnow().isoformat(),
        }).eq("id", streak["id"]).execute()


async def _recalculate_streak(user_id: UUID, streak_id: str) -> int:
    """Recalculate streak from reflection history."""
    # Get recent reflections ordered by date
    response = supabase.table("daily_reflections").select(
        "reflection_date, is_streak_day"
    ).eq("user_id", str(user_id)).eq(
        "is_streak_day", True
    ).order("reflection_date", desc=True).limit(365).execute()

    if not response.data:
        return 0

    reflections = response.data
    streak_count = 0
    expected_date = date.today()

    for ref in reflections:
        ref_date = date.fromisoformat(ref["reflection_date"])
        if ref_date == expected_date:
            streak_count += 1
            expected_date -= timedelta(days=1)
        elif ref_date < expected_date:
            # Gap in streak
            break

    return streak_count


@router.get("/stats")
async def get_reflection_stats(
    start_date: date,
    end_date: date,
    user: User = Depends(get_current_user)
) -> ReflectionStats:
    """Get aggregated reflection statistics for a period."""
    reflections_response = supabase.table("daily_reflections").select("*").eq(
        "user_id", str(user.id)
    ).gte("reflection_date", start_date.isoformat()).lte(
        "reflection_date", end_date.isoformat()
    ).execute()

    reflections = reflections_response.data or []

    total_days = (end_date - start_date).days + 1
    days_with_reflection = len(reflections)

    total_events_planned = sum(r["events_planned"] for r in reflections)
    total_events_completed = sum(r["events_completed"] for r in reflections)

    # Calculate average completion rate
    completion_rates = []
    for r in reflections:
        if r["events_planned"] > 0:
            rate = (r["events_completed"] + r["events_partial"] * 0.5) / r["events_planned"]
            completion_rates.append(rate)

    avg_completion = sum(completion_rates) / len(completion_rates) if completion_rates else 0.0

    # Calculate average mood
    moods = [r["mood"] for r in reflections if r.get("mood")]
    avg_mood = sum(moods) / len(moods) if moods else None

    # Get streak info
    streak_response = supabase.table("streaks").select("*").eq(
        "user_id", str(user.id)
    ).eq("streak_type", "daily_completion").single().execute()

    streak = streak_response.data or {}

    return ReflectionStats(
        period_start=start_date,
        period_end=end_date,
        total_days=total_days,
        days_with_reflection=days_with_reflection,
        average_completion_rate=round(avg_completion, 3),
        average_mood=round(avg_mood, 2) if avg_mood else None,
        current_streak=streak.get("current_count", 0),
        longest_streak=streak.get("longest_count", 0),
        total_events_planned=total_events_planned,
        total_events_completed=total_events_completed,
    )


@router.get("/streaks")
async def get_streaks(
    user: User = Depends(get_current_user)
):
    """Get all user streaks."""
    response = supabase.table("streaks").select("*").eq(
        "user_id", str(user.id)
    ).execute()

    return {"streaks": response.data or []}


@router.put("/streaks/{streak_id}")
async def update_streak_settings(
    streak_id: UUID,
    update: StreakUpdate,
    user: User = Depends(get_current_user)
):
    """Update streak settings (e.g., completion threshold)."""
    # Verify streak belongs to user
    streak = supabase.table("streaks").select("id").eq(
        "id", str(streak_id)
    ).eq("user_id", str(user.id)).single().execute()

    if not streak.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Streak not found"
        )

    update_data = update.model_dump(exclude_unset=True)
    if update_data:
        update_data["updated_at"] = datetime.utcnow().isoformat()
        supabase.table("streaks").update(update_data).eq(
            "id", str(streak_id)
        ).execute()

    # Fetch updated streak
    response = supabase.table("streaks").select("*").eq(
        "id", str(streak_id)
    ).single().execute()

    return response.data
