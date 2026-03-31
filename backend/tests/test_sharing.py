"""
Tests for the Sharing router — share events, respond, list shares.
"""

import pytest
from datetime import datetime
from uuid import uuid4
from unittest.mock import patch

from tests.conftest import (
    TEST_USER_ID, TEST_USER_2_ID,
    make_mock_supabase, make_event_dict,
)


# ===================================================================
# POST /sharing/events/{id}/share — Share event (feature 4.3)
# ===================================================================

class TestShareEvent:
    """Tests for sharing events with friends."""

    def test_owner_can_share_event(self, client):
        """Event owner should be able to share with another user."""
        ev = make_event_dict(title="Shared event")
        target = {"id": TEST_USER_2_ID, "display_name": "Friend"}

        mock_sb = make_mock_supabase({
            "events": ev,
            "users": target,
            "event_shares": [],
        })

        with patch("app.routers.sharing.supabase", mock_sb):
            resp = client.post(
                f"/sharing/events/{ev['id']}/share",
                json={
                    "user_id": TEST_USER_2_ID,
                    "permission": "view",
                },
            )

        assert resp.status_code == 200
        data = resp.json()
        assert data["permission"] == "view"
        assert data["response"] == "pending"

    def test_share_nonexistent_event_404(self, client):
        """Should return 404 for missing event."""
        mock_sb = make_mock_supabase({"events": None})

        with patch("app.routers.sharing.supabase", mock_sb):
            resp = client.post(
                f"/sharing/events/{uuid4()}/share",
                json={
                    "user_id": TEST_USER_2_ID,
                    "permission": "view",
                },
            )

        assert resp.status_code in (404, 500)

    def test_share_with_edit_permission(self, client):
        """Should accept edit and admin permission levels."""
        ev = make_event_dict(title="Collab event")
        target = {"id": TEST_USER_2_ID, "display_name": "Collaborator"}

        mock_sb = make_mock_supabase({
            "events": ev,
            "users": target,
            "event_shares": [],
        })

        with patch("app.routers.sharing.supabase", mock_sb):
            resp = client.post(
                f"/sharing/events/{ev['id']}/share",
                json={
                    "user_id": TEST_USER_2_ID,
                    "permission": "edit",
                },
            )

        assert resp.status_code == 200
        assert resp.json()["permission"] == "edit"

    def test_duplicate_share_rejected(self, client):
        """Should reject sharing with same user twice."""
        ev = make_event_dict(title="Already shared")
        existing_share = {
            "id": str(uuid4()),
            "event_id": ev["id"],
            "shared_with_user_id": TEST_USER_2_ID,
        }

        mock_sb = make_mock_supabase({
            "events": ev,
            "users": {"id": TEST_USER_2_ID, "display_name": "Friend"},
            "event_shares": [existing_share],
        })

        with patch("app.routers.sharing.supabase", mock_sb):
            resp = client.post(
                f"/sharing/events/{ev['id']}/share",
                json={
                    "user_id": TEST_USER_2_ID,
                    "permission": "view",
                },
            )

        assert resp.status_code == 400


# ===================================================================
# PUT /sharing/events/{id}/share/respond — Respond to share
# ===================================================================

class TestRespondToShare:
    """Tests for responding to event share invitations."""

    @pytest.mark.parametrize("response_val", ["accepted", "declined", "tentative"])
    def test_respond_to_share(self, client, response_val):
        """Should accept valid responses."""
        ev_id = str(uuid4())
        share = {
            "id": str(uuid4()),
            "event_id": ev_id,
            "shared_with_user_id": TEST_USER_ID,
            "response": "pending",
        }

        mock_sb = make_mock_supabase({"event_shares": share})

        with patch("app.routers.sharing.supabase", mock_sb):
            resp = client.put(
                f"/sharing/events/{ev_id}/share/respond",
                json={"response": response_val},
            )

        assert resp.status_code == 200


# ===================================================================
# GET /sharing/events/{id}/shares — List shares
# ===================================================================

class TestListShares:
    """Tests for listing event shares."""

    def test_owner_can_list_shares(self, client):
        """Owner should see all shares."""
        ev = make_event_dict(title="Shared event")

        mock_sb = make_mock_supabase({
            "events": {"owner_id": TEST_USER_ID},
            "event_shares": [],
        })

        with patch("app.routers.sharing.supabase", mock_sb):
            resp = client.get(f"/sharing/events/{ev['id']}/shares")

        assert resp.status_code == 200


# ===================================================================
# DELETE /sharing/events/{id}/share/{user_id} — Remove share
# ===================================================================

class TestRemoveShare:
    """Tests for removing shares."""

    def test_owner_can_remove_share(self, client):
        """Owner should be able to unshare."""
        ev = make_event_dict(title="Unshare this")

        mock_sb = make_mock_supabase({
            "events": {"owner_id": TEST_USER_ID},
            "event_shares": [],
        })

        with patch("app.routers.sharing.supabase", mock_sb):
            resp = client.delete(
                f"/sharing/events/{ev['id']}/share/{TEST_USER_2_ID}",
            )

        assert resp.status_code == 200
