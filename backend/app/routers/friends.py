"""Friends router - friend requests, management, and pokes."""

from datetime import datetime, timedelta
from typing import Optional
from uuid import UUID, uuid4
from fastapi import APIRouter, HTTPException, status, Depends, Query
from pydantic import BaseModel

from app.core.database import supabase
from app.core.security import get_current_user
from app.models.user import User
from app.models.friendship import (
    Friendship, FriendRequest, FriendshipResponse, FriendshipStatus,
    Poke, PokeCreate
)
from app.services.recurrence import expand_recurrence_in_range

router = APIRouter()


class FriendshipUpdate(BaseModel):
    """Schema for updating friendship metadata."""
    is_favorite: Optional[bool] = None
    is_muted: Optional[bool] = None
    nickname: Optional[str] = None


@router.get("/calendar/{friend_user_id}")
async def get_friend_calendar(
    friend_user_id: UUID,
    start: datetime,
    end: datetime,
    user: User = Depends(get_current_user),
):
    """Return a friend's events in a range for calendar comparison."""
    friendship = supabase.table("friendships").select("id").or_(
        f"and(requester_id.eq.{user.id},addressee_id.eq.{friend_user_id}),"
        f"and(requester_id.eq.{friend_user_id},addressee_id.eq.{user.id})"
    ).eq("status", "accepted").execute()

    if not friendship.data:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You can only compare calendars with accepted friends",
        )

    friend_events = supabase.table("events").select("*").eq(
        "owner_id", str(friend_user_id)
    ).is_("deleted_at", "null").or_(
        f"and(start_time.lte.{end.isoformat()},end_time.gte.{start.isoformat()}),"
        "recurrence_rule_id.not.is.null"
    ).execute().data or []

    expanded_events = []
    for event in friend_events:
        if event.get("recurrence_rule_id") and not event.get("recurrence_parent_id"):
            expanded_events.extend(await expand_recurrence_in_range(event, start, end))
        elif not event.get("recurrence_parent_id"):
            expanded_events.append(event)

    return {
        "events": expanded_events,
        "total": len(expanded_events),
    }


@router.get("")
async def list_friends(
    status_filter: Optional[FriendshipStatus] = Query(FriendshipStatus.ACCEPTED, alias="status"),
    user: User = Depends(get_current_user)
):
    """List friends with optional status filter."""
    # Get friendships where user is requester or addressee
    query1 = supabase.table("friendships").select(
        "*, users!addressee_id(id, display_name, avatar_url, public_key)"
    ).eq("requester_id", str(user.id))

    query2 = supabase.table("friendships").select(
        "*, users!requester_id(id, display_name, avatar_url, public_key)"
    ).eq("addressee_id", str(user.id))

    if status_filter:
        query1 = query1.eq("status", status_filter.value)
        query2 = query2.eq("status", status_filter.value)

    response1 = query1.execute()
    response2 = query2.execute()

    # Collect all friend user IDs to batch-fetch streaks
    friend_user_ids = set()
    for f in response1.data or []:
        friend_data = f.get("users")
        if friend_data:
            friend_user_ids.add(friend_data["id"])
    for f in response2.data or []:
        friend_data = f.get("users")
        if friend_data:
            friend_user_ids.add(friend_data["id"])

    # Fetch streak data for all friends in one query
    streaks_by_user = {}
    if friend_user_ids:
        streaks_response = supabase.table("streaks").select(
            "user_id, streak_type, current_count, longest_count"
        ).in_("user_id", list(friend_user_ids)).eq(
            "streak_type", "daily_completion"
        ).execute()

        for s in streaks_response.data or []:
            streaks_by_user[s["user_id"]] = {
                "current_count": s.get("current_count", 0),
                "longest_count": s.get("longest_count", 0),
            }

    friends = []

    # Process friendships where user is requester
    for f in response1.data or []:
        friend_data = f.get("users")
        if friend_data:
            streak = streaks_by_user.get(friend_data["id"], {})
            friends.append({
                "friendship_id": f["id"],
                "user_id": friend_data["id"],
                "display_name": friend_data["display_name"],
                "avatar_url": friend_data.get("avatar_url"),
                "public_key": friend_data.get("public_key"),
                "status": f["status"],
                "is_requester": True,
                "created_at": f["created_at"],
                "accepted_at": f.get("accepted_at"),
                "streak_count": streak.get("current_count", 0),
                "longest_streak": streak.get("longest_count", 0),
            })

    # Process friendships where user is addressee
    for f in response2.data or []:
        friend_data = f.get("users")
        if friend_data:
            streak = streaks_by_user.get(friend_data["id"], {})
            friends.append({
                "friendship_id": f["id"],
                "user_id": friend_data["id"],
                "display_name": friend_data["display_name"],
                "avatar_url": friend_data.get("avatar_url"),
                "public_key": friend_data.get("public_key"),
                "status": f["status"],
                "is_requester": False,
                "created_at": f["created_at"],
                "accepted_at": f.get("accepted_at"),
                "streak_count": streak.get("current_count", 0),
                "longest_streak": streak.get("longest_count", 0),
            })

    return {"friends": friends}


