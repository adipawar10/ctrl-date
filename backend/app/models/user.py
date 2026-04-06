"""User model."""

from datetime import datetime
from typing import Optional, Dict, Any
from pydantic import BaseModel, EmailStr, Field
from uuid import UUID


class UserPreferences(BaseModel):
    """User preferences for scheduling and display."""
    default_event_duration: int = 60  # minutes
    week_start: str = "monday"  # monday or sunday
    working_hours_start: str = "09:00"
    working_hours_end: str = "17:00"
    notification_lead_time: int = 15  # minutes
    preferred_focus_hours: list[int] = Field(default_factory=lambda: [9, 10, 11, 14, 15])


class User(BaseModel):
    """User model matching database schema."""
    id: UUID
    email: EmailStr
    display_name: str
    avatar_url: Optional[str] = None
    timezone: str = "UTC"
    preferences: Optional[UserPreferences] = Field(default_factory=UserPreferences)
    public_key: Optional[str] = None  # E2E encryption public key
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class UserCreate(BaseModel):
    """Schema for creating a user."""
    email: EmailStr
    display_name: str
    timezone: str = "UTC"
    preferences: Optional[UserPreferences] = None


class UserUpdate(BaseModel):
    """Schema for updating a user."""
    display_name: Optional[str] = None
    avatar_url: Optional[str] = None
    timezone: Optional[str] = None
    preferences: Optional[UserPreferences] = None
    public_key: Optional[str] = None
