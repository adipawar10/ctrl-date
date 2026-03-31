"""
Tests for the AI Suggestions router — generation, apply, feedback (features 6.1, 6.2).
"""

import pytest
from datetime import datetime, date, timedelta
from uuid import uuid4
from unittest.mock import patch, AsyncMock

from tests.conftest import (
    TEST_USER_ID,
    make_mock_supabase, make_event_dict,
)


# ===================================================================
# POST /ai/suggestions — Generate suggestions
# ===================================================================

class TestGenerateSuggestions:
    """Tests for AI scheduling suggestions."""

    def test_generate_suggestions_calls_llm(self, client):
        """Should fetch events, call LLM, and return validated suggestions."""
        events = [
            make_event_dict(title="Standup", is_locked=True, start_hours_from_now=1),
            make_event_dict(title="Flexible task", start_hours_from_now=3),
        ]

        mock_llm_response = {
            "suggestions": [
                {
                    "id": "sug_test01",
                    "type": "add_event",
                    "title": "Focus time",
                    "proposed_start": (datetime.utcnow() + timedelta(hours=5)).isoformat(),
                    "proposed_end": (datetime.utcnow() + timedelta(hours=6)).isoformat(),
                    "reasoning": "You have a gap after 3pm",
                    "confidence": 0.85,
                    "category": "focus_time",
                }
            ],
            "analysis": {
                "utilization": 0.65,
                "focus_time_hours": 2.5,
                "meeting_hours": 3.0,
                "identified_gaps": ["2pm-3pm free slot", "No focus time in morning"],
            },
        }

        mock_sb = make_mock_supabase({
            "events": events,
            "daily_reflections": [],
            "ai_suggestions": [{"id": str(uuid4())}],
        })

        with (
            patch("app.routers.ai_suggestions.supabase", mock_sb),
            patch("app.routers.ai_suggestions.call_llm", new_callable=AsyncMock) as mock_llm,
        ):
            mock_llm.return_value = mock_llm_response

            tomorrow = date.today() + timedelta(days=1)
            resp = client.post("/ai/suggestions", json={
                "start_date": date.today().isoformat(),
                "end_date": tomorrow.isoformat(),
                "max_suggestions": 5,
            })

        assert resp.status_code == 200
        data = resp.json()

        # Check suggestions
        assert "suggestions" in data
        assert len(data["suggestions"]) >= 1
        sug = data["suggestions"][0]
        assert sug["type"] == "add_event"
        assert sug["confidence"] > 0

        # Check analysis (feature 6.2 - whitespace detection)
        assert "analysis" in data
        assert "utilization" in data["analysis"]
        assert "focus_time_hours" in data["analysis"]
        assert "identified_gaps" in data["analysis"]
        assert len(data["analysis"]["identified_gaps"]) > 0

    def test_suggestion_guardrails_filter_locked(self, client):
        """Suggestions that modify locked events should be filtered out."""
        locked_event = make_event_dict(title="Locked", is_locked=True, event_id="locked123")

        mock_llm_response = {
            "suggestions": [
                {
                    "id": "sug_bad",
                    "type": "reschedule",
                    "event_id": "locked123",
                    "proposed_start": (datetime.utcnow() + timedelta(hours=5)).isoformat(),
                    "proposed_end": (datetime.utcnow() + timedelta(hours=6)).isoformat(),
                    "reasoning": "Move this locked event",
                    "confidence": 0.9,
                },
                {
                    "id": "sug_good",
                    "type": "add_event",
                    "title": "Break",
                    "proposed_start": (datetime.utcnow() + timedelta(hours=8)).isoformat(),
                    "proposed_end": (datetime.utcnow() + timedelta(hours=8, minutes=15)).isoformat(),
                    "reasoning": "Take a break",
                    "confidence": 0.7,
                    "category": "break",
                },
            ],
            "analysis": {
                "utilization": 0.5,
                "focus_time_hours": 1.0,
                "meeting_hours": 2.0,
                "identified_gaps": [],
            },
        }

        mock_sb = make_mock_supabase({
            "events": [locked_event],
            "daily_reflections": [],
            "ai_suggestions": [{"id": str(uuid4())}],
        })

        with (
            patch("app.routers.ai_suggestions.supabase", mock_sb),
            patch("app.routers.ai_suggestions.call_llm", new_callable=AsyncMock) as mock_llm,
        ):
            mock_llm.return_value = mock_llm_response

            tomorrow = date.today() + timedelta(days=1)
            resp = client.post("/ai/suggestions", json={
                "start_date": date.today().isoformat(),
                "end_date": tomorrow.isoformat(),
            })

        assert resp.status_code == 200
        suggestions = resp.json()["suggestions"]

        # The locked reschedule should be filtered out
        ids = [s["id"] for s in suggestions]
        assert "sug_bad" not in ids
        assert "sug_good" in ids


