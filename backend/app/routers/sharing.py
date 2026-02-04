"""Event sharing router."""

from datetime import datetime
from uuid import UUID, uuid4
from fastapi import APIRouter, HTTPException, status, Depends

from app.core.database import supabase
from app.core.security import get_current_user
from app.models.user import User
from app.models.friendship import EventShare, EventShareCreate, EventShareResponse

router = APIRouter()


@router.post("/events/{event_id}/share")
async def share_event(
    event_id: UUID,
    share: EventShareCreate,
    user: User = Depends(get_current_user)
):
    """
    Share an event with another user.

    Creates an inbox notification for the recipient.
    """
    # Verify event exists and user owns it
    event_response = supabase.table("events").select("*").eq(
        "id", str(event_id)
    ).is_("deleted_at", "null").single().execute()

    if not event_response.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Event not found"
        )

    event = event_response.data

    if event["owner_id"] != str(user.id):
        # Check if user has admin permission
        admin_check = supabase.table("event_shares").select("*").eq(
            "event_id", str(event_id)
        ).eq(
            "shared_with_user_id", str(user.id)
        ).eq("permission", "admin").execute()

        if not admin_check.data:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Only owner or admin can share this event"
            )

    # Verify target user exists
    target_user = supabase.table("users").select("id, display_name").eq(
        "id", str(share.user_id)
    ).single().execute()

    if not target_user.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )

    # Check if already shared
    existing = supabase.table("event_shares").select("*").eq(
        "event_id", str(event_id)
    ).eq("shared_with_user_id", str(share.user_id)).execute()

    if existing.data:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Event already shared with this user"
        )

    # Create share record
    share_id = str(uuid4())
    share_data = {
        "id": share_id,
        "event_id": str(event_id),
        "shared_with_user_id": str(share.user_id),
        "shared_by_user_id": str(user.id),
        "permission": share.permission,
        "response": "pending",
    }

    supabase.table("event_shares").insert(share_data).execute()

    # Note: Inbox notification would be created here via E2E encryption
    # The client should create the encrypted message since server can't access plaintext

    return {
        "id": share_id,
        "event_id": str(event_id),
        "shared_with_user_id": str(share.user_id),
        "permission": share.permission,
        "response": "pending",
        "message": "Event shared. Recipient will receive a notification.",
    }


@router.put("/events/{event_id}/share/respond")
async def respond_to_share(
    event_id: UUID,
    response_data: EventShareResponse,
    user: User = Depends(get_current_user)
):
    """Respond to an event share invitation."""
    # Find the share record
    share_response = supabase.table("event_shares").select("*").eq(
        "event_id", str(event_id)
    ).eq("shared_with_user_id", str(user.id)).single().execute()

    if not share_response.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Share invitation not found"
        )

    share = share_response.data

    if share["response"] != "pending":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Already responded to this invitation"
        )

    # Update response
    supabase.table("event_shares").update({
        "response": response_data.response
    }).eq("id", share["id"]).execute()

    return {
        "message": f"Response recorded: {response_data.response}",
        "event_id": str(event_id),
        "response": response_data.response,
    }


@router.delete("/events/{event_id}/share/{user_id}")
async def remove_share(
    event_id: UUID,
    user_id: UUID,
    user: User = Depends(get_current_user)
):
    """Remove event share (unshare)."""
    # Verify event exists and user owns it or has admin permission
    event_response = supabase.table("events").select("owner_id").eq(
        "id", str(event_id)
    ).is_("deleted_at", "null").single().execute()

    if not event_response.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Event not found"
        )

    event = event_response.data
    is_owner = event["owner_id"] == str(user.id)
    is_self_removing = str(user_id) == str(user.id)

    if not is_owner and not is_self_removing:
        # Check admin permission
        admin_check = supabase.table("event_shares").select("*").eq(
            "event_id", str(event_id)
        ).eq("shared_with_user_id", str(user.id)).eq("permission", "admin").execute()

        if not admin_check.data:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Permission denied"
            )

    # Remove share
    supabase.table("event_shares").delete().eq(
        "event_id", str(event_id)
    ).eq("shared_with_user_id", str(user_id)).execute()

    return {"message": "Share removed"}


@router.get("/events/{event_id}/shares")
async def list_event_shares(
    event_id: UUID,
    user: User = Depends(get_current_user)
):
    """List all shares for an event."""
    # Verify access to event
    event_response = supabase.table("events").select("owner_id").eq(
        "id", str(event_id)
    ).is_("deleted_at", "null").single().execute()

    if not event_response.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Event not found"
        )

    event = event_response.data

    if event["owner_id"] != str(user.id):
        # Check if user has access
        access_check = supabase.table("event_shares").select("*").eq(
            "event_id", str(event_id)
        ).eq("shared_with_user_id", str(user.id)).execute()

        if not access_check.data:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Access denied"
            )

    # Get all shares with user info
    shares_response = supabase.table("event_shares").select(
        "*, users!shared_with_user_id(id, display_name, avatar_url)"
    ).eq("event_id", str(event_id)).execute()

    return {"shares": shares_response.data or []}
