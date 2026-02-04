-- Ctrl+Shift+Date Initial Database Schema
-- PostgreSQL migration for Supabase
-- Run with: psql -d your_database -f 001_initial_schema.sql

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =============================================================================
-- USERS TABLE
-- =============================================================================
-- Core user table integrated with Supabase Auth
-- Note: Supabase Auth creates auth.users, this is the public profile

CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL UNIQUE,
    display_name TEXT NOT NULL,
    avatar_url TEXT,
    timezone TEXT NOT NULL DEFAULT 'UTC',
    preferences JSONB NOT NULL DEFAULT '{
        "default_event_duration": 60,
        "week_start": "monday",
        "working_hours_start": "09:00",
        "working_hours_end": "17:00",
        "notification_lead_time": 15,
        "preferred_focus_hours": [9, 10, 11, 14, 15]
    }'::jsonb,
    public_key TEXT, -- X25519 public key for E2E encryption
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create updated_at trigger
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Index for email lookups
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);


-- =============================================================================
-- RECURRENCE RULES TABLE
-- =============================================================================
-- RFC 5545 compliant recurrence rules

CREATE TABLE IF NOT EXISTS recurrence_rules (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    frequency TEXT NOT NULL CHECK (frequency IN ('daily', 'weekly', 'monthly', 'yearly')),
    interval INTEGER NOT NULL DEFAULT 1 CHECK (interval >= 1),
    by_weekday INTEGER[], -- 0=Mon, 6=Sun
    by_monthday INTEGER[],
    by_month INTEGER[],
    by_setpos INTEGER[],
    until_date DATE,
    count INTEGER CHECK (count > 0),
    excluded_dates DATE[] NOT NULL DEFAULT '{}',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER update_recurrence_rules_updated_at
    BEFORE UPDATE ON recurrence_rules
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();


-- =============================================================================
-- IMPORT BATCHES TABLE
-- =============================================================================
-- Track CSV/ICS import operations

CREATE TABLE IF NOT EXISTS import_batches (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    filename TEXT NOT NULL,
    file_type TEXT NOT NULL CHECK (file_type IN ('csv', 'ics', 'google', 'apple', 'outlook')),
    total_rows INTEGER NOT NULL DEFAULT 0,
    events_imported INTEGER NOT NULL DEFAULT 0,
    events_skipped INTEGER NOT NULL DEFAULT 0,
    error_log JSONB,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'failed')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_import_batches_user ON import_batches(user_id);
CREATE INDEX IF NOT EXISTS idx_import_batches_status ON import_batches(status);


-- =============================================================================
-- EVENTS TABLE
-- =============================================================================
-- Core events table with recurrence and completion tracking

CREATE TABLE IF NOT EXISTS events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    owner_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    location TEXT,

    -- Timing
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ NOT NULL,
    all_day BOOLEAN NOT NULL DEFAULT FALSE,
    timezone TEXT NOT NULL,

    -- Scheduling constraints
    is_locked BOOLEAN NOT NULL DEFAULT FALSE,
    priority INTEGER NOT NULL DEFAULT 2 CHECK (priority BETWEEN 1 AND 4),

    -- Recurrence
    recurrence_rule_id UUID REFERENCES recurrence_rules(id) ON DELETE SET NULL,
    recurrence_parent_id UUID REFERENCES events(id) ON DELETE CASCADE,
    recurrence_instance_date DATE, -- For materialized recurring instances

    -- Completion tracking
    status TEXT NOT NULL DEFAULT 'scheduled' CHECK (
        status IN ('scheduled', 'completed', 'skipped', 'partial', 'cancelled')
    ),
    completion_notes TEXT,
    completed_at TIMESTAMPTZ,

    -- Import tracking
    import_batch_id UUID REFERENCES import_batches(id) ON DELETE SET NULL,
    external_id TEXT, -- ID from external calendar system

    -- Metadata
    color TEXT,
    tags TEXT[] NOT NULL DEFAULT '{}',

    -- Sync and soft delete
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,
    version INTEGER NOT NULL DEFAULT 1,

    -- Constraints
    CONSTRAINT valid_event_times CHECK (end_time > start_time),
    CONSTRAINT recurrence_instance_requires_parent CHECK (
        (recurrence_instance_date IS NULL) OR (recurrence_parent_id IS NOT NULL)
    )
);

