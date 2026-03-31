"""
Tests for Pydantic models — validation rules, serialization, computed properties.
"""

import pytest
from datetime import datetime, date, timedelta
from uuid import uuid4

from app.models.event import (
    Event, EventCreate, EventUpdate, EventComplete,
    EventStatus, RecurrenceFrequency, RecurrenceRule, RecurrenceUpdateScope,
)
from app.models.user import User, UserCreate, UserUpdate, UserPreferences
from app.models.friendship import (
    Friendship, FriendRequest, FriendshipResponse, FriendshipStatus,
    Poke, PokeCreate, EventShare, EventShareCreate, EventShareResponse,
)
from app.models.reflection import (
    DailyReflection, DailyReflectionCreate, Streak, StreakUpdate,
    StreakType, ReflectionStats,
)
from app.models.inbox import (
    InboxMessage, InboxMessageCreate, InboxMessageResponse,
    MessageType, PublicKeyResponse,
)


# ===================================================================
# Event models
# ===================================================================

class TestEventModels:
    """Tests for Event-related Pydantic models."""

    def test_event_status_enum_values(self):
        """EventStatus should have all required values including partial and skipped."""
        assert EventStatus.SCHEDULED == "scheduled"
        assert EventStatus.COMPLETED == "completed"
        assert EventStatus.SKIPPED == "skipped"
        assert EventStatus.PARTIAL == "partial"
        assert EventStatus.CANCELLED == "cancelled"

    def test_event_create_validation(self):
        """EventCreate should validate end_time > start_time."""
        tomorrow = date.today() + timedelta(days=1)
        event = EventCreate(
            title="Test",
            start_time=datetime(tomorrow.year, tomorrow.month, tomorrow.day, 9, 0),
            end_time=datetime(tomorrow.year, tomorrow.month, tomorrow.day, 10, 0),
            timezone="UTC",
        )
        assert event.title == "Test"
        assert event.priority == 2  # default
        assert event.is_locked is False  # default

    def test_event_create_end_before_start(self):
        """Should reject end_time before start_time."""
        with pytest.raises(Exception):
            EventCreate(
                title="Bad",
                start_time=datetime(2026, 4, 1, 10, 0),
                end_time=datetime(2026, 4, 1, 9, 0),
                timezone="UTC",
            )

    def test_event_create_priority_range(self):
        """Priority must be 1-4 (validated on Event model)."""
        from app.models.event import Event
        with pytest.raises(Exception):
            Event(
                id=uuid4(),
                owner_id=uuid4(),
                title="Bad priority",
                start_time=datetime(2026, 5, 1, 9, 0),
                end_time=datetime(2026, 5, 1, 10, 0),
                timezone="UTC",
                priority=5,
                created_at=datetime(2026, 1, 1),
                updated_at=datetime(2026, 1, 1),
            )

    def test_event_update_partial_fields(self):
        """EventUpdate should allow any combination of fields."""
        update = EventUpdate(title="New title")
        data = update.model_dump(exclude_unset=True)
        assert data == {"title": "New title"}

        update2 = EventUpdate(is_private=True, status=EventStatus.COMPLETED)
        data2 = update2.model_dump(exclude_unset=True)
        assert data2["is_private"] is True
        assert data2["status"] == EventStatus.COMPLETED

    def test_event_complete_model(self):
        """EventComplete should accept status and optional notes."""
        complete = EventComplete(status=EventStatus.COMPLETED, notes="Done!")
        assert complete.status == EventStatus.COMPLETED
        assert complete.notes == "Done!"

        partial = EventComplete(status=EventStatus.PARTIAL)
        assert partial.notes is None

    def test_recurrence_rule_interval_validation(self):
        """Interval must be >= 1."""
        with pytest.raises(Exception):
            RecurrenceRule(frequency=RecurrenceFrequency.DAILY, interval=0)

    def test_recurrence_update_scope_enum(self):
        """Should have single, future, all scopes."""
        assert RecurrenceUpdateScope.SINGLE == "single"
        assert RecurrenceUpdateScope.FUTURE == "future"
        assert RecurrenceUpdateScope.ALL == "all"


# ===================================================================
# User models
# ===================================================================

