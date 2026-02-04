"""Scheduling service - conflict detection and resolution."""

from datetime import datetime, timedelta
from typing import List, Optional
from dataclasses import dataclass, field
from enum import Enum

from app.core.database import supabase


class ConflictSeverity(str, Enum):
    """Severity levels for scheduling conflicts."""
    NONE = "none"
    WARNING = "warning"      # Soft conflicts (flexible events overlap)
    ERROR = "error"          # Hard conflicts (locked events overlap)
    CRITICAL = "critical"    # High-priority locked events overlap


class ConflictResolution(str, Enum):
    """Resolution strategies for conflicts."""
    BLOCKED = "blocked"                      # Cannot proceed
    SUGGEST_MOVE_PROPOSED = "move_proposed"  # Suggest moving the new event
    SUGGEST_MOVE_EXISTING = "move_existing"  # Suggest moving existing event
    ALLOW_WITH_WARNING = "allow_warning"     # Allow but show warning


@dataclass
class Conflict:
    """A detected scheduling conflict."""
    conflicting_event_id: str
    conflicting_event_title: str
    overlap_minutes: int
    severity: ConflictSeverity
    resolution: ConflictResolution
    is_locked: bool
    priority: int


@dataclass
class RescheduleSuggestion:
    """A suggestion for rescheduling an event."""
    event_id: str
    original_start: datetime
    original_end: datetime
    suggested_start: datetime
    suggested_end: datetime
    reason: str
    score: float = 0.0


@dataclass
class ConflictCheckResult:
    """Result of conflict checking."""
    conflicts: List[Conflict] = field(default_factory=list)
    suggestions: List[RescheduleSuggestion] = field(default_factory=list)
    has_blocking_conflicts: bool = False


async def check_conflicts(
    user_id: str,
    start: datetime,
    end: datetime,
    is_locked: bool = False,
    exclude_event_id: Optional[str] = None,
) -> ConflictCheckResult:
    """
    Check for scheduling conflicts in a proposed time range.

    Rules:
    1. Locked + Locked overlap = CRITICAL (blocked)
    2. Locked + Flexible overlap = ERROR (suggest reschedule flexible)
    3. Flexible + Flexible overlap = WARNING (allowed but flagged)
    """
    # Query for overlapping events
    query = supabase.table("events").select(
        "id, title, start_time, end_time, is_locked, priority"
    ).eq("owner_id", user_id).is_("deleted_at", "null")

    # Time overlap: event.start < proposed.end AND event.end > proposed.start
    query = query.lt("start_time", end.isoformat()).gt("end_time", start.isoformat())

    if exclude_event_id:
        query = query.neq("id", exclude_event_id)

    response = query.execute()
    overlapping_events = response.data or []

    result = ConflictCheckResult()

    for event in overlapping_events:
        event_start = datetime.fromisoformat(event["start_time"].replace("Z", "+00:00"))
        event_end = datetime.fromisoformat(event["end_time"].replace("Z", "+00:00"))

        # Calculate overlap
        overlap_start = max(start, event_start)
        overlap_end = min(end, event_end)
        overlap_minutes = int((overlap_end - overlap_start).total_seconds() / 60)

        if overlap_minutes <= 0:
            continue

        event_is_locked = event.get("is_locked", False)

        # Determine severity and resolution
        if is_locked and event_is_locked:
            severity = ConflictSeverity.CRITICAL
            resolution = ConflictResolution.BLOCKED
            result.has_blocking_conflicts = True
        elif is_locked and not event_is_locked:
            severity = ConflictSeverity.ERROR
            resolution = ConflictResolution.SUGGEST_MOVE_EXISTING
        elif not is_locked and event_is_locked:
            severity = ConflictSeverity.ERROR
            resolution = ConflictResolution.SUGGEST_MOVE_PROPOSED
        else:
            severity = ConflictSeverity.WARNING
            resolution = ConflictResolution.ALLOW_WITH_WARNING

        conflict = Conflict(
            conflicting_event_id=event["id"],
            conflicting_event_title=event["title"],
            overlap_minutes=overlap_minutes,
            severity=severity,
            resolution=resolution,
            is_locked=event_is_locked,
            priority=event.get("priority", 2),
        )
        result.conflicts.append(conflict)

        # Generate reschedule suggestions for non-blocking conflicts
        if resolution == ConflictResolution.SUGGEST_MOVE_EXISTING:
            suggestions = await _find_alternative_slots(
                user_id=user_id,
                event_id=event["id"],
                duration=event_end - event_start,
                original_start=event_start,
                blocked_start=start,
                blocked_end=end,
            )
            result.suggestions.extend(suggestions)
        elif resolution == ConflictResolution.SUGGEST_MOVE_PROPOSED:
            suggestions = await _find_alternative_slots(
                user_id=user_id,
                event_id=None,  # Proposed event
                duration=end - start,
                original_start=start,
                blocked_start=event_start,
                blocked_end=event_end,
            )
            result.suggestions.extend(suggestions)

    return result


async def _find_alternative_slots(
    user_id: str,
    event_id: Optional[str],
    duration: timedelta,
    original_start: datetime,
    blocked_start: datetime,
    blocked_end: datetime,
    search_days: int = 3,
) -> List[RescheduleSuggestion]:
    """Find alternative time slots for an event."""
    suggestions = []

    # Search for free slots in the same day first, then adjacent days
    search_start = original_start.replace(hour=9, minute=0, second=0, microsecond=0)
    search_end = search_start + timedelta(days=search_days)

    # Get all events in search range
    response = supabase.table("events").select(
        "start_time, end_time"
    ).eq("owner_id", user_id).is_("deleted_at", "null").gte(
        "start_time", search_start.isoformat()
    ).lte("end_time", search_end.isoformat()).execute()

    busy_slots = []
    for event in response.data or []:
        busy_slots.append((
            datetime.fromisoformat(event["start_time"].replace("Z", "+00:00")),
            datetime.fromisoformat(event["end_time"].replace("Z", "+00:00")),
        ))

    # Add the blocked slot
    busy_slots.append((blocked_start, blocked_end))
    busy_slots.sort(key=lambda x: x[0])

    # Find free slots
    current = search_start
    working_end_hour = 17

    while current < search_end and len(suggestions) < 3:
        # Skip outside working hours
        if current.hour < 9:
            current = current.replace(hour=9, minute=0)
            continue
        if current.hour >= working_end_hour:
            current = (current + timedelta(days=1)).replace(hour=9, minute=0)
            continue

        slot_end = current + duration

        # Check if slot is free
        is_free = True
        for busy_start, busy_end in busy_slots:
            if current < busy_end and slot_end > busy_start:
                is_free = False
                # Skip to end of busy slot
                current = busy_end
                break

        if is_free and slot_end.hour <= working_end_hour:
            # Calculate score (prefer closer to original time)
            time_diff = abs((current - original_start).total_seconds() / 3600)
            score = max(0, 100 - time_diff * 5)

            # Bonus for same day
            if current.date() == original_start.date():
                score += 20

            suggestions.append(RescheduleSuggestion(
                event_id=event_id or "proposed",
                original_start=original_start,
                original_end=original_start + duration,
                suggested_start=current,
                suggested_end=slot_end,
                reason="Available slot that avoids conflict",
                score=score,
            ))
            current = slot_end + timedelta(minutes=30)
        elif is_free:
            current = (current + timedelta(days=1)).replace(hour=9, minute=0)

    # Sort by score
    suggestions.sort(key=lambda x: x.score, reverse=True)
    return suggestions[:3]
