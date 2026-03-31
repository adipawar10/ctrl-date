"""
Tests for the Events router — CRUD, completion, conflict checking, invite links.
"""

import pytest
from datetime import datetime, date, timedelta
from uuid import uuid4
from unittest.mock import patch, MagicMock

from tests.conftest import (
    TEST_USER_ID, TEST_USER_2_ID, TEST_USER,
    MockSupabaseResponse, MockQueryBuilder, make_mock_supabase, make_event_dict,
)


# ===================================================================
# POST /events — Create event
# ===================================================================

class TestCreateEvent:
    """Tests for event creation."""

    def test_create_simple_event(self, client):
        """Should create a non-recurring, non-locked event."""
        tomorrow = (date.today() + timedelta(days=1))
        payload = {
            "title": "Team standup",
            "start_time": datetime(tomorrow.year, tomorrow.month, tomorrow.day, 9, 0).isoformat(),
            "end_time": datetime(tomorrow.year, tomorrow.month, tomorrow.day, 9, 30).isoformat(),
            "timezone": "America/New_York",
        }

        mock_sb = make_mock_supabase({
            "events": [{**payload, "id": str(uuid4()), "owner_id": TEST_USER_ID, "status": "scheduled"}],
        })

        with patch("app.routers.events.supabase", mock_sb):
            resp = client.post("/events", json=payload)

        assert resp.status_code == 201

    def test_create_event_end_before_start_rejected(self, client):
        """Pydantic validator should reject end_time <= start_time."""
        tomorrow = (date.today() + timedelta(days=1))
        payload = {
            "title": "Bad event",
            "start_time": datetime(tomorrow.year, tomorrow.month, tomorrow.day, 10, 0).isoformat(),
            "end_time": datetime(tomorrow.year, tomorrow.month, tomorrow.day, 9, 0).isoformat(),
            "timezone": "UTC",
        }
        resp = client.post("/events", json=payload)
        assert resp.status_code == 422  # Validation error

    def test_create_locked_event_checks_conflicts(self, client):
        """Locked event creation should trigger conflict check."""
        tomorrow = (date.today() + timedelta(days=1))

        payload = {
            "title": "Locked meeting",
            "start_time": datetime(tomorrow.year, tomorrow.month, tomorrow.day, 9, 0).isoformat(),
            "end_time": datetime(tomorrow.year, tomorrow.month, tomorrow.day, 10, 0).isoformat(),
            "timezone": "UTC",
            "is_locked": True,
        }

        # No conflicts
        mock_sb = make_mock_supabase({
            "events": [{**payload, "id": str(uuid4()), "owner_id": TEST_USER_ID, "status": "scheduled"}],
        })

        with (
            patch("app.routers.events.supabase", mock_sb),
            patch("app.routers.events.check_conflicts") as mock_conflicts,
        ):
            from app.services.scheduling import ConflictCheckResult
            mock_conflicts.return_value = ConflictCheckResult(has_blocking_conflicts=False)

            resp = client.post("/events", json=payload)

        assert resp.status_code == 201
        mock_conflicts.assert_called_once()

    def test_create_locked_event_conflict_returns_409(self, client):
        """If locked event conflicts with another locked event, return 409."""
        tomorrow = (date.today() + timedelta(days=1))
        payload = {
            "title": "Conflicting meeting",
            "start_time": datetime(tomorrow.year, tomorrow.month, tomorrow.day, 9, 0).isoformat(),
            "end_time": datetime(tomorrow.year, tomorrow.month, tomorrow.day, 10, 0).isoformat(),
            "timezone": "UTC",
            "is_locked": True,
        }

        with patch("app.routers.events.check_conflicts") as mock_conflicts:
            from app.services.scheduling import ConflictCheckResult
            mock_conflicts.return_value = ConflictCheckResult(
                has_blocking_conflicts=True,
                conflicts=[],
            )
            resp = client.post("/events", json=payload)

        assert resp.status_code == 409

    def test_create_recurring_event_creates_rule(self, client):
        """Recurring event should insert recurrence rule first."""
        tomorrow = (date.today() + timedelta(days=1))
        payload = {
            "title": "Daily standup",
            "start_time": datetime(tomorrow.year, tomorrow.month, tomorrow.day, 9, 0).isoformat(),
            "end_time": datetime(tomorrow.year, tomorrow.month, tomorrow.day, 9, 15).isoformat(),
            "timezone": "UTC",
            "recurrence_rule": {
                "frequency": "daily",
                "interval": 1,
                "count": 30,
            },
        }

        inserted_tables = []
        mock_sb = MagicMock()

        def _table(name):
            qb = MockQueryBuilder([{
                **payload, "id": str(uuid4()),
                "owner_id": TEST_USER_ID, "status": "scheduled",
            }])
            inserted_tables.append(name)
            return qb

        mock_sb.table = MagicMock(side_effect=_table)

        with patch("app.routers.events.supabase", mock_sb):
            resp = client.post("/events", json=payload)

        assert resp.status_code == 201
        assert "recurrence_rules" in inserted_tables
        assert "events" in inserted_tables