CREATE TRIGGER update_events_updated_at
    BEFORE UPDATE ON events
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Indexes for common queries
CREATE INDEX IF NOT EXISTS idx_events_owner ON events(owner_id);
CREATE INDEX IF NOT EXISTS idx_events_owner_time ON events(owner_id, start_time, end_time) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_events_recurrence_parent ON events(recurrence_parent_id) WHERE recurrence_parent_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_events_status ON events(owner_id, status) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_events_deleted ON events(deleted_at) WHERE deleted_at IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_events_external ON events(external_id) WHERE external_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_events_tags ON events USING GIN(tags);


-- =============================================================================
-- EVENT SHARES TABLE
-- =============================================================================
-- Sharing events with other users

CREATE TABLE IF NOT EXISTS event_shares (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    shared_with_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    shared_by_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    permission TEXT NOT NULL DEFAULT 'view' CHECK (permission IN ('view', 'edit', 'admin')),
    response TEXT NOT NULL DEFAULT 'pending' CHECK (
        response IN ('pending', 'accepted', 'declined', 'tentative')
    ),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    responded_at TIMESTAMPTZ,

    -- Prevent duplicate shares
    UNIQUE(event_id, shared_with_user_id)
);

CREATE INDEX IF NOT EXISTS idx_event_shares_event ON event_shares(event_id);
CREATE INDEX IF NOT EXISTS idx_event_shares_user ON event_shares(shared_with_user_id);
CREATE INDEX IF NOT EXISTS idx_event_shares_pending ON event_shares(shared_with_user_id, response) WHERE response = 'pending';


-- =============================================================================
-- FRIENDSHIPS TABLE
-- =============================================================================
-- User friendship connections

CREATE TABLE IF NOT EXISTS friendships (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    requester_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    addressee_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (
        status IN ('pending', 'accepted', 'blocked')
    ),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    accepted_at TIMESTAMPTZ,

    -- Prevent duplicate friendships
    UNIQUE(requester_id, addressee_id),
    -- Prevent self-friendship
    CHECK (requester_id != addressee_id)
);

CREATE INDEX IF NOT EXISTS idx_friendships_requester ON friendships(requester_id);
CREATE INDEX IF NOT EXISTS idx_friendships_addressee ON friendships(addressee_id);
CREATE INDEX IF NOT EXISTS idx_friendships_status ON friendships(status);

-- View for accepted friendships (bidirectional)
CREATE OR REPLACE VIEW accepted_friends AS
SELECT
    f.id,
    f.requester_id AS user_id,
    f.addressee_id AS friend_id,
    f.accepted_at,
    u.display_name AS friend_display_name,
    u.avatar_url AS friend_avatar_url
FROM friendships f
JOIN users u ON u.id = f.addressee_id
WHERE f.status = 'accepted'
UNION ALL
SELECT
    f.id,
    f.addressee_id AS user_id,
    f.requester_id AS friend_id,
    f.accepted_at,
    u.display_name AS friend_display_name,
    u.avatar_url AS friend_avatar_url
FROM friendships f
JOIN users u ON u.id = f.requester_id
WHERE f.status = 'accepted';


-- =============================================================================
-- INBOX MESSAGES TABLE
-- =============================================================================
-- E2E encrypted messaging

