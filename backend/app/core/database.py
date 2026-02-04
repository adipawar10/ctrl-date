"""Database connection and session management."""

from supabase import create_client, Client
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession, async_sessionmaker
from sqlalchemy.orm import declarative_base

from app.core.config import settings

# Supabase client for auth and realtime
supabase: Client = create_client(settings.SUPABASE_URL, settings.SUPABASE_SERVICE_ROLE_KEY)

# SQLAlchemy for direct database access (background jobs, complex queries)
engine = create_async_engine(
    settings.DATABASE_URL.replace("postgresql://", "postgresql+asyncpg://"),
    echo=settings.DEBUG,
    pool_size=5,
    max_overflow=10,
)

AsyncSessionLocal = async_sessionmaker(
    engine,
    class_=AsyncSession,
    expire_on_commit=False,
)

Base = declarative_base()


async def get_db() -> AsyncSession:
    """Dependency for getting database sessions."""
    async with AsyncSessionLocal() as session:
        try:
            yield session
        finally:
            await session.close()
