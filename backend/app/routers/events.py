"""Events router - CRUD operations for calendar events."""

from datetime import datetime, date
from typing import List, Optional
from uuid import UUID, uuid4
from fastapi import APIRouter, HTTPException, status, Depends, Query

from app.core.database import supabase
from app.core.security import get_current_user
from app.models.user import User
from app.models.event import (
    Event, EventCreate, EventUpdate, EventComplete,
    EventStatus, RecurrenceUpdateScope
)
from app.services.scheduling import check_conflicts, ConflictCheckResult
from app.services.recurrence import expand_recurrence_in_range

router = APIRouter()


class EventListResponse:
    """Response for event list."""
    events: List[Event]
    total: int


class ConflictCheckResponse:
    """Response for conflict check."""
    has_conflicts: bool
    conflicts: List[dict]


@router.get("")
async def list_events(
    start: datetime,
    end: datetime,
    include_shared: bool = True,
    include_recurring: bool = True,
    status_filter: Optional[List[EventStatus]] = Query(None, alias="status"),
    user: User = Depends(get_current_user)
) -> dict:
    """
    Get events in date range.

    - Recurring events are expanded to instances if include_recurring=True
    - Includes shared events if include_shared=True
    - Returns events owned by user + accepted shared events
    """
    # Base query for owned events
    query = supabase.table("events").select("*").eq(
        "owner_id", str(user.id)
    ).is_("deleted_at", "null").gte(
        "start_time", start.isoformat()
    ).lte(
        "end_time", end.isoformat()
    )

    if status_filter:
        query = query.in_("status", [s.value for s in status_filter])

    response = query.execute()
    events = response.data or []

    # Get shared events if requested
    if include_shared:
        shares_response = supabase.table("event_shares").select(
            "event_id"
        ).eq(
            "shared_with_user_id", str(user.id)
        ).eq("response", "accepted").execute()

        if shares_response.data:
            shared_event_ids = [s["event_id"] for s in shares_response.data]
            shared_events_response = supabase.table("events").select("*").in_(
                "id", shared_event_ids
            ).is_("deleted_at", "null").gte(
                "start_time", start.isoformat()
            ).lte(
                "end_time", end.isoformat()
            ).execute()
            events.extend(shared_events_response.data or [])

    # Expand recurring events
    if include_recurring:
        expanded_events = []
        for event in events:
            if event.get("recurrence_rule_id") and not event.get("recurrence_parent_id"):
                # This is a recurring event parent - expand it
                instances = await expand_recurrence_in_range(
                    event, start, end
                )
                expanded_events.extend(instances)
            elif not event.get("recurrence_parent_id"):
                # Regular non-recurring event
                expanded_events.append(event)
            # Skip parent events in output, include only instances
        events = expanded_events

    return {
        "events": events,
        "total": len(events),
    }


@router.post("", status_code=status.HTTP_201_CREATED)
async def create_event(
    event: EventCreate,
    user: User = Depends(get_current_user)
) -> dict:
    """
    Create a single or recurring event.

    Validates that new locked events don't conflict with existing locked events.
    """
    # Check for conflicts if event is locked
    if event.is_locked:
        conflict_result = await check_conflicts(
            user_id=str(user.id),
            start=event.start_time,
            end=event.end_time,
            is_locked=True,
        )
        if conflict_result.has_blocking_conflicts:
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail={
                    "message": "Conflicts with existing locked event(s)",
                    "conflicts": conflict_result.conflicts
                }
            )

    # Create recurrence rule if provided
    recurrence_rule_id = None
    if event.recurrence_rule:
        rule_data = event.recurrence_rule.model_dump()
        rule_data["id"] = str(uuid4())
        supabase.table("recurrence_rules").insert(rule_data).execute()
        recurrence_rule_id = rule_data["id"]

    # Create event
    event_data = {
        "id": str(uuid4()),
        "owner_id": str(user.id),
        "title": event.title,
        "description": event.description,
        "location": event.location,
        "start_time": event.start_time.isoformat(),
        "end_time": event.end_time.isoformat(),
        "all_day": event.all_day,
        "timezone": event.timezone,
        "is_locked": event.is_locked,
        "priority": event.priority,
        "recurrence_rule_id": recurrence_rule_id,
        "color": event.color,
        "tags": event.tags,
        "status": EventStatus.SCHEDULED.value,
    }

    response = supabase.table("events").insert(event_data).execute()
    return response.data[0]


@router.get("/{event_id}")
async def get_event(
    event_id: UUID,
    user: User = Depends(get_current_user)
) -> dict:
    """Get a single event by ID."""
    response = supabase.table("events").select("*").eq(
        "id", str(event_id)
    ).is_("deleted_at", "null").single().execute()

    if not response.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Event not found"
        )

    event = response.data

    # Check access
    if event["owner_id"] != str(user.id):
        # Check if shared with user
        share_response = supabase.table("event_shares").select("*").eq(
            "event_id", str(event_id)
        ).eq(
            "shared_with_user_id", str(user.id)
        ).eq("response", "accepted").execute()

        if not share_response.data:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Access denied"
            )

    return event


