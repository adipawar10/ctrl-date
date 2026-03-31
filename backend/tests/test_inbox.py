"""
Tests for the Inbox router — E2E encrypted messaging (feature 3.3).
"""

import pytest
from datetime import datetime
from uuid import uuid4
from unittest.mock import patch

from tests.conftest import (
    TEST_USER_ID, TEST_USER_2_ID,
    make_mock_supabase,
)


# ===================================================================
# GET /inbox — List messages
# ===================================================================

class TestListMessages:
    """Tests for listing inbox messages."""

    def test_list_messages(self, client):
        """Should return messages for the authenticated user."""
        messages = [
            {
                "id": str(uuid4()),
                "sender_id": TEST_USER_2_ID,
                "recipient_id": TEST_USER_ID,
                "message_type": "text",
                "ciphertext": "encrypted_payload",
                "ephemeral_public_key": "key123",
                "nonce": "nonce123",
                "is_read": False,
                "created_at": datetime.utcnow().isoformat(),
                "deleted_at": None,
                "sender": {
                    "id": TEST_USER_2_ID,
                    "display_name": "Friend User",
                    "avatar_url": None,
                },
            }
        ]

        mock_sb = make_mock_supabase({"inbox_messages": messages})

        with patch("app.routers.inbox.supabase", mock_sb):
            resp = client.get("/inbox")

        assert resp.status_code == 200
        data = resp.json()
        assert "messages" in data
        assert "next_cursor" in data
        assert "has_more" in data

    def test_list_unread_only(self, client):
        """Should filter to unread messages when requested."""
        mock_sb = make_mock_supabase({"inbox_messages": []})

        with patch("app.routers.inbox.supabase", mock_sb):
            resp = client.get("/inbox", params={"unread_only": True})

        assert resp.status_code == 200

    def test_filter_by_message_type(self, client):
        """Should filter by message type."""
        mock_sb = make_mock_supabase({"inbox_messages": []})

        with patch("app.routers.inbox.supabase", mock_sb):
            resp = client.get("/inbox", params={"message_type": "poke"})

        assert resp.status_code == 200


# ===================================================================
# POST /inbox — Send encrypted message
# ===================================================================

class TestSendMessage:
    """Tests for sending E2E encrypted messages."""

    def test_send_text_message(self, client):
        """Should create an encrypted message record."""
        recipient = {
            "id": TEST_USER_2_ID,
            "display_name": "Friend",
            "public_key": "recipient_public_key_x25519",
        }

        mock_sb = make_mock_supabase({
            "users": recipient,
            "inbox_messages": [],
        })

        with patch("app.routers.inbox.supabase", mock_sb):
            resp = client.post("/inbox", json={
                "recipient_id": TEST_USER_2_ID,
                "message_type": "text",
                "ciphertext": "base64_encrypted_data",
                "ephemeral_public_key": "sender_ephemeral_key",
                "nonce": "random_nonce",
            })

        assert resp.status_code == 201
        data = resp.json()
        assert data["recipient_id"] == TEST_USER_2_ID
        assert data["message_type"] == "text"

    def test_send_to_nonexistent_user_404(self, client):
        """Should reject messages to unknown users."""
        mock_sb = make_mock_supabase({"users": None})

        with patch("app.routers.inbox.supabase", mock_sb):
            resp = client.post("/inbox", json={
                "recipient_id": str(uuid4()),
                "message_type": "text",
                "ciphertext": "data",
                "ephemeral_public_key": "key",
                "nonce": "nonce",
            })

        assert resp.status_code in (404, 500)

    def test_send_to_user_without_key_rejected(self, client):
        """Should reject messages to users without public keys."""
        recipient = {
            "id": TEST_USER_2_ID,
            "display_name": "No-Key User",
            "public_key": None,
        }

        mock_sb = make_mock_supabase({"users": recipient})

        with patch("app.routers.inbox.supabase", mock_sb):
            resp = client.post("/inbox", json={
                "recipient_id": TEST_USER_2_ID,
                "message_type": "text",
                "ciphertext": "data",
                "ephemeral_public_key": "key",
                "nonce": "nonce",
            })

        assert resp.status_code == 400


# ===================================================================
# PUT /inbox/{id}/read — Mark read
# ===================================================================

class TestMarkRead:
    """Tests for marking messages as read."""

    def test_mark_message_read(self, client):
        """Should mark a single message as read."""
        msg_id = str(uuid4())
        msg = {
            "id": msg_id,
            "recipient_id": TEST_USER_ID,
        }

        mock_sb = make_mock_supabase({"inbox_messages": msg})

        with patch("app.routers.inbox.supabase", mock_sb):
            resp = client.put(f"/inbox/{msg_id}/read")

        assert resp.status_code == 200

    def test_mark_all_read(self, client):
        """Should mark all messages as read."""
        mock_sb = make_mock_supabase({"inbox_messages": []})

        with patch("app.routers.inbox.supabase", mock_sb):
            resp = client.post("/inbox/read-all")

        assert resp.status_code == 200


# ===================================================================
# DELETE /inbox/{id} — Soft delete message
# ===================================================================

class TestDeleteMessage:
    """Tests for deleting messages."""

    def test_delete_received_message(self, client):
        """Recipient should be able to soft-delete a message."""
        msg_id = str(uuid4())
        msg = {"id": msg_id}

        mock_sb = make_mock_supabase({"inbox_messages": msg})

        with patch("app.routers.inbox.supabase", mock_sb):
            resp = client.delete(f"/inbox/{msg_id}")

        assert resp.status_code == 200
