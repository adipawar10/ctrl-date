import 'package:drift/drift.dart';

/// Events table for storing calendar events
class Events extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().named('user_id')();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get startTime => dateTime().named('start_time')();
  DateTimeColumn get endTime => dateTime().named('end_time')();
  BoolColumn get isAllDay => boolean().named('is_all_day').withDefault(const Constant(false))();
  TextColumn get location => text().nullable()();
  TextColumn get locationUrl => text().nullable().named('location_url')();
  TextColumn get status => text().withDefault(const Constant('scheduled'))();
  TextColumn get priority => text().withDefault(const Constant('medium'))();
  TextColumn get color => text().nullable()();
  TextColumn get tags => text().withDefault(const Constant('[]'))(); // JSON array
  TextColumn get recurrenceRule => text().nullable().named('recurrence_rule')(); // JSON
  TextColumn get parentEventId => text().nullable().named('parent_event_id')();
  TextColumn get reminders => text().withDefault(const Constant('[]'))(); // JSON array
  TextColumn get attachments => text().withDefault(const Constant('[]'))(); // JSON array
  BoolColumn get isPrivate => boolean().named('is_private').withDefault(const Constant(false))();
  TextColumn get encryptedData => text().nullable().named('encrypted_data')();
  BoolColumn get isShared => boolean().named('is_shared').withDefault(const Constant(false))();
  TextColumn get sharedWithUserIds => text().named('shared_with_user_ids').withDefault(const Constant('[]'))(); // JSON array
  DateTimeColumn get createdAt => dateTime().nullable().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().nullable().named('updated_at')();
  BoolColumn get isSynced => boolean().named('is_synced').withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().nullable().named('sync_version')();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (parent_event_id) REFERENCES events(id) ON DELETE SET NULL',
  ];
}

/// Daily reflections table
class DailyReflections extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().named('user_id')();
  DateTimeColumn get date => dateTime()();
  IntColumn get mood => integer().nullable()(); // 1-5
  IntColumn get energy => integer().nullable()(); // 1-5
  IntColumn get productivity => integer().nullable()(); // 1-5
  TextColumn get gratitude => text().nullable()();
  TextColumn get accomplishments => text().nullable()();
  TextColumn get challenges => text().nullable()();
  TextColumn get learnings => text().nullable()();
  TextColumn get tomorrowGoals => text().nullable().named('tomorrow_goals')();
  TextColumn get notes => text().nullable()();
  TextColumn get tags => text().withDefault(const Constant('[]'))(); // JSON array
  BoolColumn get isPrivate => boolean().named('is_private').withDefault(const Constant(false))();
  TextColumn get encryptedData => text().nullable().named('encrypted_data')();
  BoolColumn get isComplete => boolean().named('is_complete').withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().nullable().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().nullable().named('updated_at')();
  BoolColumn get isSynced => boolean().named('is_synced').withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().nullable().named('sync_version')();

  @override
  Set<Column> get primaryKey => {id};
}

/// Friendships table for storing friend relationships
class Friendships extends Table {
  TextColumn get id => text()();
  TextColumn get requesterId => text().named('requester_id')();
  TextColumn get addresseeId => text().named('addressee_id')();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get nickname => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().nullable().named('updated_at')();
  DateTimeColumn get acceptedAt => dateTime().nullable().named('accepted_at')();
  BoolColumn get isFavorite => boolean().named('is_favorite').withDefault(const Constant(false))();
  BoolColumn get isMuted => boolean().named('is_muted').withDefault(const Constant(false))();
  TextColumn get sharedKey => text().nullable().named('shared_key')(); // Encrypted shared key

  @override
  Set<Column> get primaryKey => {id};
}

/// Pokes table for storing poke interactions
class Pokes extends Table {
  TextColumn get id => text()();
  TextColumn get senderId => text().named('sender_id')();
  TextColumn get receiverId => text().named('receiver_id')();
  TextColumn get type => text().withDefault(const Constant('wave'))();
  TextColumn get customMessage => text().nullable().named('custom_message')();
  BoolColumn get isRead => boolean().named('is_read').withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().nullable().named('created_at')();
  DateTimeColumn get readAt => dateTime().nullable().named('read_at')();

