"""Event polls router for collaborative planning."""

from datetime import datetime
from typing import List, Optional
from uuid import UUID, uuid4
from fastapi import APIRouter, HTTPException, status, Depends
from pydantic import BaseModel

from app.core.database import supabase
from app.core.security import get_current_user
from app.models.user import User

router = APIRouter()


class PollOption(BaseModel):
    """A single poll option (time slot or place)."""
    label: str
    start_time: Optional[datetime] = None
    end_time: Optional[datetime] = None


class PollCreate(BaseModel):
    """Request to create a new poll."""
    title: str
    description: Optional[str] = None
    poll_type: str = "time"  # "time" or "place"
    options: List[PollOption]
    invited_user_ids: List[str] = []
    expires_at: Optional[datetime] = None


class PollVote(BaseModel):
    """A vote on a poll option."""
    option_index: int
    vote: str = "yes"  # "yes", "no", "maybe"


@router.post("/polls")
async def create_poll(
    poll: PollCreate,
    user: User = Depends(get_current_user),
):
    """Create a new poll for event planning."""
    poll_id = str(uuid4())

    options_data = []
    for i, opt in enumerate(poll.options):
        options_data.append({
            "index": i,
            "label": opt.label,
            "start_time": opt.start_time.isoformat() if opt.start_time else None,
            "end_time": opt.end_time.isoformat() if opt.end_time else None,
            "votes": [],
        })

    poll_data = {
        "id": poll_id,
        "creator_id": str(user.id),
        "title": poll.title,
        "description": poll.description,
        "poll_type": poll.poll_type,
        "options": options_data,
        "invited_user_ids": poll.invited_user_ids,
        "expires_at": poll.expires_at.isoformat() if poll.expires_at else None,
        "is_closed": False,
    }

    supabase.table("polls").insert(poll_data).execute()

    # Send inbox notifications to invited users
    for invited_id in poll.invited_user_ids:
        notification = {
            "id": str(uuid4()),
            "user_id": invited_id,
            "type": "poll_invite",
            "title": f"Poll: {poll.title}",
            "body": f"{user.display_name or 'Someone'} invited you to vote",
            "sender_id": str(user.id),
            "data": {"poll_id": poll_id},
        }
        supabase.table("inbox_messages").insert(notification).execute()

    return {"id": poll_id, "message": "Poll created", **poll_data}


@router.get("/polls")
async def list_polls(
    user: User = Depends(get_current_user),
):
    """List polls the user created or is invited to."""
    # Polls created by user
    created = supabase.table("polls").select("*").eq(
        "creator_id", str(user.id)
    ).execute()

    # Polls user is invited to
    invited = supabase.table("polls").select("*").contains(
        "invited_user_ids", [str(user.id)]
    ).execute()

    all_polls = {p["id"]: p for p in (created.data or []) + (invited.data or [])}

    return {"polls": list(all_polls.values())}


@router.get("/polls/{poll_id}")
async def get_poll(
    poll_id: UUID,
    user: User = Depends(get_current_user),
):
    """Get poll details with vote counts."""
    response = supabase.table("polls").select("*").eq(
        "id", str(poll_id)
    ).single().execute()

    if not response.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Poll not found",
        )

    poll = response.data

    # Verify access
    if (poll["creator_id"] != str(user.id) and
            str(user.id) not in (poll.get("invited_user_ids") or [])):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Access denied",
        )

    return poll


@router.post("/polls/{poll_id}/vote")
async def vote_on_poll(
    poll_id: UUID,
    vote: PollVote,
    user: User = Depends(get_current_user),
):
    """Cast a vote on a poll option."""
    response = supabase.table("polls").select("*").eq(
        "id", str(poll_id)
    ).single().execute()

    if not response.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Poll not found",
        )

    poll = response.data

    if poll.get("is_closed"):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Poll is closed",
        )

    options = poll.get("options", [])
    if vote.option_index >= len(options):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid option index",
        )

    # Remove existing vote from this user on this option
    option = options[vote.option_index]
    existing_votes = option.get("votes", [])
    existing_votes = [v for v in existing_votes if v.get("user_id") != str(user.id)]

    # Add new vote
    existing_votes.append({
        "user_id": str(user.id),
        "vote": vote.vote,
        "voted_at": datetime.utcnow().isoformat(),
    })

    options[vote.option_index]["votes"] = existing_votes

    supabase.table("polls").update({
        "options": options,
    }).eq("id", str(poll_id)).execute()

    return {"message": "Vote recorded"}


@router.post("/polls/{poll_id}/close")
async def close_poll(
    poll_id: UUID,
    user: User = Depends(get_current_user),
):
    """Close a poll (creator only). Returns winning option."""
    response = supabase.table("polls").select("*").eq(
        "id", str(poll_id)
    ).single().execute()

    if not response.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Poll not found",
        )

    poll = response.data

    if poll["creator_id"] != str(user.id):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only creator can close poll",
        )

    # Find winning option
    options = poll.get("options", [])
    best_index = 0
    best_yes_count = 0

    for i, opt in enumerate(options):
        yes_count = sum(
            1 for v in opt.get("votes", []) if v.get("vote") == "yes"
        )
        if yes_count > best_yes_count:
            best_yes_count = yes_count
            best_index = i

    supabase.table("polls").update({
        "is_closed": True,
        "winning_option_index": best_index,
    }).eq("id", str(poll_id)).execute()

    return {
        "message": "Poll closed",
        "winning_option": options[best_index] if options else None,
        "winning_index": best_index,
    }
