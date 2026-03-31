"""
Tests for the Friends router — requests, accept/decline, pokes, streaks.
"""

import pytest
from datetime import datetime, timedelta
from uuid import uuid4
from unittest.mock import patch

from tests.conftest import (
    TEST_USER_ID, TEST_USER_2_ID,
    make_mock_supabase, MockQueryBuilder,
)


# ===================================================================
# GET /friends — List friends
# ===================================================================

class TestListFriends:
    """Tests for listing friends."""

    def test_list_friends_returns_streaks(self, client):
        """Friend list should include streak data (feature 3.2)."""
        friendship = {
            "id": str(uuid4()),
            "requester_id": TEST_USER_ID,
            "addressee_id": TEST_USER_2_ID,
            "status": "accepted",
            "created_at": datetime.utcnow().isoformat(),
            "accepted_at": datetime.utcnow().isoformat(),
            "users": {
                "id": TEST_USER_2_ID,
                "display_name": "Friend User",
                "avatar_url": None,
                "public_key": None,
            },
        }

        streak = {
            "user_id": TEST_USER_2_ID,
            "streak_type": "daily_completion",
            "current_count": 5,
            "longest_count": 12,
        }

        mock_sb = make_mock_supabase({
            "friendships": [friendship],
            "streaks": [streak],
        })

        with patch("app.routers.friends.supabase", mock_sb):
            resp = client.get("/friends")

        assert resp.status_code == 200
        data = resp.json()
        assert "friends" in data

    def test_list_friends_empty(self, client):
        """Should return empty list for user with no friends."""
        mock_sb = make_mock_supabase({"friendships": [], "streaks": []})

        with patch("app.routers.friends.supabase", mock_sb):
            resp = client.get("/friends")

        assert resp.status_code == 200
        assert resp.json()["friends"] == []


# ===================================================================
# POST /friends/request — Send friend request
# ===================================================================

class TestFriendRequest:
    """Tests for sending friend requests."""

    def test_send_friend_request_by_email(self, client):
        """Should find user by email and create pending request."""
        target = {"id": TEST_USER_2_ID, "display_name": "Friend User"}

        mock_sb = make_mock_supabase({
            "users": target,
            "friendships": [],
        })

        with patch("app.routers.friends.supabase", mock_sb):
            resp = client.post("/friends/request", json={
                "email": "friend@example.com",
            })

        assert resp.status_code == 200
        data = resp.json()
        assert data["status"] == "pending"

    def test_send_request_to_self_rejected(self, client):
        """Cannot send friend request to yourself."""
        mock_sb = make_mock_supabase({
            "users": {"id": TEST_USER_ID, "display_name": "Test User"},
            "friendships": [],
        })

        with patch("app.routers.friends.supabase", mock_sb):
            resp = client.post("/friends/request", json={
                "user_id": TEST_USER_ID,
            })

        assert resp.status_code == 400

    def test_send_request_no_id_or_email_rejected(self, client):
        """Must provide either user_id or email."""
        resp = client.post("/friends/request", json={})
        assert resp.status_code == 400

    def test_duplicate_request_rejected(self, client):
        """Should reject if friendship already exists."""
        existing = {
            "id": str(uuid4()),
            "requester_id": TEST_USER_ID,
            "addressee_id": TEST_USER_2_ID,
            "status": "pending",
        }

        mock_sb = make_mock_supabase({
            "users": {"id": TEST_USER_2_ID, "display_name": "Friend"},
            "friendships": [existing],
        })

        with patch("app.routers.friends.supabase", mock_sb):
            resp = client.post("/friends/request", json={
                "user_id": TEST_USER_2_ID,
            })

        assert resp.status_code == 400


# ===================================================================
# PUT /friends/{id}/respond — Accept / decline / block
# ===================================================================

class TestFriendResponse:
    """Tests for responding to friend requests."""

    def test_accept_friend_request(self, client):
        """Should update status to accepted with timestamp."""
        friendship_id = str(uuid4())
        friendship = {
            "id": friendship_id,
            "requester_id": TEST_USER_2_ID,
            "addressee_id": TEST_USER_ID,
            "status": "pending",
        }

        mock_sb = make_mock_supabase({"friendships": friendship})

        with patch("app.routers.friends.supabase", mock_sb):
            resp = client.put(
                f"/friends/{friendship_id}/respond",
                json={"action": "accept"},
            )

        assert resp.status_code == 200
        assert "accepted" in resp.json().get("status", "")

    def test_decline_friend_request(self, client):
        """Declined request should be removed."""
        friendship_id = str(uuid4())
        friendship = {
            "id": friendship_id,
            "requester_id": TEST_USER_2_ID,
            "addressee_id": TEST_USER_ID,
            "status": "pending",
        }

        mock_sb = make_mock_supabase({"friendships": friendship})

        with patch("app.routers.friends.supabase", mock_sb):
            resp = client.put(
                f"/friends/{friendship_id}/respond",
                json={"action": "decline"},
            )

        assert resp.status_code == 200


# ===================================================================
# POST /friends/{id}/poke — Procrastination nudge
# ===================================================================

class TestPoke:
    """Tests for poking friends."""

    def test_poke_friend(self, client):
        """Should send a poke to a friend."""
        friendship = {
            "id": str(uuid4()),
            "requester_id": TEST_USER_ID,
            "addressee_id": TEST_USER_2_ID,
            "status": "accepted",
        }

        mock_sb = make_mock_supabase({
            "friendships": [friendship],
            "pokes": [],
        })

        with patch("app.routers.friends.supabase", mock_sb):
            resp = client.post(f"/friends/{TEST_USER_2_ID}/poke", json={})

        assert resp.status_code == 200
        assert "poke" in resp.json()["message"].lower()

    def test_poke_rate_limited(self, client):
        """Should reject if user already poked within the hour."""
        friendship = {
            "id": str(uuid4()),
            "requester_id": TEST_USER_ID,
            "addressee_id": TEST_USER_2_ID,
            "status": "accepted",
        }
        recent_poke = {
            "id": str(uuid4()),
            "poker_id": TEST_USER_ID,
            "pokee_id": TEST_USER_2_ID,
            "created_at": datetime.utcnow().isoformat(),
        }

        mock_sb = make_mock_supabase({
            "friendships": [friendship],
            "pokes": [recent_poke],
        })

        with patch("app.routers.friends.supabase", mock_sb):
            resp = client.post(f"/friends/{TEST_USER_2_ID}/poke", json={})

        assert resp.status_code == 429
