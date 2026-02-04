"""Authentication router."""

from fastapi import APIRouter, HTTPException, status, Depends
from pydantic import BaseModel, EmailStr
from typing import Optional

from app.core.database import supabase
from app.core.security import get_current_user
from app.models.user import User, UserUpdate

router = APIRouter()


class RegisterRequest(BaseModel):
    """Registration request schema."""
    email: EmailStr
    password: str
    display_name: str
    timezone: str = "UTC"


class LoginRequest(BaseModel):
    """Login request schema."""
    email: EmailStr
    password: str


class TokenResponse(BaseModel):
    """Token response schema."""
    access_token: str
    refresh_token: str
    token_type: str = "bearer"
    expires_in: int
    user: dict


class PublicKeyUpdate(BaseModel):
    """Schema for updating E2E public key."""
    public_key: str


@router.post("/register", response_model=TokenResponse)
async def register(request: RegisterRequest):
    """Register a new user."""
    try:
        # Create auth user in Supabase
        auth_response = supabase.auth.sign_up({
            "email": request.email,
            "password": request.password,
            "options": {
                "data": {
                    "display_name": request.display_name,
                    "timezone": request.timezone,
                }
            }
        })

        if auth_response.user is None:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Registration failed"
            )

        # Create user record in users table
        user_data = {
            "id": str(auth_response.user.id),
            "email": request.email,
            "display_name": request.display_name,
            "timezone": request.timezone,
            "preferences": {
                "default_event_duration": 60,
                "week_start": "monday",
                "working_hours_start": "09:00",
                "working_hours_end": "17:00",
                "notification_lead_time": 15,
            }
        }
        supabase.table("users").insert(user_data).execute()

        # Create default streak
        supabase.table("streaks").insert({
            "user_id": str(auth_response.user.id),
            "streak_type": "daily_completion",
            "completion_threshold": 0.80,
        }).execute()

        return TokenResponse(
            access_token=auth_response.session.access_token,
            refresh_token=auth_response.session.refresh_token,
            expires_in=auth_response.session.expires_in,
            user=user_data,
        )

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.post("/login", response_model=TokenResponse)
async def login(request: LoginRequest):
    """Login with email and password."""
    try:
        auth_response = supabase.auth.sign_in_with_password({
            "email": request.email,
            "password": request.password,
        })

        if auth_response.user is None:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid credentials"
            )

        # Fetch user data
        user_response = supabase.table("users").select("*").eq(
            "id", str(auth_response.user.id)
        ).single().execute()

        return TokenResponse(
            access_token=auth_response.session.access_token,
            refresh_token=auth_response.session.refresh_token,
            expires_in=auth_response.session.expires_in,
            user=user_response.data,
        )

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid credentials"
        )


@router.post("/refresh", response_model=TokenResponse)
async def refresh_token(refresh_token: str):
    """Refresh access token."""
    try:
        auth_response = supabase.auth.refresh_session(refresh_token)

        if auth_response.user is None:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid refresh token"
            )

        user_response = supabase.table("users").select("*").eq(
            "id", str(auth_response.user.id)
        ).single().execute()

        return TokenResponse(
            access_token=auth_response.session.access_token,
            refresh_token=auth_response.session.refresh_token,
            expires_in=auth_response.session.expires_in,
            user=user_response.data,
        )

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token refresh failed"
        )


@router.post("/logout")
async def logout(user: User = Depends(get_current_user)):
    """Logout current user."""
    try:
        supabase.auth.sign_out()
        return {"message": "Logged out successfully"}
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Logout failed"
        )


@router.put("/public-key")
async def update_public_key(
    request: PublicKeyUpdate,
    user: User = Depends(get_current_user)
):
    """Update user's E2E encryption public key."""
    try:
        supabase.table("users").update({
            "public_key": request.public_key
        }).eq("id", str(user.id)).execute()

        return {"message": "Public key updated"}

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to update public key"
        )


@router.get("/me", response_model=User)
async def get_current_user_info(user: User = Depends(get_current_user)):
    """Get current user information."""
    return user


@router.put("/me")
async def update_current_user(
    update: UserUpdate,
    user: User = Depends(get_current_user)
):
    """Update current user information."""
    try:
        update_data = update.model_dump(exclude_unset=True)
        if update_data:
            supabase.table("users").update(update_data).eq(
                "id", str(user.id)
            ).execute()

        # Fetch updated user
        response = supabase.table("users").select("*").eq(
            "id", str(user.id)
        ).single().execute()

        return response.data

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to update user"
        )
