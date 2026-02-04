"""Security utilities for authentication and authorization."""

from datetime import datetime, timedelta
from typing import Optional
import jwt
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials

from app.core.config import settings
from app.core.database import supabase
from app.models.user import User

security = HTTPBearer()


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
        payload = jwt.decode(
            token,
            settings.JWT_SECRET,
            algorithms=[settings.JWT_ALGORITHM],
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

    # Fetch user from Supabase
    response = supabase.table("users").select("*").eq("id", user_id).single().execute()

    if not response.data:
        raise AuthError("User not found")

    return User(**response.data)


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
