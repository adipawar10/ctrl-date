"""Calendar import router for CSV imports."""

from datetime import datetime
from typing import Optional
from uuid import UUID, uuid4
from fastapi import APIRouter, HTTPException, status, Depends, UploadFile, File, BackgroundTasks
from pydantic import BaseModel

from app.core.database import supabase
from app.core.security import get_current_user
from app.models.user import User
from app.services.import_service import process_csv_import

router = APIRouter()


class ImportBatchResponse(BaseModel):
    """Response for import batch."""
    id: UUID
    filename: str
    status: str  # pending, processing, completed, failed
    events_imported: int
    events_skipped: int
    can_undo: bool
    error_log: Optional[dict] = None
    created_at: datetime


@router.post("/csv", response_model=ImportBatchResponse)
async def import_csv(
    background_tasks: BackgroundTasks,
    file: UploadFile = File(...),
    user: User = Depends(get_current_user)
):
    """
    Queue CSV import for background processing.

    Expected CSV format:
    title,description,start_time,end_time,location,is_locked,priority,tags

    Returns batch_id for tracking progress.
    """
    if not file.filename.endswith('.csv'):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="File must be a CSV"
        )

    # Read file content
    content = await file.read()

    # Create import batch record
    batch_id = str(uuid4())
    batch_data = {
        "id": batch_id,
        "user_id": str(user.id),
        "filename": file.filename,
        "events_imported": 0,
        "events_skipped": 0,
        "can_undo": True,
    }

    supabase.table("import_batches").insert(batch_data).execute()

    # Queue background processing
    background_tasks.add_task(
        process_csv_import,
        batch_id=batch_id,
        user_id=str(user.id),
        content=content.decode('utf-8'),
        timezone=user.timezone,
    )

    return ImportBatchResponse(
        id=UUID(batch_id),
        filename=file.filename,
        status="processing",
        events_imported=0,
        events_skipped=0,
        can_undo=True,
        created_at=datetime.utcnow(),
    )


@router.get("/{batch_id}", response_model=ImportBatchResponse)
async def get_import_status(
    batch_id: UUID,
    user: User = Depends(get_current_user)
):
    """Get import batch status and results."""
    response = supabase.table("import_batches").select("*").eq(
        "id", str(batch_id)
    ).eq("user_id", str(user.id)).single().execute()

    if not response.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Import batch not found"
        )

    batch = response.data

    # Determine status
    if batch.get("undone_at"):
        status_str = "undone"
    elif batch.get("error_log"):
        status_str = "failed" if batch["events_imported"] == 0 else "completed_with_errors"
    elif batch["events_imported"] > 0 or batch["events_skipped"] > 0:
        status_str = "completed"
    else:
        status_str = "processing"

    return ImportBatchResponse(
        id=UUID(batch["id"]),
        filename=batch["filename"],
        status=status_str,
        events_imported=batch["events_imported"],
        events_skipped=batch["events_skipped"],
        can_undo=batch["can_undo"] and not batch.get("undone_at"),
        error_log=batch.get("error_log"),
        created_at=batch["created_at"],
    )


@router.post("/{batch_id}/undo")
async def undo_import(
    batch_id: UUID,
    user: User = Depends(get_current_user)
):
    """Undo entire import batch (soft delete all imported events)."""
    # Verify batch exists and belongs to user
    response = supabase.table("import_batches").select("*").eq(
        "id", str(batch_id)
    ).eq("user_id", str(user.id)).single().execute()

    if not response.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Import batch not found"
        )

    batch = response.data

    if not batch["can_undo"]:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="This import cannot be undone"
        )

    if batch.get("undone_at"):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Import already undone"
        )

    # Soft delete all events from this batch
    deleted_at = datetime.utcnow().isoformat()
    supabase.table("events").update({
        "deleted_at": deleted_at
    }).eq("import_batch_id", str(batch_id)).execute()

    # Mark batch as undone
    supabase.table("import_batches").update({
        "undone_at": deleted_at
    }).eq("id", str(batch_id)).execute()

    return {"message": f"Undone import of {batch['events_imported']} events"}


@router.get("")
async def list_import_batches(
    limit: int = 20,
    user: User = Depends(get_current_user)
):
    """List recent import batches."""
    response = supabase.table("import_batches").select("*").eq(
        "user_id", str(user.id)
    ).order("created_at", desc=True).limit(limit).execute()

    batches = []
    for batch in response.data or []:
        if batch.get("undone_at"):
            status_str = "undone"
        elif batch.get("error_log"):
            status_str = "failed" if batch["events_imported"] == 0 else "completed_with_errors"
        elif batch["events_imported"] > 0 or batch["events_skipped"] > 0:
            status_str = "completed"
        else:
            status_str = "processing"

        batches.append({
            "id": batch["id"],
            "filename": batch["filename"],
            "status": status_str,
            "events_imported": batch["events_imported"],
            "events_skipped": batch["events_skipped"],
            "can_undo": batch["can_undo"] and not batch.get("undone_at"),
            "created_at": batch["created_at"],
        })

    return {"batches": batches}