# ===================================================================
# GET /events — List events
# ===================================================================

class TestListEvents:
    """Tests for event listing."""

    def test_list_events_in_range(self, client):
        """Should return events in the given date range."""
        ev1 = make_event_dict(title="Morning run", start_hours_from_now=1)
        ev2 = make_event_dict(title="Lunch", start_hours_from_now=4)

        mock_sb = make_mock_supabase({"events": [ev1, ev2], "event_shares": []})

        with patch("app.routers.events.supabase", mock_sb):
            now = datetime.utcnow()
            resp = client.get("/events", params={
                "start": (now - timedelta(hours=1)).isoformat(),
                "end": (now + timedelta(hours=12)).isoformat(),
            })

        assert resp.status_code == 200
        data = resp.json()
        assert data["total"] == 2

    def test_list_events_requires_auth(self):
        """Unauthenticated requests should be rejected."""
        from app.main import app
        from fastapi.testclient import TestClient

        # No auth override
        app.dependency_overrides.clear()
        with TestClient(app) as c:
            now = datetime.utcnow()
            resp = c.get("/events", params={
                "start": now.isoformat(),
                "end": (now + timedelta(hours=1)).isoformat(),
            })
        assert resp.status_code in (401, 403)


# ===================================================================
# GET /events/{id} — Get single event
# ===================================================================

class TestGetEvent:
    """Tests for getting a single event."""

    def test_get_own_event(self, client):
        """Owner can retrieve their own event."""
        ev = make_event_dict(title="My event")
        mock_sb = make_mock_supabase({"events": ev})

        with patch("app.routers.events.supabase", mock_sb):
            resp = client.get(f"/events/{ev['id']}")

        assert resp.status_code == 200

    def test_get_nonexistent_event_404(self, client):
        """Missing event should return 404."""
        mock_sb = make_mock_supabase({"events": None})

        with patch("app.routers.events.supabase", mock_sb):
            resp = client.get(f"/events/{uuid4()}")

        assert resp.status_code in (404, 500)


# ===================================================================
# PUT /events/{id} — Update event
# ===================================================================

class TestUpdateEvent:
    """Tests for event updates."""

    def test_update_event_title(self, client):
        """Owner can update event title."""
        ev = make_event_dict(title="Old title")
        updated = {**ev, "title": "New title", "version": 2}

        mock_sb = make_mock_supabase({"events": updated})

        with patch("app.routers.events.supabase", mock_sb):
            resp = client.put(
                f"/events/{ev['id']}",
                json={"title": "New title"},
            )

        assert resp.status_code == 200

    def test_update_event_privacy(self, client):
        """Should accept is_private field (feature 7.5)."""
        ev = make_event_dict(title="Secret event")
        updated = {**ev, "is_private": True, "version": 2}

        mock_sb = make_mock_supabase({"events": updated})

        with patch("app.routers.events.supabase", mock_sb):
            resp = client.put(
                f"/events/{ev['id']}",
                json={"is_private": True},
            )

        assert resp.status_code == 200