  @override
  Set<Column> get primaryKey => {id};
}

/// Event shares table for shared events between friends
class EventShares extends Table {
  TextColumn get id => text()();
  TextColumn get eventId => text().named('event_id')();
  TextColumn get sharedByUserId => text().named('shared_by_user_id')();
  TextColumn get sharedWithUserId => text().named('shared_with_user_id')();
  TextColumn get permission => text().withDefault(const Constant('view'))();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get message => text().nullable()();
  TextColumn get encryptedEventData => text().nullable().named('encrypted_event_data')();
  DateTimeColumn get createdAt => dateTime().nullable().named('created_at')();
  DateTimeColumn get acceptedAt => dateTime().nullable().named('accepted_at')();
  DateTimeColumn get expiresAt => dateTime().nullable().named('expires_at')();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE',
  ];
}

/// Inbox messages table
class InboxMessages extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().named('user_id')();
  TextColumn get type => text()();
  TextColumn get title => text()();
  TextColumn get body => text().nullable()();
  TextColumn get senderId => text().nullable().named('sender_id')();
  TextColumn get priority => text().withDefault(const Constant('normal'))();
  BoolColumn get isRead => boolean().named('is_read').withDefault(const Constant(false))();
  BoolColumn get isArchived => boolean().named('is_archived').withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().named('is_deleted').withDefault(const Constant(false))();
  TextColumn get data => text().nullable()(); // JSON
  TextColumn get actionUrl => text().nullable().named('action_url')();
  TextColumn get actions => text().nullable()(); // JSON array
  DateTimeColumn get createdAt => dateTime().nullable().named('created_at')();
  DateTimeColumn get readAt => dateTime().nullable().named('read_at')();
  DateTimeColumn get expiresAt => dateTime().nullable().named('expires_at')();

  @override
  Set<Column> get primaryKey => {id};
}

/// Streaks table for tracking reflection streaks
class Streaks extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().named('user_id')();
  IntColumn get currentStreak => integer().named('current_streak').withDefault(const Constant(0))();
  IntColumn get longestStreak => integer().named('longest_streak').withDefault(const Constant(0))();
  DateTimeColumn get lastReflectionDate => dateTime().nullable().named('last_reflection_date')();
  DateTimeColumn get streakStartDate => dateTime().nullable().named('streak_start_date')();
  IntColumn get totalReflections => integer().named('total_reflections').withDefault(const Constant(0))();
  TextColumn get milestones => text().withDefault(const Constant('[]'))(); // JSON array
  DateTimeColumn get updatedAt => dateTime().nullable().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}

/// User profiles cache table
class UserProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get displayName => text().named('display_name')();
  TextColumn get avatarUrl => text().nullable().named('avatar_url')();
  BoolColumn get isOnline => boolean().named('is_online').withDefault(const Constant(false))();
  DateTimeColumn get lastSeenAt => dateTime().nullable().named('last_seen_at')();
  DateTimeColumn get cachedAt => dateTime().named('cached_at')();

  @override
  Set<Column> get primaryKey => {id};
}

/// Sync metadata table for tracking sync state
class SyncMetadata extends Table {
  TextColumn get tableName => text().named('table_name')();
  DateTimeColumn get lastSyncAt => dateTime().nullable().named('last_sync_at')();
  IntColumn get lastSyncVersion => integer().nullable().named('last_sync_version')();
  TextColumn get syncCursor => text().nullable().named('sync_cursor')();

  @override
  Set<Column> get primaryKey => {tableName};
}

/// Pending sync operations table
class PendingSyncOperations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tableName => text().named('table_name')();
  TextColumn get recordId => text().named('record_id')();
  TextColumn get operation => text()(); // 'insert', 'update', 'delete'
  TextColumn get data => text().nullable()(); // JSON
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  IntColumn get retryCount => integer().named('retry_count').withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable().named('last_error')();
}