# ===================================================================
# POST /ai/suggestions/{id}/apply — Apply suggestion
# ===================================================================

class TestApplySuggestion:
    """Tests for applying AI suggestions."""

    def test_apply_add_event_suggestion(self, client):
        """Should create an event from an add_event suggestion."""
        suggestion = {
            "id": "sug_apply01",
            "type": "add_event",
            "title": "Focus Block",
            "proposed_start": (datetime.utcnow() + timedelta(hours=2)).isoformat(),
            "proposed_end": (datetime.utcnow() + timedelta(hours=3)).isoformat(),
            "category": "focus_time",
        }

        ai_log = {
            "id": str(uuid4()),
            "suggestions": [suggestion],
            "accepted_suggestion_ids": [],
            "rejected_suggestion_ids": [],
        }

        created_event = make_event_dict(title="Focus Block")

        mock_sb = make_mock_supabase({
            "ai_suggestions": ai_log,
            "events": [created_event],
        })

        with patch("app.routers.ai_suggestions.supabase", mock_sb):
            resp = client.post("/ai/suggestions/sug_apply01/apply")

        assert resp.status_code == 200
        assert "event" in resp.json()

    def test_apply_nonexistent_suggestion_404(self, client):
        """Should 404 for expired or unknown suggestion."""
        mock_sb = make_mock_supabase({"ai_suggestions": []})

        with patch("app.routers.ai_suggestions.supabase", mock_sb):
            resp = client.post("/ai/suggestions/sug_missing/apply")

        assert resp.status_code == 404


# ===================================================================
# POST /ai/suggestions/feedback — Submit feedback
# ===================================================================

class TestSuggestionFeedback:
    """Tests for recording feedback on suggestions."""

    def test_accept_feedback(self, client):
        """Should record accepted feedback."""
        ai_log = {
            "id": str(uuid4()),
            "suggestions": [{"id": "sug_fb01", "type": "add_event"}],
            "accepted_suggestion_ids": [],
            "rejected_suggestion_ids": [],
        }

        mock_sb = make_mock_supabase({"ai_suggestions": ai_log})

        with patch("app.routers.ai_suggestions.supabase", mock_sb):
            resp = client.post("/ai/suggestions/feedback", json={
                "suggestion_id": "sug_fb01",
                "accepted": True,
            })

        assert resp.status_code == 200

    def test_reject_feedback(self, client):
        """Should record rejected feedback."""
        ai_log = {
            "id": str(uuid4()),
            "suggestions": [{"id": "sug_fb02", "type": "add_event"}],
            "accepted_suggestion_ids": [],
            "rejected_suggestion_ids": [],
        }

        mock_sb = make_mock_supabase({"ai_suggestions": ai_log})

        with patch("app.routers.ai_suggestions.supabase", mock_sb):
            resp = client.post("/ai/suggestions/feedback", json={
                "suggestion_id": "sug_fb02",
                "accepted": False,
            })

        assert resp.status_code == 200
