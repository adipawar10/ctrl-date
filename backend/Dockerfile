# Ctrl+Shift+Date Backend Dockerfile
# Multi-stage build for FastAPI application

# =============================================================================
# Stage 1: Builder
# =============================================================================
FROM python:3.12-slim as builder

WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Create virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt


# =============================================================================
# Stage 2: Production
# =============================================================================
FROM python:3.12-slim as production

WORKDIR /app

# Install runtime dependencies only
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
    curl \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Create non-root user for security
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

# Copy virtual environment from builder
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copy application code
COPY ./app ./app
COPY ./migrations ./migrations

# Set ownership to non-root user
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONPATH=/app \
    PORT=8000

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# Run the application
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]


# =============================================================================
# Stage 3: Development (optional)
# =============================================================================
FROM production as development

USER root

# Install development dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install dev Python packages
RUN pip install --no-cache-dir \
    pytest \
    pytest-asyncio \
    pytest-cov \
    httpx \
    black \
    isort \
    mypy

USER appuser

# Development command with hot reload
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]


# =============================================================================
# Stage 4: Celery Worker
# =============================================================================
FROM production as celery-worker

# Celery worker command
CMD ["celery", "-A", "app.workers.celery_app", "worker", "--loglevel=info", "--concurrency=4"]


# =============================================================================
# Stage 5: Celery Beat (Scheduler)
# =============================================================================
FROM production as celery-beat

# Celery beat command
CMD ["celery", "-A", "app.workers.celery_app", "beat", "--loglevel=info"]