CREATE TABLE IF NOT EXISTS inbox_messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sender_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    recipient_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    message_type TEXT NOT NULL CHECK (
        message_type IN ('text', 'event_share', 'poke', 'system')
    ),

    -- E2E encrypted payload
    ciphertext TEXT NOT NULL,
    ephemeral_public_key TEXT NOT NULL, -- X25519 ephemeral key
    nonce TEXT NOT NULL,

    -- Metadata (not encrypted)
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_inbox_messages_recipient ON inbox_messages(recipient_id, created_at DESC) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS idx_inbox_messages_sender ON inbox_messages(sender_id);
CREATE INDEX IF NOT EXISTS idx_inbox_messages_unread ON inbox_messages(recipient_id) WHERE is_read = FALSE AND deleted_at IS NULL;


-- =============================================================================
-- POKES TABLE
-- =============================================================================
-- Procrastination nudges between friends

CREATE TABLE IF NOT EXISTS pokes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    poker_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    pokee_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    event_id UUID REFERENCES events(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Prevent self-poking
    CHECK (poker_id != pokee_id)
);

CREATE INDEX IF NOT EXISTS idx_pokes_pokee ON pokes(pokee_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_pokes_event ON pokes(event_id) WHERE event_id IS NOT NULL;


-- =============================================================================
-- DAILY REFLECTIONS TABLE
-- =============================================================================
-- End-of-day productivity tracking

CREATE TABLE IF NOT EXISTS daily_reflections (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    reflection_date DATE NOT NULL,

    -- Computed stats
    events_planned INTEGER NOT NULL DEFAULT 0,
    events_completed INTEGER NOT NULL DEFAULT 0,
    events_skipped INTEGER NOT NULL DEFAULT 0,
    events_partial INTEGER NOT NULL DEFAULT 0,

    -- User input
    notes TEXT,
    mood INTEGER CHECK (mood BETWEEN 1 AND 5),

    -- Streak
    is_streak_day BOOLEAN NOT NULL DEFAULT FALSE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- One reflection per day per user
    UNIQUE(user_id, reflection_date)
);

CREATE TRIGGER update_daily_reflections_updated_at
    BEFORE UPDATE ON daily_reflections
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE INDEX IF NOT EXISTS idx_daily_reflections_user_date ON daily_reflections(user_id, reflection_date DESC);


-- =============================================================================
-- STREAKS TABLE
-- =============================================================================
-- Productivity streak tracking

CREATE TABLE IF NOT EXISTS streaks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    streak_type TEXT NOT NULL DEFAULT 'daily_completion' CHECK (
        streak_type IN ('daily_completion', 'reflection', 'custom')
    ),
    current_count INTEGER NOT NULL DEFAULT 0,
    longest_count INTEGER NOT NULL DEFAULT 0,
    last_completed_date DATE,
    completion_threshold DECIMAL(3,2) NOT NULL DEFAULT 0.80 CHECK (
        completion_threshold BETWEEN 0 AND 1
    ),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- One streak type per user
    UNIQUE(user_id, streak_type)
);

CREATE TRIGGER update_streaks_updated_at
    BEFORE UPDATE ON streaks
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();


-- =============================================================================
-- AI SUGGESTIONS TABLE
-- =============================================================================
-- Store AI-generated scheduling suggestions for learning

