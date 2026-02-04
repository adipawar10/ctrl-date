"""Shared Pydantic schemas for the Ctrl+Shift+Date API."""

from datetime import datetime, date
from typing import Optional, List, Generic, TypeVar
from uuid import UUID

from pydantic import BaseModel, Field, ConfigDict


# =============================================================================
# Generic Response Schemas
# =============================================================================

DataT = TypeVar("DataT")


class APIResponse(BaseModel, Generic[DataT]):
    """Standard API response wrapper."""
    success: bool = True
    data: Optional[DataT] = None
    message: Optional[str] = None


class PaginatedResponse(BaseModel, Generic[DataT]):
    """Paginated response wrapper."""
    items: List[DataT]
    total: int
    page: int
    page_size: int
    has_more: bool

    @property
    def total_pages(self) -> int:
        """Calculate total number of pages."""
        return (self.total + self.page_size - 1) // self.page_size


class ErrorResponse(BaseModel):
    """Standard error response."""
    success: bool = False
    error: str
    error_code: Optional[str] = None
    details: Optional[dict] = None


# =============================================================================
# Pagination Request
# =============================================================================

class PaginationParams(BaseModel):
    """Common pagination parameters."""
    page: int = Field(default=1, ge=1, description="Page number (1-indexed)")
    page_size: int = Field(default=20, ge=1, le=100, description="Items per page")

    @property
    def offset(self) -> int:
        """Calculate offset for database query."""
        return (self.page - 1) * self.page_size


# =============================================================================
# Date Range Request
# =============================================================================

class DateRangeParams(BaseModel):
    """Date range parameters for queries."""
    start_date: date
    end_date: date

    model_config = ConfigDict(
        json_schema_extra={
            "example": {
                "start_date": "2024-01-01",
                "end_date": "2024-01-31"
            }
        }
    )


class DateTimeRangeParams(BaseModel):
    """DateTime range parameters for queries."""
    start: datetime
    end: datetime


# =============================================================================
# Sync Schemas
# =============================================================================

class SyncRequest(BaseModel):
    """Request for syncing data with local client."""
    last_sync_at: Optional[datetime] = None
    device_id: Optional[str] = None


class SyncResponse(BaseModel):
    """Response containing sync data."""
    events: List[dict] = Field(default_factory=list)
    deleted_event_ids: List[str] = Field(default_factory=list)
    reflections: List[dict] = Field(default_factory=list)
    server_time: datetime
    next_sync_token: Optional[str] = None


class ConflictResolution(BaseModel):
    """Conflict resolution for sync conflicts."""
    event_id: UUID
    resolution: str = Field(
        ...,
        description="Resolution strategy: 'local', 'server', or 'merge'"
    )
    merged_data: Optional[dict] = None


# =============================================================================
# Device Registration
# =============================================================================

class DeviceTokenCreate(BaseModel):
    """Register a device for push notifications."""
    token: str
    platform: str = Field(..., pattern="^(ios|android|web)$")
    device_name: Optional[str] = None


class DeviceTokenResponse(BaseModel):
    """Device token response."""
    id: UUID
    platform: str
    device_name: Optional[str]
    is_active: bool
    created_at: datetime


# =============================================================================
# Health Check
# =============================================================================

class HealthCheck(BaseModel):
    """Health check response."""
    status: str = "healthy"
    version: str
    database: str = "connected"
    redis: str = "connected"
    timestamp: datetime = Field(default_factory=datetime.utcnow)


# =============================================================================
# Batch Operations
# =============================================================================

class BatchOperation(BaseModel):
    """Single operation in a batch request."""
    operation: str = Field(
        ...,
        description="Operation type: 'create', 'update', 'delete'"
    )
    resource_type: str = Field(
        ...,
        description="Resource type: 'event', 'reflection', etc."
    )
    resource_id: Optional[UUID] = None
    data: Optional[dict] = None


class BatchRequest(BaseModel):
    """Batch operations request."""
    operations: List[BatchOperation] = Field(
        ...,
        max_length=100,
        description="List of operations to perform"
    )
    atomic: bool = Field(
        default=False,
        description="If true, all operations must succeed or none will be applied"
    )


