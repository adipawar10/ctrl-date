"""CSV import service for calendar events."""

import csv
import io
from datetime import datetime
from typing import Optional
from uuid import uuid4

from app.core.database import supabase


async def process_csv_import(
    batch_id: str,
    user_id: str,
    content: str,
    timezone: str,
):
    """
    Process a CSV file and import events.

    Expected CSV format:
    title,description,start_time,end_time,location,is_locked,priority,tags

    - start_time/end_time: ISO 8601 format
    - is_locked: true/false
    - priority: 1-4
    - tags: comma-separated within quotes
    """
    events_imported = 0
    events_skipped = 0
    errors = []

    try:
        reader = csv.DictReader(io.StringIO(content))

        # Validate required columns
        required_columns = {"title", "start_time", "end_time"}
        if not required_columns.issubset(set(reader.fieldnames or [])):
            errors.append({
                "row": 0,
                "error": f"Missing required columns: {required_columns - set(reader.fieldnames or [])}"
            })
            await _update_batch_status(batch_id, 0, 0, errors)
            return

        events_to_insert = []

        for row_num, row in enumerate(reader, start=2):  # Start at 2 (header is row 1)
            try:
                event = _parse_csv_row(row, user_id, batch_id, timezone)
                if event:
                    events_to_insert.append(event)
                else:
                    events_skipped += 1
            except Exception as e:
                events_skipped += 1
                errors.append({
                    "row": row_num,
                    "error": str(e),
                    "data": row.get("title", "Unknown"),
                })

        # Batch insert events
        if events_to_insert:
            # Insert in batches of 100
            batch_size = 100
            for i in range(0, len(events_to_insert), batch_size):
                batch = events_to_insert[i:i + batch_size]
                supabase.table("events").insert(batch).execute()
                events_imported += len(batch)

    except Exception as e:
        errors.append({
            "row": 0,
            "error": f"Failed to parse CSV: {str(e)}"
        })

    # Update batch status
    await _update_batch_status(batch_id, events_imported, events_skipped, errors if errors else None)


def _parse_csv_row(
    row: dict,
    user_id: str,
    batch_id: str,
    default_timezone: str,
) -> Optional[dict]:
    """Parse a single CSV row into an event dict."""
    title = row.get("title", "").strip()
    if not title:
        raise ValueError("Title is required")

    # Parse times
    start_str = row.get("start_time", "").strip()
    end_str = row.get("end_time", "").strip()

    if not start_str or not end_str:
        raise ValueError("start_time and end_time are required")

    try:
        start_time = _parse_datetime(start_str)
        end_time = _parse_datetime(end_str)
    except ValueError as e:
        raise ValueError(f"Invalid datetime format: {e}")

    if end_time <= start_time:
        raise ValueError("end_time must be after start_time")

    # Parse optional fields
    is_locked = row.get("is_locked", "").lower() in ("true", "1", "yes")

    priority_str = row.get("priority", "2").strip()
    try:
        priority = int(priority_str) if priority_str else 2
        priority = max(1, min(4, priority))
    except ValueError:
        priority = 2

    # Parse tags
    tags_str = row.get("tags", "").strip()
    tags = [t.strip() for t in tags_str.split(",") if t.strip()] if tags_str else []

    # Detect all-day events
    all_day = (
        start_time.hour == 0 and start_time.minute == 0 and
        end_time.hour == 0 and end_time.minute == 0 and
        (end_time - start_time).days >= 1
    )

    return {
        "id": str(uuid4()),
        "owner_id": user_id,
        "title": title,
        "description": row.get("description", "").strip() or None,
        "location": row.get("location", "").strip() or None,
        "start_time": start_time.isoformat(),
        "end_time": end_time.isoformat(),
        "all_day": all_day,
        "timezone": default_timezone,
        "is_locked": is_locked,
        "priority": priority,
        "tags": tags,
        "status": "scheduled",
        "import_batch_id": batch_id,
        "external_id": row.get("external_id", "").strip() or None,
    }


def _parse_datetime(value: str) -> datetime:
    """Parse datetime from various formats."""
    formats = [
        "%Y-%m-%dT%H:%M:%S%z",
        "%Y-%m-%dT%H:%M:%S.%f%z",
        "%Y-%m-%dT%H:%M:%S",
        "%Y-%m-%dT%H:%M",
        "%Y-%m-%d %H:%M:%S",
        "%Y-%m-%d %H:%M",
        "%Y-%m-%d",
        "%m/%d/%Y %H:%M:%S",
        "%m/%d/%Y %H:%M",
        "%m/%d/%Y",
    ]

    for fmt in formats:
        try:
            return datetime.strptime(value, fmt)
        except ValueError:
            continue

    # Try ISO format as fallback
    try:
        return datetime.fromisoformat(value.replace("Z", "+00:00"))
    except ValueError:
        pass

    raise ValueError(f"Could not parse datetime: {value}")


async def _update_batch_status(
    batch_id: str,
    events_imported: int,
    events_skipped: int,
    errors: Optional[list],
):
    """Update import batch with final status."""
    update_data = {
        "events_imported": events_imported,
        "events_skipped": events_skipped,
    }

    if errors:
        update_data["error_log"] = {"errors": errors}

    supabase.table("import_batches").update(update_data).eq("id", batch_id).execute()
