import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/inbox.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';
import 'events_provider.dart';
import '../models/user.dart';

/// Provider for inbox messages
final inboxProvider =
    StateNotifierProvider<InboxNotifier, InboxState>((ref) {
  return InboxNotifier(ref);
});

/// Provider for unread message count
final unreadMessageCountProvider = Provider<int>((ref) {
  final inboxState = ref.watch(inboxProvider);
  return inboxState.unreadCount;
});

/// Provider for messages by type
final messagesByTypeProvider =
    Provider.family<List<InboxMessage>, MessageType>((ref, type) {
  final inboxState = ref.watch(inboxProvider);
  return inboxState.messages.where((m) => m.type == type).toList();
});

/// Provider for unread messages
final unreadMessagesProvider = Provider<List<InboxMessage>>((ref) {
  final inboxState = ref.watch(inboxProvider);
  return inboxState.messages.where((m) => !m.isRead).toList();
});

/// Provider for archived messages
final archivedMessagesProvider = Provider<List<InboxMessage>>((ref) {
  final inboxState = ref.watch(inboxProvider);
  return inboxState.messages.where((m) => m.isArchived).toList();
});

/// Provider for actionable messages (messages with pending actions)
final actionableMessagesProvider = Provider<List<InboxMessage>>((ref) {
  final inboxState = ref.watch(inboxProvider);
  return inboxState.messages.where((m) => m.isActionable && !m.isRead).toList();
});

/// Notifier for managing inbox state
class InboxNotifier extends StateNotifier<InboxState> {
  final Ref _ref;
  RealtimeChannel? _realtimeChannel;
  Timer? _refreshTimer;

  static const int _pageSize = 20;

  InboxNotifier(this._ref) : super(const InboxState(isLoading: true)) {
    _loadMessages();
    _subscribeToRealtimeUpdates();
    _startPeriodicRefresh();
  }

  ApiService get _api => _ref.read(apiServiceProvider);
  NotificationService get _notificationService => NotificationService.instance;

  bool _initialLoadDone = false;

  InboxMessage _fromBackendMessage(Map<String, dynamic> json) {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id ?? '';
    final senderId = (json['sender_id'] ?? '') as String;
    final recipientId = (json['recipient_id'] ?? currentUserId) as String;
    final rawType = (json['message_type'] ?? 'system').toString();

    MessageType type;
    switch (rawType) {
      case 'text':
        type = MessageType.text;
        break;
      case 'event_share':
        type = MessageType.eventShare;
        break;
      case 'poke':
        type = MessageType.poke;
        break;
      case 'friend_request':
        type = MessageType.friendRequest;
        break;
      case 'friend_accepted':
        type = MessageType.friendAccepted;
        break;
      default:
        type = MessageType.system;
    }

    final senderName = (json['sender_display_name'] ?? 'Unknown').toString();
    final recipientName =
        (json['recipient_display_name'] ?? 'Unknown').toString();
    final body = (json['ciphertext'] ?? '').toString();

    final isMine = senderId == currentUserId;
    final counterpartId = isMine ? recipientId : senderId;
    final counterpartName = isMine ? recipientName : senderName;
    final counterpartAvatar = isMine
        ? json['recipient_avatar_url'] as String?
        : json['sender_avatar_url'] as String?;

    return InboxMessage(
      id: (json['id'] ?? '').toString(),
      userId: currentUserId,
      type: type,
      title:
          rawType == 'text' ? counterpartName : rawType.replaceAll('_', ' '),
      body: body,
      senderId: senderId,
      sender: UserProfile(
        id: counterpartId,
        displayName: counterpartName,
        avatarUrl: counterpartAvatar,
      ),
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.tryParse((json['created_at'] ?? '').toString()),
      data: {
        'recipientId': recipientId,
        'counterpartId': counterpartId,
        'counterpartName': counterpartName,
      },
    );
  }


