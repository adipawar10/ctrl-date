"""Event and recurrence models."""

from datetime import datetime, date
from typing import Optional, List
from pydantic import BaseModel, Field, field_validator
from uuid import UUID
from enum import Enum


class EventStatus(str, Enum):
    """Event completion status."""
    SCHEDULED = "scheduled"
    COMPLETED = "completed"
    SKIPPED = "skipped"
    PARTIAL = "partial"
    CANCELLED = "cancelled"


class RecurrenceFrequency(str, Enum):
    """Recurrence frequency options."""
    DAILY = "daily"
    WEEKLY = "weekly"
    MONTHLY = "monthly"
    YEARLY = "yearly"


class RecurrenceUpdateScope(str, Enum):
    """Scope for updating recurring events."""
    SINGLE = "single"
    FUTURE = "future"
    ALL = "all"


class RecurrenceRule(BaseModel):
    """RFC 5545 compliant recurrence rule."""
    id: Optional[UUID] = None
    frequency: RecurrenceFrequency
    interval: int = 1
    by_weekday: Optional[List[int]] = None  # 0=Mon, 6=Sun
    by_monthday: Optional[List[int]] = None
    by_month: Optional[List[int]] = None
    by_setpos: Optional[List[int]] = None
    until_date: Optional[date] = None
    count: Optional[int] = None
    excluded_dates: List[date] = Field(default_factory=list)

    @field_validator('interval')
    @classmethod
    def interval_must_be_positive(cls, v: int) -> int:
        if v < 1:
            raise ValueError('interval must be at least 1')
        return v


class Event(BaseModel):
    """Event model matching database schema."""
    id: UUID
    owner_id: UUID
    title: str
    description: Optional[str] = None
    location: Optional[str] = None

    # Timing
    start_time: datetime
    end_time: datetime
    all_day: bool = False
    timezone: str

    # Scheduling constraints
    is_locked: bool = False
    priority: int = 2  # 1=low, 2=medium, 3=high, 4=critical

    # Recurrence
    recurrence_rule_id: Optional[UUID] = None
    recurrence_parent_id: Optional[UUID] = None
    recurrence_instance_date: Optional[date] = None

    # Completion
    status: EventStatus = EventStatus.SCHEDULED
    completion_notes: Optional[str] = None
    completed_at: Optional[datetime] = None

    # Import tracking
    import_batch_id: Optional[UUID] = None
    external_id: Optional[str] = None

    # Metadata
    color: Optional[str] = None
    tags: List[str] = Field(default_factory=list)

    # Sync
    created_at: datetime
    updated_at: datetime
    deleted_at: Optional[datetime] = None
    version: int = 1

    class Config:
        from_attributes = True

    @field_validator('priority')
    @classmethod
    def priority_must_be_valid(cls, v: int) -> int:
        if not 1 <= v <= 4:
            raise ValueError('priority must be between 1 and 4')
        return v


class EventCreate(BaseModel):
    """Schema for creating an event."""
    title: str
    description: Optional[str] = None
    location: Optional[str] = None
    start_time: datetime
    end_time: datetime
    all_day: bool = False
    timezone: str
    is_locked: bool = False
    priority: int = 2
    recurrence_rule: Optional[RecurrenceRule] = None
    color: Optional[str] = None
    tags: List[str] = Field(default_factory=list)

    @field_validator('end_time')
    @classmethod
    def end_must_be_after_start(cls, v: datetime, info) -> datetime:
        start = info.data.get('start_time')
        if start and v <= start:
            raise ValueError('end_time must be after start_time')
        return v


class EventUpdate(BaseModel):
    """Schema for updating an event."""
    title: Optional[str] = None
    description: Optional[str] = None
    location: Optional[str] = None
    start_time: Optional[datetime] = None
    end_time: Optional[datetime] = None
    all_day: Optional[bool] = None
    timezone: Optional[str] = None
    is_locked: Optional[bool] = None
    priority: Optional[int] = None
    status: Optional[EventStatus] = None
    completion_notes: Optional[str] = None
    color: Optional[str] = None
    tags: Optional[List[str]] = None


class EventComplete(BaseModel):
    """Schema for marking event completion."""
    status: EventStatus
    notes: Optional[str] = None
