// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventImpl _$$EventImplFromJson(Map<String, dynamic> json) => _$EventImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      isAllDay: json['isAllDay'] as bool? ?? false,
      location: json['location'] as String?,
      locationUrl: json['locationUrl'] as String?,
      status: $enumDecodeNullable(_$EventStatusEnumMap, json['status']) ??
          EventStatus.scheduled,
      priority: $enumDecodeNullable(_$EventPriorityEnumMap, json['priority']) ??
          EventPriority.medium,
      color: json['color'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      recurrenceRule: json['recurrenceRule'] == null
          ? null
          : RecurrenceRule.fromJson(
              json['recurrenceRule'] as Map<String, dynamic>),
      parentEventId: json['parentEventId'] as String?,
      reminders: (json['reminders'] as List<dynamic>?)
              ?.map((e) => EventReminder.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => EventAttachment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isPrivate: json['isPrivate'] as bool? ?? false,
      encryptedData: json['encryptedData'] as String?,
      isShared: json['isShared'] as bool? ?? false,
      sharedWithUserIds: (json['sharedWithUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      isSynced: json['isSynced'] as bool? ?? false,
      syncVersion: (json['syncVersion'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$EventImplToJson(_$EventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'isAllDay': instance.isAllDay,
      'location': instance.location,
      'locationUrl': instance.locationUrl,
      'status': _$EventStatusEnumMap[instance.status]!,
      'priority': _$EventPriorityEnumMap[instance.priority]!,
      'color': instance.color,
      'tags': instance.tags,
      'recurrenceRule': instance.recurrenceRule,
      'parentEventId': instance.parentEventId,
      'reminders': instance.reminders,
      'attachments': instance.attachments,
      'isPrivate': instance.isPrivate,
      'encryptedData': instance.encryptedData,
      'isShared': instance.isShared,
      'sharedWithUserIds': instance.sharedWithUserIds,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'isSynced': instance.isSynced,
      'syncVersion': instance.syncVersion,
    };

const _$EventStatusEnumMap = {
  EventStatus.draft: 'draft',
  EventStatus.scheduled: 'scheduled',
  EventStatus.inProgress: 'in_progress',
  EventStatus.completed: 'completed',
  EventStatus.cancelled: 'cancelled',
};

const _$EventPriorityEnumMap = {
  EventPriority.low: 'low',
  EventPriority.medium: 'medium',
  EventPriority.high: 'high',
  EventPriority.urgent: 'urgent',
};

_$RecurrenceRuleImpl _$$RecurrenceRuleImplFromJson(Map<String, dynamic> json) =>
    _$RecurrenceRuleImpl(
      frequency: $enumDecode(_$RecurrenceFrequencyEnumMap, json['frequency']),
      interval: (json['interval'] as num?)?.toInt() ?? 1,
      byWeekDay: (json['byWeekDay'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      byMonthDay: (json['byMonthDay'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      byMonth: (json['byMonth'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      count: (json['count'] as num?)?.toInt(),
      until: json['until'] == null
          ? null
          : DateTime.parse(json['until'] as String),
      exceptions: (json['exceptions'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e as String))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$RecurrenceRuleImplToJson(
        _$RecurrenceRuleImpl instance) =>
    <String, dynamic>{
      'frequency': _$RecurrenceFrequencyEnumMap[instance.frequency]!,
      'interval': instance.interval,
      'byWeekDay': instance.byWeekDay,
      'byMonthDay': instance.byMonthDay,
      'byMonth': instance.byMonth,
      'count': instance.count,
      'until': instance.until?.toIso8601String(),
      'exceptions':
          instance.exceptions.map((e) => e.toIso8601String()).toList(),
    };

const _$RecurrenceFrequencyEnumMap = {
  RecurrenceFrequency.daily: 'daily',
  RecurrenceFrequency.weekly: 'weekly',
  RecurrenceFrequency.monthly: 'monthly',
  RecurrenceFrequency.yearly: 'yearly',
};

_$EventReminderImpl _$$EventReminderImplFromJson(Map<String, dynamic> json) =>
    _$EventReminderImpl(
      id: json['id'] as String,
      minutesBefore: (json['minutesBefore'] as num).toInt(),
      type: json['type'] as String? ?? 'push',
      isSent: json['isSent'] as bool? ?? false,
    );

Map<String, dynamic> _$$EventReminderImplToJson(_$EventReminderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'minutesBefore': instance.minutesBefore,
      'type': instance.type,
      'isSent': instance.isSent,
    };

_$EventAttachmentImpl _$$EventAttachmentImplFromJson(
        Map<String, dynamic> json) =>
    _$EventAttachmentImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      mimeType: json['mimeType'] as String?,
      sizeBytes: (json['sizeBytes'] as num?)?.toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$EventAttachmentImplToJson(
        _$EventAttachmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'url': instance.url,
      'mimeType': instance.mimeType,
      'sizeBytes': instance.sizeBytes,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$EventOccurrenceImpl _$$EventOccurrenceImplFromJson(
        Map<String, dynamic> json) =>
    _$EventOccurrenceImpl(
      eventId: json['eventId'] as String,
      originalStartTime: DateTime.parse(json['originalStartTime'] as String),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      isCancelled: json['isCancelled'] as bool? ?? false,
      isModified: json['isModified'] as bool? ?? false,
      modifiedEvent: json['modifiedEvent'] == null
          ? null
          : Event.fromJson(json['modifiedEvent'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$EventOccurrenceImplToJson(
        _$EventOccurrenceImpl instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'originalStartTime': instance.originalStartTime.toIso8601String(),
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'isCancelled': instance.isCancelled,
      'isModified': instance.isModified,
      'modifiedEvent': instance.modifiedEvent,
    };

_$EventFilterImpl _$$EventFilterImplFromJson(Map<String, dynamic> json) =>
    _$EventFilterImpl(
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      statuses: (json['statuses'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$EventStatusEnumMap, e))
          .toList(),
      priorities: (json['priorities'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$EventPriorityEnumMap, e))
          .toList(),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      searchQuery: json['searchQuery'] as String?,
      includeRecurring: json['includeRecurring'] as bool? ?? false,
      onlyShared: json['onlyShared'] as bool? ?? false,
    );

Map<String, dynamic> _$$EventFilterImplToJson(_$EventFilterImpl instance) =>
    <String, dynamic>{
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'statuses':
          instance.statuses?.map((e) => _$EventStatusEnumMap[e]!).toList(),
      'priorities':
          instance.priorities?.map((e) => _$EventPriorityEnumMap[e]!).toList(),
      'tags': instance.tags,
      'searchQuery': instance.searchQuery,
      'includeRecurring': instance.includeRecurring,
      'onlyShared': instance.onlyShared,
    };
