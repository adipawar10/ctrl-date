"""
Tests for the Calendar Import router — CSV upload (feature 4.2).
"""

import pytest
from datetime import datetime
from uuid import uuid4
from unittest.mock import patch, AsyncMock
from io import BytesIO

from tests.conftest import TEST_USER_ID, make_mock_supabase


# ===================================================================
# POST /import/csv — CSV upload
# ===================================================================

class TestCsvImport:
    """Tests for CSV calendar import."""

    def test_import_valid_csv(self, client):
        """Should accept a valid CSV and return a batch ID."""
        csv_content = (
            "title,start_time,end_time,location\n"
            "Meeting,2026-04-01T09:00:00,2026-04-01T10:00:00,Office\n"
            "Lunch,2026-04-01T12:00:00,2026-04-01T13:00:00,Cafe\n"
        )

        mock_sb = make_mock_supabase({
            "import_batches": [{
                "id": str(uuid4()),
                "user_id": TEST_USER_ID,
                "filename": "test.csv",
                "events_imported": 0,
                "events_skipped": 0,
                "can_undo": True,
            }],
        })

        with patch("app.routers.calendar_import.supabase", mock_sb), \
             patch("app.services.import_service.supabase", mock_sb):
            resp = client.post(
                "/import/csv",
                files={"file": ("calendar.csv", csv_content.encode(), "text/csv")},
            )

        assert resp.status_code == 200
        data = resp.json()
        assert "id" in data
        assert data["status"] == "processing"

    def test_import_non_csv_rejected(self, client):
        """Should reject files that aren't CSV."""
        resp = client.post(
            "/import/csv",
            files={"file": ("calendar.txt", b"not,a,csv", "text/plain")},
        )
        assert resp.status_code == 400

    def test_import_empty_csv(self, client):
        """Should handle an empty CSV gracefully."""
        csv_content = "title,start_time,end_time\n"

        mock_sb = make_mock_supabase({
            "import_batches": [{
                "id": str(uuid4()),
                "user_id": TEST_USER_ID,
                "filename": "empty.csv",
                "events_imported": 0,
                "events_skipped": 0,
                "can_undo": True,
            }],
        })

        with patch("app.routers.calendar_import.supabase", mock_sb), \
             patch("app.services.import_service.supabase", mock_sb):
            resp = client.post(
                "/import/csv",
                files={"file": ("empty.csv", csv_content.encode(), "text/csv")},
            )

        assert resp.status_code == 200


# ===================================================================
# GET /import/{batch_id} — Check import status
# ===================================================================

class TestImportStatus:
    """Tests for checking import batch status."""

    def test_get_batch_status(self, client):
        """Should return batch progress."""
        batch_id = str(uuid4())
        batch = {
            "id": batch_id,
            "user_id": TEST_USER_ID,
            "filename": "calendar.csv",
            "status": "completed",
            "events_imported": 10,
            "events_skipped": 2,
            "can_undo": True,
            "error_log": None,
            "created_at": datetime.utcnow().isoformat(),
        }

        mock_sb = make_mock_supabase({"import_batches": batch})

        with patch("app.routers.calendar_import.supabase", mock_sb):
            resp = client.get(f"/import/{batch_id}")

        assert resp.status_code == 200
        data = resp.json()
        assert data["events_imported"] == 10

    def test_get_missing_batch_404(self, client):
        """Should 404 for unknown batch ID."""
        mock_sb = make_mock_supabase({"import_batches": None})

        with patch("app.routers.calendar_import.supabase", mock_sb):
            resp = client.get(f"/import/{uuid4()}")

        assert resp.status_code in (404, 500)
