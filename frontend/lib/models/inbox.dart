import 'package:freezed_annotation/freezed_annotation.dart';
import 'user.dart';

part 'inbox.freezed.dart';
part 'inbox.g.dart';

/// Message type enumeration for inbox messages
enum MessageType {
  @JsonValue('text')
  text,
  @JsonValue('friend_request')
  friendRequest,
  @JsonValue('friend_accepted')
  friendAccepted,
  @JsonValue('poke')
  poke,
  @JsonValue('event_share')
  eventShare,
  @JsonValue('event_reminder')
  eventReminder,
  @JsonValue('event_update')
  eventUpdate,
  @JsonValue('event_cancelled')
  eventCancelled,
  @JsonValue('reflection_reminder')
  reflectionReminder,
  @JsonValue('streak_milestone')
  streakMilestone,
  @JsonValue('system')
  system,
  @JsonValue('announcement')
  announcement,
}

/// Message priority levels
enum MessagePriority {
  @JsonValue('low')
  low,
  @JsonValue('normal')
  normal,
  @JsonValue('high')
  high,
  @JsonValue('urgent')
  urgent,
}

/// Inbox message model
@freezed
class InboxMessage with _$InboxMessage {
  const InboxMessage._();

  const factory InboxMessage({
    required String id,
    required String userId,
    required MessageType type,
    required String title,
    String? body,
    String? senderId,
    UserProfile? sender,
    @Default(MessagePriority.normal) MessagePriority priority,
    @Default(false) bool isRead,
    @Default(false) bool isArchived,
    @Default(false) bool isDeleted,
    Map<String, dynamic>? data,
    String? actionUrl,
    List<MessageAction>? actions,
    DateTime? createdAt,
    DateTime? readAt,
    DateTime? expiresAt,
  }) = _InboxMessage;

  factory InboxMessage.fromJson(Map<String, dynamic> json) =>
      _$InboxMessageFromJson(json);

  /// Check if this message is actionable (has pending actions)
  bool get isActionable => actions != null && actions!.isNotEmpty;

  /// Check if this message has expired
  bool get isExpired =>
      expiresAt != null && DateTime.now().isAfter(expiresAt!);

  /// Check if this message is visible (not deleted, not expired)
  bool get isVisible => !isDeleted && !isExpired;

  /// Get related entity ID from data (e.g., eventId, friendshipId)
  String? get relatedEntityId {
    if (data == null) return null;
    return data!['eventId'] as String? ??
        data!['friendshipId'] as String? ??
        data!['pokeId'] as String? ??
        data!['shareId'] as String?;
  }
}

/// Action that can be taken on a message
@freezed
class MessageAction with _$MessageAction {
  const factory MessageAction({
    required String id,
    required String label,
    required String actionType,
    Map<String, dynamic>? actionData,
    @Default(false) bool isPrimary,
    @Default(false) bool isDestructive,
  }) = _MessageAction;

  factory MessageAction.fromJson(Map<String, dynamic> json) =>
      _$MessageActionFromJson(json);
}

/// Inbox state for managing the inbox UI
@freezed
class InboxState with _$InboxState {
  const factory InboxState({
    @Default([]) List<InboxMessage> messages,
    @Default(0) int unreadCount,
    @Default(false) bool isLoading,
    @Default(false) bool hasMore,
    String? error,
    InboxFilter? filter,
  }) = _InboxState;

  factory InboxState.fromJson(Map<String, dynamic> json) =>
      _$InboxStateFromJson(json);
}

/// Filter for inbox messages
@freezed
class InboxFilter with _$InboxFilter {
  const factory InboxFilter({
    List<MessageType>? types,
    @Default(false) bool unreadOnly,
    @Default(false) bool archivedOnly,
    DateTime? fromDate,
    DateTime? toDate,
    String? searchQuery,
  }) = _InboxFilter;

  factory InboxFilter.fromJson(Map<String, dynamic> json) =>
      _$InboxFilterFromJson(json);
}

/// Notification settings for different message types
@freezed
class NotificationSettings with _$NotificationSettings {
  const factory NotificationSettings({
    @Default(true) bool friendRequests,
    @Default(true) bool pokes,
    @Default(true) bool eventShares,
    @Default(true) bool eventReminders,
    @Default(true) bool eventUpdates,
    @Default(true) bool reflectionReminders,
    @Default(true) bool streakMilestones,
    @Default(true) bool systemMessages,
    @Default(false) bool announcements,
    @Default(true) bool soundEnabled,
    @Default(true) bool vibrationEnabled,
    @Default('08:00') String quietHoursStart,
    @Default('22:00') String quietHoursEnd,
    @Default(false) bool quietHoursEnabled,
  }) = _NotificationSettings;

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);
}

/// Batch operation result for inbox actions
@freezed
class InboxBatchResult with _$InboxBatchResult {
  const factory InboxBatchResult({
    required int successCount,
    required int failureCount,
    @Default([]) List<String> failedIds,
    String? error,
  }) = _InboxBatchResult;

  factory InboxBatchResult.fromJson(Map<String, dynamic> json) =>
      _$InboxBatchResultFromJson(json);
}
