"""Sync router for offline-first bidirectional sync."""

from datetime import datetime
from typing import List, Optional
from uuid import UUID
from fastapi import APIRouter, HTTPException, status, Depends
from pydantic import BaseModel

from app.core.database import supabase
from app.core.security import get_current_user
from app.models.user import User

router = APIRouter()


class SyncChange(BaseModel):
    """A single change to sync."""
    table: str  # events, daily_reflections, etc.
    operation: str  # insert, update, delete
    record_id: str
    data: dict
    local_updated_at: datetime
    version: Optional[int] = None


class SyncRequest(BaseModel):
    """Request for bidirectional sync."""
    last_sync_at: Optional[datetime] = None
    local_changes: List[SyncChange] = []


class SyncConflict(BaseModel):
    """A sync conflict that was resolved."""
    table: str
    record_id: str
    resolution: str  # server_wins, client_wins, merged
    server_version: int
    client_version: int


class SyncResponse(BaseModel):
    """Response from sync operation."""
    server_changes: List[dict]
    conflicts: List[SyncConflict]
    sync_timestamp: datetime
    success: bool


# Tables allowed for sync
SYNCABLE_TABLES = {
    "events",
    "daily_reflections",
    "streaks",
}


@router.post("", response_model=SyncResponse)
async def sync_changes(
    request: SyncRequest,
    user: User = Depends(get_current_user)
):
    """
    Bidirectional sync endpoint.

    Client sends:
    - last_sync_at timestamp
    - local changes made offline

    Server returns:
    - server changes since last_sync_at
    - conflict resolutions (last-write-wins with version check)
    - new sync timestamp
    """
    sync_timestamp = datetime.utcnow()
    server_changes = []
    conflicts = []

    # Process client changes first
    for change in request.local_changes:
        if change.table not in SYNCABLE_TABLES:
            continue

        try:
            conflict = await _process_client_change(change, user)
            if conflict:
                conflicts.append(conflict)
        except Exception as e:
            # Log error but continue with other changes
            print(f"Error processing sync change: {e}")

    # Fetch server changes since last sync
    if request.last_sync_at:
        for table in SYNCABLE_TABLES:
            changes = await _get_server_changes(
                table, user.id, request.last_sync_at
            )
            server_changes.extend(changes)

    return SyncResponse(
        server_changes=server_changes,
        conflicts=conflicts,
        sync_timestamp=sync_timestamp,
        success=True,
    )


async def _process_client_change(
    change: SyncChange,
    user: User
) -> Optional[SyncConflict]:
    """Process a single client change with conflict resolution."""
    table = change.table

    # Verify ownership based on table
    if table == "events":
        owner_field = "owner_id"
    elif table in ["daily_reflections", "streaks"]:
        owner_field = "user_id"
    else:
        return None

    if change.operation == "insert":
        # For inserts, just add the record
        data = change.data.copy()
        data[owner_field] = str(user.id)
        data["id"] = change.record_id

        try:
            supabase.table(table).insert(data).execute()
        except Exception:
            # Record might already exist (duplicate), try update instead
            supabase.table(table).upsert(data).execute()

    elif change.operation == "update":
        # Check for conflicts using version
        existing = supabase.table(table).select("version, updated_at").eq(
            "id", change.record_id
        ).eq(owner_field, str(user.id)).single().execute()

        if not existing.data:
            # Record doesn't exist, treat as insert
            data = change.data.copy()
            data[owner_field] = str(user.id)
            data["id"] = change.record_id
            supabase.table(table).insert(data).execute()
            return None

        server_version = existing.data.get("version", 1)
        client_version = change.version or 1

        if server_version > client_version:
            # Server has newer version - server wins
            return SyncConflict(
                table=table,
                record_id=change.record_id,
                resolution="server_wins",
                server_version=server_version,
                client_version=client_version,
            )

        # Client version is same or newer - apply update
        data = change.data.copy()
        data["version"] = server_version + 1
        data["updated_at"] = datetime.utcnow().isoformat()

        supabase.table(table).update(data).eq(
            "id", change.record_id
        ).eq(owner_field, str(user.id)).execute()

    elif change.operation == "delete":
        # Soft delete
        supabase.table(table).update({
            "deleted_at": datetime.utcnow().isoformat()
        }).eq("id", change.record_id).eq(owner_field, str(user.id)).execute()

    return None


async def _get_server_changes(
    table: str,
    user_id: UUID,
    since: datetime
) -> List[dict]:
    """Get all changes from server since timestamp."""
    if table == "events":
        owner_field = "owner_id"
    elif table in ["daily_reflections", "streaks"]:
        owner_field = "user_id"
    else:
        return []

    response = supabase.table(table).select("*").eq(
        owner_field, str(user_id)
    ).gte("updated_at", since.isoformat()).execute()

    changes = []
    for record in response.data or []:
        changes.append({
            "table": table,
            "operation": "delete" if record.get("deleted_at") else "upsert",
            "record_id": record["id"],
            "data": record,
            "server_updated_at": record.get("updated_at"),
            "version": record.get("version", 1),
        })

    return changes


@router.get("/status")
async def get_sync_status(
    user: User = Depends(get_current_user)
):
    """Get sync status and statistics."""
    # Count records per table
    stats = {}
    for table in SYNCABLE_TABLES:
        if table == "events":
            owner_field = "owner_id"
        else:
            owner_field = "user_id"

        response = supabase.table(table).select(
            "id", count="exact"
        ).eq(owner_field, str(user.id)).is_("deleted_at", "null").execute()

        stats[table] = response.count or 0

    return {
        "user_id": str(user.id),
        "record_counts": stats,
        "server_time": datetime.utcnow().isoformat(),
    }