@router.post("/request")
async def send_friend_request(
    request: FriendRequest,
    user: User = Depends(get_current_user)
):
    """Send a friend request by user_id or email."""
    # Find target user
    if request.user_id:
        target_response = supabase.table("users").select("id, display_name").eq(
            "id", str(request.user_id)
        ).single().execute()
    elif request.email:
        target_response = supabase.table("users").select("id, display_name").eq(
            "email", request.email
        ).single().execute()
    else:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Must provide user_id or email"
        )

    if not target_response.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )

    target = target_response.data
    target_id = target["id"]

    if target_id == str(user.id):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Cannot send friend request to yourself"
        )

    # Check for existing friendship
    existing = supabase.table("friendships").select("*").or_(
        f"and(requester_id.eq.{user.id},addressee_id.eq.{target_id}),"
        f"and(requester_id.eq.{target_id},addressee_id.eq.{user.id})"
    ).execute()

    if existing.data:
        friendship = existing.data[0]
        if friendship["status"] == "accepted":
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Already friends"
            )
        elif friendship["status"] == "pending":
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Friend request already pending"
            )
        elif friendship["status"] == "blocked":
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Cannot send request"
            )

    # Create friendship request
    friendship_id = str(uuid4())
    friendship_data = {
        "id": friendship_id,
        "requester_id": str(user.id),
        "addressee_id": target_id,
        "status": "pending",
    }

    supabase.table("friendships").insert(friendship_data).execute()

    return {
        "id": friendship_id,
        "addressee_id": target_id,
        "addressee_name": target["display_name"],
        "status": "pending",
        "message": "Friend request sent",
    }


@router.put("/{friendship_id}/respond")
async def respond_to_request(
    friendship_id: UUID,
    response: FriendshipResponse,
    user: User = Depends(get_current_user)
):
    """Respond to a friend request (accept, decline, or block)."""
    # Find friendship where user is addressee
    friendship_response = supabase.table("friendships").select("*").eq(
        "id", str(friendship_id)
    ).eq("addressee_id", str(user.id)).single().execute()

    if not friendship_response.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Friend request not found"
        )

    friendship = friendship_response.data

    if friendship["status"] != "pending":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Request already responded to"
        )

    # Update status
    update_data = {"status": response.action}
    if response.action == "accept":
        update_data["status"] = "accepted"
        update_data["accepted_at"] = datetime.utcnow().isoformat()
    elif response.action == "decline":
        # Delete the request instead of keeping it
        supabase.table("friendships").delete().eq(
            "id", str(friendship_id)
        ).execute()
        return {"message": "Friend request declined"}
    elif response.action == "block":
        update_data["status"] = "blocked"

    supabase.table("friendships").update(update_data).eq(
        "id", str(friendship_id)
    ).execute()

    return {
        "id": str(friendship_id),
        "status": update_data["status"],
        "message": f"Friend request {response.action}ed",
    }


