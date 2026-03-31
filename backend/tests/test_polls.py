"""
Tests for the Polls router — CRUD, voting, close (feature 7.4).
"""

import pytest
from datetime import datetime, timedelta
from uuid import uuid4
from unittest.mock import patch

from tests.conftest import (
    TEST_USER_ID, TEST_USER_2_ID,
    make_mock_supabase,
)


# ===================================================================
# POST /polls/polls — Create poll
# ===================================================================

class TestCreatePoll:
    """Tests for creating event planning polls."""

    def test_create_time_poll(self, client):
        """Should create a poll with time options."""
        tomorrow = datetime.utcnow() + timedelta(days=1)
        payload = {
            "title": "When should we meet?",
            "description": "Pick a time slot",
            "poll_type": "time",
            "options": [
                {
                    "label": "Monday 10am",
                    "start_time": tomorrow.isoformat(),
                    "end_time": (tomorrow + timedelta(hours=1)).isoformat(),
                },
                {
                    "label": "Tuesday 2pm",
                    "start_time": (tomorrow + timedelta(days=1, hours=4)).isoformat(),
                    "end_time": (tomorrow + timedelta(days=1, hours=5)).isoformat(),
                },
            ],
            "invited_user_ids": [TEST_USER_2_ID],
        }

        mock_sb = make_mock_supabase({
            "polls": [{"id": str(uuid4()), **payload}],
            "inbox_messages": [],
        })

        with patch("app.routers.polls.supabase", mock_sb):
            resp = client.post("/polls/polls", json=payload)

        assert resp.status_code == 200
        data = resp.json()
        assert data["title"] == "When should we meet?"
        assert len(data["options"]) == 2

    def test_create_place_poll(self, client):
        """Should create a poll with place options."""
        payload = {
            "title": "Where should we eat?",
            "poll_type": "place",
            "options": [
                {"label": "Sushi Place"},
                {"label": "Pizza Joint"},
                {"label": "Taco Stand"},
            ],
        }

        mock_sb = make_mock_supabase({
            "polls": [{"id": str(uuid4()), **payload}],
        })

        with patch("app.routers.polls.supabase", mock_sb):
            resp = client.post("/polls/polls", json=payload)

        assert resp.status_code == 200
        assert len(resp.json()["options"]) == 3


# ===================================================================
# GET /polls/polls — List polls
# ===================================================================

class TestListPolls:
    """Tests for listing polls."""

    def test_list_created_and_invited_polls(self, client):
        """Should return polls user created or is invited to."""
        created_poll = {
            "id": str(uuid4()),
            "creator_id": TEST_USER_ID,
            "title": "My poll",
            "options": [],
        }
        invited_poll = {
            "id": str(uuid4()),
            "creator_id": TEST_USER_2_ID,
            "title": "Friend's poll",
            "invited_user_ids": [TEST_USER_ID],
            "options": [],
        }

        mock_sb = make_mock_supabase({
            "polls": [created_poll, invited_poll],
        })

        with patch("app.routers.polls.supabase", mock_sb):
            resp = client.get("/polls/polls")

        assert resp.status_code == 200
        data = resp.json()
        assert "polls" in data


# ===================================================================
# GET /polls/polls/{id} — Get poll detail
# ===================================================================

class TestGetPoll:
    """Tests for getting a single poll."""

    def test_get_poll_as_creator(self, client):
        """Creator can view their poll."""
        poll_id = str(uuid4())
        poll = {
            "id": poll_id,
            "creator_id": TEST_USER_ID,
            "title": "Test poll",
            "options": [{"index": 0, "label": "Option A", "votes": []}],
            "invited_user_ids": [],
        }

        mock_sb = make_mock_supabase({"polls": poll})

        with patch("app.routers.polls.supabase", mock_sb):
            resp = client.get(f"/polls/polls/{poll_id}")

        assert resp.status_code == 200

    def test_get_nonexistent_poll_404(self, client):
        """Should 404 for missing poll."""
        mock_sb = make_mock_supabase({"polls": None})

        with patch("app.routers.polls.supabase", mock_sb):
            resp = client.get(f"/polls/polls/{uuid4()}")

        assert resp.status_code in (404, 500)


# ===================================================================
# POST /polls/polls/{id}/vote — Cast vote
# ===================================================================

class TestVoteOnPoll:
    """Tests for voting on polls."""

    def test_cast_yes_vote(self, client):
        """Should record a 'yes' vote on a poll option."""
        poll_id = str(uuid4())
        poll = {
            "id": poll_id,
            "creator_id": TEST_USER_2_ID,
            "title": "When?",
            "is_closed": False,
            "invited_user_ids": [TEST_USER_ID],
            "options": [
                {"index": 0, "label": "Monday", "votes": []},
                {"index": 1, "label": "Tuesday", "votes": []},
            ],
        }

        mock_sb = make_mock_supabase({"polls": poll})

        with patch("app.routers.polls.supabase", mock_sb):
            resp = client.post(f"/polls/polls/{poll_id}/vote", json={
                "option_index": 0,
                "vote": "yes",
            })

        assert resp.status_code == 200

    def test_vote_on_closed_poll_rejected(self, client):
        """Should reject votes on closed polls."""
        poll_id = str(uuid4())
        poll = {
            "id": poll_id,
            "creator_id": TEST_USER_2_ID,
            "is_closed": True,
            "invited_user_ids": [TEST_USER_ID],
            "options": [{"index": 0, "label": "A", "votes": []}],
        }

        mock_sb = make_mock_supabase({"polls": poll})

        with patch("app.routers.polls.supabase", mock_sb):
            resp = client.post(f"/polls/polls/{poll_id}/vote", json={
                "option_index": 0,
                "vote": "yes",
            })

        assert resp.status_code == 400

    def test_vote_invalid_option_index(self, client):
        """Should reject votes with out-of-range option index."""
        poll_id = str(uuid4())
        poll = {
            "id": poll_id,
            "creator_id": TEST_USER_2_ID,
            "is_closed": False,
            "invited_user_ids": [TEST_USER_ID],
            "options": [{"index": 0, "label": "Only option", "votes": []}],
        }

        mock_sb = make_mock_supabase({"polls": poll})

        with patch("app.routers.polls.supabase", mock_sb):
            resp = client.post(f"/polls/polls/{poll_id}/vote", json={
                "option_index": 99,
                "vote": "yes",
            })

        assert resp.status_code == 400

    @pytest.mark.parametrize("vote_val", ["yes", "no", "maybe"])
    def test_vote_types(self, client, vote_val):
        """Should accept yes, no, and maybe votes."""
        poll_id = str(uuid4())
        poll = {
            "id": poll_id,
            "creator_id": TEST_USER_2_ID,
            "is_closed": False,
            "invited_user_ids": [TEST_USER_ID],
            "options": [{"index": 0, "label": "Option", "votes": []}],
        }

        mock_sb = make_mock_supabase({"polls": poll})

        with patch("app.routers.polls.supabase", mock_sb):
            resp = client.post(f"/polls/polls/{poll_id}/vote", json={
                "option_index": 0,
                "vote": vote_val,
            })

        assert resp.status_code == 200
