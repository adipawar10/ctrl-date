# Ctrl+Shift+Date

A cross-platform productivity application that combines calendar-first planning with intelligent scheduling assistance, daily reflection, and lightweight collaboration.

## Overview

Ctrl+Shift+Date helps users plan their days and weeks, balance fixed commitments with flexible tasks, and improve productivity over time. The app runs on iOS, Android, and macOS with full offline support.

### Key Features

- **Smart Calendar** - Daily, weekly, monthly, and agenda views with conflict detection
- **Event Locking** - Mark important events as "locked" to prevent AI from suggesting changes
- **Recurring Events** - Full RFC 5545 support for complex recurrence patterns
- **AI Scheduling** - Get intelligent suggestions to optimize your schedule
- **Daily Reflection** - Track completion rates and build productivity streaks
- **Friends & Collaboration** - Share events and send "pokes" to friends who are procrastinating
- **Encrypted Inbox** - End-to-end encrypted messaging (server never sees plaintext)
- **CSV Import** - Import events from other calendars with undo support
- **Offline-First** - Works without internet, syncs when connected

### Design Philosophy

The app uses a **minimalist black and white design**. Color is reserved exclusively for semantic meaning:

- Priority levels (green → red)
- Completion states
- Conflict warnings
- Streak indicators

## Tech Stack

| Layer | Technology |
|-------|------------|
| Mobile/Desktop | Flutter (Dart) |
| Backend API | FastAPI (Python) |
| Database | PostgreSQL (Supabase) |
| Local Storage | Drift (SQLite) |
| Background Jobs | Celery + Redis |
| Authentication | Supabase Auth |
| Realtime | Supabase Realtime |
| AI | Claude API / OpenAI |
| Push Notifications | APNS (iOS) / FCM (Android) |

## Project Structure

```
ctrl-shift-date/
├── backend/                 # FastAPI Python backend
│   ├── app/
│   │   ├── routers/        # API endpoints
│   │   ├── models/         # Pydantic models
│   │   ├── services/       # Business logic
│   │   ├── workers/        # Celery background tasks
│   │   └── core/           # Config, database, security
│   ├── migrations/         # PostgreSQL migrations
│   ├── requirements.txt
│   └── Dockerfile
│
├── frontend/               # Flutter application
│   ├── lib/
│   │   ├── screens/       # UI screens
│   │   ├── widgets/       # Reusable components
│   │   ├── providers/     # Riverpod state management
│   │   ├── services/      # API, auth, sync, encryption
│   │   ├── database/      # Drift local database
│   │   ├── models/        # Data models
│   │   └── utils/         # Constants, extensions
│   ├── pubspec.yaml
│   └── Dockerfile
│
└── docker-compose.yml      # Full stack orchestration
```

## Setup

### Prerequisites

- Python 3.11+
- Flutter 3.16+
- Docker & Docker Compose (optional)
- Supabase account
- Redis (for background jobs)

### Environment Variables

Create `backend/.env` based on the example:

```bash
cp backend/.env.example backend/.env
```

Required variables:

```env
# Supabase
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
DATABASE_URL=postgresql://user:pass@host:5432/postgres

# Authentication
JWT_SECRET=your-supabase-jwt-secret

# Redis
REDIS_URL=redis://localhost:6379/0

# AI (at least one required for suggestions)
ANTHROPIC_API_KEY=sk-ant-...
# or
OPENAI_API_KEY=sk-...
```

### Database Setup

Run the migration against your Supabase database:

```bash
psql $DATABASE_URL < backend/migrations/001_initial_schema.sql
```

### Backend Setup

```bash
cd backend

# Create virtual environment (recommended)
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run the server
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

The API will be available at `http://localhost:8000`. View docs at `/docs`.

### Frontend Setup

```bash
cd frontend

# Install dependencies
flutter pub get

# Generate code (freezed, drift, riverpod)
dart run build_runner build --delete-conflicting-outputs

# Run on your device/simulator
flutter run
```

### Background Workers (Celery)

```bash
cd backend

# Start worker
celery -A app.workers.celery_app worker -l info

# Start scheduler (for periodic tasks)
celery -A app.workers.celery_app beat -l info
```

### Docker Setup (Full Stack)

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

## API Overview

| Endpoint | Description |
|----------|-------------|
| `POST /auth/register` | Register new user |
| `POST /auth/login` | Login |
| `GET /events` | List events in date range |
| `POST /events` | Create event |
| `POST /events/{id}/complete` | Mark event completion |
| `GET /friends` | List friends |
| `POST /friends/{id}/poke` | Send poke |
| `GET /inbox` | List encrypted messages |
| `POST /inbox` | Send encrypted message |
| `POST /reflections/{date}` | Create daily reflection |
| `POST /ai/suggestions` | Get AI scheduling suggestions |
| `POST /sync` | Bidirectional offline sync |

Full API documentation available at `/docs` when running the backend.

## Architecture Highlights

### Offline-First Sync

All data is stored locally in SQLite (Drift) and syncs to the server when online. Conflicts are resolved using version numbers with last-write-wins semantics.

### Event Locking

Events marked as "locked" are hard constraints. The AI will never suggest moving them, and creating overlapping locked events is blocked with a 409 error.

### E2E Encryption

Inbox messages use X25519 key exchange with AES-256-GCM encryption. The server stores only ciphertext and cannot read message contents.

### AI Guardrails

AI suggestions go through post-processing validation to ensure:

- Locked events are never modified
- Suggestions don't overlap with locked events
- Times respect user's working hours

## Development

### Running Tests

```bash
# Backend
cd backend
pytest

# Frontend
cd frontend
flutter test
```

### Code Generation (Flutter)

After modifying freezed models or Drift tables:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## License

MIT