@router.delete("/{friendship_id}")
async def remove_friend(
    friendship_id: UUID,
    user: User = Depends(get_current_user)
):
    """Remove a friend or cancel a pending request."""
    # Find friendship
    friendship_response = supabase.table("friendships").select("*").eq(
        "id", str(friendship_id)
    ).or_(
        f"requester_id.eq.{user.id},addressee_id.eq.{user.id}"
    ).single().execute()

    if not friendship_response.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Friendship not found"
        )

    # Delete friendship
    supabase.table("friendships").delete().eq(
        "id", str(friendship_id)
    ).execute()

    return {"message": "Friend removed"}


@router.patch("/{friendship_id}")
async def update_friendship(
    friendship_id: UUID,
    update: FriendshipUpdate,
    user: User = Depends(get_current_user)
):
    """Update friendship metadata (favorite, mute, nickname)."""
    # Verify friendship exists and user is part of it
    friendship_response = supabase.table("friendships").select("*").eq(
        "id", str(friendship_id)
    ).or_(
        f"requester_id.eq.{user.id},addressee_id.eq.{user.id}"
    ).single().execute()

    if not friendship_response.data:
        raise HTTPException(status_code=404, detail="Friendship not found")

    update_data = {k: v for k, v in update.dict().items() if v is not None}
    if not update_data:
        raise HTTPException(status_code=400, detail="No fields to update")

    supabase.table("friendships").update(update_data).eq(
        "id", str(friendship_id)
    ).execute()

    return {"id": str(friendship_id), **update_data}


@router.post("/pokes/mark-all-read")
async def mark_all_pokes_read(
    user: User = Depends(get_current_user)
):
    """Mark all pokes as read for the current user."""
    supabase.table("pokes").update(
        {"is_read": True}
    ).eq("receiver_id", str(user.id)).eq("is_read", False).execute()

    return {"message": "All pokes marked as read"}


@router.patch("/pokes/{poke_id}")
async def mark_poke_read(
    poke_id: UUID,
    user: User = Depends(get_current_user)
):
    """Mark a poke as read."""
    supabase.table("pokes").update(
        {"is_read": True}
    ).eq("id", str(poke_id)).eq("receiver_id", str(user.id)).execute()

    return {"id": str(poke_id), "is_read": True}


@router.post("/{friend_id}/poke")
async def poke_friend(
    friend_id: UUID,
    poke_data: PokeCreate,
    user: User = Depends(get_current_user)
):
    """
    Send a procrastination nudge to a friend.

    Rate limited to 1 poke per friend pair per hour.
    Triggers push notification.
    """
    # Verify friendship exists and is accepted
    friendship = supabase.table("friendships").select("*").or_(
        f"and(requester_id.eq.{user.id},addressee_id.eq.{friend_id}),"
        f"and(requester_id.eq.{friend_id},addressee_id.eq.{user.id})"
    ).eq("status", "accepted").execute()

    if not friendship.data:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You can only poke friends"
        )

    # Check rate limit (1 poke per hour per pair)
    one_hour_ago = (datetime.utcnow() - timedelta(hours=1)).isoformat()
    recent_poke = supabase.table("pokes").select("*").eq(
        "poker_id", str(user.id)
    ).eq("pokee_id", str(friend_id)).gte(
        "created_at", one_hour_ago
    ).execute()

    if recent_poke.data:
        raise HTTPException(
            status_code=status.HTTP_429_TOO_MANY_REQUESTS,
            detail="You can only poke this friend once per hour"
        )

    # Create poke
    poke_id = str(uuid4())
    poke_record = {
        "id": poke_id,
        "poker_id": str(user.id),
        "pokee_id": str(friend_id),
        "event_id": str(poke_data.event_id) if poke_data.event_id else None,
    }

    supabase.table("pokes").insert(poke_record).execute()

    # TODO: Trigger push notification
    # This would be handled by a background task/worker

    return {
        "id": poke_id,
        "pokee_id": str(friend_id),
        "message": "Poke sent!",
    }


@router.get("/pokes")
async def get_recent_pokes(
    limit: int = 20,
    user: User = Depends(get_current_user)
):
    """Get recent pokes received."""
    response = supabase.table("pokes").select(
        "*, users!poker_id(id, display_name, avatar_url)"
    ).eq("pokee_id", str(user.id)).order(
        "created_at", desc=True
    ).limit(limit).execute()

    return {"pokes": response.data or []}
