import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';
part 'event.g.dart';

/// Event status enumeration
enum EventStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('scheduled')
  scheduled,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('partial')
  partial,
  @JsonValue('skipped')
  skipped,
  @JsonValue('cancelled')
  cancelled,
}

/// Event priority levels
enum EventPriority {
  @JsonValue('low')
  low,
  @JsonValue('medium')
  medium,
  @JsonValue('high')
  high,
  @JsonValue('urgent')
  urgent,
}

/// Recurrence frequency for recurring events
enum RecurrenceFrequency {
  @JsonValue('daily')
  daily,
  @JsonValue('weekly')
  weekly,
  @JsonValue('monthly')
  monthly,
  @JsonValue('yearly')
  yearly,
}

/// Main Event model representing a calendar event
@freezed
class Event with _$Event {
  const Event._();

  const factory Event({
    required String id,
    required String userId,
    required String title,
    String? description,
    required DateTime startTime,
    required DateTime endTime,
    @Default(false) bool isAllDay,
    String? location,
    String? locationUrl,
    @Default(EventStatus.scheduled) EventStatus status,
    @Default(EventPriority.medium) EventPriority priority,
    String? color,
    @Default([]) List<String> tags,
    RecurrenceRule? recurrenceRule,
    String? parentEventId,
    @Default([]) List<EventReminder> reminders,
    @Default([]) List<EventAttachment> attachments,
    @Default(false) bool isPrivate,
    String? encryptedData,
    @Default(false) bool isShared,
    @Default([]) List<String> sharedWithUserIds,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(false) bool isSynced,
    int? syncVersion,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  /// Check if the event is currently happening
  bool get isHappeningNow {
    final now = DateTime.now();
    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  /// Check if the event is in the past
  bool get isPast => DateTime.now().isAfter(endTime);

  /// Check if the event is in the future
  bool get isFuture => DateTime.now().isBefore(startTime);

  /// Get the duration of the event
  Duration get duration => endTime.difference(startTime);

  /// Check if this is a recurring event
  bool get isRecurring => recurrenceRule != null;
}

/// Recurrence rule for recurring events
@freezed
class RecurrenceRule with _$RecurrenceRule {
  const RecurrenceRule._();

  const factory RecurrenceRule({
    required RecurrenceFrequency frequency,
    @Default(1) int interval,
    @Default([]) List<int> byWeekDay, // 0 = Monday, 6 = Sunday
    @Default([]) List<int> byMonthDay, // 1-31
    @Default([]) List<int> byMonth, // 1-12
    int? count,
    DateTime? until,
    @Default([]) List<DateTime> exceptions,
  }) = _RecurrenceRule;

  factory RecurrenceRule.fromJson(Map<String, dynamic> json) =>
      _$RecurrenceRuleFromJson(json);

  /// Check if the recurrence has an end condition
  bool get hasEndCondition => count != null || until != null;

  /// Get a human-readable description of the recurrence
  String get description {
    final buffer = StringBuffer('Every ');

    if (interval > 1) {
      buffer.write('$interval ');
    }

    switch (frequency) {
      case RecurrenceFrequency.daily:
        buffer.write(interval == 1 ? 'day' : 'days');
        break;
      case RecurrenceFrequency.weekly:
        buffer.write(interval == 1 ? 'week' : 'weeks');
        break;
      case RecurrenceFrequency.monthly:
        buffer.write(interval == 1 ? 'month' : 'months');
        break;
      case RecurrenceFrequency.yearly:
        buffer.write(interval == 1 ? 'year' : 'years');
        break;
    }

    if (count != null) {
      buffer.write(', $count times');
    } else if (until != null) {
      buffer.write(', until ${until!.toIso8601String().split('T')[0]}');
    }

    return buffer.toString();
  }
}

/// Event reminder configuration
@freezed
class EventReminder with _$EventReminder {
  const factory EventReminder({
    required String id,
    required int minutesBefore,
    @Default('push') String type, // 'push', 'email', 'sms'
    @Default(false) bool isSent,
  }) = _EventReminder;

  factory EventReminder.fromJson(Map<String, dynamic> json) =>
      _$EventReminderFromJson(json);
}

/// Event attachment (files, links, etc.)
@freezed
class EventAttachment with _$EventAttachment {
  const factory EventAttachment({
    required String id,
    required String name,
    required String url,
    String? mimeType,
    int? sizeBytes,
    DateTime? createdAt,
  }) = _EventAttachment;

  factory EventAttachment.fromJson(Map<String, dynamic> json) =>
      _$EventAttachmentFromJson(json);
}

/// Event occurrence for recurring events (a specific instance)
@freezed
class EventOccurrence with _$EventOccurrence {
  const factory EventOccurrence({
    required String eventId,
    required DateTime originalStartTime,
    required DateTime startTime,
    required DateTime endTime,
    @Default(false) bool isCancelled,
    @Default(false) bool isModified,
    Event? modifiedEvent,
  }) = _EventOccurrence;

  factory EventOccurrence.fromJson(Map<String, dynamic> json) =>
      _$EventOccurrenceFromJson(json);
}

/// Event search/filter criteria
@freezed
class EventFilter with _$EventFilter {
  const factory EventFilter({
    DateTime? startDate,
    DateTime? endDate,
    List<EventStatus>? statuses,
    List<EventPriority>? priorities,
    List<String>? tags,
    String? searchQuery,
    @Default(false) bool includeRecurring,
    @Default(false) bool onlyShared,
  }) = _EventFilter;

  factory EventFilter.fromJson(Map<String, dynamic> json) =>
      _$EventFilterFromJson(json);
}
