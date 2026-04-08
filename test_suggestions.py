#!/usr/bin/env python3
"""Test script for AI suggestions endpoint."""

import requests
import json
from datetime import datetime, timedelta

# Get a test token from Supabase
SUPABASE_URL = "https://qsinqjlxfvkguagpaqdf.supabase.co"
SUPABASE_ANON_KEY = "sb_publishable_qTzpzY8e785uuv4y1tEvTA_5TROfz7q"
API_BASE = "http://172.20.10.2:8000/api/v1"

def test_suggestions_endpoint():
    """Test the /ai/suggestions endpoint."""

    # Use a valid JWT token (generated with JWT_SECRET from .env)
    # Token for test user: test-user-id (with 'aud': 'authenticated')
    token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ0ZXN0LXVzZXItaWQiLCJlbWFpbCI6InRlc3RAZXhhbXBsZS5jb20iLCJhdWQiOiJhdXRoZW50aWNhdGVkIiwiaWF0IjoxNzc1MzI4ODEwLjg4MDY0MiwiZXhwIjoxNzc1MzMyNDEwLjg4MDY1fQ.FlEZtJlvEYwP0H1vpTlw8mQAzZuTMP8msFzq0ynp7Nc"

    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json",
    }

    # Prepare request
    start_date = datetime.now().date().isoformat()
    end_date = (datetime.now() + timedelta(days=7)).date().isoformat()

    payload = {
        "start_date": start_date,
        "end_date": end_date,
        "max_suggestions": 5,
    }

    print(f"Testing endpoint: http://172.20.10.2:8000/ai/suggestions")
    print(f"Payload: {json.dumps(payload, indent=2)}")

    try:
        response = requests.post(
            "http://172.20.10.2:8000/ai/suggestions",
            json=payload,
            headers=headers,
            timeout=30
        )

        print(f"\nResponse Status: {response.status_code}")
        print(f"Response Body:\n{json.dumps(response.json(), indent=2)}")

        if response.status_code == 200:
            print("\n✅ SUCCESS: Suggestions endpoint is working!")
            return True
        else:
            print(f"\n❌ FAILED: Got status {response.status_code}")
            return False

    except requests.exceptions.ConnectionError as e:
        print(f"\n❌ CONNECTION ERROR: {e}")
        print(f"Make sure backend is running on {API_BASE}")
        return False
    except Exception as e:
        print(f"\n❌ ERROR: {e}")
        return False

def test_backend_health():
    """Test if backend is reachable."""
    print("Testing backend health...")
    try:
        response = requests.get("http://172.20.10.2:8000", timeout=5)
        print(f"Backend reachable: {response.status_code}")
        return True
    except Exception as e:
        print(f"❌ Backend not reachable: {e}")
        return False

if __name__ == "__main__":
    print("🧪 Running AI Suggestions Test\n")

    if not test_backend_health():
        print("\n⚠️  Backend is not reachable. Make sure it's running:")
        print("   cd backend && uvicorn app.main:app --reload --host 0.0.0.0 --port 8000")
        exit(1)

    print("\n" + "="*50)
    test_suggestions_endpoint()