CREATE TABLE IF NOT EXISTS ai_suggestions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    context_hash TEXT NOT NULL, -- Hash of context for deduplication
    date_range_start DATE NOT NULL,
    date_range_end DATE NOT NULL,
    suggestions JSONB NOT NULL DEFAULT '[]'::jsonb,
    accepted_suggestion_ids TEXT[] DEFAULT '{}',
    rejected_suggestion_ids TEXT[] DEFAULT '{}',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_ai_suggestions_user ON ai_suggestions(user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_ai_suggestions_context ON ai_suggestions(context_hash);


-- =============================================================================
-- DEVICE TOKENS TABLE
-- =============================================================================
-- Push notification device registration

CREATE TABLE IF NOT EXISTS device_tokens (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token TEXT NOT NULL,
    platform TEXT NOT NULL CHECK (platform IN ('ios', 'android', 'web')),
    device_name TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deactivated_at TIMESTAMPTZ,
    deactivation_reason TEXT,

    -- Unique token per user/platform
    UNIQUE(user_id, token)
);

CREATE TRIGGER update_device_tokens_updated_at
    BEFORE UPDATE ON device_tokens
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE INDEX IF NOT EXISTS idx_device_tokens_user ON device_tokens(user_id) WHERE is_active = TRUE;
CREATE INDEX IF NOT EXISTS idx_device_tokens_token ON device_tokens(token);


-- =============================================================================
-- SENT REMINDERS TABLE
-- =============================================================================
-- Track sent reminders to avoid duplicates

CREATE TABLE IF NOT EXISTS sent_reminders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    sent_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- One reminder per event per user
    UNIQUE(event_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_sent_reminders_event ON sent_reminders(event_id);


-- =============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- =============================================================================

-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE recurrence_rules ENABLE ROW LEVEL SECURITY;
ALTER TABLE event_shares ENABLE ROW LEVEL SECURITY;
ALTER TABLE friendships ENABLE ROW LEVEL SECURITY;
ALTER TABLE inbox_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE pokes ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_reflections ENABLE ROW LEVEL SECURITY;
ALTER TABLE streaks ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_suggestions ENABLE ROW LEVEL SECURITY;
ALTER TABLE device_tokens ENABLE ROW LEVEL SECURITY;
ALTER TABLE import_batches ENABLE ROW LEVEL SECURITY;
ALTER TABLE sent_reminders ENABLE ROW LEVEL SECURITY;

-- Users: Can read/update own profile, read others' public info
CREATE POLICY users_select_own ON users FOR SELECT USING (auth.uid() = id);
CREATE POLICY users_select_friends ON users FOR SELECT USING (
    id IN (
        SELECT friend_id FROM accepted_friends WHERE user_id = auth.uid()
    )
);
CREATE POLICY users_update_own ON users FOR UPDATE USING (auth.uid() = id);
CREATE POLICY users_insert_own ON users FOR INSERT WITH CHECK (auth.uid() = id);

-- Events: Owner has full access, shared users have limited access
CREATE POLICY events_owner_all ON events FOR ALL USING (auth.uid() = owner_id);
CREATE POLICY events_shared_select ON events FOR SELECT USING (
    id IN (
        SELECT event_id FROM event_shares
        WHERE shared_with_user_id = auth.uid() AND response = 'accepted'
    )
);
CREATE POLICY events_shared_update ON events FOR UPDATE USING (
    id IN (
        SELECT event_id FROM event_shares
        WHERE shared_with_user_id = auth.uid()
        AND response = 'accepted'
        AND permission IN ('edit', 'admin')
    )
);

-- Recurrence rules: Access via events
CREATE POLICY recurrence_rules_via_events ON recurrence_rules FOR ALL USING (
    id IN (SELECT recurrence_rule_id FROM events WHERE owner_id = auth.uid())
);

-- Event shares: Sharer and recipient have access
CREATE POLICY event_shares_sharer ON event_shares FOR ALL USING (auth.uid() = shared_by_user_id);
CREATE POLICY event_shares_recipient ON event_shares FOR SELECT USING (auth.uid() = shared_with_user_id);
CREATE POLICY event_shares_recipient_update ON event_shares FOR UPDATE USING (auth.uid() = shared_with_user_id);

-- Friendships: Both parties can view, requester can update/delete
CREATE POLICY friendships_view ON friendships FOR SELECT USING (
    auth.uid() IN (requester_id, addressee_id)
);
CREATE POLICY friendships_requester ON friendships FOR INSERT WITH CHECK (auth.uid() = requester_id);
CREATE POLICY friendships_addressee_update ON friendships FOR UPDATE USING (
    auth.uid() = addressee_id AND status = 'pending'
);
CREATE POLICY friendships_delete ON friendships FOR DELETE USING (
    auth.uid() IN (requester_id, addressee_id)
);

-- Inbox messages: Sender and recipient have access
CREATE POLICY inbox_messages_sender ON inbox_messages FOR INSERT WITH CHECK (auth.uid() = sender_id);
CREATE POLICY inbox_messages_recipient ON inbox_messages FOR SELECT USING (auth.uid() = recipient_id);
CREATE POLICY inbox_messages_recipient_update ON inbox_messages FOR UPDATE USING (auth.uid() = recipient_id);

-- Pokes: Poker can send, pokee can view
CREATE POLICY pokes_send ON pokes FOR INSERT WITH CHECK (auth.uid() = poker_id);
CREATE POLICY pokes_view ON pokes FOR SELECT USING (auth.uid() IN (poker_id, pokee_id));

-- Daily reflections: User owns their reflections
CREATE POLICY daily_reflections_own ON daily_reflections FOR ALL USING (auth.uid() = user_id);

-- Streaks: User owns their streaks
CREATE POLICY streaks_own ON streaks FOR ALL USING (auth.uid() = user_id);

-- AI suggestions: User owns their suggestions
CREATE POLICY ai_suggestions_own ON ai_suggestions FOR ALL USING (auth.uid() = user_id);

-- Device tokens: User owns their tokens
CREATE POLICY device_tokens_own ON device_tokens FOR ALL USING (auth.uid() = user_id);

-- Import batches: User owns their batches
CREATE POLICY import_batches_own ON import_batches FOR ALL USING (auth.uid() = user_id);

-- Sent reminders: User owns their reminders
CREATE POLICY sent_reminders_own ON sent_reminders FOR ALL USING (auth.uid() = user_id);


-- =============================================================================
-- FUNCTIONS FOR COMMON OPERATIONS
-- =============================================================================

-- Function to get user's events for a date range
CREATE OR REPLACE FUNCTION get_user_events(
    p_user_id UUID,
    p_start TIMESTAMPTZ,
    p_end TIMESTAMPTZ
)
RETURNS TABLE (
    id UUID,
    title TEXT,
    description TEXT,
    location TEXT,
    start_time TIMESTAMPTZ,
    end_time TIMESTAMPTZ,
    all_day BOOLEAN,
    timezone TEXT,
    is_locked BOOLEAN,
    priority INTEGER,
    status TEXT,
    color TEXT,
    tags TEXT[],
    is_shared BOOLEAN,
    permission TEXT
) AS $$
BEGIN
    RETURN QUERY
    -- Own events
    SELECT
        e.id,
        e.title,
        e.description,
        e.location,
        e.start_time,
        e.end_time,
        e.all_day,
        e.timezone,
        e.is_locked,
        e.priority,
        e.status,
        e.color,
        e.tags,
        FALSE AS is_shared,
        'owner'::TEXT AS permission
    FROM events e
    WHERE e.owner_id = p_user_id
        AND e.deleted_at IS NULL
        AND e.start_time <= p_end
        AND e.end_time >= p_start
    UNION ALL
    -- Shared events
    SELECT
        e.id,
        e.title,
        e.description,
        e.location,
        e.start_time,
        e.end_time,
        e.all_day,
        e.timezone,
        e.is_locked,
        e.priority,
        e.status,
        e.color,
        e.tags,
        TRUE AS is_shared,
        es.permission
    FROM events e
    JOIN event_shares es ON es.event_id = e.id
    WHERE es.shared_with_user_id = p_user_id
        AND es.response = 'accepted'
        AND e.deleted_at IS NULL
        AND e.start_time <= p_end
        AND e.end_time >= p_start
    ORDER BY start_time;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- Function to calculate completion rate for a date
CREATE OR REPLACE FUNCTION calculate_daily_completion(
    p_user_id UUID,
    p_date DATE
)
RETURNS TABLE (
    events_planned INTEGER,
    events_completed INTEGER,
    events_skipped INTEGER,
    events_partial INTEGER,
    completion_rate DECIMAL
) AS $$
DECLARE
    v_planned INTEGER;
    v_completed INTEGER;
    v_skipped INTEGER;
    v_partial INTEGER;
BEGIN
    SELECT
        COUNT(*)::INTEGER,
        COUNT(*) FILTER (WHERE status = 'completed')::INTEGER,
        COUNT(*) FILTER (WHERE status = 'skipped')::INTEGER,
        COUNT(*) FILTER (WHERE status = 'partial')::INTEGER
    INTO v_planned, v_completed, v_skipped, v_partial
    FROM events
    WHERE owner_id = p_user_id
        AND deleted_at IS NULL
        AND DATE(start_time AT TIME ZONE 'UTC') = p_date;

    RETURN QUERY SELECT
        v_planned,
        v_completed,
        v_skipped,
        v_partial,
        CASE
            WHEN v_planned = 0 THEN 0
            ELSE (v_completed::DECIMAL + v_partial::DECIMAL * 0.5) / v_planned::DECIMAL
        END;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- Function to check friendship status
CREATE OR REPLACE FUNCTION check_friendship(
    p_user_id UUID,
    p_other_user_id UUID
)
RETURNS TEXT AS $$
DECLARE
    v_status TEXT;
BEGIN
    SELECT status INTO v_status
    FROM friendships
    WHERE (requester_id = p_user_id AND addressee_id = p_other_user_id)
       OR (requester_id = p_other_user_id AND addressee_id = p_user_id);

    RETURN COALESCE(v_status, 'none');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- =============================================================================
-- TRIGGERS FOR DATA INTEGRITY
-- =============================================================================

-- Auto-create user profile on auth signup
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.users (id, email, display_name)
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'display_name', split_part(NEW.email, '@', 1))
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Only create if not exists
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger WHERE tgname = 'on_auth_user_created'
    ) THEN
        CREATE TRIGGER on_auth_user_created
            AFTER INSERT ON auth.users
            FOR EACH ROW
            EXECUTE FUNCTION handle_new_user();
    END IF;
