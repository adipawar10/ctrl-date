"""
Tests for the Auth router — registration, login, profile, keys.
"""

import pytest
from datetime import datetime
from uuid import uuid4
from unittest.mock import patch, MagicMock

from tests.conftest import TEST_USER_ID, make_mock_supabase


# ===================================================================
# POST /auth/register — User registration
# ===================================================================

class TestRegister:
    """Tests for user registration."""

    def test_register_valid_user(self, client):
        """Should register a new user and return tokens."""
        mock_auth_response = MagicMock()
        mock_auth_response.user = MagicMock()
        mock_auth_response.user.id = uuid4()
        mock_auth_response.session = MagicMock()
        mock_auth_response.session.access_token = "test_access_token"
        mock_auth_response.session.refresh_token = "test_refresh_token"
        mock_auth_response.session.expires_in = 3600

        mock_sb = make_mock_supabase({
            "users": [{"id": str(mock_auth_response.user.id)}],
            "streaks": [{"id": str(uuid4())}],
        })
        mock_sb.auth = MagicMock()
        mock_sb.auth.sign_up = MagicMock(return_value=mock_auth_response)

        with patch("app.routers.auth.supabase", mock_sb):
            resp = client.post("/auth/register", json={
                "email": "newuser@example.com",
                "password": "secureP@ss123",
                "display_name": "New User",
                "timezone": "America/Chicago",
            })

        assert resp.status_code == 200
        data = resp.json()
        assert "access_token" in data
        assert "refresh_token" in data
        assert data["token_type"] == "bearer"

    def test_register_invalid_email(self, client):
        """Should reject invalid email format."""
        resp = client.post("/auth/register", json={
            "email": "not-an-email",
            "password": "secureP@ss123",
            "display_name": "Bad Email",
        })
        assert resp.status_code == 422

    def test_register_missing_fields(self, client):
        """Should reject incomplete registration."""
        resp = client.post("/auth/register", json={
            "email": "missing@example.com",
        })
        assert resp.status_code == 422


# ===================================================================
# GET /health — Health check
# ===================================================================

class TestHealthCheck:
    """Tests for health and root endpoints."""

    def test_health_endpoint(self, client):
        """Health check should return healthy status."""
        resp = client.get("/health")
        assert resp.status_code == 200
        data = resp.json()
        assert data["status"] == "healthy"
        assert "version" in data

    def test_root_endpoint(self, client):
        """Root should return app info."""
        resp = client.get("/")
        assert resp.status_code == 200
        data = resp.json()
        assert "app" in data
        assert "version" in data
        assert "docs" in data
