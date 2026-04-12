"""Security utilities for authentication and authorization."""

from datetime import datetime, timedelta
from typing import Optional
from uuid import UUID, uuid5, NAMESPACE_DNS
import json
import jwt
from jwt import PyJWK
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import httpx

from app.core.config import settings
from app.core.database import supabase
from app.models.user import User, UserPreferences

security = HTTPBearer()

# Cache the JWKS signing key at startup
_signing_key = None


def _get_signing_key():
    """Fetch and cache the Supabase JWKS signing key."""
    global _signing_key
    if _signing_key is not None:
        return _signing_key

    jwks_url = f"{settings.SUPABASE_URL}/auth/v1/.well-known/jwks.json"
    response = httpx.get(jwks_url)
    response.raise_for_status()
    jwks_data = response.json()

    for key_data in jwks_data.get("keys", []):
        if key_data.get("use") == "sig":
            _signing_key = PyJWK(key_data).key
            return _signing_key

    raise RuntimeError("No signing key found in Supabase JWKS")


class AuthError(HTTPException):
    """Authentication error."""
    def __init__(self, detail: str):
        super().__init__(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=detail,
            headers={"WWW-Authenticate": "Bearer"},
        )


def verify_token(token: str) -> dict:
    """Verify JWT token and return payload."""
    try:
        key = _get_signing_key()
        payload = jwt.decode(
            token,
            key,
            algorithms=["ES256"],
            audience="authenticated",
        )
        return payload
    except jwt.ExpiredSignatureError:
        raise AuthError("Token has expired")
    except jwt.InvalidTokenError as e:
        raise AuthError(f"Invalid token: {str(e)}")


async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security)
) -> User:
    """Get current authenticated user from JWT token."""
    token = credentials.credentials
    payload = verify_token(token)

    user_id = payload.get("sub")
    if not user_id:
        raise AuthError("Invalid token payload")

    # Try to fetch user from public.users table
    try:
        response = supabase.table("users").select("*").eq("id", user_id).single().execute()
        if response.data:
            return User(**response.data)
    except Exception:
        pass

    # User not in public.users yet — auto-create from JWT claims
    try:
        user_uuid = UUID(user_id)
    except ValueError:
        user_uuid = uuid5(NAMESPACE_DNS, user_id)

    email = payload.get("email", f"user+{user_uuid}@example.com")
    user_metadata = payload.get("user_metadata", {})
    display_name = (
        user_metadata.get("display_name")
        or payload.get("name")
        or email.split("@")[0]
    )

    # Upsert into public.users so foreign keys work
    user_data = {
        "id": str(user_uuid),
        "email": email,
        "display_name": display_name,
    }
    try:
        supabase.table("users").upsert(user_data).execute()
    except Exception:
        pass  # Non-fatal — user object still works for this request

    return User(
        id=user_uuid,
        email=email,
        display_name=display_name,
        created_at=datetime.utcnow(),
        updated_at=datetime.utcnow(),
        preferences=UserPreferences(),
    )


async def get_optional_user(
    credentials: Optional[HTTPAuthorizationCredentials] = Depends(
        HTTPBearer(auto_error=False)
    )
) -> Optional[User]:
    """Get current user if authenticated, None otherwise."""
    if not credentials:
        return None
    try:
        return await get_current_user(credentials)
    except AuthError:
        return None
