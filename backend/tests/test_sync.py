"""
Tests for the Sync router — bidirectional offline-first sync.
"""

import pytest
from datetime import datetime, timedelta
from uuid import uuid4
from unittest.mock import patch

from tests.conftest import TEST_USER_ID, make_mock_supabase, make_event_dict


# ===================================================================
# POST /sync — Bidirectional sync
# ===================================================================

class TestSync:
    """Tests for the sync endpoint."""

    def test_initial_sync_returns_server_changes(self, client):
        """First sync (no last_sync_at) should work without errors."""
        mock_sb = make_mock_supabase({
            "events": [],
            "daily_reflections": [],
            "streaks": [],
        })

        with patch("app.routers.sync.supabase", mock_sb):
            resp = client.post("/sync", json={
                "local_changes": [],
            })

        assert resp.status_code == 200
        data = resp.json()
        assert "server_changes" in data
        assert "conflicts" in data
        assert "sync_timestamp" in data
        assert data["success"] is True

    def test_sync_with_local_changes(self, client):
        """Should process local changes and return server changes."""
        ev = make_event_dict(title="Locally modified")

        mock_sb = make_mock_supabase({
            "events": [ev],
            "daily_reflections": [],
            "streaks": [],
        })

        with patch("app.routers.sync.supabase", mock_sb):
            resp = client.post("/sync", json={
                "last_sync_at": (datetime.utcnow() - timedelta(hours=1)).isoformat(),
                "local_changes": [
                    {
                        "table": "events",
                        "operation": "update",
                        "record_id": ev["id"],
                        "data": {"title": "Updated offline"},
                        "local_updated_at": datetime.utcnow().isoformat(),
                        "version": 1,
                    }
                ],
            })

        assert resp.status_code == 200
        data = resp.json()
        assert data["success"] is True

    def test_sync_rejects_invalid_table(self, client):
        """Changes to non-syncable tables should be ignored."""
        mock_sb = make_mock_supabase({
            "events": [],
            "daily_reflections": [],
            "streaks": [],
        })

        with patch("app.routers.sync.supabase", mock_sb):
            resp = client.post("/sync", json={
                "local_changes": [
                    {
                        "table": "users",  # Not syncable
                        "operation": "update",
                        "record_id": str(uuid4()),
                        "data": {"display_name": "hacked"},
                        "local_updated_at": datetime.utcnow().isoformat(),
                    }
                ],
            })

        assert resp.status_code == 200
        # Should succeed but ignore the users table change