END $$;


-- Increment version on event update
CREATE OR REPLACE FUNCTION increment_event_version()
RETURNS TRIGGER AS $$
BEGIN
    NEW.version = OLD.version + 1;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER increment_event_version_trigger
    BEFORE UPDATE ON events
    FOR EACH ROW
    WHEN (OLD.* IS DISTINCT FROM NEW.*)
    EXECUTE FUNCTION increment_event_version();


-- =============================================================================
-- INITIAL DATA (optional)
-- =============================================================================

-- You can add initial data here if needed
-- Example: Default streak types, system messages, etc.

COMMENT ON TABLE users IS 'User profiles linked to Supabase Auth';
COMMENT ON TABLE events IS 'Calendar events with completion tracking';
COMMENT ON TABLE recurrence_rules IS 'RFC 5545 compliant recurrence patterns';
COMMENT ON TABLE event_shares IS 'Event sharing between users';
COMMENT ON TABLE friendships IS 'User friendship connections';
COMMENT ON TABLE inbox_messages IS 'E2E encrypted messages';
COMMENT ON TABLE pokes IS 'Procrastination nudges between friends';
COMMENT ON TABLE daily_reflections IS 'Daily productivity reflections';
COMMENT ON TABLE streaks IS 'Productivity streak tracking';
COMMENT ON TABLE ai_suggestions IS 'AI-generated scheduling suggestions';
COMMENT ON TABLE device_tokens IS 'Push notification device tokens';
COMMENT ON TABLE import_batches IS 'Calendar import tracking';
COMMENT ON TABLE sent_reminders IS 'Reminder delivery tracking';