@router.put("/{event_id}")
async def update_event(
    event_id: UUID,
    event_update: EventUpdate,
    update_scope: RecurrenceUpdateScope = Query(RecurrenceUpdateScope.SINGLE),
    user: User = Depends(get_current_user)
) -> dict:
    """
    Update an event.

    For recurring events, scope determines what gets updated:
    - single: Only this instance
    - future: This and all future instances
    - all: All instances including past
    """
    # Fetch existing event
    response = supabase.table("events").select("*").eq(
        "id", str(event_id)
    ).is_("deleted_at", "null").single().execute()

    if not response.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Event not found"
        )

    existing = response.data

    # Check ownership or edit permission
    if existing["owner_id"] != str(user.id):
        share_response = supabase.table("event_shares").select("*").eq(
            "event_id", str(event_id)
        ).eq(
            "shared_with_user_id", str(user.id)
        ).in_("permission", ["edit", "admin"]).execute()

        if not share_response.data:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Access denied"
            )

    # Check for time conflicts if changing time and event is/will be locked
    update_data = event_update.model_dump(exclude_unset=True)
    new_is_locked = update_data.get("is_locked", existing["is_locked"])
    new_start = update_data.get("start_time", existing["start_time"])
    new_end = update_data.get("end_time", existing["end_time"])

    if new_is_locked and (
        "start_time" in update_data or
        "end_time" in update_data or
        "is_locked" in update_data
    ):
        conflict_result = await check_conflicts(
            user_id=str(user.id),
            start=new_start if isinstance(new_start, datetime) else datetime.fromisoformat(new_start),
            end=new_end if isinstance(new_end, datetime) else datetime.fromisoformat(new_end),
            is_locked=True,
            exclude_event_id=str(event_id),
        )
        if conflict_result.has_blocking_conflicts:
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail={
                    "message": "Conflicts with existing locked event(s)",
                    "conflicts": conflict_result.conflicts
                }
            )

    # Handle recurring event updates
    if existing.get("recurrence_parent_id") and update_scope == RecurrenceUpdateScope.SINGLE:
        # Create a modified instance (exception)
        update_data["recurrence_instance_date"] = existing.get("recurrence_instance_date")

    # Convert datetime objects to ISO strings
    if "start_time" in update_data and isinstance(update_data["start_time"], datetime):
        update_data["start_time"] = update_data["start_time"].isoformat()
    if "end_time" in update_data and isinstance(update_data["end_time"], datetime):
        update_data["end_time"] = update_data["end_time"].isoformat()

    # Increment version for optimistic locking
    update_data["version"] = existing["version"] + 1
    update_data["updated_at"] = datetime.utcnow().isoformat()

    # Update event
    response = supabase.table("events").update(update_data).eq(
        "id", str(event_id)
    ).eq("version", existing["version"]).execute()

    if not response.data:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Event was modified by another request"
        )

    return response.data[0]


@router.delete("/{event_id}")
async def delete_event(
    event_id: UUID,
    delete_scope: RecurrenceUpdateScope = Query(RecurrenceUpdateScope.SINGLE),
    user: User = Depends(get_current_user)
):
    """
    Soft delete an event.

    For recurring events, scope determines what gets deleted.
    """
    # Fetch existing event
    response = supabase.table("events").select("*").eq(
        "id", str(event_id)
    ).is_("deleted_at", "null").single().execute()

    if not response.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Event not found"
        )

    existing = response.data

    # Check ownership
    if existing["owner_id"] != str(user.id):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only owner can delete events"
        )

    # Soft delete
    deleted_at = datetime.utcnow().isoformat()

    if delete_scope == RecurrenceUpdateScope.ALL and existing.get("recurrence_parent_id"):
        # Delete all instances of recurring event
        parent_id = existing.get("recurrence_parent_id") or str(event_id)
        supabase.table("events").update({
            "deleted_at": deleted_at
        }).eq("recurrence_parent_id", parent_id).execute()
        supabase.table("events").update({
            "deleted_at": deleted_at
        }).eq("id", parent_id).execute()
    elif delete_scope == RecurrenceUpdateScope.FUTURE and existing.get("recurrence_instance_date"):
        # Delete this and future instances
        supabase.table("events").update({
            "deleted_at": deleted_at
        }).eq(
            "recurrence_parent_id", existing.get("recurrence_parent_id")
        ).gte(
            "recurrence_instance_date", existing["recurrence_instance_date"]
        ).execute()
    else:
        # Delete single event
        supabase.table("events").update({
            "deleted_at": deleted_at
        }).eq("id", str(event_id)).execute()

    return {"message": "Event deleted"}


@router.post("/{event_id}/complete")
async def mark_complete(
    event_id: UUID,
    completion: EventComplete,
    user: User = Depends(get_current_user)
) -> dict:
    """Mark event as completed, skipped, or partial."""
    # Fetch existing event
    response = supabase.table("events").select("*").eq(
        "id", str(event_id)
    ).is_("deleted_at", "null").single().execute()

    if not response.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Event not found"
        )

    existing = response.data

    # Check ownership
    if existing["owner_id"] != str(user.id):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only owner can mark completion"
        )

    # Update completion status
    update_data = {
        "status": completion.status.value,
        "completion_notes": completion.notes,
        "completed_at": datetime.utcnow().isoformat() if completion.status in [
            EventStatus.COMPLETED, EventStatus.PARTIAL
        ] else None,
        "updated_at": datetime.utcnow().isoformat(),
    }

    response = supabase.table("events").update(update_data).eq(
        "id", str(event_id)
    ).execute()

    return response.data[0]


@router.get("/conflicts/check")
async def check_time_conflicts(
    start: datetime,
    end: datetime,
    exclude_event_id: Optional[UUID] = None,
    user: User = Depends(get_current_user)
) -> dict:
    """Check for time conflicts in proposed range."""
    result = await check_conflicts(
        user_id=str(user.id),
        start=start,
        end=end,
        is_locked=False,
        exclude_event_id=str(exclude_event_id) if exclude_event_id else None,
    )

    return {
        "has_conflicts": len(result.conflicts) > 0,
        "has_blocking_conflicts": result.has_blocking_conflicts,
        "conflicts": result.conflicts,
        "suggestions": result.suggestions,
    }