class BatchResult(BaseModel):
    """Result of a single batch operation."""
    index: int
    success: bool
    resource_id: Optional[UUID] = None
    error: Optional[str] = None


class BatchResponse(BaseModel):
    """Batch operations response."""
    success: bool
    results: List[BatchResult]
    total_succeeded: int
    total_failed: int


# =============================================================================
# Search and Filter
# =============================================================================

class SearchParams(BaseModel):
    """Search parameters."""
    query: str = Field(..., min_length=1, max_length=200)
    filters: Optional[dict] = None
    sort_by: Optional[str] = None
    sort_order: str = Field(default="desc", pattern="^(asc|desc)$")


class EventFilter(BaseModel):
    """Event filtering parameters."""
    status: Optional[List[str]] = None
    priority: Optional[List[int]] = None
    tags: Optional[List[str]] = None
    is_locked: Optional[bool] = None
    has_recurrence: Optional[bool] = None


# =============================================================================
# Statistics
# =============================================================================

class UserStats(BaseModel):
    """User statistics summary."""
    total_events: int
    events_completed: int
    events_pending: int
    current_streak: int
    longest_streak: int
    average_completion_rate: float
    total_friends: int


class PeriodStats(BaseModel):
    """Statistics for a time period."""
    period_start: date
    period_end: date
    events_planned: int
    events_completed: int
    events_skipped: int
    events_partial: int
    completion_rate: float
    average_mood: Optional[float]
    streak_days: int


# =============================================================================
# Export schemas from models for convenience
# =============================================================================

from app.models.user import User, UserCreate, UserUpdate, UserPreferences
from app.models.event import (
    Event,
    EventCreate,
    EventUpdate,
    EventComplete,
    EventStatus,
    RecurrenceRule,
    RecurrenceFrequency,
    RecurrenceUpdateScope,
)
from app.models.friendship import (
    Friendship,
    FriendRequest,
    FriendshipResponse,
    FriendshipStatus,
    Poke,
    PokeCreate,
    EventShare,
    EventShareCreate,
    EventShareResponse,
)
from app.models.inbox import (
    InboxMessage,
    InboxMessageCreate,
    InboxMessageResponse,
    MessageType,
    PublicKeyResponse,
)
from app.models.reflection import (
    DailyReflection,
    DailyReflectionCreate,
    Streak,
    StreakUpdate,
    StreakType,
    ReflectionStats,
)

__all__ = [
    # Generic responses
    "APIResponse",
    "PaginatedResponse",
    "ErrorResponse",
    # Request params
    "PaginationParams",
    "DateRangeParams",
    "DateTimeRangeParams",
    "SearchParams",
    "EventFilter",
    # Sync
    "SyncRequest",
    "SyncResponse",
    "ConflictResolution",
    # Device
    "DeviceTokenCreate",
    "DeviceTokenResponse",
    # Health
    "HealthCheck",
    # Batch
    "BatchOperation",
    "BatchRequest",
    "BatchResult",
    "BatchResponse",
    # Stats
    "UserStats",
    "PeriodStats",
    # User models
    "User",
    "UserCreate",
    "UserUpdate",
    "UserPreferences",
    # Event models
    "Event",
    "EventCreate",
    "EventUpdate",
    "EventComplete",
    "EventStatus",
    "RecurrenceRule",
    "RecurrenceFrequency",
    "RecurrenceUpdateScope",
    # Friendship models
    "Friendship",
    "FriendRequest",
    "FriendshipResponse",
    "FriendshipStatus",
    "Poke",
    "PokeCreate",
    "EventShare",
    "EventShareCreate",
    "EventShareResponse",
    # Inbox models
    "InboxMessage",
    "InboxMessageCreate",
    "InboxMessageResponse",
    "MessageType",
    "PublicKeyResponse",
    # Reflection models
    "DailyReflection",
    "DailyReflectionCreate",
    "Streak",
    "StreakUpdate",
    "StreakType",
    "ReflectionStats",
]
