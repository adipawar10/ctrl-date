"""Friendship and social models."""

from datetime import datetime
from typing import Optional
from pydantic import BaseModel
from uuid import UUID
from enum import Enum


class FriendshipStatus(str, Enum):
    """Friendship request status."""
    PENDING = "pending"
    ACCEPTED = "accepted"
    BLOCKED = "blocked"


class Friendship(BaseModel):
    """Friendship model matching database schema."""
    id: UUID
    requester_id: UUID
    addressee_id: UUID
    status: FriendshipStatus = FriendshipStatus.PENDING
    created_at: datetime
    accepted_at: Optional[datetime] = None
    # ADD THESE TWO FIELDS:
    streak_count: int = 0
    longest_streak: int = 0

    class Config:
        from_attributes = True


class FriendRequest(BaseModel):
    """Schema for sending a friend request."""
    user_id: Optional[UUID] = None
    email: Optional[str] = None  # Alternative: find by email


class FriendshipResponse(BaseModel):
    """Schema for responding to a friend request."""
    action: str  # accept, decline, block


class Poke(BaseModel):
    """Poke model for procrastination nudges."""
    id: UUID
    poker_id: UUID
    pokee_id: UUID
    event_id: Optional[UUID] = None
    created_at: datetime

    class Config:
        from_attributes = True


class PokeCreate(BaseModel):
    """Schema for creating a poke."""
    event_id: Optional[UUID] = None


class EventShare(BaseModel):
    """Event share model."""
    id: UUID
    event_id: UUID
    shared_with_user_id: UUID
    shared_by_user_id: UUID
    permission: str = "view"  # view, edit, admin
    response: str = "pending"  # pending, accepted, declined, tentative
    created_at: datetime

    class Config:
        from_attributes = True


class EventShareCreate(BaseModel):
    """Schema for sharing an event."""
    user_id: UUID
    permission: str = "view"


class EventShareResponse(BaseModel):
    """Schema for responding to an event share."""
    response: str  # accepted, declined, tentative