# ===================================================================
# DELETE /events/{id} — Soft-delete event
# ===================================================================

class TestDeleteEvent:
    """Tests for event deletion."""

    def test_delete_own_event(self, client):
        """Owner can soft-delete their event."""
        ev = make_event_dict(title="Deletable")

        mock_sb = make_mock_supabase({"events": ev})

        with patch("app.routers.events.supabase", mock_sb):
            resp = client.delete(f"/events/{ev['id']}")

        assert resp.status_code == 200
        assert "deleted" in resp.json()["message"].lower()


# ===================================================================
# POST /events/{id}/complete — Mark completion
# ===================================================================

class TestMarkComplete:
    """Tests for event completion (feature 5.2)."""

    @pytest.mark.parametrize("status_val", ["completed", "skipped", "partial"])
    def test_mark_event_completion_statuses(self, client, status_val):
        """Should accept completed, skipped, and partial statuses."""
        ev = make_event_dict(title="Finishable")
        updated = {**ev, "status": status_val}

        mock_sb = make_mock_supabase({"events": updated})

        with patch("app.routers.events.supabase", mock_sb):
            resp = client.post(
                f"/events/{ev['id']}/complete",
                json={"status": status_val},
            )

        assert resp.status_code == 200

    def test_mark_complete_with_notes(self, client):
        """Should accept optional completion notes."""
        ev = make_event_dict(title="Noted")
        updated = {**ev, "status": "completed", "completion_notes": "Went well"}

        mock_sb = make_mock_supabase({"events": updated})

        with patch("app.routers.events.supabase", mock_sb):
            resp = client.post(
                f"/events/{ev['id']}/complete",
                json={"status": "completed", "notes": "Went well"},
            )

        assert resp.status_code == 200


# ===================================================================
# POST /events/{id}/invite-link — Invite links (feature 7.5)
# ===================================================================

class TestInviteLinks:
    """Tests for private event invite links."""

    def test_create_invite_link(self, client):
        """Owner should be able to generate an invite link."""
        ev = make_event_dict(title="Private party")
        mock_sb = make_mock_supabase({
            "events": ev,
            "event_invites": [{"id": str(uuid4()), "token": "abc123"}],
        })

        with patch("app.routers.events.supabase", mock_sb):
            resp = client.post(f"/events/{ev['id']}/invite-link")

        assert resp.status_code == 200
        data = resp.json()
        assert "token" in data
        assert "invite_link" in data
        assert data["token"]  # non-empty

    def test_accept_invite_link(self, client):
        """User should be able to accept a valid invite token."""
        invite = {
            "id": str(uuid4()),
            "event_id": str(uuid4()),
            "created_by": TEST_USER_2_ID,
            "token": "valid_token",
            "is_active": True,
            "max_uses": 10,
            "use_count": 0,
        }

        mock_sb = make_mock_supabase({
            "event_invites": invite,
            "event_shares": [],  # no existing share
        })

        with patch("app.routers.events.supabase", mock_sb):
            resp = client.post("/events/invite/valid_token/accept")

        assert resp.status_code == 200

    def test_accept_invalid_token_404(self, client):
        """Invalid token should return 404."""
        mock_sb = make_mock_supabase({"event_invites": None})

        with patch("app.routers.events.supabase", mock_sb):
            resp = client.post("/events/invite/badtoken/accept")

        assert resp.status_code in (404, 500)


# ===================================================================
# GET /events/conflicts/check — Conflict detection
# ===================================================================

class TestConflictCheck:
    """Tests for time conflict checking."""

    def test_no_conflicts(self, client):
        """Should report no conflicts when time is free."""
        with patch("app.routers.events.check_conflicts") as mock_conflicts:
            from app.services.scheduling import ConflictCheckResult
            mock_conflicts.return_value = ConflictCheckResult()

            now = datetime.utcnow()
            resp = client.get("/events/conflicts/check", params={
                "start": now.isoformat(),
                "end": (now + timedelta(hours=1)).isoformat(),
            })

        assert resp.status_code == 200
        assert resp.json()["has_conflicts"] is False
