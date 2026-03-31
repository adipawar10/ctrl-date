"""
Ctrl+Shift+Date - FastAPI Backend
Cross-platform productivity application with intelligent scheduling
"""

from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.core.config import settings
from app.routers import auth, events, calendar_import, sharing, friends, inbox, reflections, ai_suggestions, sync, polls


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Application lifespan handler for startup/shutdown events."""
    # Startup
    print(f"Starting {settings.APP_NAME} v{settings.VERSION}")
    yield
    # Shutdown
    print("Shutting down...")


app = FastAPI(
    title=settings.APP_NAME,
    version=settings.VERSION,
    description="Cross-platform productivity application with intelligent scheduling",
    lifespan=lifespan,
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth.router, prefix="/auth", tags=["Authentication"])
app.include_router(events.router, prefix="/events", tags=["Events"])
app.include_router(calendar_import.router, prefix="/import", tags=["Import"])
app.include_router(sharing.router, prefix="/sharing", tags=["Sharing"])
app.include_router(friends.router, prefix="/friends", tags=["Friends"])
app.include_router(inbox.router, prefix="/inbox", tags=["Inbox"])
app.include_router(reflections.router, prefix="/reflections", tags=["Reflections"])
app.include_router(ai_suggestions.router, prefix="/ai", tags=["AI"])
app.include_router(sync.router, prefix="/sync", tags=["Sync"])
app.include_router(polls.router, prefix="/polls", tags=["Polls"])


@app.get("/health")
async def health_check():
    """Health check endpoint."""
    return {"status": "healthy", "version": settings.VERSION}


@app.get("/")
async def root():
    """Root endpoint."""
    return {
        "app": settings.APP_NAME,
        "version": settings.VERSION,
        "docs": "/docs",
    }