  Future<void> _loadMessages({bool refresh = false}) async {
    if (_initialLoadDone && !refresh && state.isLoading) return;
    _initialLoadDone = true;

    try {
      state = state.copyWith(isLoading: true, error: null);

      final queryParams = <String, String>{
        'page_size': _pageSize.toString(),
      };

      if (state.filter != null) {
        if (state.filter!.unreadOnly) {
          queryParams['unread_only'] = 'true';
        }
        if (state.filter!.archivedOnly) {
          queryParams['archived_only'] = 'true';
        }
        if (state.filter!.types != null && state.filter!.types!.isNotEmpty) {
          queryParams['types'] = state.filter!.types!.map((t) => t.name).join(',');
        }
      }

      final response = await _api.get<Map<String, dynamic>>(
        '/inbox',
        queryParams: queryParams,
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final messagesJson = data['messages'] as List? ?? [];
        final messages = messagesJson
            .map((json) => _fromBackendMessage(json as Map<String, dynamic>))
            .toList();

        state = state.copyWith(
          messages: messages,
          unreadCount: messages.where((m) => !m.isRead).length,
          hasMore: messages.length >= _pageSize,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.error?.message ?? 'Failed to load messages',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    try {
      state = state.copyWith(isLoading: true);

      final offset = state.messages.length;
      final response = await _api.get<Map<String, dynamic>>(
        '/inbox',
        queryParams: {
          'page_size': _pageSize.toString(),
          'offset': offset.toString(),
        },
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final messagesJson = data['messages'] as List? ?? [];
        final newMessages = messagesJson
            .map((json) => _fromBackendMessage(json as Map<String, dynamic>))
            .toList();

        state = state.copyWith(
          messages: [...state.messages, ...newMessages],
          hasMore: newMessages.length >= _pageSize,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void _subscribeToRealtimeUpdates() {
    _realtimeChannel = Supabase.instance.client
        .channel('inbox')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'inbox_messages',
          callback: (payload) {
            _handleNewMessage(payload.newRecord);
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'inbox_messages',
          callback: (payload) {
            _handleMessageUpdate(payload.newRecord);
          },
        )
        .subscribe();
  }

  void _handleNewMessage(Map<String, dynamic> messageData) {
    final message = _fromBackendMessage(messageData);

    // Add to state
    state = state.copyWith(
      messages: [message, ...state.messages],
      unreadCount: state.unreadCount + 1,
    );

    // Show notification
    _notificationService.showInboxNotification(message);
  }

  void _handleMessageUpdate(Map<String, dynamic> messageData) {
    final updatedMessage = _fromBackendMessage(messageData);

    final updatedMessages = state.messages.map((m) {
      if (m.id == updatedMessage.id) {
        return updatedMessage;
      }
      return m;
    }).toList();

    // Recalculate unread count
    final unreadCount = updatedMessages.where((m) => !m.isRead).length;

    state = state.copyWith(
      messages: updatedMessages,
      unreadCount: unreadCount,
    );
  }

  void _startPeriodicRefresh() {
    _refreshTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _loadMessages(refresh: true),
    );
  }

  /// Mark a message as read
  Future<void> markAsRead(String messageId) async {
    try {
      await _api.put('/inbox/$messageId/read');

      final updatedMessages = state.messages.map((m) {
        if (m.id == messageId) {
          return m.copyWith(
            isRead: true,
            readAt: DateTime.now(),
          );
        }
        return m;
      }).toList();

      state = state.copyWith(
        messages: updatedMessages,
        unreadCount: state.unreadCount > 0 ? state.unreadCount - 1 : 0,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Mark all messages as read
  Future<void> markAllAsRead() async {
    try {
      await _api.post('/inbox/read-all');

      final updatedMessages = state.messages.map((m) {
        if (!m.isRead) {
          return m.copyWith(
            isRead: true,
            readAt: DateTime.now(),
          );
        }
        return m;
      }).toList();

      state = state.copyWith(
        messages: updatedMessages,
        unreadCount: 0,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Archive a message
  Future<void> archiveMessage(String messageId) async {
    try {
      final updatedMessages = state.messages.map((m) {
        if (m.id == messageId) {
          return m.copyWith(isArchived: true);
        }
        return m;
      }).toList();

      state = state.copyWith(messages: updatedMessages);
    } catch (e) {
      rethrow;
    }
  }

  /// Unarchive a message
  Future<void> unarchiveMessage(String messageId) async {
    try {
      final updatedMessages = state.messages.map((m) {
        if (m.id == messageId) {
          return m.copyWith(isArchived: false);
        }
        return m;
      }).toList();

      state = state.copyWith(messages: updatedMessages);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a message
  Future<void> deleteMessage(String messageId) async {
    try {
      await _api.delete('/inbox/$messageId');

      final message = state.messages.firstWhere((m) => m.id == messageId);
      final updatedMessages =
          state.messages.where((m) => m.id != messageId).toList();

      state = state.copyWith(
        messages: updatedMessages,
        unreadCount: !message.isRead && state.unreadCount > 0
            ? state.unreadCount - 1
            : state.unreadCount,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Execute an action on a message
  Future<void> executeAction(String messageId, MessageAction action) async {
    try {
      await _api.post(
        '/inbox/$messageId/actions/${action.id}',
        body: action.actionData,
      );

      // Refresh to get updated state
      await _loadMessages(refresh: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Batch archive messages
  Future<InboxBatchResult> archiveMessages(List<String> messageIds) async {
    try {
      final response = await _api.post<Map<String, dynamic>>(
        '/inbox/batch/archive',
        body: {'message_ids': messageIds},
      );

      if (response.isSuccess && response.data != null) {
        await _loadMessages(refresh: true);
        return InboxBatchResult.fromJson(response.data!);
      }

      return InboxBatchResult(
        successCount: 0,
        failureCount: messageIds.length,
        error: response.error?.message,
      );
    } catch (e) {
      return InboxBatchResult(
        successCount: 0,
        failureCount: messageIds.length,
        error: e.toString(),
      );
    }
  }

  /// Batch delete messages
  Future<InboxBatchResult> deleteMessages(List<String> messageIds) async {
    try {
      final response = await _api.post<Map<String, dynamic>>(
        '/inbox/batch/delete',
        body: {'message_ids': messageIds},
      );

      if (response.isSuccess && response.data != null) {
        await _loadMessages(refresh: true);
        return InboxBatchResult.fromJson(response.data!);
      }

      return InboxBatchResult(
        successCount: 0,
        failureCount: messageIds.length,
        error: response.error?.message,
      );
    } catch (e) {
      return InboxBatchResult(
        successCount: 0,
        failureCount: messageIds.length,
        error: e.toString(),
      );
    }
  }

  /// Set filter
  void setFilter(InboxFilter? filter) {
    state = state.copyWith(filter: filter);
    _loadMessages(refresh: true);
  }

  /// Clear filter
  void clearFilter() {
    state = state.copyWith(filter: null);
    _loadMessages(refresh: true);
  }

  /// Refresh inbox
  Future<void> refresh() async {
    await _loadMessages(refresh: true);
  }

  @override
  void dispose() {
    _realtimeChannel?.unsubscribe();
    _refreshTimer?.cancel();
    super.dispose();
  }
}

/// Provider for inbox actions
final inboxActionsProvider = Provider<InboxActions>((ref) {
  return InboxActions(ref);
});

/// Class containing inbox actions
class InboxActions {
  final Ref _ref;

  InboxActions(this._ref);

  InboxNotifier get _inboxNotifier => _ref.read(inboxProvider.notifier);

  Future<void> markAsRead(String messageId) =>
      _inboxNotifier.markAsRead(messageId);

  Future<void> markAllAsRead() => _inboxNotifier.markAllAsRead();

  Future<void> archive(String messageId) =>
      _inboxNotifier.archiveMessage(messageId);

  Future<void> unarchive(String messageId) =>
      _inboxNotifier.unarchiveMessage(messageId);

  Future<void> delete(String messageId) =>
      _inboxNotifier.deleteMessage(messageId);

  Future<void> executeAction(String messageId, MessageAction action) =>
      _inboxNotifier.executeAction(messageId, action);

  Future<InboxBatchResult> archiveMultiple(List<String> messageIds) =>
      _inboxNotifier.archiveMessages(messageIds);

  Future<InboxBatchResult> deleteMultiple(List<String> messageIds) =>
      _inboxNotifier.deleteMessages(messageIds);

  void setFilter(InboxFilter filter) => _inboxNotifier.setFilter(filter);

  void clearFilter() => _inboxNotifier.clearFilter();

  Future<void> refresh() => _inboxNotifier.refresh();

  Future<void> loadMore() => _inboxNotifier.loadMore();
}

/// Provider for notification settings
final notificationSettingsProvider =
    StateNotifierProvider<NotificationSettingsNotifier, NotificationSettings>(
        (ref) {
  return NotificationSettingsNotifier(ref);
});

/// Notifier for managing notification settings
class NotificationSettingsNotifier extends StateNotifier<NotificationSettings> {
  final Ref _ref;

  NotificationSettingsNotifier(this._ref)
      : super(const NotificationSettings()) {
    _loadSettings();
  }

  NotificationService get _notificationService => NotificationService.instance;

  Future<void> _loadSettings() async {
    state = _notificationService.settings;
  }

  Future<void> updateFriendRequests(bool enabled) async {
    state = state.copyWith(friendRequests: enabled);
    await _saveSettings();
  }

  Future<void> updatePokes(bool enabled) async {
    state = state.copyWith(pokes: enabled);
    await _saveSettings();
  }

  Future<void> updateEventShares(bool enabled) async {
    state = state.copyWith(eventShares: enabled);
    await _saveSettings();
  }

  Future<void> updateEventReminders(bool enabled) async {
    state = state.copyWith(eventReminders: enabled);
    await _saveSettings();
  }

  Future<void> updateEventUpdates(bool enabled) async {
    state = state.copyWith(eventUpdates: enabled);
    await _saveSettings();
  }

  Future<void> updateReflectionReminders(bool enabled) async {
    state = state.copyWith(reflectionReminders: enabled);
    await _saveSettings();
  }

  Future<void> updateStreakMilestones(bool enabled) async {
    state = state.copyWith(streakMilestones: enabled);
    await _saveSettings();
  }

  Future<void> updateSystemMessages(bool enabled) async {
    state = state.copyWith(systemMessages: enabled);
    await _saveSettings();
  }

  Future<void> updateAnnouncements(bool enabled) async {
    state = state.copyWith(announcements: enabled);
    await _saveSettings();
  }

  Future<void> updateSoundEnabled(bool enabled) async {
    state = state.copyWith(soundEnabled: enabled);
    await _saveSettings();
  }

  Future<void> updateVibrationEnabled(bool enabled) async {
    state = state.copyWith(vibrationEnabled: enabled);
    await _saveSettings();
  }

  Future<void> updateQuietHours(
    bool enabled, {
    String? start,
    String? end,
  }) async {
    state = state.copyWith(
      quietHoursEnabled: enabled,
      quietHoursStart: start ?? state.quietHoursStart,
      quietHoursEnd: end ?? state.quietHoursEnd,
    );
    await _saveSettings();
  }

  Future<void> _saveSettings() async {
    await _notificationService.updateSettings(state);
  }
}
