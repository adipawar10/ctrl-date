"""
Shared test fixtures and configuration for Ctrl+Shift+Date backend tests.
Uses mocked Supabase client so tests run without a database.
"""

import pytest
from datetime import datetime, date, timedelta
from uuid import uuid4
from unittest.mock import AsyncMock, MagicMock, patch
from fastapi.testclient import TestClient

from app.core.config import settings
from app.models.user import User, UserPreferences

# ---------------------------------------------------------------------------
# Test users
# ---------------------------------------------------------------------------

TEST_USER_ID = str(uuid4())
TEST_USER_2_ID = str(uuid4())

TEST_USER = User(
    id=TEST_USER_ID,
    email="testuser@example.com",
    display_name="Test User",
    timezone="America/New_York",
    preferences=UserPreferences(),
    created_at=datetime(2025, 1, 1),
    updated_at=datetime(2025, 1, 1),
)

TEST_USER_2 = User(
    id=TEST_USER_2_ID,
    email="friend@example.com",
    display_name="Friend User",
    timezone="UTC",
    preferences=UserPreferences(),
    created_at=datetime(2025, 1, 1),
    updated_at=datetime(2025, 1, 1),
)

# ---------------------------------------------------------------------------
# Helper: mock supabase response
# ---------------------------------------------------------------------------

class MockSupabaseResponse:
    """Simulates a Supabase .execute() response."""
    def __init__(self, data=None):
        self.data = data if data is not None else []


class MockQueryBuilder:
    """
    A chainable mock that mimics supabase.table("x").select(...).eq(...).execute().

    When the raw data is a **dict** the builder wraps it in a list for
    `.execute()` (supabase returns `[row]`), and returns the dict directly
    when `.single().execute()` is used.
    When the raw data is already a **list** it is returned as-is.
    """
    def __init__(self, data=None):
        self._data = data
        self._is_single = False

    # Every filter / modifier just returns self for chaining
    def __getattr__(self, name):
        def _chain(*args, **kwargs):
            return self
        return _chain

    def execute(self):
        if self._is_single:
            # .single() → return dict
            if isinstance(self._data, list):
                return MockSupabaseResponse(self._data[0] if self._data else None)
            return MockSupabaseResponse(self._data)
        # Normal query → always return a list
        if isinstance(self._data, dict):
            return MockSupabaseResponse([self._data])
        return MockSupabaseResponse(self._data)

    def single(self):
        """single() makes supabase return dict instead of list."""
        self._is_single = True
        return self


def make_mock_supabase(table_responses: dict | None = None):
    """
    Build a mock supabase client.

    table_responses: { "table_name": <list|dict to return from execute()> }
    Each call to `.table(name)` returns a **fresh** MockQueryBuilder so that
    sequential calls in the same endpoint (fetch then update) both work.
    """
    table_responses = table_responses or {}
    mock_client = MagicMock()

    def _table(name):
        data = table_responses.get(name, [])
        return MockQueryBuilder(data)

    mock_client.table = MagicMock(side_effect=_table)
    return mock_client


# ---------------------------------------------------------------------------
# Pytest fixtures
# ---------------------------------------------------------------------------

@pytest.fixture
def test_user():
    return TEST_USER


@pytest.fixture
def test_user_2():
    return TEST_USER_2


@pytest.fixture
def mock_supabase():
    """Provides a mock Supabase client that returns empty results by default."""
    return make_mock_supabase()


@pytest.fixture
def auth_override():
    """
    Returns a dependency-override dict that replaces get_current_user.
    Usage:
        app.dependency_overrides.update(auth_override)
    """
    from app.core.security import get_current_user

    async def _override():
        return TEST_USER

    return {get_current_user: _override}


@pytest.fixture
def client(auth_override):
    """TestClient with auth already overridden."""
    from app.main import app
    app.dependency_overrides.update(auth_override)
    with TestClient(app) as c:
        yield c
    app.dependency_overrides.clear()


# ---------------------------------------------------------------------------
# Time helpers
# ---------------------------------------------------------------------------

def tomorrow_at(hour: int, minute: int = 0) -> datetime:
    d = date.today() + timedelta(days=1)
    return datetime(d.year, d.month, d.day, hour, minute)


def make_event_dict(
    title: str = "Test Event",
    owner_id: str | None = None,
    start_hours_from_now: int = 1,
    duration_minutes: int = 60,
    is_locked: bool = False,
    priority: int = 2,
    status: str = "scheduled",
    event_id: str | None = None,
    **extra,
) -> dict:
    """Create a realistic event dict as returned by Supabase."""
    now = datetime.utcnow()
    start = now + timedelta(hours=start_hours_from_now)
    end = start + timedelta(minutes=duration_minutes)
    return {
        "id": event_id or str(uuid4()),
        "owner_id": owner_id or TEST_USER_ID,
        "title": title,
        "description": None,
        "location": None,
        "start_time": start.isoformat(),
        "end_time": end.isoformat(),
        "all_day": False,
        "timezone": "UTC",
        "is_locked": is_locked,
        "priority": priority,
        "recurrence_rule_id": None,
        "recurrence_parent_id": None,
        "recurrence_instance_date": None,
        "status": status,
        "completion_notes": None,
        "completed_at": None,
        "import_batch_id": None,
        "external_id": None,
        "color": None,
        "tags": [],
        "created_at": now.isoformat(),
        "updated_at": now.isoformat(),
        "deleted_at": None,
        "version": 1,
        **extra,
    }
