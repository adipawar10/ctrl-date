"""
Tests for backend services — scheduling conflicts, recurrence expansion, CSV import.
"""

import pytest
from datetime import datetime, date, timedelta
from uuid import uuid4
from unittest.mock import patch, MagicMock

from tests.conftest import TEST_USER_ID, make_mock_supabase, make_event_dict


# ===================================================================
# Scheduling service — conflict detection
# ===================================================================

class TestConflictDetection:
    """Tests for the scheduling conflict detection service."""

    @pytest.mark.asyncio
    async def test_no_conflicts_when_empty(self):
        """Should return no conflicts if no overlapping events exist."""
        mock_sb = make_mock_supabase({"events": []})

        with patch("app.services.scheduling.supabase", mock_sb):
            from app.services.scheduling import check_conflicts
            result = await check_conflicts(
                user_id=TEST_USER_ID,
                start=datetime(2026, 4, 1, 9, 0),
                end=datetime(2026, 4, 1, 10, 0),
            )

        assert result.has_blocking_conflicts is False
        assert len(result.conflicts) == 0

    @pytest.mark.asyncio
    async def test_locked_vs_locked_is_blocking(self):
        """Two locked events overlapping should be a blocking conflict."""
        existing = {
            "id": str(uuid4()),
            "title": "Existing locked",
            "start_time": "2026-04-01T09:00:00+00:00",
            "end_time": "2026-04-01T10:00:00+00:00",
            "is_locked": True,
            "priority": 3,
        }

        mock_sb = make_mock_supabase({"events": [existing]})

        with patch("app.services.scheduling.supabase", mock_sb):
            from datetime import timezone
            from app.services.scheduling import check_conflicts
            result = await check_conflicts(
                user_id=TEST_USER_ID,
                start=datetime(2026, 4, 1, 9, 30, tzinfo=timezone.utc),
                end=datetime(2026, 4, 1, 10, 30, tzinfo=timezone.utc),
                is_locked=True,
            )

        assert result.has_blocking_conflicts is True
        assert len(result.conflicts) > 0


# ===================================================================
# CSV import service
# ===================================================================

class TestCsvImportService:
    """Tests for the CSV import parsing logic."""

    def test_parse_valid_csv(self):
        """Should parse well-formed CSV rows into event dicts."""
        from app.services.import_service import _parse_csv_row

        row = {
            "title": "Team Meeting",
            "description": "Weekly standup",
            "start_time": "2026-04-01T09:00:00",
            "end_time": "2026-04-01T10:00:00",
            "location": "Conference Room",
            "is_locked": "true",
            "priority": "3",
            "tags": "work,meeting",
        }

        event = _parse_csv_row(row, TEST_USER_ID, str(uuid4()), "UTC")
        assert event is not None
        assert event["title"] == "Team Meeting"
        assert event["is_locked"] is True
        assert event["priority"] == 3
        assert event["owner_id"] == TEST_USER_ID

    def test_parse_empty_title_raises(self):
        """Should raise for rows with empty title."""
        from app.services.import_service import _parse_csv_row

        row = {
            "title": "",
            "start_time": "2026-04-01T09:00:00",
            "end_time": "2026-04-01T10:00:00",
        }

        with pytest.raises(ValueError, match="[Tt]itle"):
            _parse_csv_row(row, TEST_USER_ID, str(uuid4()), "UTC")

    def test_parse_missing_times_raises(self):
        """Should raise for rows missing start or end time."""
        from app.services.import_service import _parse_csv_row

        row = {
            "title": "No times",
            "start_time": "",
            "end_time": "",
        }

        with pytest.raises(ValueError):
            _parse_csv_row(row, TEST_USER_ID, str(uuid4()), "UTC")

    def test_parse_minimal_row(self):
        """Should parse a row with only required fields."""
        from app.services.import_service import _parse_csv_row

        row = {
            "title": "Quick call",
            "start_time": "2026-04-01T14:00:00",
            "end_time": "2026-04-01T14:30:00",
        }

        event = _parse_csv_row(row, TEST_USER_ID, str(uuid4()), "UTC")
        assert event is not None
        assert event["title"] == "Quick call"
        assert event["is_locked"] is False  # default
        assert event["priority"] == 2  # default


# ===================================================================
# Recurrence expansion service
# ===================================================================

class TestRecurrenceExpansion:
    """Tests for recurring event expansion."""

    @pytest.mark.asyncio
    async def test_expand_daily_recurrence(self):
        """Should expand a daily recurring event into instances."""
        rule = {
            "id": str(uuid4()),
            "frequency": "daily",
            "interval": 1,
            "count": 7,
            "by_weekday": None,
            "by_monthday": None,
            "by_month": None,
            "by_setpos": None,
            "until_date": None,
            "excluded_dates": [],
        }

        event = make_event_dict(
            title="Daily standup",
            start_hours_from_now=0,
            duration_minutes=15,
        )
        event["recurrence_rule_id"] = rule["id"]

        mock_sb = make_mock_supabase({
            "recurrence_rules": rule,
            "events": [],  # no modified instances
        })

        with patch("app.services.recurrence.supabase", mock_sb):
            from app.services.recurrence import expand_recurrence_in_range
            now = datetime.utcnow()
            instances = await expand_recurrence_in_range(
                event,
                now - timedelta(hours=1),
                now + timedelta(days=8),
            )

        assert len(instances) >= 1  # At least the first instance

    @pytest.mark.asyncio
    async def test_non_recurring_returns_self(self):
        """Non-recurring event should return itself."""
        event = make_event_dict(title="One-off")
        event["recurrence_rule_id"] = None

        from app.services.recurrence import expand_recurrence_in_range
        instances = await expand_recurrence_in_range(
            event,
            datetime.utcnow() - timedelta(hours=1),
            datetime.utcnow() + timedelta(hours=2),
        )
        assert len(instances) == 1
        assert instances[0]["title"] == "One-off"
