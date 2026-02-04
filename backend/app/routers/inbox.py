"""Inbox router - E2E encrypted messaging."""

from datetime import datetime
from typing import Optional
from uuid import UUID, uuid4
from fastapi import APIRouter, HTTPException, status, Depends, Query

from app.core.database import supabase
from app.core.security import get_current_user
from app.models.user import User
from app.models.inbox import (
    InboxMessage, InboxMessageCreate, InboxMessageResponse,
    MessageType, PublicKeyResponse
)

router = APIRouter()


@router.get("")
async def list_messages(
    unread_only: bool = False,
    message_type: Optional[MessageType] = None,
    limit: int = Query(50, le=100),
    cursor: Optional[str] = None,
    user: User = Depends(get_current_user)
):
    """
    List inbox messages (ciphertext only, client decrypts).

    Paginated with cursor-based pagination.
    """
    query = supabase.table("inbox_messages").select(
        "*, sender:users!sender_id(id, display_name, avatar_url)"
    ).eq("recipient_id", str(user.id)).is_("deleted_at", "null")

    if unread_only:
        query = query.eq("is_read", False)

    if message_type:
        query = query.eq("message_type", message_type.value)

    if cursor:
        # Cursor is the created_at of the last message
        query = query.lt("created_at", cursor)

    query = query.order("created_at", desc=True).limit(limit)

    response = query.execute()
    messages = response.data or []

    # Build response
    result = []
    for msg in messages:
        sender = msg.pop("sender", {})
        result.append({
            "id": msg["id"],
            "sender_id": msg["sender_id"],
            "sender_display_name": sender.get("display_name", "Unknown"),
            "sender_avatar_url": sender.get("avatar_url"),
            "message_type": msg["message_type"],
            "ciphertext": msg["ciphertext"],
            "ephemeral_public_key": msg["ephemeral_public_key"],
            "nonce": msg["nonce"],
            "is_read": msg["is_read"],
            "created_at": msg["created_at"],
        })

    next_cursor = messages[-1]["created_at"] if messages else None

    return {
        "messages": result,
        "next_cursor": next_cursor,
        "has_more": len(messages) == limit,
    }


@router.post("", status_code=status.HTTP_201_CREATED)
async def send_message(
    message: InboxMessageCreate,
    user: User = Depends(get_current_user)
):
    """
    Send an E2E encrypted message.

    Server never sees plaintext - client encrypts with recipient's public key.
    Triggers push notification with generic text (no content).
    """
    # Verify recipient exists
    recipient = supabase.table("users").select("id, display_name, public_key").eq(
        "id", str(message.recipient_id)
    ).single().execute()

    if not recipient.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Recipient not found"
        )

    if not recipient.data.get("public_key"):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Recipient has not set up encryption"
        )

    # Create message record
    message_id = str(uuid4())
    message_data = {
        "id": message_id,
        "sender_id": str(user.id),
        "recipient_id": str(message.recipient_id),
        "message_type": message.message_type.value,
        "ciphertext": message.ciphertext,
        "ephemeral_public_key": message.ephemeral_public_key,
        "nonce": message.nonce,
        "is_read": False,
    }

    supabase.table("inbox_messages").insert(message_data).execute()

    # TODO: Trigger push notification (generic, no content)
    # notification_text = f"New message from {user.display_name}"

    return {
        "id": message_id,
        "recipient_id": str(message.recipient_id),
        "message_type": message.message_type.value,
        "created_at": datetime.utcnow().isoformat(),
    }


@router.put("/{message_id}/read")
async def mark_read(
    message_id: UUID,
    user: User = Depends(get_current_user)
):
    """Mark a message as read."""
    # Verify message belongs to user
    message = supabase.table("inbox_messages").select("id").eq(
        "id", str(message_id)
    ).eq("recipient_id", str(user.id)).single().execute()

    if not message.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Message not found"
        )

    supabase.table("inbox_messages").update({
        "is_read": True
    }).eq("id", str(message_id)).execute()

    return {"message": "Marked as read"}


@router.post("/read-all")
async def mark_all_read(
    user: User = Depends(get_current_user)
):
    """Mark all messages as read."""
    supabase.table("inbox_messages").update({
        "is_read": True
    }).eq("recipient_id", str(user.id)).eq("is_read", False).execute()

    return {"message": "All messages marked as read"}


@router.delete("/{message_id}")
async def delete_message(
    message_id: UUID,
    user: User = Depends(get_current_user)
):
    """Soft delete a message."""
    # Verify message belongs to user (sender or recipient can delete)
    message = supabase.table("inbox_messages").select("id").eq(
        "id", str(message_id)
    ).or_(
        f"recipient_id.eq.{user.id},sender_id.eq.{user.id}"
    ).single().execute()

    if not message.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Message not found"
        )

    supabase.table("inbox_messages").update({
        "deleted_at": datetime.utcnow().isoformat()
    }).eq("id", str(message_id)).execute()

    return {"message": "Message deleted"}


@router.get("/public-key/{user_id}", response_model=PublicKeyResponse)
async def get_public_key(
    user_id: UUID,
    user: User = Depends(get_current_user)
):
    """Get a user's public key for E2E encryption."""
    target = supabase.table("users").select(
        "id, display_name, public_key"
    ).eq("id", str(user_id)).single().execute()

    if not target.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )

    return PublicKeyResponse(
        user_id=UUID(target.data["id"]),
        public_key=target.data.get("public_key"),
        display_name=target.data["display_name"],
    )


@router.get("/unread-count")
async def get_unread_count(
    user: User = Depends(get_current_user)
):
    """Get count of unread messages."""
    response = supabase.table("inbox_messages").select(
        "id", count="exact"
    ).eq("recipient_id", str(user.id)).eq(
        "is_read", False
    ).is_("deleted_at", "null").execute()

    return {"unread_count": response.count or 0}
