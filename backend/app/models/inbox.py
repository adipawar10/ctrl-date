"""Inbox and E2E encrypted messaging models."""

from datetime import datetime
from typing import Optional
from pydantic import BaseModel
from uuid import UUID
from enum import Enum


class MessageType(str, Enum):
    """Message type for inbox."""
    TEXT = "text"
    EVENT_SHARE = "event_share"
    POKE = "poke"
    SYSTEM = "system"


class InboxMessage(BaseModel):
    """Inbox message model with E2E encryption fields."""
    id: UUID
    sender_id: UUID
    recipient_id: UUID
    message_type: MessageType

    # E2E encrypted payload
    ciphertext: str
    ephemeral_public_key: str
    nonce: str

    # Metadata (not encrypted)
    is_read: bool = False
    created_at: datetime
    deleted_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class InboxMessageCreate(BaseModel):
    """Schema for sending an encrypted message."""
    recipient_id: UUID
    message_type: MessageType
    ciphertext: str  # Encrypted with recipient's public key
    ephemeral_public_key: str  # X25519 ephemeral key for this message
    nonce: str  # Nonce for decryption


class InboxMessageResponse(BaseModel):
    """Response schema for inbox messages."""
    id: UUID
    sender_id: UUID
    sender_display_name: str
    message_type: MessageType
    ciphertext: str
    ephemeral_public_key: str
    nonce: str
    is_read: bool
    created_at: datetime


class PublicKeyResponse(BaseModel):
    """Response schema for user public key."""
    user_id: UUID
    public_key: Optional[str]
    display_name: str
