"""Daily reflection and streak models."""

from datetime import datetime, date
from typing import Optional
from pydantic import BaseModel, Field
from uuid import UUID
from enum import Enum


class StreakType(str, Enum):
    """Types of streaks to track."""
    DAILY_COMPLETION = "daily_completion"
    REFLECTION = "reflection"
    CUSTOM = "custom"


class DailyReflection(BaseModel):
    """Daily reflection model."""
    id: UUID
    user_id: UUID
    reflection_date: date

    # Computed stats
    events_planned: int = 0
    events_completed: int = 0
    events_skipped: int = 0
    events_partial: int = 0

    # User input
    notes: Optional[str] = None
    mood: Optional[int] = Field(None, ge=1, le=5)

    # Streak
    is_streak_day: bool = False

    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

    @property
    def completion_rate(self) -> float:
        """Calculate completion rate."""
        if self.events_planned == 0:
            return 0.0
        completed_weight = self.events_completed + (self.events_partial * 0.5)
        return completed_weight / self.events_planned


class DailyReflectionCreate(BaseModel):
    """Schema for creating/updating a reflection."""
    notes: Optional[str] = None
    mood: Optional[int] = Field(None, ge=1, le=5)


class Streak(BaseModel):
    """Streak tracking model."""
    id: UUID
    user_id: UUID
    streak_type: StreakType = StreakType.DAILY_COMPLETION
    current_count: int = 0
    longest_count: int = 0
    last_completed_date: Optional[date] = None
    completion_threshold: float = 0.80
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class StreakUpdate(BaseModel):
    """Schema for updating streak settings."""
    completion_threshold: Optional[float] = Field(None, ge=0.0, le=1.0)


class ReflectionStats(BaseModel):
    """Aggregated reflection statistics."""
    period_start: date
    period_end: date
    total_days: int
    days_with_reflection: int
    average_completion_rate: float
    average_mood: Optional[float]
    current_streak: int
    longest_streak: int
    total_events_planned: int
    total_events_completed: int
