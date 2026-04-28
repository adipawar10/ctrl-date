"""Inbox router - E2E encrypted messaging."""

from datetime import datetime
from dataclasses import dataclass, field
from typing import Optional, List, Dict
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
    include_sent: bool = False,
    user: User = Depends(get_current_user)
):
    """
    List inbox messages (ciphertext only, client decrypts).

    Paginated with cursor-based pagination.
    """
    query = supabase.table("inbox_messages").select(
        "*, sender:users!sender_id(id, display_name, avatar_url), recipient:users!recipient_id(id, display_name, avatar_url)"
    ).is_("deleted_at", "null")

    if include_sent:
        query = query.or_(f"recipient_id.eq.{user.id},sender_id.eq.{user.id}")
    else:
        query = query.eq("recipient_id", str(user.id))

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
        recipient = msg.pop("recipient", {})
        result.append({
            "id": msg["id"],
            "sender_id": msg["sender_id"],
            "recipient_id": msg["recipient_id"],
            "sender_display_name": sender.get("display_name", "Unknown"),
            "sender_avatar_url": sender.get("avatar_url"),
            "recipient_display_name": recipient.get("display_name", "Unknown"),
            "recipient_avatar_url": recipient.get("avatar_url"),
            "message_type": msg["message_type"],
            "ciphertext": msg["ciphertext"],
            "ephemeral_public_key": msg.get("ephemeral_public_key", ""),
            "nonce": msg.get("nonce", ""),
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



@router.get("/thread/{friend_id}")
async def get_thread(
    friend_id: UUID,
    limit: int = Query(100, le=200),
    user: User = Depends(get_current_user)
):
    """Get direct message thread between current user and friend."""
    response = supabase.table("inbox_messages").select(
        "*, sender:users!sender_id(id, display_name, avatar_url), recipient:users!recipient_id(id, display_name, avatar_url)"
    ).or_(
        f"and(sender_id.eq.{user.id},recipient_id.eq.{friend_id}),and(sender_id.eq.{friend_id},recipient_id.eq.{user.id})"
    ).eq("message_type", "text").is_("deleted_at", "null").order(
        "created_at", desc=False
    ).limit(limit).execute()

    items = []
    for msg in response.data or []:
        sender = msg.get("sender") or {}
        recipient = msg.get("recipient") or {}
        items.append({
            "id": msg["id"],
            "sender_id": msg["sender_id"],
            "recipient_id": msg["recipient_id"],
            "sender_display_name": sender.get("display_name", "Unknown"),
            "recipient_display_name": recipient.get("display_name", "Unknown"),
            "message_type": msg["message_type"],
            "ciphertext": msg["ciphertext"],
            "ephemeral_public_key": msg.get("ephemeral_public_key", ""),
            "nonce": msg.get("nonce", ""),
            "is_read": msg.get("is_read", False),
            "created_at": msg.get("created_at"),
        })

    return {"messages": items, "count": len(items)}


# In-memory community events for Inbox social feed
_COMMUNITY_EVENTS: Dict[str, dict] = {}
_COMMUNITY_ATTENDEES: Dict[str, set] = {}


@router.get("/community-events")
async def list_community_events(user: User = Depends(get_current_user)):
    events = sorted(_COMMUNITY_EVENTS.values(), key=lambda e: e["created_at"], reverse=True)
    out = []
    for e in events:
        if e.get("kind") == "poll":
            options = e.get("options", [])
            vote_totals = [len(opt.get("voter_ids", [])) for opt in options]
            selected_option = None
            for idx, opt in enumerate(options):
                if str(user.id) in (opt.get("voter_ids") or []):
                    selected_option = idx
                    break
            out.append({
                **e,
                "vote_totals": vote_totals,
                "selected_option": selected_option,
            })
        else:
            attendees = _COMMUNITY_ATTENDEES.get(e["id"], set())
            out.append({
                **e,
                "attendee_count": len(attendees),
                "is_going": str(user.id) in attendees,
                "attendees": list(attendees),
            })
    return {"events": out}


@router.post("/community-events", status_code=status.HTTP_201_CREATED)
async def create_community_event(payload: dict, user: User = Depends(get_current_user)):
    event_id = str(uuid4())
    kind = (payload.get("kind") or "event").strip().lower()
    if kind not in {"event", "poll"}:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Invalid kind")

    if kind == "poll":
        question = (payload.get("question") or "").strip()
        option1 = (payload.get("option_1") or "").strip()
        option2 = (payload.get("option_2") or "").strip()
        if not question or not option1 or not option2:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Poll question and two options are required",
            )
        rec = {
            "id": event_id,
            "kind": "poll",
            "question": question,
            "options": [
                {"label": option1, "voter_ids": []},
                {"label": option2, "voter_ids": []},
            ],
            "created_at": datetime.utcnow().isoformat(),
            "creator_id": str(user.id),
            "creator_name": getattr(user, "display_name", None) or "Unknown",
        }
        _COMMUNITY_EVENTS[event_id] = rec
        return rec

    rec = {
        "id": event_id,
        "kind": "event",
        "title": payload.get("title", "Untitled event"),
        "description": payload.get("description"),
        "location": payload.get("location"),
        "notes": payload.get("notes"),
        "starts_at": payload.get("starts_at"),
        "created_at": datetime.utcnow().isoformat(),
        "creator_id": str(user.id),
        "creator_name": getattr(user, "display_name", None) or "Unknown",
    }
    _COMMUNITY_EVENTS[event_id] = rec
    _COMMUNITY_ATTENDEES.setdefault(event_id, set()).add(str(user.id))
    return rec


@router.post("/community-events/{event_id}/rsvp")
async def rsvp_community_event(event_id: UUID, payload: dict, user: User = Depends(get_current_user)):
    key = str(event_id)
    if key not in _COMMUNITY_EVENTS:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Event not found")
    if _COMMUNITY_EVENTS[key].get("kind") != "event":
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="RSVP is only for events")
    going = bool(payload.get("going", True))
    attendees = _COMMUNITY_ATTENDEES.setdefault(key, set())
    if going:
        attendees.add(str(user.id))
    else:
        attendees.discard(str(user.id))
    return {"event_id": key, "going": going, "attendee_count": len(attendees)}


