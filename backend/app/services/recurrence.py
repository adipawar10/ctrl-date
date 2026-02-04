"""Recurrence service - RFC 5545 compliant recurrence expansion."""

from datetime import datetime, date, timedelta
from typing import List, Optional
from uuid import uuid4

from dateutil.rrule import rrule, DAILY, WEEKLY, MONTHLY, YEARLY

from app.core.database import supabase

FREQ_MAP = {
    'daily': DAILY,
    'weekly': WEEKLY,
    'monthly': MONTHLY,
    'yearly': YEARLY,
}


async def expand_recurrence_in_range(
    event: dict,
    range_start: datetime,
    range_end: datetime,
) -> List[dict]:
    """
    Expand a recurring event to instances within a date range.

    Handles:
    - RFC 5545 RRULE patterns
    - Exception dates (excluded_dates)
    - Modified instances (stored separately with recurrence_parent_id)
    """
    if not event.get("recurrence_rule_id"):
        return [event]

    # Fetch recurrence rule
    rule_response = supabase.table("recurrence_rules").select("*").eq(
        "id", event["recurrence_rule_id"]
    ).single().execute()

    if not rule_response.data:
        return [event]

    rule = rule_response.data

    # Parse base event times
    base_start = datetime.fromisoformat(event["start_time"].replace("Z", "+00:00"))
    base_end = datetime.fromisoformat(event["end_time"].replace("Z", "+00:00"))
    duration = base_end - base_start

    # Build rrule kwargs
    rrule_kwargs = {
        'freq': FREQ_MAP.get(rule["frequency"], DAILY),
        'interval': rule.get("interval", 1),
        'dtstart': base_start,
    }

    if rule.get("until_date"):
        until = datetime.fromisoformat(rule["until_date"])
        if until.tzinfo is None:
            until = until.replace(tzinfo=base_start.tzinfo)
        rrule_kwargs['until'] = until

    if rule.get("count"):
        rrule_kwargs['count'] = rule["count"]

    if rule.get("by_weekday"):
        rrule_kwargs['byweekday'] = rule["by_weekday"]

    if rule.get("by_monthday"):
        rrule_kwargs['bymonthday'] = rule["by_monthday"]

    if rule.get("by_month"):
        rrule_kwargs['bymonth'] = rule["by_month"]

    if rule.get("by_setpos"):
        rrule_kwargs['bysetpos'] = rule["by_setpos"]

    # Generate occurrences
    try:
        rr = rrule(**rrule_kwargs)
        occurrences = list(rr.between(range_start, range_end, inc=True))
    except Exception as e:
        print(f"Error expanding recurrence: {e}")
        return [event]

    # Filter out excluded dates
    excluded = set()
    for exc_date in rule.get("excluded_dates") or []:
        if isinstance(exc_date, str):
            excluded.add(date.fromisoformat(exc_date))
        else:
            excluded.add(exc_date)

    occurrences = [o for o in occurrences if o.date() not in excluded]

    # Fetch modified instances
    modified_response = supabase.table("events").select("*").eq(
        "recurrence_parent_id", event["id"]
    ).is_("deleted_at", "null").gte(
        "recurrence_instance_date", range_start.date().isoformat()
    ).lte(
        "recurrence_instance_date", range_end.date().isoformat()
    ).execute()

    modified_instances = {
        date.fromisoformat(m["recurrence_instance_date"]): m
        for m in modified_response.data or []
    }

    # Create event instances
    instances = []
    for occurrence in occurrences:
        instance_date = occurrence.date()

        # Check if this instance has been modified
        if instance_date in modified_instances:
            instances.append(modified_instances[instance_date])
            continue

        # Create virtual instance
        instance = event.copy()
        instance["id"] = f"{event['id']}_{instance_date.isoformat()}"
        instance["start_time"] = occurrence.isoformat()
        instance["end_time"] = (occurrence + duration).isoformat()
        instance["recurrence_parent_id"] = event["id"]
        instance["recurrence_instance_date"] = instance_date.isoformat()
        instance["_is_virtual"] = True  # Flag for client

        instances.append(instance)

    return instances


async def create_recurrence_exception(
    parent_event_id: str,
    instance_date: date,
    user_id: str,
    updates: dict,
) -> dict:
    """
    Create an exception to a recurring event (modified instance).

    This creates a new event record that overrides the virtual instance
    for a specific date.
    """
    # Fetch parent event
    parent_response = supabase.table("events").select("*").eq(
        "id", parent_event_id
    ).single().execute()

    if not parent_response.data:
        raise ValueError("Parent event not found")

    parent = parent_response.data

    # Verify ownership
    if parent["owner_id"] != user_id:
        raise ValueError("Permission denied")

    # Create exception record
    exception_data = {
        "id": str(uuid4()),
        "owner_id": user_id,
        "title": updates.get("title", parent["title"]),
        "description": updates.get("description", parent["description"]),
        "location": updates.get("location", parent["location"]),
        "start_time": updates.get("start_time", parent["start_time"]),
        "end_time": updates.get("end_time", parent["end_time"]),
        "all_day": updates.get("all_day", parent["all_day"]),
        "timezone": parent["timezone"],
        "is_locked": updates.get("is_locked", parent["is_locked"]),
        "priority": updates.get("priority", parent["priority"]),
        "recurrence_parent_id": parent_event_id,
        "recurrence_instance_date": instance_date.isoformat(),
        "status": updates.get("status", "scheduled"),
        "color": updates.get("color", parent.get("color")),
        "tags": updates.get("tags", parent.get("tags", [])),
    }

    response = supabase.table("events").insert(exception_data).execute()
    return response.data[0]


async def add_recurrence_exclusion(
    parent_event_id: str,
    exclude_date: date,
    user_id: str,
) -> dict:
    """Add an exclusion date to a recurring event (delete single instance)."""
    # Fetch parent event
    parent_response = supabase.table("events").select(
        "id, owner_id, recurrence_rule_id"
    ).eq("id", parent_event_id).single().execute()

    if not parent_response.data:
        raise ValueError("Parent event not found")

    parent = parent_response.data

    # Verify ownership
    if parent["owner_id"] != user_id:
        raise ValueError("Permission denied")

    if not parent.get("recurrence_rule_id"):
        raise ValueError("Event is not recurring")

    # Fetch and update recurrence rule
    rule_response = supabase.table("recurrence_rules").select("*").eq(
        "id", parent["recurrence_rule_id"]
    ).single().execute()

    rule = rule_response.data
    excluded_dates = rule.get("excluded_dates") or []

    if exclude_date.isoformat() not in excluded_dates:
        excluded_dates.append(exclude_date.isoformat())

        supabase.table("recurrence_rules").update({
            "excluded_dates": excluded_dates
        }).eq("id", rule["id"]).execute()

    return {"message": f"Excluded {exclude_date.isoformat()} from recurrence"}
