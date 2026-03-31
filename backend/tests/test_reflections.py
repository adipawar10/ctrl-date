"""
Tests for the Reflections router — daily reflections, streaks, stats (features 5.1, 5.2).
"""

import pytest
from datetime import datetime, date, timedelta
from uuid import uuid4
from unittest.mock import patch

from tests.conftest import (
    TEST_USER_ID,
    make_mock_supabase, make_event_dict,
)


# ===================================================================
# GET /reflections — List reflections (feature 5.1)
# ===================================================================

class TestListReflections:
    """Tests for listing reflection history."""

    def test_list_reflections_in_date_range(self, client):
        """Should return reflections in the given range."""
        reflections = [
            {
                "id": str(uuid4()),
                "user_id": TEST_USER_ID,
                "reflection_date": (date.today() - timedelta(days=i)).isoformat(),
                "events_planned": 5,
                "events_completed": 3 + i,
                "events_skipped": 1,
                "events_partial": 1,
                "notes": f"Day {i}",
                "mood": 4,
                "is_streak_day": True,
            }
            for i in range(7)
        ]

        mock_sb = make_mock_supabase({"daily_reflections": reflections})

        with patch("app.routers.reflections.supabase", mock_sb):
            resp = client.get("/reflections", params={
                "start_date": (date.today() - timedelta(days=7)).isoformat(),
                "end_date": date.today().isoformat(),
            })

        assert resp.status_code == 200
        data = resp.json()
        assert "reflections" in data

    def test_list_reflections_empty_range(self, client):
        """Should return empty list for a range with no reflections."""
        mock_sb = make_mock_supabase({"daily_reflections": []})

        with patch("app.routers.reflections.supabase", mock_sb):
            resp = client.get("/reflections", params={
                "start_date": "2020-01-01",
                "end_date": "2020-01-07",
            })

        assert resp.status_code == 200
        assert resp.json()["reflections"] == []


# ===================================================================
# POST /reflections/{date} — Create/update reflection
# ===================================================================

class TestCreateReflection:
    """Tests for creating and updating daily reflections."""

    def test_create_reflection_with_mood(self, client):
        """Should create a reflection and compute event stats."""
        today = date.today()

        events = [
            make_event_dict(title="Done", status="completed"),
            make_event_dict(title="Half done", status="partial"),
            make_event_dict(title="Skipped", status="skipped"),
        ]

        streak = {
            "id": str(uuid4()),
            "user_id": TEST_USER_ID,
            "streak_type": "daily_completion",
            "current_count": 3,
            "longest_count": 10,
            "last_completed_date": (today - timedelta(days=1)).isoformat(),
            "completion_threshold": 0.80,
        }

        reflection_data = {
            "id": str(uuid4()),
            "user_id": TEST_USER_ID,
            "reflection_date": today.isoformat(),
        }

        mock_sb = make_mock_supabase({
            "events": events,
            "streaks": streak,
            "daily_reflections": [],
        })

        with patch("app.routers.reflections.supabase", mock_sb):
            resp = client.post(
                f"/reflections/{today.isoformat()}",
                json={"notes": "Good day!", "mood": 4},
            )

        assert resp.status_code == 200
        data = resp.json()
        assert data["mood"] == 4
        assert data["events_planned"] == 3
        assert data["events_completed"] == 1

    def test_create_reflection_mood_validation(self, client):
        """Mood must be between 1 and 5."""
        today = date.today()
        resp = client.post(
            f"/reflections/{today.isoformat()}",
            json={"mood": 10},  # Invalid
        )
        assert resp.status_code == 422

    def test_create_reflection_no_events(self, client):
        """Should handle days with zero events planned."""
        today = date.today()

        streak = {
            "id": str(uuid4()),
            "user_id": TEST_USER_ID,
            "streak_type": "daily_completion",
            "current_count": 0,
            "longest_count": 0,
            "completion_threshold": 0.80,
        }

        mock_sb = make_mock_supabase({
            "events": [],
            "streaks": streak,
            "daily_reflections": [],
        })

        with patch("app.routers.reflections.supabase", mock_sb):
            resp = client.post(
                f"/reflections/{today.isoformat()}",
                json={"notes": "Rest day"},
            )

        assert resp.status_code == 200
        data = resp.json()
        assert data["events_planned"] == 0
        assert data["is_streak_day"] is False  # 0 events → no streak


# ===================================================================
# GET /reflections/stats — Aggregated stats
# ===================================================================

class TestReflectionStats:
    """Tests for aggregated reflection statistics."""

    def test_stats_calculation(self, client):
        """Should compute averages and totals correctly."""
        reflections = [
            {
                "user_id": TEST_USER_ID,
                "reflection_date": (date.today() - timedelta(days=i)).isoformat(),
                "events_planned": 4,
                "events_completed": 3,
                "events_skipped": 0,
                "events_partial": 1,
                "mood": 4,
                "is_streak_day": True,
            }
            for i in range(5)
        ]

        streak = {
            "user_id": TEST_USER_ID,
            "streak_type": "daily_completion",
            "current_count": 5,
            "longest_count": 12,
        }

        mock_sb = make_mock_supabase({
            "daily_reflections": reflections,
            "streaks": streak,
        })

        with patch("app.routers.reflections.supabase", mock_sb):
            resp = client.get("/reflections/stats", params={
                "start_date": (date.today() - timedelta(days=7)).isoformat(),
                "end_date": date.today().isoformat(),
            })

        assert resp.status_code == 200
        data = resp.json()
        assert data["total_days"] == 8  # 7 day range inclusive
        assert data["days_with_reflection"] == 5
        assert data["total_events_planned"] == 20
        assert data["total_events_completed"] == 15
        assert data["current_streak"] == 5
        assert data["longest_streak"] == 12
        assert data["average_mood"] is not None