@router.post("/community-events/{event_id}/vote")
async def vote_community_poll(event_id: UUID, payload: dict, user: User = Depends(get_current_user)):
    key = str(event_id)
    event = _COMMUNITY_EVENTS.get(key)
    if not event:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Event not found")
    if event.get("kind") != "poll":
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Voting is only for polls")

    option_index = int(payload.get("option_index", -1))
    options = event.get("options", [])
    if option_index < 0 or option_index >= len(options):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Invalid poll option")

    for opt in options:
        voter_ids = opt.get("voter_ids", [])
        if str(user.id) in voter_ids:
            voter_ids.remove(str(user.id))
        opt["voter_ids"] = voter_ids

    selected = options[option_index].get("voter_ids", [])
    if str(user.id) not in selected:
        selected.append(str(user.id))
    options[option_index]["voter_ids"] = selected
    event["options"] = options
    _COMMUNITY_EVENTS[key] = event

    return {
        "event_id": key,
        "selected_option": option_index,
        "vote_totals": [len(opt.get("voter_ids", [])) for opt in options],
    }


@router.put("/community-events/{event_id}/notes")
async def update_community_event_notes(event_id: UUID, payload: dict, user: User = Depends(get_current_user)):
    key = str(event_id)
    event = _COMMUNITY_EVENTS.get(key)
    if not event:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Event not found")
    if event.get("kind") != "event":
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Notes are only for events")
    if event.get("creator_id") != str(user.id):
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Only creator can edit notes")

    event["notes"] = (payload.get("notes") or "").strip() or None
    _COMMUNITY_EVENTS[key] = event
    return {"event_id": key, "notes": event.get("notes")}


@router.get("/community-events/{event_id}/attendees")
async def community_event_attendees(event_id: UUID, user: User = Depends(get_current_user)):
    key = str(event_id)
    if key not in _COMMUNITY_EVENTS:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Event not found")
    if _COMMUNITY_EVENTS[key].get("kind") != "event":
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Attendees are only for events")
    ids = list(_COMMUNITY_ATTENDEES.get(key, set()))
    if not ids:
        return {"attendees": []}
    res = supabase.table("users").select("id, display_name, avatar_url").in_("id", ids).execute()
    return {"attendees": res.data or []}


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
