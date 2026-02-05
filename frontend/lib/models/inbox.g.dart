// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbox.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InboxMessageImpl _$$InboxMessageImplFromJson(Map<String, dynamic> json) =>
    _$InboxMessageImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$MessageTypeEnumMap, json['type']),
      title: json['title'] as String,
      body: json['body'] as String?,
      senderId: json['senderId'] as String?,
      sender: json['sender'] == null
          ? null
          : UserProfile.fromJson(json['sender'] as Map<String, dynamic>),
      priority:
          $enumDecodeNullable(_$MessagePriorityEnumMap, json['priority']) ??
              MessagePriority.normal,
      isRead: json['isRead'] as bool? ?? false,
      isArchived: json['isArchived'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
      data: json['data'] as Map<String, dynamic>?,
      actionUrl: json['actionUrl'] as String?,
      actions: (json['actions'] as List<dynamic>?)
          ?.map((e) => MessageAction.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      readAt: json['readAt'] == null
          ? null
          : DateTime.parse(json['readAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$$InboxMessageImplToJson(_$InboxMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'title': instance.title,
      'body': instance.body,
      'senderId': instance.senderId,
      'sender': instance.sender,
      'priority': _$MessagePriorityEnumMap[instance.priority]!,
      'isRead': instance.isRead,
      'isArchived': instance.isArchived,
      'isDeleted': instance.isDeleted,
      'data': instance.data,
      'actionUrl': instance.actionUrl,
      'actions': instance.actions,
      'createdAt': instance.createdAt?.toIso8601String(),
      'readAt': instance.readAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };

const _$MessageTypeEnumMap = {
  MessageType.friendRequest: 'friend_request',
  MessageType.friendAccepted: 'friend_accepted',
  MessageType.poke: 'poke',
  MessageType.eventShare: 'event_share',
  MessageType.eventReminder: 'event_reminder',
  MessageType.eventUpdate: 'event_update',
  MessageType.eventCancelled: 'event_cancelled',
  MessageType.reflectionReminder: 'reflection_reminder',
  MessageType.streakMilestone: 'streak_milestone',
  MessageType.system: 'system',
  MessageType.announcement: 'announcement',
};

const _$MessagePriorityEnumMap = {
  MessagePriority.low: 'low',
  MessagePriority.normal: 'normal',
  MessagePriority.high: 'high',
  MessagePriority.urgent: 'urgent',
};

_$MessageActionImpl _$$MessageActionImplFromJson(Map<String, dynamic> json) =>
    _$MessageActionImpl(
      id: json['id'] as String,
      label: json['label'] as String,
      actionType: json['actionType'] as String,
      actionData: json['actionData'] as Map<String, dynamic>?,
      isPrimary: json['isPrimary'] as bool? ?? false,
      isDestructive: json['isDestructive'] as bool? ?? false,
    );

Map<String, dynamic> _$$MessageActionImplToJson(_$MessageActionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'actionType': instance.actionType,
      'actionData': instance.actionData,
      'isPrimary': instance.isPrimary,
      'isDestructive': instance.isDestructive,
    };

_$InboxStateImpl _$$InboxStateImplFromJson(Map<String, dynamic> json) =>
    _$InboxStateImpl(
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => InboxMessage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      isLoading: json['isLoading'] as bool? ?? false,
      hasMore: json['hasMore'] as bool? ?? false,
      error: json['error'] as String?,
      filter: json['filter'] == null
          ? null
          : InboxFilter.fromJson(json['filter'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$InboxStateImplToJson(_$InboxStateImpl instance) =>
    <String, dynamic>{
      'messages': instance.messages,
      'unreadCount': instance.unreadCount,
      'isLoading': instance.isLoading,
      'hasMore': instance.hasMore,
      'error': instance.error,
      'filter': instance.filter,
    };

_$InboxFilterImpl _$$InboxFilterImplFromJson(Map<String, dynamic> json) =>
    _$InboxFilterImpl(
      types: (json['types'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$MessageTypeEnumMap, e))
          .toList(),
      unreadOnly: json['unreadOnly'] as bool? ?? false,
      archivedOnly: json['archivedOnly'] as bool? ?? false,
      fromDate: json['fromDate'] == null
          ? null
          : DateTime.parse(json['fromDate'] as String),
      toDate: json['toDate'] == null
          ? null
          : DateTime.parse(json['toDate'] as String),
      searchQuery: json['searchQuery'] as String?,
    );

Map<String, dynamic> _$$InboxFilterImplToJson(_$InboxFilterImpl instance) =>
    <String, dynamic>{
      'types': instance.types?.map((e) => _$MessageTypeEnumMap[e]!).toList(),
      'unreadOnly': instance.unreadOnly,
      'archivedOnly': instance.archivedOnly,
      'fromDate': instance.fromDate?.toIso8601String(),
      'toDate': instance.toDate?.toIso8601String(),
      'searchQuery': instance.searchQuery,
    };

_$NotificationSettingsImpl _$$NotificationSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationSettingsImpl(
      friendRequests: json['friendRequests'] as bool? ?? true,
      pokes: json['pokes'] as bool? ?? true,
      eventShares: json['eventShares'] as bool? ?? true,
      eventReminders: json['eventReminders'] as bool? ?? true,
      eventUpdates: json['eventUpdates'] as bool? ?? true,
      reflectionReminders: json['reflectionReminders'] as bool? ?? true,
      streakMilestones: json['streakMilestones'] as bool? ?? true,
      systemMessages: json['systemMessages'] as bool? ?? true,
      announcements: json['announcements'] as bool? ?? false,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
      quietHoursStart: json['quietHoursStart'] as String? ?? '08:00',
      quietHoursEnd: json['quietHoursEnd'] as String? ?? '22:00',
      quietHoursEnabled: json['quietHoursEnabled'] as bool? ?? false,
    );

Map<String, dynamic> _$$NotificationSettingsImplToJson(
        _$NotificationSettingsImpl instance) =>
    <String, dynamic>{
      'friendRequests': instance.friendRequests,
      'pokes': instance.pokes,
      'eventShares': instance.eventShares,
      'eventReminders': instance.eventReminders,
      'eventUpdates': instance.eventUpdates,
      'reflectionReminders': instance.reflectionReminders,
      'streakMilestones': instance.streakMilestones,
      'systemMessages': instance.systemMessages,
      'announcements': instance.announcements,
      'soundEnabled': instance.soundEnabled,
      'vibrationEnabled': instance.vibrationEnabled,
      'quietHoursStart': instance.quietHoursStart,
      'quietHoursEnd': instance.quietHoursEnd,
      'quietHoursEnabled': instance.quietHoursEnabled,
    };

_$InboxBatchResultImpl _$$InboxBatchResultImplFromJson(
        Map<String, dynamic> json) =>
    _$InboxBatchResultImpl(
      successCount: (json['successCount'] as num).toInt(),
      failureCount: (json['failureCount'] as num).toInt(),
      failedIds: (json['failedIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      error: json['error'] as String?,
    );

Map<String, dynamic> _$$InboxBatchResultImplToJson(
        _$InboxBatchResultImpl instance) =>
    <String, dynamic>{
      'successCount': instance.successCount,
      'failureCount': instance.failureCount,
      'failedIds': instance.failedIds,
      'error': instance.error,
    };