class TestUserModels:
    """Tests for User-related Pydantic models."""

    def test_user_default_preferences(self):
        """User should have sensible default preferences."""
        prefs = UserPreferences()
        assert prefs.default_event_duration == 60
        assert prefs.week_start == "monday"
        assert prefs.working_hours_start == "09:00"
        assert prefs.working_hours_end == "17:00"

    def test_user_model(self):
        """User model should parse all fields."""
        user = User(
            id=uuid4(),
            email="test@example.com",
            display_name="Test",
            timezone="UTC",
            created_at=datetime.utcnow(),
            updated_at=datetime.utcnow(),
        )
        assert user.display_name == "Test"

    def test_user_update_partial(self):
        """UserUpdate should allow partial updates."""
        update = UserUpdate(display_name="New Name")
        data = update.model_dump(exclude_unset=True)
        assert data == {"display_name": "New Name"}


# ===================================================================
# Friendship models
# ===================================================================

class TestFriendshipModels:
    """Tests for Friendship and social models."""

    def test_friendship_status_enum(self):
        """FriendshipStatus should have pending, accepted, blocked."""
        assert FriendshipStatus.PENDING == "pending"
        assert FriendshipStatus.ACCEPTED == "accepted"
        assert FriendshipStatus.BLOCKED == "blocked"

    def test_friend_request_by_email(self):
        """FriendRequest should accept email lookup."""
        req = FriendRequest(email="friend@example.com")
        assert req.email == "friend@example.com"
        assert req.user_id is None

    def test_friend_request_by_id(self):
        """FriendRequest should accept user_id lookup."""
        uid = uuid4()
        req = FriendRequest(user_id=uid)
        assert req.user_id == uid

    def test_event_share_create(self):
        """EventShareCreate should validate permission."""
        share = EventShareCreate(user_id=uuid4(), permission="edit")
        assert share.permission == "edit"


# ===================================================================
# Reflection models
# ===================================================================

class TestReflectionModels:
    """Tests for Reflection and streak models."""

    def test_reflection_completion_rate(self):
        """DailyReflection should compute completion rate correctly."""
        ref = DailyReflection(
            id=uuid4(),
            user_id=uuid4(),
            reflection_date=date.today(),
            events_planned=4,
            events_completed=2,
            events_partial=2,
            events_skipped=0,
            created_at=datetime.utcnow(),
            updated_at=datetime.utcnow(),
        )
        # (2 completed + 2 partial * 0.5) / 4 = 3/4 = 0.75
        assert ref.completion_rate == 0.75

    def test_reflection_zero_events_rate(self):
        """Completion rate should be 0 when no events planned."""
        ref = DailyReflection(
            id=uuid4(),
            user_id=uuid4(),
            reflection_date=date.today(),
            events_planned=0,
            created_at=datetime.utcnow(),
            updated_at=datetime.utcnow(),
        )
        assert ref.completion_rate == 0.0

    def test_reflection_mood_validation(self):
        """Mood must be between 1 and 5."""
        with pytest.raises(Exception):
            DailyReflectionCreate(mood=6)

    def test_streak_threshold_validation(self):
        """Streak threshold must be 0.0 to 1.0."""
        with pytest.raises(Exception):
            StreakUpdate(completion_threshold=1.5)

    def test_streak_type_enum(self):
        """StreakType should have expected values."""
        assert StreakType.DAILY_COMPLETION == "daily_completion"
        assert StreakType.REFLECTION == "reflection"


# ===================================================================
# Inbox models
# ===================================================================

class TestInboxModels:
    """Tests for inbox message models."""

    def test_message_type_enum(self):
        """MessageType should have text, event_share, poke, system."""
        assert MessageType.TEXT == "text"
        assert MessageType.EVENT_SHARE == "event_share"
        assert MessageType.POKE == "poke"
        assert MessageType.SYSTEM == "system"

    def test_inbox_message_create(self):
        """InboxMessageCreate should validate required E2E fields."""
        msg = InboxMessageCreate(
            recipient_id=uuid4(),
            message_type=MessageType.TEXT,
            ciphertext="encrypted_data",
            ephemeral_public_key="pub_key",
            nonce="random_nonce",
        )
        assert msg.ciphertext == "encrypted_data"
