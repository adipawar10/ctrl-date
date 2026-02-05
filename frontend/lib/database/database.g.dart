// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $EventsTable extends Events with TableInfo<$EventsTable, Event> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
      'start_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
      'end_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isAllDayMeta =
      const VerificationMeta('isAllDay');
  @override
  late final GeneratedColumn<bool> isAllDay = GeneratedColumn<bool>(
      'is_all_day', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_all_day" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _locationMeta =
      const VerificationMeta('location');
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
      'location', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _locationUrlMeta =
      const VerificationMeta('locationUrl');
  @override
  late final GeneratedColumn<String> locationUrl = GeneratedColumn<String>(
      'location_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('scheduled'));
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
      'priority', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('medium'));
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _recurrenceRuleMeta =
      const VerificationMeta('recurrenceRule');
  @override
  late final GeneratedColumn<String> recurrenceRule = GeneratedColumn<String>(
      'recurrence_rule', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _parentEventIdMeta =
      const VerificationMeta('parentEventId');
  @override
  late final GeneratedColumn<String> parentEventId = GeneratedColumn<String>(
      'parent_event_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _remindersMeta =
      const VerificationMeta('reminders');
  @override
  late final GeneratedColumn<String> reminders = GeneratedColumn<String>(
      'reminders', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _attachmentsMeta =
      const VerificationMeta('attachments');
  @override
  late final GeneratedColumn<String> attachments = GeneratedColumn<String>(
      'attachments', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _isPrivateMeta =
      const VerificationMeta('isPrivate');
  @override
  late final GeneratedColumn<bool> isPrivate = GeneratedColumn<bool>(
      'is_private', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_private" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _encryptedDataMeta =
      const VerificationMeta('encryptedData');
  @override
  late final GeneratedColumn<String> encryptedData = GeneratedColumn<String>(
      'encrypted_data', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isSharedMeta =
      const VerificationMeta('isShared');
  @override
  late final GeneratedColumn<bool> isShared = GeneratedColumn<bool>(
      'is_shared', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_shared" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _sharedWithUserIdsMeta =
      const VerificationMeta('sharedWithUserIds');
  @override
  late final GeneratedColumn<String> sharedWithUserIds =
      GeneratedColumn<String>('shared_with_user_ids', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('[]'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _syncVersionMeta =
      const VerificationMeta('syncVersion');
  @override
  late final GeneratedColumn<int> syncVersion = GeneratedColumn<int>(
      'sync_version', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        title,
        description,
        startTime,
        endTime,
        isAllDay,
        location,
        locationUrl,
        status,
        priority,
        color,
        tags,
        recurrenceRule,
        parentEventId,
        reminders,
        attachments,
        isPrivate,
        encryptedData,
        isShared,
        sharedWithUserIds,
        createdAt,
        updatedAt,
        isSynced,
        syncVersion
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'events';
  @override
  VerificationContext validateIntegrity(Insertable<Event> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('is_all_day')) {
      context.handle(_isAllDayMeta,
          isAllDay.isAcceptableOrUnknown(data['is_all_day']!, _isAllDayMeta));
    }
    if (data.containsKey('location')) {
      context.handle(_locationMeta,
          location.isAcceptableOrUnknown(data['location']!, _locationMeta));
    }
    if (data.containsKey('location_url')) {
      context.handle(
          _locationUrlMeta,
          locationUrl.isAcceptableOrUnknown(
              data['location_url']!, _locationUrlMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    if (data.containsKey('recurrence_rule')) {
      context.handle(
          _recurrenceRuleMeta,
          recurrenceRule.isAcceptableOrUnknown(
              data['recurrence_rule']!, _recurrenceRuleMeta));
    }
    if (data.containsKey('parent_event_id')) {
      context.handle(
          _parentEventIdMeta,
          parentEventId.isAcceptableOrUnknown(
              data['parent_event_id']!, _parentEventIdMeta));
    }
    if (data.containsKey('reminders')) {
      context.handle(_remindersMeta,
          reminders.isAcceptableOrUnknown(data['reminders']!, _remindersMeta));
    }
    if (data.containsKey('attachments')) {
      context.handle(
          _attachmentsMeta,
          attachments.isAcceptableOrUnknown(
              data['attachments']!, _attachmentsMeta));
    }
    if (data.containsKey('is_private')) {
      context.handle(_isPrivateMeta,
          isPrivate.isAcceptableOrUnknown(data['is_private']!, _isPrivateMeta));
    }
    if (data.containsKey('encrypted_data')) {
      context.handle(
          _encryptedDataMeta,
          encryptedData.isAcceptableOrUnknown(
              data['encrypted_data']!, _encryptedDataMeta));
    }
    if (data.containsKey('is_shared')) {
      context.handle(_isSharedMeta,
          isShared.isAcceptableOrUnknown(data['is_shared']!, _isSharedMeta));
    }
    if (data.containsKey('shared_with_user_ids')) {
      context.handle(
          _sharedWithUserIdsMeta,
          sharedWithUserIds.isAcceptableOrUnknown(
              data['shared_with_user_ids']!, _sharedWithUserIdsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('sync_version')) {
      context.handle(
          _syncVersionMeta,
          syncVersion.isAcceptableOrUnknown(
              data['sync_version']!, _syncVersionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Event map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Event(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_time'])!,
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_time'])!,
      isAllDay: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_all_day'])!,
      location: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location']),
      locationUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location_url']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}priority'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color']),
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      recurrenceRule: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recurrence_rule']),
      parentEventId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_event_id']),
      reminders: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reminders'])!,
      attachments: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}attachments'])!,
      isPrivate: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_private'])!,
      encryptedData: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}encrypted_data']),
      isShared: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_shared'])!,
      sharedWithUserIds: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}shared_with_user_ids'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      syncVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sync_version']),
    );
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(attachedDatabase, alias);
  }
}

class Event extends DataClass implements Insertable<Event> {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final bool isAllDay;
  final String? location;
  final String? locationUrl;
  final String status;
  final String priority;
  final String? color;
  final String tags;
  final String? recurrenceRule;
  final String? parentEventId;
  final String reminders;
  final String attachments;
  final bool isPrivate;
  final String? encryptedData;
  final bool isShared;
  final String sharedWithUserIds;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isSynced;
  final int? syncVersion;
  const Event(
      {required this.id,
      required this.userId,
      required this.title,
      this.description,
      required this.startTime,
      required this.endTime,
      required this.isAllDay,
      this.location,
      this.locationUrl,
      required this.status,
      required this.priority,
      this.color,
      required this.tags,
      this.recurrenceRule,
      this.parentEventId,
      required this.reminders,
      required this.attachments,
      required this.isPrivate,
      this.encryptedData,
      required this.isShared,
      required this.sharedWithUserIds,
      this.createdAt,
      this.updatedAt,
      required this.isSynced,
      this.syncVersion});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['start_time'] = Variable<DateTime>(startTime);
    map['end_time'] = Variable<DateTime>(endTime);
    map['is_all_day'] = Variable<bool>(isAllDay);
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || locationUrl != null) {
      map['location_url'] = Variable<String>(locationUrl);
    }
    map['status'] = Variable<String>(status);
    map['priority'] = Variable<String>(priority);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    map['tags'] = Variable<String>(tags);
    if (!nullToAbsent || recurrenceRule != null) {
      map['recurrence_rule'] = Variable<String>(recurrenceRule);
    }
    if (!nullToAbsent || parentEventId != null) {
      map['parent_event_id'] = Variable<String>(parentEventId);
    }
    map['reminders'] = Variable<String>(reminders);
    map['attachments'] = Variable<String>(attachments);
    map['is_private'] = Variable<bool>(isPrivate);
    if (!nullToAbsent || encryptedData != null) {
      map['encrypted_data'] = Variable<String>(encryptedData);
    }
    map['is_shared'] = Variable<bool>(isShared);
    map['shared_with_user_ids'] = Variable<String>(sharedWithUserIds);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || syncVersion != null) {
      map['sync_version'] = Variable<int>(syncVersion);
    }
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: Value(id),
      userId: Value(userId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      startTime: Value(startTime),
      endTime: Value(endTime),
      isAllDay: Value(isAllDay),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      locationUrl: locationUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(locationUrl),
      status: Value(status),
      priority: Value(priority),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      tags: Value(tags),
      recurrenceRule: recurrenceRule == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceRule),
      parentEventId: parentEventId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentEventId),
      reminders: Value(reminders),
      attachments: Value(attachments),
      isPrivate: Value(isPrivate),
      encryptedData: encryptedData == null && nullToAbsent
          ? const Value.absent()
          : Value(encryptedData),
      isShared: Value(isShared),
      sharedWithUserIds: Value(sharedWithUserIds),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      isSynced: Value(isSynced),
      syncVersion: syncVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(syncVersion),
    );
  }

  factory Event.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Event(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime>(json['endTime']),
      isAllDay: serializer.fromJson<bool>(json['isAllDay']),
      location: serializer.fromJson<String?>(json['location']),
      locationUrl: serializer.fromJson<String?>(json['locationUrl']),
      status: serializer.fromJson<String>(json['status']),
      priority: serializer.fromJson<String>(json['priority']),
      color: serializer.fromJson<String?>(json['color']),
      tags: serializer.fromJson<String>(json['tags']),
      recurrenceRule: serializer.fromJson<String?>(json['recurrenceRule']),
      parentEventId: serializer.fromJson<String?>(json['parentEventId']),
      reminders: serializer.fromJson<String>(json['reminders']),
      attachments: serializer.fromJson<String>(json['attachments']),
      isPrivate: serializer.fromJson<bool>(json['isPrivate']),
      encryptedData: serializer.fromJson<String?>(json['encryptedData']),
      isShared: serializer.fromJson<bool>(json['isShared']),
      sharedWithUserIds: serializer.fromJson<String>(json['sharedWithUserIds']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      syncVersion: serializer.fromJson<int?>(json['syncVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime>(endTime),
      'isAllDay': serializer.toJson<bool>(isAllDay),
      'location': serializer.toJson<String?>(location),
      'locationUrl': serializer.toJson<String?>(locationUrl),
      'status': serializer.toJson<String>(status),
      'priority': serializer.toJson<String>(priority),
      'color': serializer.toJson<String?>(color),
      'tags': serializer.toJson<String>(tags),
      'recurrenceRule': serializer.toJson<String?>(recurrenceRule),
      'parentEventId': serializer.toJson<String?>(parentEventId),
      'reminders': serializer.toJson<String>(reminders),
      'attachments': serializer.toJson<String>(attachments),
      'isPrivate': serializer.toJson<bool>(isPrivate),
      'encryptedData': serializer.toJson<String?>(encryptedData),
      'isShared': serializer.toJson<bool>(isShared),
      'sharedWithUserIds': serializer.toJson<String>(sharedWithUserIds),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'syncVersion': serializer.toJson<int?>(syncVersion),
    };
  }

  Event copyWith(
          {String? id,
          String? userId,
          String? title,
          Value<String?> description = const Value.absent(),
          DateTime? startTime,
          DateTime? endTime,
          bool? isAllDay,
          Value<String?> location = const Value.absent(),
          Value<String?> locationUrl = const Value.absent(),
          String? status,
          String? priority,
          Value<String?> color = const Value.absent(),
          String? tags,
          Value<String?> recurrenceRule = const Value.absent(),
          Value<String?> parentEventId = const Value.absent(),
          String? reminders,
          String? attachments,
          bool? isPrivate,
          Value<String?> encryptedData = const Value.absent(),
          bool? isShared,
          String? sharedWithUserIds,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          bool? isSynced,
          Value<int?> syncVersion = const Value.absent()}) =>
      Event(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        isAllDay: isAllDay ?? this.isAllDay,
        location: location.present ? location.value : this.location,
        locationUrl: locationUrl.present ? locationUrl.value : this.locationUrl,
        status: status ?? this.status,
        priority: priority ?? this.priority,
        color: color.present ? color.value : this.color,
        tags: tags ?? this.tags,
        recurrenceRule:
            recurrenceRule.present ? recurrenceRule.value : this.recurrenceRule,
        parentEventId:
            parentEventId.present ? parentEventId.value : this.parentEventId,
        reminders: reminders ?? this.reminders,
        attachments: attachments ?? this.attachments,
        isPrivate: isPrivate ?? this.isPrivate,
        encryptedData:
            encryptedData.present ? encryptedData.value : this.encryptedData,
        isShared: isShared ?? this.isShared,
        sharedWithUserIds: sharedWithUserIds ?? this.sharedWithUserIds,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        isSynced: isSynced ?? this.isSynced,
        syncVersion: syncVersion.present ? syncVersion.value : this.syncVersion,
      );
  @override
  String toString() {
    return (StringBuffer('Event(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('isAllDay: $isAllDay, ')
          ..write('location: $location, ')
          ..write('locationUrl: $locationUrl, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('color: $color, ')
          ..write('tags: $tags, ')
          ..write('recurrenceRule: $recurrenceRule, ')
          ..write('parentEventId: $parentEventId, ')
          ..write('reminders: $reminders, ')
          ..write('attachments: $attachments, ')
          ..write('isPrivate: $isPrivate, ')
          ..write('encryptedData: $encryptedData, ')
          ..write('isShared: $isShared, ')
          ..write('sharedWithUserIds: $sharedWithUserIds, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncVersion: $syncVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        userId,
        title,
        description,
        startTime,
        endTime,
        isAllDay,
        location,
        locationUrl,
        status,
        priority,
        color,
        tags,
        recurrenceRule,
        parentEventId,
        reminders,
        attachments,
        isPrivate,
        encryptedData,
        isShared,
        sharedWithUserIds,
        createdAt,
        updatedAt,
        isSynced,
        syncVersion
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Event &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.title == this.title &&
          other.description == this.description &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.isAllDay == this.isAllDay &&
          other.location == this.location &&
          other.locationUrl == this.locationUrl &&
          other.status == this.status &&
          other.priority == this.priority &&
          other.color == this.color &&
          other.tags == this.tags &&
          other.recurrenceRule == this.recurrenceRule &&
          other.parentEventId == this.parentEventId &&
          other.reminders == this.reminders &&
          other.attachments == this.attachments &&
          other.isPrivate == this.isPrivate &&
          other.encryptedData == this.encryptedData &&
          other.isShared == this.isShared &&
          other.sharedWithUserIds == this.sharedWithUserIds &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced &&
          other.syncVersion == this.syncVersion);
}

class EventsCompanion extends UpdateCompanion<Event> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> title;
  final Value<String?> description;
  final Value<DateTime> startTime;
  final Value<DateTime> endTime;
  final Value<bool> isAllDay;
  final Value<String?> location;
  final Value<String?> locationUrl;
  final Value<String> status;
  final Value<String> priority;
  final Value<String?> color;
  final Value<String> tags;
  final Value<String?> recurrenceRule;
  final Value<String?> parentEventId;
  final Value<String> reminders;
  final Value<String> attachments;
  final Value<bool> isPrivate;
  final Value<String?> encryptedData;
  final Value<bool> isShared;
  final Value<String> sharedWithUserIds;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<bool> isSynced;
  final Value<int?> syncVersion;
  final Value<int> rowid;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.isAllDay = const Value.absent(),
    this.location = const Value.absent(),
    this.locationUrl = const Value.absent(),
    this.status = const Value.absent(),
    this.priority = const Value.absent(),
    this.color = const Value.absent(),
    this.tags = const Value.absent(),
    this.recurrenceRule = const Value.absent(),
    this.parentEventId = const Value.absent(),
    this.reminders = const Value.absent(),
    this.attachments = const Value.absent(),
    this.isPrivate = const Value.absent(),
    this.encryptedData = const Value.absent(),
    this.isShared = const Value.absent(),
    this.sharedWithUserIds = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventsCompanion.insert({
    required String id,
    required String userId,
    required String title,
    this.description = const Value.absent(),
    required DateTime startTime,
    required DateTime endTime,
    this.isAllDay = const Value.absent(),
    this.location = const Value.absent(),
    this.locationUrl = const Value.absent(),
    this.status = const Value.absent(),
    this.priority = const Value.absent(),
    this.color = const Value.absent(),
    this.tags = const Value.absent(),
    this.recurrenceRule = const Value.absent(),
    this.parentEventId = const Value.absent(),
    this.reminders = const Value.absent(),
    this.attachments = const Value.absent(),
    this.isPrivate = const Value.absent(),
    this.encryptedData = const Value.absent(),
    this.isShared = const Value.absent(),
    this.sharedWithUserIds = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        title = Value(title),
        startTime = Value(startTime),
        endTime = Value(endTime);
  static Insertable<Event> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<bool>? isAllDay,
    Expression<String>? location,
    Expression<String>? locationUrl,
    Expression<String>? status,
    Expression<String>? priority,
    Expression<String>? color,
    Expression<String>? tags,
    Expression<String>? recurrenceRule,
    Expression<String>? parentEventId,
    Expression<String>? reminders,
    Expression<String>? attachments,
    Expression<bool>? isPrivate,
    Expression<String>? encryptedData,
    Expression<bool>? isShared,
    Expression<String>? sharedWithUserIds,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<int>? syncVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (isAllDay != null) 'is_all_day': isAllDay,
      if (location != null) 'location': location,
      if (locationUrl != null) 'location_url': locationUrl,
      if (status != null) 'status': status,
      if (priority != null) 'priority': priority,
      if (color != null) 'color': color,
      if (tags != null) 'tags': tags,
      if (recurrenceRule != null) 'recurrence_rule': recurrenceRule,
      if (parentEventId != null) 'parent_event_id': parentEventId,
      if (reminders != null) 'reminders': reminders,
      if (attachments != null) 'attachments': attachments,
      if (isPrivate != null) 'is_private': isPrivate,
      if (encryptedData != null) 'encrypted_data': encryptedData,
      if (isShared != null) 'is_shared': isShared,
      if (sharedWithUserIds != null) 'shared_with_user_ids': sharedWithUserIds,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (syncVersion != null) 'sync_version': syncVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? title,
      Value<String?>? description,
      Value<DateTime>? startTime,
      Value<DateTime>? endTime,
      Value<bool>? isAllDay,
      Value<String?>? location,
      Value<String?>? locationUrl,
      Value<String>? status,
      Value<String>? priority,
      Value<String?>? color,
      Value<String>? tags,
      Value<String?>? recurrenceRule,
      Value<String?>? parentEventId,
      Value<String>? reminders,
      Value<String>? attachments,
      Value<bool>? isPrivate,
      Value<String?>? encryptedData,
      Value<bool>? isShared,
      Value<String>? sharedWithUserIds,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<bool>? isSynced,
      Value<int?>? syncVersion,
      Value<int>? rowid}) {
    return EventsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAllDay: isAllDay ?? this.isAllDay,
      location: location ?? this.location,
      locationUrl: locationUrl ?? this.locationUrl,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      color: color ?? this.color,
      tags: tags ?? this.tags,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      parentEventId: parentEventId ?? this.parentEventId,
      reminders: reminders ?? this.reminders,
      attachments: attachments ?? this.attachments,
      isPrivate: isPrivate ?? this.isPrivate,
      encryptedData: encryptedData ?? this.encryptedData,
      isShared: isShared ?? this.isShared,
      sharedWithUserIds: sharedWithUserIds ?? this.sharedWithUserIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      syncVersion: syncVersion ?? this.syncVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (isAllDay.present) {
      map['is_all_day'] = Variable<bool>(isAllDay.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (locationUrl.present) {
      map['location_url'] = Variable<String>(locationUrl.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (recurrenceRule.present) {
      map['recurrence_rule'] = Variable<String>(recurrenceRule.value);
    }
    if (parentEventId.present) {
      map['parent_event_id'] = Variable<String>(parentEventId.value);
    }
    if (reminders.present) {
      map['reminders'] = Variable<String>(reminders.value);
    }
    if (attachments.present) {
      map['attachments'] = Variable<String>(attachments.value);
    }
    if (isPrivate.present) {
      map['is_private'] = Variable<bool>(isPrivate.value);
    }
    if (encryptedData.present) {
      map['encrypted_data'] = Variable<String>(encryptedData.value);
    }
    if (isShared.present) {
      map['is_shared'] = Variable<bool>(isShared.value);
    }
    if (sharedWithUserIds.present) {
      map['shared_with_user_ids'] = Variable<String>(sharedWithUserIds.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (syncVersion.present) {
      map['sync_version'] = Variable<int>(syncVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('isAllDay: $isAllDay, ')
          ..write('location: $location, ')
          ..write('locationUrl: $locationUrl, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('color: $color, ')
          ..write('tags: $tags, ')
          ..write('recurrenceRule: $recurrenceRule, ')
          ..write('parentEventId: $parentEventId, ')
          ..write('reminders: $reminders, ')
          ..write('attachments: $attachments, ')
          ..write('isPrivate: $isPrivate, ')
          ..write('encryptedData: $encryptedData, ')
          ..write('isShared: $isShared, ')
          ..write('sharedWithUserIds: $sharedWithUserIds, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyReflectionsTable extends DailyReflections
    with TableInfo<$DailyReflectionsTable, DailyReflection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyReflectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<int> mood = GeneratedColumn<int>(
      'mood', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _energyMeta = const VerificationMeta('energy');
  @override
  late final GeneratedColumn<int> energy = GeneratedColumn<int>(
      'energy', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _productivityMeta =
      const VerificationMeta('productivity');
  @override
  late final GeneratedColumn<int> productivity = GeneratedColumn<int>(
      'productivity', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _gratitudeMeta =
      const VerificationMeta('gratitude');
  @override
  late final GeneratedColumn<String> gratitude = GeneratedColumn<String>(
      'gratitude', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _accomplishmentsMeta =
      const VerificationMeta('accomplishments');
  @override
  late final GeneratedColumn<String> accomplishments = GeneratedColumn<String>(
      'accomplishments', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _challengesMeta =
      const VerificationMeta('challenges');
  @override
  late final GeneratedColumn<String> challenges = GeneratedColumn<String>(
      'challenges', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _learningsMeta =
      const VerificationMeta('learnings');
  @override
  late final GeneratedColumn<String> learnings = GeneratedColumn<String>(
      'learnings', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tomorrowGoalsMeta =
      const VerificationMeta('tomorrowGoals');
  @override
  late final GeneratedColumn<String> tomorrowGoals = GeneratedColumn<String>(
      'tomorrow_goals', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _isPrivateMeta =
      const VerificationMeta('isPrivate');
  @override
  late final GeneratedColumn<bool> isPrivate = GeneratedColumn<bool>(
      'is_private', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_private" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _encryptedDataMeta =
      const VerificationMeta('encryptedData');
  @override
  late final GeneratedColumn<String> encryptedData = GeneratedColumn<String>(
      'encrypted_data', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isCompleteMeta =
      const VerificationMeta('isComplete');
  @override
  late final GeneratedColumn<bool> isComplete = GeneratedColumn<bool>(
      'is_complete', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_complete" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _syncVersionMeta =
      const VerificationMeta('syncVersion');
  @override
  late final GeneratedColumn<int> syncVersion = GeneratedColumn<int>(
      'sync_version', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        date,
        mood,
        energy,
        productivity,
        gratitude,
        accomplishments,
        challenges,
        learnings,
        tomorrowGoals,
        notes,
        tags,
        isPrivate,
        encryptedData,
        isComplete,
        createdAt,
        updatedAt,
        isSynced,
        syncVersion
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_reflections';
  @override
  VerificationContext validateIntegrity(Insertable<DailyReflection> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('mood')) {
      context.handle(
          _moodMeta, mood.isAcceptableOrUnknown(data['mood']!, _moodMeta));
    }
    if (data.containsKey('energy')) {
      context.handle(_energyMeta,
          energy.isAcceptableOrUnknown(data['energy']!, _energyMeta));
    }
    if (data.containsKey('productivity')) {
      context.handle(
          _productivityMeta,
          productivity.isAcceptableOrUnknown(
              data['productivity']!, _productivityMeta));
    }
    if (data.containsKey('gratitude')) {
      context.handle(_gratitudeMeta,
          gratitude.isAcceptableOrUnknown(data['gratitude']!, _gratitudeMeta));
    }
    if (data.containsKey('accomplishments')) {
      context.handle(
          _accomplishmentsMeta,
          accomplishments.isAcceptableOrUnknown(
              data['accomplishments']!, _accomplishmentsMeta));
    }
    if (data.containsKey('challenges')) {
      context.handle(
          _challengesMeta,
          challenges.isAcceptableOrUnknown(
              data['challenges']!, _challengesMeta));
    }
    if (data.containsKey('learnings')) {
      context.handle(_learningsMeta,
          learnings.isAcceptableOrUnknown(data['learnings']!, _learningsMeta));
    }
    if (data.containsKey('tomorrow_goals')) {
      context.handle(
          _tomorrowGoalsMeta,
          tomorrowGoals.isAcceptableOrUnknown(
              data['tomorrow_goals']!, _tomorrowGoalsMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    if (data.containsKey('is_private')) {
      context.handle(_isPrivateMeta,
          isPrivate.isAcceptableOrUnknown(data['is_private']!, _isPrivateMeta));
    }
    if (data.containsKey('encrypted_data')) {
      context.handle(
          _encryptedDataMeta,
          encryptedData.isAcceptableOrUnknown(
              data['encrypted_data']!, _encryptedDataMeta));
    }
    if (data.containsKey('is_complete')) {
      context.handle(
          _isCompleteMeta,
          isComplete.isAcceptableOrUnknown(
              data['is_complete']!, _isCompleteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('sync_version')) {
      context.handle(
          _syncVersionMeta,
          syncVersion.isAcceptableOrUnknown(
              data['sync_version']!, _syncVersionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyReflection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyReflection(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      mood: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mood']),
      energy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}energy']),
      productivity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}productivity']),
      gratitude: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gratitude']),
      accomplishments: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}accomplishments']),
      challenges: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}challenges']),
      learnings: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}learnings']),
      tomorrowGoals: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tomorrow_goals']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      isPrivate: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_private'])!,
      encryptedData: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}encrypted_data']),
      isComplete: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_complete'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      syncVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sync_version']),
    );
  }

  @override
  $DailyReflectionsTable createAlias(String alias) {
    return $DailyReflectionsTable(attachedDatabase, alias);
  }
}

class DailyReflection extends DataClass implements Insertable<DailyReflection> {
  final String id;
  final String userId;
  final DateTime date;
  final int? mood;
  final int? energy;
  final int? productivity;
  final String? gratitude;
  final String? accomplishments;
  final String? challenges;
  final String? learnings;
  final String? tomorrowGoals;
  final String? notes;
  final String tags;
  final bool isPrivate;
  final String? encryptedData;
  final bool isComplete;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isSynced;
  final int? syncVersion;
  const DailyReflection(
      {required this.id,
      required this.userId,
      required this.date,
      this.mood,
      this.energy,
      this.productivity,
      this.gratitude,
      this.accomplishments,
      this.challenges,
      this.learnings,
      this.tomorrowGoals,
      this.notes,
      required this.tags,
      required this.isPrivate,
      this.encryptedData,
      required this.isComplete,
      this.createdAt,
      this.updatedAt,
      required this.isSynced,
      this.syncVersion});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || mood != null) {
      map['mood'] = Variable<int>(mood);
    }
    if (!nullToAbsent || energy != null) {
      map['energy'] = Variable<int>(energy);
    }
    if (!nullToAbsent || productivity != null) {
      map['productivity'] = Variable<int>(productivity);
    }
    if (!nullToAbsent || gratitude != null) {
      map['gratitude'] = Variable<String>(gratitude);
    }
    if (!nullToAbsent || accomplishments != null) {
      map['accomplishments'] = Variable<String>(accomplishments);
    }
    if (!nullToAbsent || challenges != null) {
      map['challenges'] = Variable<String>(challenges);
    }
    if (!nullToAbsent || learnings != null) {
      map['learnings'] = Variable<String>(learnings);
    }
    if (!nullToAbsent || tomorrowGoals != null) {
      map['tomorrow_goals'] = Variable<String>(tomorrowGoals);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['tags'] = Variable<String>(tags);
    map['is_private'] = Variable<bool>(isPrivate);
    if (!nullToAbsent || encryptedData != null) {
      map['encrypted_data'] = Variable<String>(encryptedData);
    }
    map['is_complete'] = Variable<bool>(isComplete);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || syncVersion != null) {
      map['sync_version'] = Variable<int>(syncVersion);
    }
    return map;
  }

  DailyReflectionsCompanion toCompanion(bool nullToAbsent) {
    return DailyReflectionsCompanion(
      id: Value(id),
      userId: Value(userId),
      date: Value(date),
      mood: mood == null && nullToAbsent ? const Value.absent() : Value(mood),
      energy:
          energy == null && nullToAbsent ? const Value.absent() : Value(energy),
      productivity: productivity == null && nullToAbsent
          ? const Value.absent()
          : Value(productivity),
      gratitude: gratitude == null && nullToAbsent
          ? const Value.absent()
          : Value(gratitude),
      accomplishments: accomplishments == null && nullToAbsent
          ? const Value.absent()
          : Value(accomplishments),
      challenges: challenges == null && nullToAbsent
          ? const Value.absent()
          : Value(challenges),
      learnings: learnings == null && nullToAbsent
          ? const Value.absent()
          : Value(learnings),
      tomorrowGoals: tomorrowGoals == null && nullToAbsent
          ? const Value.absent()
          : Value(tomorrowGoals),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      tags: Value(tags),
      isPrivate: Value(isPrivate),
      encryptedData: encryptedData == null && nullToAbsent
          ? const Value.absent()
          : Value(encryptedData),
      isComplete: Value(isComplete),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      isSynced: Value(isSynced),
      syncVersion: syncVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(syncVersion),
    );
  }

  factory DailyReflection.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyReflection(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      date: serializer.fromJson<DateTime>(json['date']),
      mood: serializer.fromJson<int?>(json['mood']),
      energy: serializer.fromJson<int?>(json['energy']),
      productivity: serializer.fromJson<int?>(json['productivity']),
      gratitude: serializer.fromJson<String?>(json['gratitude']),
      accomplishments: serializer.fromJson<String?>(json['accomplishments']),
      challenges: serializer.fromJson<String?>(json['challenges']),
      learnings: serializer.fromJson<String?>(json['learnings']),
      tomorrowGoals: serializer.fromJson<String?>(json['tomorrowGoals']),
      notes: serializer.fromJson<String?>(json['notes']),
      tags: serializer.fromJson<String>(json['tags']),
      isPrivate: serializer.fromJson<bool>(json['isPrivate']),
      encryptedData: serializer.fromJson<String?>(json['encryptedData']),
      isComplete: serializer.fromJson<bool>(json['isComplete']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      syncVersion: serializer.fromJson<int?>(json['syncVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'date': serializer.toJson<DateTime>(date),
      'mood': serializer.toJson<int?>(mood),
      'energy': serializer.toJson<int?>(energy),
      'productivity': serializer.toJson<int?>(productivity),
      'gratitude': serializer.toJson<String?>(gratitude),
      'accomplishments': serializer.toJson<String?>(accomplishments),
      'challenges': serializer.toJson<String?>(challenges),
      'learnings': serializer.toJson<String?>(learnings),
      'tomorrowGoals': serializer.toJson<String?>(tomorrowGoals),
      'notes': serializer.toJson<String?>(notes),
      'tags': serializer.toJson<String>(tags),
      'isPrivate': serializer.toJson<bool>(isPrivate),
      'encryptedData': serializer.toJson<String?>(encryptedData),
      'isComplete': serializer.toJson<bool>(isComplete),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'syncVersion': serializer.toJson<int?>(syncVersion),
    };
  }

  DailyReflection copyWith(
          {String? id,
          String? userId,
          DateTime? date,
          Value<int?> mood = const Value.absent(),
          Value<int?> energy = const Value.absent(),
          Value<int?> productivity = const Value.absent(),
          Value<String?> gratitude = const Value.absent(),
          Value<String?> accomplishments = const Value.absent(),
          Value<String?> challenges = const Value.absent(),
          Value<String?> learnings = const Value.absent(),
          Value<String?> tomorrowGoals = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          String? tags,
          bool? isPrivate,
          Value<String?> encryptedData = const Value.absent(),
          bool? isComplete,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          bool? isSynced,
          Value<int?> syncVersion = const Value.absent()}) =>
      DailyReflection(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        date: date ?? this.date,
        mood: mood.present ? mood.value : this.mood,
        energy: energy.present ? energy.value : this.energy,
        productivity:
            productivity.present ? productivity.value : this.productivity,
        gratitude: gratitude.present ? gratitude.value : this.gratitude,
        accomplishments: accomplishments.present
            ? accomplishments.value
            : this.accomplishments,
        challenges: challenges.present ? challenges.value : this.challenges,
        learnings: learnings.present ? learnings.value : this.learnings,
        tomorrowGoals:
            tomorrowGoals.present ? tomorrowGoals.value : this.tomorrowGoals,
        notes: notes.present ? notes.value : this.notes,
        tags: tags ?? this.tags,
        isPrivate: isPrivate ?? this.isPrivate,
        encryptedData:
            encryptedData.present ? encryptedData.value : this.encryptedData,
        isComplete: isComplete ?? this.isComplete,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        isSynced: isSynced ?? this.isSynced,
        syncVersion: syncVersion.present ? syncVersion.value : this.syncVersion,
      );
  @override
  String toString() {
    return (StringBuffer('DailyReflection(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('date: $date, ')
          ..write('mood: $mood, ')
          ..write('energy: $energy, ')
          ..write('productivity: $productivity, ')
          ..write('gratitude: $gratitude, ')
          ..write('accomplishments: $accomplishments, ')
          ..write('challenges: $challenges, ')
          ..write('learnings: $learnings, ')
          ..write('tomorrowGoals: $tomorrowGoals, ')
          ..write('notes: $notes, ')
          ..write('tags: $tags, ')
          ..write('isPrivate: $isPrivate, ')
          ..write('encryptedData: $encryptedData, ')
          ..write('isComplete: $isComplete, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncVersion: $syncVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userId,
      date,
      mood,
      energy,
      productivity,
      gratitude,
      accomplishments,
      challenges,
      learnings,
      tomorrowGoals,
      notes,
      tags,
      isPrivate,
      encryptedData,
      isComplete,
      createdAt,
      updatedAt,
      isSynced,
      syncVersion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyReflection &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.date == this.date &&
          other.mood == this.mood &&
          other.energy == this.energy &&
          other.productivity == this.productivity &&
          other.gratitude == this.gratitude &&
          other.accomplishments == this.accomplishments &&
          other.challenges == this.challenges &&
          other.learnings == this.learnings &&
          other.tomorrowGoals == this.tomorrowGoals &&
          other.notes == this.notes &&
          other.tags == this.tags &&
          other.isPrivate == this.isPrivate &&
          other.encryptedData == this.encryptedData &&
          other.isComplete == this.isComplete &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced &&
          other.syncVersion == this.syncVersion);
}

class DailyReflectionsCompanion extends UpdateCompanion<DailyReflection> {
  final Value<String> id;
  final Value<String> userId;
  final Value<DateTime> date;
  final Value<int?> mood;
  final Value<int?> energy;
  final Value<int?> productivity;
  final Value<String?> gratitude;
  final Value<String?> accomplishments;
  final Value<String?> challenges;
  final Value<String?> learnings;
  final Value<String?> tomorrowGoals;
  final Value<String?> notes;
  final Value<String> tags;
  final Value<bool> isPrivate;
  final Value<String?> encryptedData;
  final Value<bool> isComplete;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<bool> isSynced;
  final Value<int?> syncVersion;
  final Value<int> rowid;
  const DailyReflectionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.date = const Value.absent(),
    this.mood = const Value.absent(),
    this.energy = const Value.absent(),
    this.productivity = const Value.absent(),
    this.gratitude = const Value.absent(),
    this.accomplishments = const Value.absent(),
    this.challenges = const Value.absent(),
    this.learnings = const Value.absent(),
    this.tomorrowGoals = const Value.absent(),
    this.notes = const Value.absent(),
    this.tags = const Value.absent(),
    this.isPrivate = const Value.absent(),
    this.encryptedData = const Value.absent(),
    this.isComplete = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyReflectionsCompanion.insert({
    required String id,
    required String userId,
    required DateTime date,
    this.mood = const Value.absent(),
    this.energy = const Value.absent(),
    this.productivity = const Value.absent(),
    this.gratitude = const Value.absent(),
    this.accomplishments = const Value.absent(),
    this.challenges = const Value.absent(),
    this.learnings = const Value.absent(),
    this.tomorrowGoals = const Value.absent(),
    this.notes = const Value.absent(),
    this.tags = const Value.absent(),
    this.isPrivate = const Value.absent(),
    this.encryptedData = const Value.absent(),
    this.isComplete = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        date = Value(date);
  static Insertable<DailyReflection> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<DateTime>? date,
    Expression<int>? mood,
    Expression<int>? energy,
    Expression<int>? productivity,
    Expression<String>? gratitude,
    Expression<String>? accomplishments,
    Expression<String>? challenges,
    Expression<String>? learnings,
    Expression<String>? tomorrowGoals,
    Expression<String>? notes,
    Expression<String>? tags,
    Expression<bool>? isPrivate,
    Expression<String>? encryptedData,
    Expression<bool>? isComplete,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<int>? syncVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (date != null) 'date': date,
      if (mood != null) 'mood': mood,
      if (energy != null) 'energy': energy,
      if (productivity != null) 'productivity': productivity,
      if (gratitude != null) 'gratitude': gratitude,
      if (accomplishments != null) 'accomplishments': accomplishments,
      if (challenges != null) 'challenges': challenges,
      if (learnings != null) 'learnings': learnings,
      if (tomorrowGoals != null) 'tomorrow_goals': tomorrowGoals,
      if (notes != null) 'notes': notes,
      if (tags != null) 'tags': tags,
      if (isPrivate != null) 'is_private': isPrivate,
      if (encryptedData != null) 'encrypted_data': encryptedData,
      if (isComplete != null) 'is_complete': isComplete,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (syncVersion != null) 'sync_version': syncVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyReflectionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<DateTime>? date,
      Value<int?>? mood,
      Value<int?>? energy,
      Value<int?>? productivity,
      Value<String?>? gratitude,
      Value<String?>? accomplishments,
      Value<String?>? challenges,
      Value<String?>? learnings,
      Value<String?>? tomorrowGoals,
      Value<String?>? notes,
      Value<String>? tags,
      Value<bool>? isPrivate,
      Value<String?>? encryptedData,
      Value<bool>? isComplete,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<bool>? isSynced,
      Value<int?>? syncVersion,
      Value<int>? rowid}) {
    return DailyReflectionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      mood: mood ?? this.mood,
      energy: energy ?? this.energy,
      productivity: productivity ?? this.productivity,
      gratitude: gratitude ?? this.gratitude,
      accomplishments: accomplishments ?? this.accomplishments,
      challenges: challenges ?? this.challenges,
      learnings: learnings ?? this.learnings,
      tomorrowGoals: tomorrowGoals ?? this.tomorrowGoals,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      isPrivate: isPrivate ?? this.isPrivate,
      encryptedData: encryptedData ?? this.encryptedData,
      isComplete: isComplete ?? this.isComplete,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      syncVersion: syncVersion ?? this.syncVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (mood.present) {
      map['mood'] = Variable<int>(mood.value);
    }
    if (energy.present) {
      map['energy'] = Variable<int>(energy.value);
    }
    if (productivity.present) {
      map['productivity'] = Variable<int>(productivity.value);
    }
    if (gratitude.present) {
      map['gratitude'] = Variable<String>(gratitude.value);
    }
    if (accomplishments.present) {
      map['accomplishments'] = Variable<String>(accomplishments.value);
    }
    if (challenges.present) {
      map['challenges'] = Variable<String>(challenges.value);
    }
    if (learnings.present) {
      map['learnings'] = Variable<String>(learnings.value);
    }
    if (tomorrowGoals.present) {
      map['tomorrow_goals'] = Variable<String>(tomorrowGoals.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (isPrivate.present) {
      map['is_private'] = Variable<bool>(isPrivate.value);
    }
    if (encryptedData.present) {
      map['encrypted_data'] = Variable<String>(encryptedData.value);
    }
    if (isComplete.present) {
      map['is_complete'] = Variable<bool>(isComplete.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (syncVersion.present) {
      map['sync_version'] = Variable<int>(syncVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyReflectionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('date: $date, ')
          ..write('mood: $mood, ')
          ..write('energy: $energy, ')
          ..write('productivity: $productivity, ')
          ..write('gratitude: $gratitude, ')
          ..write('accomplishments: $accomplishments, ')
          ..write('challenges: $challenges, ')
          ..write('learnings: $learnings, ')
          ..write('tomorrowGoals: $tomorrowGoals, ')
          ..write('notes: $notes, ')
          ..write('tags: $tags, ')
          ..write('isPrivate: $isPrivate, ')
          ..write('encryptedData: $encryptedData, ')
          ..write('isComplete: $isComplete, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FriendshipsTable extends Friendships
    with TableInfo<$FriendshipsTable, Friendship> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FriendshipsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _requesterIdMeta =
      const VerificationMeta('requesterId');
  @override
  late final GeneratedColumn<String> requesterId = GeneratedColumn<String>(
      'requester_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _addresseeIdMeta =
      const VerificationMeta('addresseeId');
  @override
  late final GeneratedColumn<String> addresseeId = GeneratedColumn<String>(
      'addressee_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _nicknameMeta =
      const VerificationMeta('nickname');
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
      'nickname', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _acceptedAtMeta =
      const VerificationMeta('acceptedAt');
  @override
  late final GeneratedColumn<DateTime> acceptedAt = GeneratedColumn<DateTime>(
      'accepted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isFavoriteMeta =
      const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
      'is_favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isMutedMeta =
      const VerificationMeta('isMuted');
  @override
  late final GeneratedColumn<bool> isMuted = GeneratedColumn<bool>(
      'is_muted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_muted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _sharedKeyMeta =
      const VerificationMeta('sharedKey');
  @override
  late final GeneratedColumn<String> sharedKey = GeneratedColumn<String>(
      'shared_key', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        requesterId,
        addresseeId,
        status,
        nickname,
        createdAt,
        updatedAt,
        acceptedAt,
        isFavorite,
        isMuted,
        sharedKey
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'friendships';
  @override
  VerificationContext validateIntegrity(Insertable<Friendship> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('requester_id')) {
      context.handle(
          _requesterIdMeta,
          requesterId.isAcceptableOrUnknown(
              data['requester_id']!, _requesterIdMeta));
    } else if (isInserting) {
      context.missing(_requesterIdMeta);
    }
    if (data.containsKey('addressee_id')) {
      context.handle(
          _addresseeIdMeta,
          addresseeId.isAcceptableOrUnknown(
              data['addressee_id']!, _addresseeIdMeta));
    } else if (isInserting) {
      context.missing(_addresseeIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('nickname')) {
      context.handle(_nicknameMeta,
          nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('accepted_at')) {
      context.handle(
          _acceptedAtMeta,
          acceptedAt.isAcceptableOrUnknown(
              data['accepted_at']!, _acceptedAtMeta));
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
          _isFavoriteMeta,
          isFavorite.isAcceptableOrUnknown(
              data['is_favorite']!, _isFavoriteMeta));
    }
    if (data.containsKey('is_muted')) {
      context.handle(_isMutedMeta,
          isMuted.isAcceptableOrUnknown(data['is_muted']!, _isMutedMeta));
    }
    if (data.containsKey('shared_key')) {
      context.handle(_sharedKeyMeta,
          sharedKey.isAcceptableOrUnknown(data['shared_key']!, _sharedKeyMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Friendship map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Friendship(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      requesterId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}requester_id'])!,
      addresseeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}addressee_id'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      nickname: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nickname']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      acceptedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}accepted_at']),
      isFavorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
      isMuted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_muted'])!,
      sharedKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shared_key']),
    );
  }

  @override
  $FriendshipsTable createAlias(String alias) {
    return $FriendshipsTable(attachedDatabase, alias);
  }
}

class Friendship extends DataClass implements Insertable<Friendship> {
  final String id;
  final String requesterId;
  final String addresseeId;
  final String status;
  final String? nickname;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? acceptedAt;
  final bool isFavorite;
  final bool isMuted;
  final String? sharedKey;
  const Friendship(
      {required this.id,
      required this.requesterId,
      required this.addresseeId,
      required this.status,
      this.nickname,
      this.createdAt,
      this.updatedAt,
      this.acceptedAt,
      required this.isFavorite,
      required this.isMuted,
      this.sharedKey});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['requester_id'] = Variable<String>(requesterId);
    map['addressee_id'] = Variable<String>(addresseeId);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || nickname != null) {
      map['nickname'] = Variable<String>(nickname);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || acceptedAt != null) {
      map['accepted_at'] = Variable<DateTime>(acceptedAt);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['is_muted'] = Variable<bool>(isMuted);
    if (!nullToAbsent || sharedKey != null) {
      map['shared_key'] = Variable<String>(sharedKey);
    }
    return map;
  }

  FriendshipsCompanion toCompanion(bool nullToAbsent) {
    return FriendshipsCompanion(
      id: Value(id),
      requesterId: Value(requesterId),
      addresseeId: Value(addresseeId),
      status: Value(status),
      nickname: nickname == null && nullToAbsent
          ? const Value.absent()
          : Value(nickname),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      acceptedAt: acceptedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(acceptedAt),
      isFavorite: Value(isFavorite),
      isMuted: Value(isMuted),
      sharedKey: sharedKey == null && nullToAbsent
          ? const Value.absent()
          : Value(sharedKey),
    );
  }

  factory Friendship.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Friendship(
      id: serializer.fromJson<String>(json['id']),
      requesterId: serializer.fromJson<String>(json['requesterId']),
      addresseeId: serializer.fromJson<String>(json['addresseeId']),
      status: serializer.fromJson<String>(json['status']),
      nickname: serializer.fromJson<String?>(json['nickname']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      acceptedAt: serializer.fromJson<DateTime?>(json['acceptedAt']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      isMuted: serializer.fromJson<bool>(json['isMuted']),
      sharedKey: serializer.fromJson<String?>(json['sharedKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'requesterId': serializer.toJson<String>(requesterId),
      'addresseeId': serializer.toJson<String>(addresseeId),
      'status': serializer.toJson<String>(status),
      'nickname': serializer.toJson<String?>(nickname),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'acceptedAt': serializer.toJson<DateTime?>(acceptedAt),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'isMuted': serializer.toJson<bool>(isMuted),
      'sharedKey': serializer.toJson<String?>(sharedKey),
    };
  }

  Friendship copyWith(
          {String? id,
          String? requesterId,
          String? addresseeId,
          String? status,
          Value<String?> nickname = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          Value<DateTime?> acceptedAt = const Value.absent(),
          bool? isFavorite,
          bool? isMuted,
          Value<String?> sharedKey = const Value.absent()}) =>
      Friendship(
        id: id ?? this.id,
        requesterId: requesterId ?? this.requesterId,
        addresseeId: addresseeId ?? this.addresseeId,
        status: status ?? this.status,
        nickname: nickname.present ? nickname.value : this.nickname,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        acceptedAt: acceptedAt.present ? acceptedAt.value : this.acceptedAt,
        isFavorite: isFavorite ?? this.isFavorite,
        isMuted: isMuted ?? this.isMuted,
        sharedKey: sharedKey.present ? sharedKey.value : this.sharedKey,
      );
  @override
  String toString() {
    return (StringBuffer('Friendship(')
          ..write('id: $id, ')
          ..write('requesterId: $requesterId, ')
          ..write('addresseeId: $addresseeId, ')
          ..write('status: $status, ')
          ..write('nickname: $nickname, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('acceptedAt: $acceptedAt, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isMuted: $isMuted, ')
          ..write('sharedKey: $sharedKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      requesterId,
      addresseeId,
      status,
      nickname,
      createdAt,
      updatedAt,
      acceptedAt,
      isFavorite,
      isMuted,
      sharedKey);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Friendship &&
          other.id == this.id &&
          other.requesterId == this.requesterId &&
          other.addresseeId == this.addresseeId &&
          other.status == this.status &&
          other.nickname == this.nickname &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.acceptedAt == this.acceptedAt &&
          other.isFavorite == this.isFavorite &&
          other.isMuted == this.isMuted &&
          other.sharedKey == this.sharedKey);
}

class FriendshipsCompanion extends UpdateCompanion<Friendship> {
  final Value<String> id;
  final Value<String> requesterId;
  final Value<String> addresseeId;
  final Value<String> status;
  final Value<String?> nickname;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> acceptedAt;
  final Value<bool> isFavorite;
  final Value<bool> isMuted;
  final Value<String?> sharedKey;
  final Value<int> rowid;
  const FriendshipsCompanion({
    this.id = const Value.absent(),
    this.requesterId = const Value.absent(),
    this.addresseeId = const Value.absent(),
    this.status = const Value.absent(),
    this.nickname = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.acceptedAt = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isMuted = const Value.absent(),
    this.sharedKey = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FriendshipsCompanion.insert({
    required String id,
    required String requesterId,
    required String addresseeId,
    this.status = const Value.absent(),
    this.nickname = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.acceptedAt = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isMuted = const Value.absent(),
    this.sharedKey = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        requesterId = Value(requesterId),
        addresseeId = Value(addresseeId);
  static Insertable<Friendship> custom({
    Expression<String>? id,
    Expression<String>? requesterId,
    Expression<String>? addresseeId,
    Expression<String>? status,
    Expression<String>? nickname,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? acceptedAt,
    Expression<bool>? isFavorite,
    Expression<bool>? isMuted,
    Expression<String>? sharedKey,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (requesterId != null) 'requester_id': requesterId,
      if (addresseeId != null) 'addressee_id': addresseeId,
      if (status != null) 'status': status,
      if (nickname != null) 'nickname': nickname,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (acceptedAt != null) 'accepted_at': acceptedAt,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (isMuted != null) 'is_muted': isMuted,
      if (sharedKey != null) 'shared_key': sharedKey,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FriendshipsCompanion copyWith(
      {Value<String>? id,
      Value<String>? requesterId,
      Value<String>? addresseeId,
      Value<String>? status,
      Value<String?>? nickname,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<DateTime?>? acceptedAt,
      Value<bool>? isFavorite,
      Value<bool>? isMuted,
      Value<String?>? sharedKey,
      Value<int>? rowid}) {
    return FriendshipsCompanion(
      id: id ?? this.id,
      requesterId: requesterId ?? this.requesterId,
      addresseeId: addresseeId ?? this.addresseeId,
      status: status ?? this.status,
      nickname: nickname ?? this.nickname,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      isMuted: isMuted ?? this.isMuted,
      sharedKey: sharedKey ?? this.sharedKey,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (requesterId.present) {
      map['requester_id'] = Variable<String>(requesterId.value);
    }
    if (addresseeId.present) {
      map['addressee_id'] = Variable<String>(addresseeId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (acceptedAt.present) {
      map['accepted_at'] = Variable<DateTime>(acceptedAt.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (isMuted.present) {
      map['is_muted'] = Variable<bool>(isMuted.value);
    }
    if (sharedKey.present) {
      map['shared_key'] = Variable<String>(sharedKey.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FriendshipsCompanion(')
          ..write('id: $id, ')
          ..write('requesterId: $requesterId, ')
          ..write('addresseeId: $addresseeId, ')
          ..write('status: $status, ')
          ..write('nickname: $nickname, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('acceptedAt: $acceptedAt, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isMuted: $isMuted, ')
          ..write('sharedKey: $sharedKey, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PokesTable extends Pokes with TableInfo<$PokesTable, Poke> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PokesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _senderIdMeta =
      const VerificationMeta('senderId');
  @override
  late final GeneratedColumn<String> senderId = GeneratedColumn<String>(
      'sender_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _receiverIdMeta =
      const VerificationMeta('receiverId');
  @override
  late final GeneratedColumn<String> receiverId = GeneratedColumn<String>(
      'receiver_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('wave'));
  static const VerificationMeta _customMessageMeta =
      const VerificationMeta('customMessage');
  @override
  late final GeneratedColumn<String> customMessage = GeneratedColumn<String>(
      'custom_message', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
      'is_read', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_read" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _readAtMeta = const VerificationMeta('readAt');
  @override
  late final GeneratedColumn<DateTime> readAt = GeneratedColumn<DateTime>(
      'read_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        senderId,
        receiverId,
        type,
        customMessage,
        isRead,
        createdAt,
        readAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pokes';
  @override
  VerificationContext validateIntegrity(Insertable<Poke> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sender_id')) {
      context.handle(_senderIdMeta,
          senderId.isAcceptableOrUnknown(data['sender_id']!, _senderIdMeta));
    } else if (isInserting) {
      context.missing(_senderIdMeta);
    }
    if (data.containsKey('receiver_id')) {
      context.handle(
          _receiverIdMeta,
          receiverId.isAcceptableOrUnknown(
              data['receiver_id']!, _receiverIdMeta));
    } else if (isInserting) {
      context.missing(_receiverIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('custom_message')) {
      context.handle(
          _customMessageMeta,
          customMessage.isAcceptableOrUnknown(
              data['custom_message']!, _customMessageMeta));
    }
    if (data.containsKey('is_read')) {
      context.handle(_isReadMeta,
          isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('read_at')) {
      context.handle(_readAtMeta,
          readAt.isAcceptableOrUnknown(data['read_at']!, _readAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Poke map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Poke(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      senderId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sender_id'])!,
      receiverId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}receiver_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      customMessage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}custom_message']),
      isRead: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_read'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      readAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}read_at']),
    );
  }

  @override
  $PokesTable createAlias(String alias) {
    return $PokesTable(attachedDatabase, alias);
  }
}

class Poke extends DataClass implements Insertable<Poke> {
  final String id;
  final String senderId;
  final String receiverId;
  final String type;
  final String? customMessage;
  final bool isRead;
  final DateTime? createdAt;
  final DateTime? readAt;
  const Poke(
      {required this.id,
      required this.senderId,
      required this.receiverId,
      required this.type,
      this.customMessage,
      required this.isRead,
      this.createdAt,
      this.readAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sender_id'] = Variable<String>(senderId);
    map['receiver_id'] = Variable<String>(receiverId);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || customMessage != null) {
      map['custom_message'] = Variable<String>(customMessage);
    }
    map['is_read'] = Variable<bool>(isRead);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || readAt != null) {
      map['read_at'] = Variable<DateTime>(readAt);
    }
    return map;
  }

  PokesCompanion toCompanion(bool nullToAbsent) {
    return PokesCompanion(
      id: Value(id),
      senderId: Value(senderId),
      receiverId: Value(receiverId),
      type: Value(type),
      customMessage: customMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(customMessage),
      isRead: Value(isRead),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      readAt:
          readAt == null && nullToAbsent ? const Value.absent() : Value(readAt),
    );
  }

  factory Poke.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Poke(
      id: serializer.fromJson<String>(json['id']),
      senderId: serializer.fromJson<String>(json['senderId']),
      receiverId: serializer.fromJson<String>(json['receiverId']),
      type: serializer.fromJson<String>(json['type']),
      customMessage: serializer.fromJson<String?>(json['customMessage']),
      isRead: serializer.fromJson<bool>(json['isRead']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      readAt: serializer.fromJson<DateTime?>(json['readAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'senderId': serializer.toJson<String>(senderId),
      'receiverId': serializer.toJson<String>(receiverId),
      'type': serializer.toJson<String>(type),
      'customMessage': serializer.toJson<String?>(customMessage),
      'isRead': serializer.toJson<bool>(isRead),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'readAt': serializer.toJson<DateTime?>(readAt),
    };
  }

  Poke copyWith(
          {String? id,
          String? senderId,
          String? receiverId,
          String? type,
          Value<String?> customMessage = const Value.absent(),
          bool? isRead,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> readAt = const Value.absent()}) =>
      Poke(
        id: id ?? this.id,
        senderId: senderId ?? this.senderId,
        receiverId: receiverId ?? this.receiverId,
        type: type ?? this.type,
        customMessage:
            customMessage.present ? customMessage.value : this.customMessage,
        isRead: isRead ?? this.isRead,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        readAt: readAt.present ? readAt.value : this.readAt,
      );
  @override
  String toString() {
    return (StringBuffer('Poke(')
          ..write('id: $id, ')
          ..write('senderId: $senderId, ')
          ..write('receiverId: $receiverId, ')
          ..write('type: $type, ')
          ..write('customMessage: $customMessage, ')
          ..write('isRead: $isRead, ')
          ..write('createdAt: $createdAt, ')
          ..write('readAt: $readAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, senderId, receiverId, type, customMessage, isRead, createdAt, readAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Poke &&
          other.id == this.id &&
          other.senderId == this.senderId &&
          other.receiverId == this.receiverId &&
          other.type == this.type &&
          other.customMessage == this.customMessage &&
          other.isRead == this.isRead &&
          other.createdAt == this.createdAt &&
          other.readAt == this.readAt);
}

class PokesCompanion extends UpdateCompanion<Poke> {
  final Value<String> id;
  final Value<String> senderId;
  final Value<String> receiverId;
  final Value<String> type;
  final Value<String?> customMessage;
  final Value<bool> isRead;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> readAt;
  final Value<int> rowid;
  const PokesCompanion({
    this.id = const Value.absent(),
    this.senderId = const Value.absent(),
    this.receiverId = const Value.absent(),
    this.type = const Value.absent(),
    this.customMessage = const Value.absent(),
    this.isRead = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.readAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PokesCompanion.insert({
    required String id,
    required String senderId,
    required String receiverId,
    this.type = const Value.absent(),
    this.customMessage = const Value.absent(),
    this.isRead = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.readAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        senderId = Value(senderId),
        receiverId = Value(receiverId);
  static Insertable<Poke> custom({
    Expression<String>? id,
    Expression<String>? senderId,
    Expression<String>? receiverId,
    Expression<String>? type,
    Expression<String>? customMessage,
    Expression<bool>? isRead,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? readAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (senderId != null) 'sender_id': senderId,
      if (receiverId != null) 'receiver_id': receiverId,
      if (type != null) 'type': type,
      if (customMessage != null) 'custom_message': customMessage,
      if (isRead != null) 'is_read': isRead,
      if (createdAt != null) 'created_at': createdAt,
      if (readAt != null) 'read_at': readAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PokesCompanion copyWith(
      {Value<String>? id,
      Value<String>? senderId,
      Value<String>? receiverId,
      Value<String>? type,
      Value<String?>? customMessage,
      Value<bool>? isRead,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? readAt,
      Value<int>? rowid}) {
    return PokesCompanion(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      type: type ?? this.type,
      customMessage: customMessage ?? this.customMessage,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<String>(senderId.value);
    }
    if (receiverId.present) {
      map['receiver_id'] = Variable<String>(receiverId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (customMessage.present) {
      map['custom_message'] = Variable<String>(customMessage.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (readAt.present) {
      map['read_at'] = Variable<DateTime>(readAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PokesCompanion(')
          ..write('id: $id, ')
          ..write('senderId: $senderId, ')
          ..write('receiverId: $receiverId, ')
          ..write('type: $type, ')
          ..write('customMessage: $customMessage, ')
          ..write('isRead: $isRead, ')
          ..write('createdAt: $createdAt, ')
          ..write('readAt: $readAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EventSharesTable extends EventShares
    with TableInfo<$EventSharesTable, EventShare> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventSharesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _eventIdMeta =
      const VerificationMeta('eventId');
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
      'event_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sharedByUserIdMeta =
      const VerificationMeta('sharedByUserId');
  @override
  late final GeneratedColumn<String> sharedByUserId = GeneratedColumn<String>(
      'shared_by_user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sharedWithUserIdMeta =
      const VerificationMeta('sharedWithUserId');
  @override
  late final GeneratedColumn<String> sharedWithUserId = GeneratedColumn<String>(
      'shared_with_user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _permissionMeta =
      const VerificationMeta('permission');
  @override
  late final GeneratedColumn<String> permission = GeneratedColumn<String>(
      'permission', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('view'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _messageMeta =
      const VerificationMeta('message');
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
      'message', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _encryptedEventDataMeta =
      const VerificationMeta('encryptedEventData');
  @override
  late final GeneratedColumn<String> encryptedEventData =
      GeneratedColumn<String>('encrypted_event_data', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _acceptedAtMeta =
      const VerificationMeta('acceptedAt');
  @override
  late final GeneratedColumn<DateTime> acceptedAt = GeneratedColumn<DateTime>(
      'accepted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _expiresAtMeta =
      const VerificationMeta('expiresAt');
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
      'expires_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        eventId,
        sharedByUserId,
        sharedWithUserId,
        permission,
        status,
        message,
        encryptedEventData,
        createdAt,
        acceptedAt,
        expiresAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'event_shares';
  @override
  VerificationContext validateIntegrity(Insertable<EventShare> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('event_id')) {
      context.handle(_eventIdMeta,
          eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta));
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('shared_by_user_id')) {
      context.handle(
          _sharedByUserIdMeta,
          sharedByUserId.isAcceptableOrUnknown(
              data['shared_by_user_id']!, _sharedByUserIdMeta));
    } else if (isInserting) {
      context.missing(_sharedByUserIdMeta);
    }
    if (data.containsKey('shared_with_user_id')) {
      context.handle(
          _sharedWithUserIdMeta,
          sharedWithUserId.isAcceptableOrUnknown(
              data['shared_with_user_id']!, _sharedWithUserIdMeta));
    } else if (isInserting) {
      context.missing(_sharedWithUserIdMeta);
    }
    if (data.containsKey('permission')) {
      context.handle(
          _permissionMeta,
          permission.isAcceptableOrUnknown(
              data['permission']!, _permissionMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('message')) {
      context.handle(_messageMeta,
          message.isAcceptableOrUnknown(data['message']!, _messageMeta));
    }
    if (data.containsKey('encrypted_event_data')) {
      context.handle(
          _encryptedEventDataMeta,
          encryptedEventData.isAcceptableOrUnknown(
              data['encrypted_event_data']!, _encryptedEventDataMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('accepted_at')) {
      context.handle(
          _acceptedAtMeta,
          acceptedAt.isAcceptableOrUnknown(
              data['accepted_at']!, _acceptedAtMeta));
    }
    if (data.containsKey('expires_at')) {
      context.handle(_expiresAtMeta,
          expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventShare map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventShare(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      eventId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_id'])!,
      sharedByUserId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}shared_by_user_id'])!,
      sharedWithUserId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}shared_with_user_id'])!,
      permission: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}permission'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      message: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message']),
      encryptedEventData: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}encrypted_event_data']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      acceptedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}accepted_at']),
      expiresAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expires_at']),
    );
  }

  @override
  $EventSharesTable createAlias(String alias) {
    return $EventSharesTable(attachedDatabase, alias);
  }
}

class EventShare extends DataClass implements Insertable<EventShare> {
  final String id;
  final String eventId;
  final String sharedByUserId;
  final String sharedWithUserId;
  final String permission;
  final String status;
  final String? message;
  final String? encryptedEventData;
  final DateTime? createdAt;
  final DateTime? acceptedAt;
  final DateTime? expiresAt;
  const EventShare(
      {required this.id,
      required this.eventId,
      required this.sharedByUserId,
      required this.sharedWithUserId,
      required this.permission,
      required this.status,
      this.message,
      this.encryptedEventData,
      this.createdAt,
      this.acceptedAt,
      this.expiresAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['event_id'] = Variable<String>(eventId);
    map['shared_by_user_id'] = Variable<String>(sharedByUserId);
    map['shared_with_user_id'] = Variable<String>(sharedWithUserId);
    map['permission'] = Variable<String>(permission);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || message != null) {
      map['message'] = Variable<String>(message);
    }
    if (!nullToAbsent || encryptedEventData != null) {
      map['encrypted_event_data'] = Variable<String>(encryptedEventData);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || acceptedAt != null) {
      map['accepted_at'] = Variable<DateTime>(acceptedAt);
    }
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    return map;
  }

  EventSharesCompanion toCompanion(bool nullToAbsent) {
    return EventSharesCompanion(
      id: Value(id),
      eventId: Value(eventId),
      sharedByUserId: Value(sharedByUserId),
      sharedWithUserId: Value(sharedWithUserId),
      permission: Value(permission),
      status: Value(status),
      message: message == null && nullToAbsent
          ? const Value.absent()
          : Value(message),
      encryptedEventData: encryptedEventData == null && nullToAbsent
          ? const Value.absent()
          : Value(encryptedEventData),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      acceptedAt: acceptedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(acceptedAt),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
    );
  }

  factory EventShare.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventShare(
      id: serializer.fromJson<String>(json['id']),
      eventId: serializer.fromJson<String>(json['eventId']),
      sharedByUserId: serializer.fromJson<String>(json['sharedByUserId']),
      sharedWithUserId: serializer.fromJson<String>(json['sharedWithUserId']),
      permission: serializer.fromJson<String>(json['permission']),
      status: serializer.fromJson<String>(json['status']),
      message: serializer.fromJson<String?>(json['message']),
      encryptedEventData:
          serializer.fromJson<String?>(json['encryptedEventData']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      acceptedAt: serializer.fromJson<DateTime?>(json['acceptedAt']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'eventId': serializer.toJson<String>(eventId),
      'sharedByUserId': serializer.toJson<String>(sharedByUserId),
      'sharedWithUserId': serializer.toJson<String>(sharedWithUserId),
      'permission': serializer.toJson<String>(permission),
      'status': serializer.toJson<String>(status),
      'message': serializer.toJson<String?>(message),
      'encryptedEventData': serializer.toJson<String?>(encryptedEventData),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'acceptedAt': serializer.toJson<DateTime?>(acceptedAt),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
    };
  }

  EventShare copyWith(
          {String? id,
          String? eventId,
          String? sharedByUserId,
          String? sharedWithUserId,
          String? permission,
          String? status,
          Value<String?> message = const Value.absent(),
          Value<String?> encryptedEventData = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> acceptedAt = const Value.absent(),
          Value<DateTime?> expiresAt = const Value.absent()}) =>
      EventShare(
        id: id ?? this.id,
        eventId: eventId ?? this.eventId,
        sharedByUserId: sharedByUserId ?? this.sharedByUserId,
        sharedWithUserId: sharedWithUserId ?? this.sharedWithUserId,
        permission: permission ?? this.permission,
        status: status ?? this.status,
        message: message.present ? message.value : this.message,
        encryptedEventData: encryptedEventData.present
            ? encryptedEventData.value
            : this.encryptedEventData,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        acceptedAt: acceptedAt.present ? acceptedAt.value : this.acceptedAt,
        expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
      );
  @override
  String toString() {
    return (StringBuffer('EventShare(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('sharedByUserId: $sharedByUserId, ')
          ..write('sharedWithUserId: $sharedWithUserId, ')
          ..write('permission: $permission, ')
          ..write('status: $status, ')
          ..write('message: $message, ')
          ..write('encryptedEventData: $encryptedEventData, ')
          ..write('createdAt: $createdAt, ')
          ..write('acceptedAt: $acceptedAt, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      eventId,
      sharedByUserId,
      sharedWithUserId,
      permission,
      status,
      message,
      encryptedEventData,
      createdAt,
      acceptedAt,
      expiresAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventShare &&
          other.id == this.id &&
          other.eventId == this.eventId &&
          other.sharedByUserId == this.sharedByUserId &&
          other.sharedWithUserId == this.sharedWithUserId &&
          other.permission == this.permission &&
          other.status == this.status &&
          other.message == this.message &&
          other.encryptedEventData == this.encryptedEventData &&
          other.createdAt == this.createdAt &&
          other.acceptedAt == this.acceptedAt &&
          other.expiresAt == this.expiresAt);
}

class EventSharesCompanion extends UpdateCompanion<EventShare> {
  final Value<String> id;
  final Value<String> eventId;
  final Value<String> sharedByUserId;
  final Value<String> sharedWithUserId;
  final Value<String> permission;
  final Value<String> status;
  final Value<String?> message;
  final Value<String?> encryptedEventData;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> acceptedAt;
  final Value<DateTime?> expiresAt;
  final Value<int> rowid;
  const EventSharesCompanion({
    this.id = const Value.absent(),
    this.eventId = const Value.absent(),
    this.sharedByUserId = const Value.absent(),
    this.sharedWithUserId = const Value.absent(),
    this.permission = const Value.absent(),
    this.status = const Value.absent(),
    this.message = const Value.absent(),
    this.encryptedEventData = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.acceptedAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventSharesCompanion.insert({
    required String id,
    required String eventId,
    required String sharedByUserId,
    required String sharedWithUserId,
    this.permission = const Value.absent(),
    this.status = const Value.absent(),
    this.message = const Value.absent(),
    this.encryptedEventData = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.acceptedAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        eventId = Value(eventId),
        sharedByUserId = Value(sharedByUserId),
        sharedWithUserId = Value(sharedWithUserId);
  static Insertable<EventShare> custom({
    Expression<String>? id,
    Expression<String>? eventId,
    Expression<String>? sharedByUserId,
    Expression<String>? sharedWithUserId,
    Expression<String>? permission,
    Expression<String>? status,
    Expression<String>? message,
    Expression<String>? encryptedEventData,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? acceptedAt,
    Expression<DateTime>? expiresAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventId != null) 'event_id': eventId,
      if (sharedByUserId != null) 'shared_by_user_id': sharedByUserId,
      if (sharedWithUserId != null) 'shared_with_user_id': sharedWithUserId,
      if (permission != null) 'permission': permission,
      if (status != null) 'status': status,
      if (message != null) 'message': message,
      if (encryptedEventData != null)
        'encrypted_event_data': encryptedEventData,
      if (createdAt != null) 'created_at': createdAt,
      if (acceptedAt != null) 'accepted_at': acceptedAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventSharesCompanion copyWith(
      {Value<String>? id,
      Value<String>? eventId,
      Value<String>? sharedByUserId,
      Value<String>? sharedWithUserId,
      Value<String>? permission,
      Value<String>? status,
      Value<String?>? message,
      Value<String?>? encryptedEventData,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? acceptedAt,
      Value<DateTime?>? expiresAt,
      Value<int>? rowid}) {
    return EventSharesCompanion(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      sharedByUserId: sharedByUserId ?? this.sharedByUserId,
      sharedWithUserId: sharedWithUserId ?? this.sharedWithUserId,
      permission: permission ?? this.permission,
      status: status ?? this.status,
      message: message ?? this.message,
      encryptedEventData: encryptedEventData ?? this.encryptedEventData,
      createdAt: createdAt ?? this.createdAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (sharedByUserId.present) {
      map['shared_by_user_id'] = Variable<String>(sharedByUserId.value);
    }
    if (sharedWithUserId.present) {
      map['shared_with_user_id'] = Variable<String>(sharedWithUserId.value);
    }
    if (permission.present) {
      map['permission'] = Variable<String>(permission.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (encryptedEventData.present) {
      map['encrypted_event_data'] = Variable<String>(encryptedEventData.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (acceptedAt.present) {
      map['accepted_at'] = Variable<DateTime>(acceptedAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventSharesCompanion(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('sharedByUserId: $sharedByUserId, ')
          ..write('sharedWithUserId: $sharedWithUserId, ')
          ..write('permission: $permission, ')
          ..write('status: $status, ')
          ..write('message: $message, ')
          ..write('encryptedEventData: $encryptedEventData, ')
          ..write('createdAt: $createdAt, ')
          ..write('acceptedAt: $acceptedAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InboxMessagesTable extends InboxMessages
    with TableInfo<$InboxMessagesTable, InboxMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InboxMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _senderIdMeta =
      const VerificationMeta('senderId');
  @override
  late final GeneratedColumn<String> senderId = GeneratedColumn<String>(
      'sender_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
      'priority', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('normal'));
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
      'is_read', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_read" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isArchivedMeta =
      const VerificationMeta('isArchived');
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_archived" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _actionUrlMeta =
      const VerificationMeta('actionUrl');
  @override
  late final GeneratedColumn<String> actionUrl = GeneratedColumn<String>(
      'action_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _actionsMeta =
      const VerificationMeta('actions');
  @override
  late final GeneratedColumn<String> actions = GeneratedColumn<String>(
      'actions', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _readAtMeta = const VerificationMeta('readAt');
  @override
  late final GeneratedColumn<DateTime> readAt = GeneratedColumn<DateTime>(
      'read_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _expiresAtMeta =
      const VerificationMeta('expiresAt');
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
      'expires_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        type,
        title,
        body,
        senderId,
        priority,
        isRead,
        isArchived,
        isDeleted,
        data,
        actionUrl,
        actions,
        createdAt,
        readAt,
        expiresAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inbox_messages';
  @override
  VerificationContext validateIntegrity(Insertable<InboxMessage> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    }
    if (data.containsKey('sender_id')) {
      context.handle(_senderIdMeta,
          senderId.isAcceptableOrUnknown(data['sender_id']!, _senderIdMeta));
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    if (data.containsKey('is_read')) {
      context.handle(_isReadMeta,
          isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta));
    }
    if (data.containsKey('is_archived')) {
      context.handle(
          _isArchivedMeta,
          isArchived.isAcceptableOrUnknown(
              data['is_archived']!, _isArchivedMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    }
    if (data.containsKey('action_url')) {
      context.handle(_actionUrlMeta,
          actionUrl.isAcceptableOrUnknown(data['action_url']!, _actionUrlMeta));
    }
    if (data.containsKey('actions')) {
      context.handle(_actionsMeta,
          actions.isAcceptableOrUnknown(data['actions']!, _actionsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('read_at')) {
      context.handle(_readAtMeta,
          readAt.isAcceptableOrUnknown(data['read_at']!, _readAtMeta));
    }
    if (data.containsKey('expires_at')) {
      context.handle(_expiresAtMeta,
          expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InboxMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InboxMessage(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body']),
      senderId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sender_id']),
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}priority'])!,
      isRead: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_read'])!,
      isArchived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_archived'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data']),
      actionUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action_url']),
      actions: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}actions']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      readAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}read_at']),
      expiresAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expires_at']),
    );
  }

  @override
  $InboxMessagesTable createAlias(String alias) {
    return $InboxMessagesTable(attachedDatabase, alias);
  }
}

class InboxMessage extends DataClass implements Insertable<InboxMessage> {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String? body;
  final String? senderId;
  final String priority;
  final bool isRead;
  final bool isArchived;
  final bool isDeleted;
  final String? data;
  final String? actionUrl;
  final String? actions;
  final DateTime? createdAt;
  final DateTime? readAt;
  final DateTime? expiresAt;
  const InboxMessage(
      {required this.id,
      required this.userId,
      required this.type,
      required this.title,
      this.body,
      this.senderId,
      required this.priority,
      required this.isRead,
      required this.isArchived,
      required this.isDeleted,
      this.data,
      this.actionUrl,
      this.actions,
      this.createdAt,
      this.readAt,
      this.expiresAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['type'] = Variable<String>(type);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || body != null) {
      map['body'] = Variable<String>(body);
    }
    if (!nullToAbsent || senderId != null) {
      map['sender_id'] = Variable<String>(senderId);
    }
    map['priority'] = Variable<String>(priority);
    map['is_read'] = Variable<bool>(isRead);
    map['is_archived'] = Variable<bool>(isArchived);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || data != null) {
      map['data'] = Variable<String>(data);
    }
    if (!nullToAbsent || actionUrl != null) {
      map['action_url'] = Variable<String>(actionUrl);
    }
    if (!nullToAbsent || actions != null) {
      map['actions'] = Variable<String>(actions);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || readAt != null) {
      map['read_at'] = Variable<DateTime>(readAt);
    }
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    return map;
  }

  InboxMessagesCompanion toCompanion(bool nullToAbsent) {
    return InboxMessagesCompanion(
      id: Value(id),
      userId: Value(userId),
      type: Value(type),
      title: Value(title),
      body: body == null && nullToAbsent ? const Value.absent() : Value(body),
      senderId: senderId == null && nullToAbsent
          ? const Value.absent()
          : Value(senderId),
      priority: Value(priority),
      isRead: Value(isRead),
      isArchived: Value(isArchived),
      isDeleted: Value(isDeleted),
      data: data == null && nullToAbsent ? const Value.absent() : Value(data),
      actionUrl: actionUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(actionUrl),
      actions: actions == null && nullToAbsent
          ? const Value.absent()
          : Value(actions),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      readAt:
          readAt == null && nullToAbsent ? const Value.absent() : Value(readAt),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
    );
  }

  factory InboxMessage.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InboxMessage(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String?>(json['body']),
      senderId: serializer.fromJson<String?>(json['senderId']),
      priority: serializer.fromJson<String>(json['priority']),
      isRead: serializer.fromJson<bool>(json['isRead']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      data: serializer.fromJson<String?>(json['data']),
      actionUrl: serializer.fromJson<String?>(json['actionUrl']),
      actions: serializer.fromJson<String?>(json['actions']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      readAt: serializer.fromJson<DateTime?>(json['readAt']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String?>(body),
      'senderId': serializer.toJson<String?>(senderId),
      'priority': serializer.toJson<String>(priority),
      'isRead': serializer.toJson<bool>(isRead),
      'isArchived': serializer.toJson<bool>(isArchived),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'data': serializer.toJson<String?>(data),
      'actionUrl': serializer.toJson<String?>(actionUrl),
      'actions': serializer.toJson<String?>(actions),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'readAt': serializer.toJson<DateTime?>(readAt),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
    };
  }

  InboxMessage copyWith(
          {String? id,
          String? userId,
          String? type,
          String? title,
          Value<String?> body = const Value.absent(),
          Value<String?> senderId = const Value.absent(),
          String? priority,
          bool? isRead,
          bool? isArchived,
          bool? isDeleted,
          Value<String?> data = const Value.absent(),
          Value<String?> actionUrl = const Value.absent(),
          Value<String?> actions = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> readAt = const Value.absent(),
          Value<DateTime?> expiresAt = const Value.absent()}) =>
      InboxMessage(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        type: type ?? this.type,
        title: title ?? this.title,
        body: body.present ? body.value : this.body,
        senderId: senderId.present ? senderId.value : this.senderId,
        priority: priority ?? this.priority,
        isRead: isRead ?? this.isRead,
        isArchived: isArchived ?? this.isArchived,
        isDeleted: isDeleted ?? this.isDeleted,
        data: data.present ? data.value : this.data,
        actionUrl: actionUrl.present ? actionUrl.value : this.actionUrl,
        actions: actions.present ? actions.value : this.actions,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        readAt: readAt.present ? readAt.value : this.readAt,
        expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
      );
  @override
  String toString() {
    return (StringBuffer('InboxMessage(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('senderId: $senderId, ')
          ..write('priority: $priority, ')
          ..write('isRead: $isRead, ')
          ..write('isArchived: $isArchived, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('data: $data, ')
          ..write('actionUrl: $actionUrl, ')
          ..write('actions: $actions, ')
          ..write('createdAt: $createdAt, ')
          ..write('readAt: $readAt, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userId,
      type,
      title,
      body,
      senderId,
      priority,
      isRead,
      isArchived,
      isDeleted,
      data,
      actionUrl,
      actions,
      createdAt,
      readAt,
      expiresAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InboxMessage &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.type == this.type &&
          other.title == this.title &&
          other.body == this.body &&
          other.senderId == this.senderId &&
          other.priority == this.priority &&
          other.isRead == this.isRead &&
          other.isArchived == this.isArchived &&
          other.isDeleted == this.isDeleted &&
          other.data == this.data &&
          other.actionUrl == this.actionUrl &&
          other.actions == this.actions &&
          other.createdAt == this.createdAt &&
          other.readAt == this.readAt &&
          other.expiresAt == this.expiresAt);
}

class InboxMessagesCompanion extends UpdateCompanion<InboxMessage> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> type;
  final Value<String> title;
  final Value<String?> body;
  final Value<String?> senderId;
  final Value<String> priority;
  final Value<bool> isRead;
  final Value<bool> isArchived;
  final Value<bool> isDeleted;
  final Value<String?> data;
  final Value<String?> actionUrl;
  final Value<String?> actions;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> readAt;
  final Value<DateTime?> expiresAt;
  final Value<int> rowid;
  const InboxMessagesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.senderId = const Value.absent(),
    this.priority = const Value.absent(),
    this.isRead = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.data = const Value.absent(),
    this.actionUrl = const Value.absent(),
    this.actions = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.readAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InboxMessagesCompanion.insert({
    required String id,
    required String userId,
    required String type,
    required String title,
    this.body = const Value.absent(),
    this.senderId = const Value.absent(),
    this.priority = const Value.absent(),
    this.isRead = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.data = const Value.absent(),
    this.actionUrl = const Value.absent(),
    this.actions = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.readAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        type = Value(type),
        title = Value(title);
  static Insertable<InboxMessage> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? senderId,
    Expression<String>? priority,
    Expression<bool>? isRead,
    Expression<bool>? isArchived,
    Expression<bool>? isDeleted,
    Expression<String>? data,
    Expression<String>? actionUrl,
    Expression<String>? actions,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? readAt,
    Expression<DateTime>? expiresAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (senderId != null) 'sender_id': senderId,
      if (priority != null) 'priority': priority,
      if (isRead != null) 'is_read': isRead,
      if (isArchived != null) 'is_archived': isArchived,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (data != null) 'data': data,
      if (actionUrl != null) 'action_url': actionUrl,
      if (actions != null) 'actions': actions,
      if (createdAt != null) 'created_at': createdAt,
      if (readAt != null) 'read_at': readAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InboxMessagesCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? type,
      Value<String>? title,
      Value<String?>? body,
      Value<String?>? senderId,
      Value<String>? priority,
      Value<bool>? isRead,
      Value<bool>? isArchived,
      Value<bool>? isDeleted,
      Value<String?>? data,
      Value<String?>? actionUrl,
      Value<String?>? actions,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? readAt,
      Value<DateTime?>? expiresAt,
      Value<int>? rowid}) {
    return InboxMessagesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      senderId: senderId ?? this.senderId,
      priority: priority ?? this.priority,
      isRead: isRead ?? this.isRead,
      isArchived: isArchived ?? this.isArchived,
      isDeleted: isDeleted ?? this.isDeleted,
      data: data ?? this.data,
      actionUrl: actionUrl ?? this.actionUrl,
      actions: actions ?? this.actions,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      expiresAt: expiresAt ?? this.expiresAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<String>(senderId.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (actionUrl.present) {
      map['action_url'] = Variable<String>(actionUrl.value);
    }
    if (actions.present) {
      map['actions'] = Variable<String>(actions.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (readAt.present) {
      map['read_at'] = Variable<DateTime>(readAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InboxMessagesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('senderId: $senderId, ')
          ..write('priority: $priority, ')
          ..write('isRead: $isRead, ')
          ..write('isArchived: $isArchived, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('data: $data, ')
          ..write('actionUrl: $actionUrl, ')
          ..write('actions: $actions, ')
          ..write('createdAt: $createdAt, ')
          ..write('readAt: $readAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StreaksTable extends Streaks with TableInfo<$StreaksTable, Streak> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StreaksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _currentStreakMeta =
      const VerificationMeta('currentStreak');
  @override
  late final GeneratedColumn<int> currentStreak = GeneratedColumn<int>(
      'current_streak', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _longestStreakMeta =
      const VerificationMeta('longestStreak');
  @override
  late final GeneratedColumn<int> longestStreak = GeneratedColumn<int>(
      'longest_streak', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastReflectionDateMeta =
      const VerificationMeta('lastReflectionDate');
  @override
  late final GeneratedColumn<DateTime> lastReflectionDate =
      GeneratedColumn<DateTime>('last_reflection_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _streakStartDateMeta =
      const VerificationMeta('streakStartDate');
  @override
  late final GeneratedColumn<DateTime> streakStartDate =
      GeneratedColumn<DateTime>('streak_start_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _totalReflectionsMeta =
      const VerificationMeta('totalReflections');
  @override
  late final GeneratedColumn<int> totalReflections = GeneratedColumn<int>(
      'total_reflections', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _milestonesMeta =
      const VerificationMeta('milestones');
  @override
  late final GeneratedColumn<String> milestones = GeneratedColumn<String>(
      'milestones', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        currentStreak,
        longestStreak,
        lastReflectionDate,
        streakStartDate,
        totalReflections,
        milestones,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'streaks';
  @override
  VerificationContext validateIntegrity(Insertable<Streak> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('current_streak')) {
      context.handle(
          _currentStreakMeta,
          currentStreak.isAcceptableOrUnknown(
              data['current_streak']!, _currentStreakMeta));
    }
    if (data.containsKey('longest_streak')) {
      context.handle(
          _longestStreakMeta,
          longestStreak.isAcceptableOrUnknown(
              data['longest_streak']!, _longestStreakMeta));
    }
    if (data.containsKey('last_reflection_date')) {
      context.handle(
          _lastReflectionDateMeta,
          lastReflectionDate.isAcceptableOrUnknown(
              data['last_reflection_date']!, _lastReflectionDateMeta));
    }
    if (data.containsKey('streak_start_date')) {
      context.handle(
          _streakStartDateMeta,
          streakStartDate.isAcceptableOrUnknown(
              data['streak_start_date']!, _streakStartDateMeta));
    }
    if (data.containsKey('total_reflections')) {
      context.handle(
          _totalReflectionsMeta,
          totalReflections.isAcceptableOrUnknown(
              data['total_reflections']!, _totalReflectionsMeta));
    }
    if (data.containsKey('milestones')) {
      context.handle(
          _milestonesMeta,
          milestones.isAcceptableOrUnknown(
              data['milestones']!, _milestonesMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Streak map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Streak(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      currentStreak: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_streak'])!,
      longestStreak: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}longest_streak'])!,
      lastReflectionDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}last_reflection_date']),
      streakStartDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}streak_start_date']),
      totalReflections: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_reflections'])!,
      milestones: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}milestones'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $StreaksTable createAlias(String alias) {
    return $StreaksTable(attachedDatabase, alias);
  }
}

class Streak extends DataClass implements Insertable<Streak> {
  final String id;
  final String userId;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastReflectionDate;
  final DateTime? streakStartDate;
  final int totalReflections;
  final String milestones;
  final DateTime? updatedAt;
  const Streak(
      {required this.id,
      required this.userId,
      required this.currentStreak,
      required this.longestStreak,
      this.lastReflectionDate,
      this.streakStartDate,
      required this.totalReflections,
      required this.milestones,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['current_streak'] = Variable<int>(currentStreak);
    map['longest_streak'] = Variable<int>(longestStreak);
    if (!nullToAbsent || lastReflectionDate != null) {
      map['last_reflection_date'] = Variable<DateTime>(lastReflectionDate);
    }
    if (!nullToAbsent || streakStartDate != null) {
      map['streak_start_date'] = Variable<DateTime>(streakStartDate);
    }
    map['total_reflections'] = Variable<int>(totalReflections);
    map['milestones'] = Variable<String>(milestones);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  StreaksCompanion toCompanion(bool nullToAbsent) {
    return StreaksCompanion(
      id: Value(id),
      userId: Value(userId),
      currentStreak: Value(currentStreak),
      longestStreak: Value(longestStreak),
      lastReflectionDate: lastReflectionDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReflectionDate),
      streakStartDate: streakStartDate == null && nullToAbsent
          ? const Value.absent()
          : Value(streakStartDate),
      totalReflections: Value(totalReflections),
      milestones: Value(milestones),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Streak.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Streak(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      currentStreak: serializer.fromJson<int>(json['currentStreak']),
      longestStreak: serializer.fromJson<int>(json['longestStreak']),
      lastReflectionDate:
          serializer.fromJson<DateTime?>(json['lastReflectionDate']),
      streakStartDate: serializer.fromJson<DateTime?>(json['streakStartDate']),
      totalReflections: serializer.fromJson<int>(json['totalReflections']),
      milestones: serializer.fromJson<String>(json['milestones']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'currentStreak': serializer.toJson<int>(currentStreak),
      'longestStreak': serializer.toJson<int>(longestStreak),
      'lastReflectionDate': serializer.toJson<DateTime?>(lastReflectionDate),
      'streakStartDate': serializer.toJson<DateTime?>(streakStartDate),
      'totalReflections': serializer.toJson<int>(totalReflections),
      'milestones': serializer.toJson<String>(milestones),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Streak copyWith(
          {String? id,
          String? userId,
          int? currentStreak,
          int? longestStreak,
          Value<DateTime?> lastReflectionDate = const Value.absent(),
          Value<DateTime?> streakStartDate = const Value.absent(),
          int? totalReflections,
          String? milestones,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      Streak(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        currentStreak: currentStreak ?? this.currentStreak,
        longestStreak: longestStreak ?? this.longestStreak,
        lastReflectionDate: lastReflectionDate.present
            ? lastReflectionDate.value
            : this.lastReflectionDate,
        streakStartDate: streakStartDate.present
            ? streakStartDate.value
            : this.streakStartDate,
        totalReflections: totalReflections ?? this.totalReflections,
        milestones: milestones ?? this.milestones,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('Streak(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('lastReflectionDate: $lastReflectionDate, ')
          ..write('streakStartDate: $streakStartDate, ')
          ..write('totalReflections: $totalReflections, ')
          ..write('milestones: $milestones, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userId,
      currentStreak,
      longestStreak,
      lastReflectionDate,
      streakStartDate,
      totalReflections,
      milestones,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Streak &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.currentStreak == this.currentStreak &&
          other.longestStreak == this.longestStreak &&
          other.lastReflectionDate == this.lastReflectionDate &&
          other.streakStartDate == this.streakStartDate &&
          other.totalReflections == this.totalReflections &&
          other.milestones == this.milestones &&
          other.updatedAt == this.updatedAt);
}

class StreaksCompanion extends UpdateCompanion<Streak> {
  final Value<String> id;
  final Value<String> userId;
  final Value<int> currentStreak;
  final Value<int> longestStreak;
  final Value<DateTime?> lastReflectionDate;
  final Value<DateTime?> streakStartDate;
  final Value<int> totalReflections;
  final Value<String> milestones;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const StreaksCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.longestStreak = const Value.absent(),
    this.lastReflectionDate = const Value.absent(),
    this.streakStartDate = const Value.absent(),
    this.totalReflections = const Value.absent(),
    this.milestones = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StreaksCompanion.insert({
    required String id,
    required String userId,
    this.currentStreak = const Value.absent(),
    this.longestStreak = const Value.absent(),
    this.lastReflectionDate = const Value.absent(),
    this.streakStartDate = const Value.absent(),
    this.totalReflections = const Value.absent(),
    this.milestones = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId);
  static Insertable<Streak> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<int>? currentStreak,
    Expression<int>? longestStreak,
    Expression<DateTime>? lastReflectionDate,
    Expression<DateTime>? streakStartDate,
    Expression<int>? totalReflections,
    Expression<String>? milestones,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (currentStreak != null) 'current_streak': currentStreak,
      if (longestStreak != null) 'longest_streak': longestStreak,
      if (lastReflectionDate != null)
        'last_reflection_date': lastReflectionDate,
      if (streakStartDate != null) 'streak_start_date': streakStartDate,
      if (totalReflections != null) 'total_reflections': totalReflections,
      if (milestones != null) 'milestones': milestones,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StreaksCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<int>? currentStreak,
      Value<int>? longestStreak,
      Value<DateTime?>? lastReflectionDate,
      Value<DateTime?>? streakStartDate,
      Value<int>? totalReflections,
      Value<String>? milestones,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return StreaksCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastReflectionDate: lastReflectionDate ?? this.lastReflectionDate,
      streakStartDate: streakStartDate ?? this.streakStartDate,
      totalReflections: totalReflections ?? this.totalReflections,
      milestones: milestones ?? this.milestones,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (currentStreak.present) {
      map['current_streak'] = Variable<int>(currentStreak.value);
    }
    if (longestStreak.present) {
      map['longest_streak'] = Variable<int>(longestStreak.value);
    }
    if (lastReflectionDate.present) {
      map['last_reflection_date'] =
          Variable<DateTime>(lastReflectionDate.value);
    }
    if (streakStartDate.present) {
      map['streak_start_date'] = Variable<DateTime>(streakStartDate.value);
    }
    if (totalReflections.present) {
      map['total_reflections'] = Variable<int>(totalReflections.value);
    }
    if (milestones.present) {
      map['milestones'] = Variable<String>(milestones.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StreaksCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('lastReflectionDate: $lastReflectionDate, ')
          ..write('streakStartDate: $streakStartDate, ')
          ..write('totalReflections: $totalReflections, ')
          ..write('milestones: $milestones, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _avatarUrlMeta =
      const VerificationMeta('avatarUrl');
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
      'avatar_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isOnlineMeta =
      const VerificationMeta('isOnline');
  @override
  late final GeneratedColumn<bool> isOnline = GeneratedColumn<bool>(
      'is_online', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_online" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _lastSeenAtMeta =
      const VerificationMeta('lastSeenAt');
  @override
  late final GeneratedColumn<DateTime> lastSeenAt = GeneratedColumn<DateTime>(
      'last_seen_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _cachedAtMeta =
      const VerificationMeta('cachedAt');
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
      'cached_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, displayName, avatarUrl, isOnline, lastSeenAt, cachedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<UserProfile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('avatar_url')) {
      context.handle(_avatarUrlMeta,
          avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta));
    }
    if (data.containsKey('is_online')) {
      context.handle(_isOnlineMeta,
          isOnline.isAcceptableOrUnknown(data['is_online']!, _isOnlineMeta));
    }
    if (data.containsKey('last_seen_at')) {
      context.handle(
          _lastSeenAtMeta,
          lastSeenAt.isAcceptableOrUnknown(
              data['last_seen_at']!, _lastSeenAtMeta));
    }
    if (data.containsKey('cached_at')) {
      context.handle(_cachedAtMeta,
          cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta));
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name'])!,
      avatarUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_url']),
      isOnline: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_online'])!,
      lastSeenAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_seen_at']),
      cachedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}cached_at'])!,
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  final String id;
  final String displayName;
  final String? avatarUrl;
  final bool isOnline;
  final DateTime? lastSeenAt;
  final DateTime cachedAt;
  const UserProfile(
      {required this.id,
      required this.displayName,
      this.avatarUrl,
      required this.isOnline,
      this.lastSeenAt,
      required this.cachedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    map['is_online'] = Variable<bool>(isOnline);
    if (!nullToAbsent || lastSeenAt != null) {
      map['last_seen_at'] = Variable<DateTime>(lastSeenAt);
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      displayName: Value(displayName),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      isOnline: Value(isOnline),
      lastSeenAt: lastSeenAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSeenAt),
      cachedAt: Value(cachedAt),
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      id: serializer.fromJson<String>(json['id']),
      displayName: serializer.fromJson<String>(json['displayName']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      isOnline: serializer.fromJson<bool>(json['isOnline']),
      lastSeenAt: serializer.fromJson<DateTime?>(json['lastSeenAt']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'displayName': serializer.toJson<String>(displayName),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'isOnline': serializer.toJson<bool>(isOnline),
      'lastSeenAt': serializer.toJson<DateTime?>(lastSeenAt),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  UserProfile copyWith(
          {String? id,
          String? displayName,
          Value<String?> avatarUrl = const Value.absent(),
          bool? isOnline,
          Value<DateTime?> lastSeenAt = const Value.absent(),
          DateTime? cachedAt}) =>
      UserProfile(
        id: id ?? this.id,
        displayName: displayName ?? this.displayName,
        avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
        isOnline: isOnline ?? this.isOnline,
        lastSeenAt: lastSeenAt.present ? lastSeenAt.value : this.lastSeenAt,
        cachedAt: cachedAt ?? this.cachedAt,
      );
  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('isOnline: $isOnline, ')
          ..write('lastSeenAt: $lastSeenAt, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, displayName, avatarUrl, isOnline, lastSeenAt, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.avatarUrl == this.avatarUrl &&
          other.isOnline == this.isOnline &&
          other.lastSeenAt == this.lastSeenAt &&
          other.cachedAt == this.cachedAt);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<String> id;
  final Value<String> displayName;
  final Value<String?> avatarUrl;
  final Value<bool> isOnline;
  final Value<DateTime?> lastSeenAt;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.isOnline = const Value.absent(),
    this.lastSeenAt = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    required String id,
    required String displayName,
    this.avatarUrl = const Value.absent(),
    this.isOnline = const Value.absent(),
    this.lastSeenAt = const Value.absent(),
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        displayName = Value(displayName),
        cachedAt = Value(cachedAt);
  static Insertable<UserProfile> custom({
    Expression<String>? id,
    Expression<String>? displayName,
    Expression<String>? avatarUrl,
    Expression<bool>? isOnline,
    Expression<DateTime>? lastSeenAt,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (isOnline != null) 'is_online': isOnline,
      if (lastSeenAt != null) 'last_seen_at': lastSeenAt,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProfilesCompanion copyWith(
      {Value<String>? id,
      Value<String>? displayName,
      Value<String?>? avatarUrl,
      Value<bool>? isOnline,
      Value<DateTime?>? lastSeenAt,
      Value<DateTime>? cachedAt,
      Value<int>? rowid}) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isOnline: isOnline ?? this.isOnline,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (isOnline.present) {
      map['is_online'] = Variable<bool>(isOnline.value);
    }
    if (lastSeenAt.present) {
      map['last_seen_at'] = Variable<DateTime>(lastSeenAt.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('isOnline: $isOnline, ')
          ..write('lastSeenAt: $lastSeenAt, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncMetadataTable extends SyncMetadata
    with TableInfo<$SyncMetadataTable, SyncMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _syncTableMeta =
      const VerificationMeta('syncTable');
  @override
  late final GeneratedColumn<String> syncTable = GeneratedColumn<String>(
      'table_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastSyncAtMeta =
      const VerificationMeta('lastSyncAt');
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
      'last_sync_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastSyncVersionMeta =
      const VerificationMeta('lastSyncVersion');
  @override
  late final GeneratedColumn<int> lastSyncVersion = GeneratedColumn<int>(
      'last_sync_version', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _syncCursorMeta =
      const VerificationMeta('syncCursor');
  @override
  late final GeneratedColumn<String> syncCursor = GeneratedColumn<String>(
      'sync_cursor', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [syncTable, lastSyncAt, lastSyncVersion, syncCursor];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_metadata';
  @override
  VerificationContext validateIntegrity(Insertable<SyncMetadataData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('table_name')) {
      context.handle(_syncTableMeta,
          syncTable.isAcceptableOrUnknown(data['table_name']!, _syncTableMeta));
    } else if (isInserting) {
      context.missing(_syncTableMeta);
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
          _lastSyncAtMeta,
          lastSyncAt.isAcceptableOrUnknown(
              data['last_sync_at']!, _lastSyncAtMeta));
    }
    if (data.containsKey('last_sync_version')) {
      context.handle(
          _lastSyncVersionMeta,
          lastSyncVersion.isAcceptableOrUnknown(
              data['last_sync_version']!, _lastSyncVersionMeta));
    }
    if (data.containsKey('sync_cursor')) {
      context.handle(
          _syncCursorMeta,
          syncCursor.isAcceptableOrUnknown(
              data['sync_cursor']!, _syncCursorMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {syncTable};
  @override
  SyncMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetadataData(
      syncTable: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}table_name'])!,
      lastSyncAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_sync_at']),
      lastSyncVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_sync_version']),
      syncCursor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_cursor']),
    );
  }

  @override
  $SyncMetadataTable createAlias(String alias) {
    return $SyncMetadataTable(attachedDatabase, alias);
  }
}

class SyncMetadataData extends DataClass
    implements Insertable<SyncMetadataData> {
  final String syncTable;
  final DateTime? lastSyncAt;
  final int? lastSyncVersion;
  final String? syncCursor;
  const SyncMetadataData(
      {required this.syncTable,
      this.lastSyncAt,
      this.lastSyncVersion,
      this.syncCursor});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['table_name'] = Variable<String>(syncTable);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    if (!nullToAbsent || lastSyncVersion != null) {
      map['last_sync_version'] = Variable<int>(lastSyncVersion);
    }
    if (!nullToAbsent || syncCursor != null) {
      map['sync_cursor'] = Variable<String>(syncCursor);
    }
    return map;
  }

  SyncMetadataCompanion toCompanion(bool nullToAbsent) {
    return SyncMetadataCompanion(
      syncTable: Value(syncTable),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
      lastSyncVersion: lastSyncVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncVersion),
      syncCursor: syncCursor == null && nullToAbsent
          ? const Value.absent()
          : Value(syncCursor),
    );
  }

  factory SyncMetadataData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetadataData(
      syncTable: serializer.fromJson<String>(json['syncTable']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
      lastSyncVersion: serializer.fromJson<int?>(json['lastSyncVersion']),
      syncCursor: serializer.fromJson<String?>(json['syncCursor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'syncTable': serializer.toJson<String>(syncTable),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
      'lastSyncVersion': serializer.toJson<int?>(lastSyncVersion),
      'syncCursor': serializer.toJson<String?>(syncCursor),
    };
  }

  SyncMetadataData copyWith(
          {String? syncTable,
          Value<DateTime?> lastSyncAt = const Value.absent(),
          Value<int?> lastSyncVersion = const Value.absent(),
          Value<String?> syncCursor = const Value.absent()}) =>
      SyncMetadataData(
        syncTable: syncTable ?? this.syncTable,
        lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
        lastSyncVersion: lastSyncVersion.present
            ? lastSyncVersion.value
            : this.lastSyncVersion,
        syncCursor: syncCursor.present ? syncCursor.value : this.syncCursor,
      );
  @override
  String toString() {
    return (StringBuffer('SyncMetadataData(')
          ..write('syncTable: $syncTable, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('lastSyncVersion: $lastSyncVersion, ')
          ..write('syncCursor: $syncCursor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(syncTable, lastSyncAt, lastSyncVersion, syncCursor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetadataData &&
          other.syncTable == this.syncTable &&
          other.lastSyncAt == this.lastSyncAt &&
          other.lastSyncVersion == this.lastSyncVersion &&
          other.syncCursor == this.syncCursor);
}

class SyncMetadataCompanion extends UpdateCompanion<SyncMetadataData> {
  final Value<String> syncTable;
  final Value<DateTime?> lastSyncAt;
  final Value<int?> lastSyncVersion;
  final Value<String?> syncCursor;
  final Value<int> rowid;
  const SyncMetadataCompanion({
    this.syncTable = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.lastSyncVersion = const Value.absent(),
    this.syncCursor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetadataCompanion.insert({
    required String syncTable,
    this.lastSyncAt = const Value.absent(),
    this.lastSyncVersion = const Value.absent(),
    this.syncCursor = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : syncTable = Value(syncTable);
  static Insertable<SyncMetadataData> custom({
    Expression<String>? syncTable,
    Expression<DateTime>? lastSyncAt,
    Expression<int>? lastSyncVersion,
    Expression<String>? syncCursor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (syncTable != null) 'table_name': syncTable,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (lastSyncVersion != null) 'last_sync_version': lastSyncVersion,
      if (syncCursor != null) 'sync_cursor': syncCursor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetadataCompanion copyWith(
      {Value<String>? syncTable,
      Value<DateTime?>? lastSyncAt,
      Value<int?>? lastSyncVersion,
      Value<String?>? syncCursor,
      Value<int>? rowid}) {
    return SyncMetadataCompanion(
      syncTable: syncTable ?? this.syncTable,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      lastSyncVersion: lastSyncVersion ?? this.lastSyncVersion,
      syncCursor: syncCursor ?? this.syncCursor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (syncTable.present) {
      map['table_name'] = Variable<String>(syncTable.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    if (lastSyncVersion.present) {
      map['last_sync_version'] = Variable<int>(lastSyncVersion.value);
    }
    if (syncCursor.present) {
      map['sync_cursor'] = Variable<String>(syncCursor.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataCompanion(')
          ..write('syncTable: $syncTable, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('lastSyncVersion: $lastSyncVersion, ')
          ..write('syncCursor: $syncCursor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PendingSyncOperationsTable extends PendingSyncOperations
    with TableInfo<$PendingSyncOperationsTable, PendingSyncOperation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingSyncOperationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _syncTableMeta =
      const VerificationMeta('syncTable');
  @override
  late final GeneratedColumn<String> syncTable = GeneratedColumn<String>(
      'table_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recordIdMeta =
      const VerificationMeta('recordId');
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
      'record_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _operationMeta =
      const VerificationMeta('operation');
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
      'operation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _retryCountMeta =
      const VerificationMeta('retryCount');
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
      'retry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastErrorMeta =
      const VerificationMeta('lastError');
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
      'last_error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        syncTable,
        recordId,
        operation,
        data,
        createdAt,
        retryCount,
        lastError
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_sync_operations';
  @override
  VerificationContext validateIntegrity(
      Insertable<PendingSyncOperation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('table_name')) {
      context.handle(_syncTableMeta,
          syncTable.isAcceptableOrUnknown(data['table_name']!, _syncTableMeta));
    } else if (isInserting) {
      context.missing(_syncTableMeta);
    }
    if (data.containsKey('record_id')) {
      context.handle(_recordIdMeta,
          recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta));
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(_operationMeta,
          operation.isAcceptableOrUnknown(data['operation']!, _operationMeta));
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
          _retryCountMeta,
          retryCount.isAcceptableOrUnknown(
              data['retry_count']!, _retryCountMeta));
    }
    if (data.containsKey('last_error')) {
      context.handle(_lastErrorMeta,
          lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingSyncOperation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingSyncOperation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      syncTable: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}table_name'])!,
      recordId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}record_id'])!,
      operation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      retryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retry_count'])!,
      lastError: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_error']),
    );
  }

  @override
  $PendingSyncOperationsTable createAlias(String alias) {
    return $PendingSyncOperationsTable(attachedDatabase, alias);
  }
}

class PendingSyncOperation extends DataClass
    implements Insertable<PendingSyncOperation> {
  final int id;
  final String syncTable;
  final String recordId;
  final String operation;
  final String? data;
  final DateTime createdAt;
  final int retryCount;
  final String? lastError;
  const PendingSyncOperation(
      {required this.id,
      required this.syncTable,
      required this.recordId,
      required this.operation,
      this.data,
      required this.createdAt,
      required this.retryCount,
      this.lastError});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['table_name'] = Variable<String>(syncTable);
    map['record_id'] = Variable<String>(recordId);
    map['operation'] = Variable<String>(operation);
    if (!nullToAbsent || data != null) {
      map['data'] = Variable<String>(data);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  PendingSyncOperationsCompanion toCompanion(bool nullToAbsent) {
    return PendingSyncOperationsCompanion(
      id: Value(id),
      syncTable: Value(syncTable),
      recordId: Value(recordId),
      operation: Value(operation),
      data: data == null && nullToAbsent ? const Value.absent() : Value(data),
      createdAt: Value(createdAt),
      retryCount: Value(retryCount),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory PendingSyncOperation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingSyncOperation(
      id: serializer.fromJson<int>(json['id']),
      syncTable: serializer.fromJson<String>(json['syncTable']),
      recordId: serializer.fromJson<String>(json['recordId']),
      operation: serializer.fromJson<String>(json['operation']),
      data: serializer.fromJson<String?>(json['data']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'syncTable': serializer.toJson<String>(syncTable),
      'recordId': serializer.toJson<String>(recordId),
      'operation': serializer.toJson<String>(operation),
      'data': serializer.toJson<String?>(data),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'retryCount': serializer.toJson<int>(retryCount),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  PendingSyncOperation copyWith(
          {int? id,
          String? syncTable,
          String? recordId,
          String? operation,
          Value<String?> data = const Value.absent(),
          DateTime? createdAt,
          int? retryCount,
          Value<String?> lastError = const Value.absent()}) =>
      PendingSyncOperation(
        id: id ?? this.id,
        syncTable: syncTable ?? this.syncTable,
        recordId: recordId ?? this.recordId,
        operation: operation ?? this.operation,
        data: data.present ? data.value : this.data,
        createdAt: createdAt ?? this.createdAt,
        retryCount: retryCount ?? this.retryCount,
        lastError: lastError.present ? lastError.value : this.lastError,
      );
  @override
  String toString() {
    return (StringBuffer('PendingSyncOperation(')
          ..write('id: $id, ')
          ..write('syncTable: $syncTable, ')
          ..write('recordId: $recordId, ')
          ..write('operation: $operation, ')
          ..write('data: $data, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, syncTable, recordId, operation, data,
      createdAt, retryCount, lastError);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingSyncOperation &&
          other.id == this.id &&
          other.syncTable == this.syncTable &&
          other.recordId == this.recordId &&
          other.operation == this.operation &&
          other.data == this.data &&
          other.createdAt == this.createdAt &&
          other.retryCount == this.retryCount &&
          other.lastError == this.lastError);
}

class PendingSyncOperationsCompanion
    extends UpdateCompanion<PendingSyncOperation> {
  final Value<int> id;
  final Value<String> syncTable;
  final Value<String> recordId;
  final Value<String> operation;
  final Value<String?> data;
  final Value<DateTime> createdAt;
  final Value<int> retryCount;
  final Value<String?> lastError;
  const PendingSyncOperationsCompanion({
    this.id = const Value.absent(),
    this.syncTable = const Value.absent(),
    this.recordId = const Value.absent(),
    this.operation = const Value.absent(),
    this.data = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
  });
  PendingSyncOperationsCompanion.insert({
    this.id = const Value.absent(),
    required String syncTable,
    required String recordId,
    required String operation,
    this.data = const Value.absent(),
    required DateTime createdAt,
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
  })  : syncTable = Value(syncTable),
        recordId = Value(recordId),
        operation = Value(operation),
        createdAt = Value(createdAt);
  static Insertable<PendingSyncOperation> custom({
    Expression<int>? id,
    Expression<String>? syncTable,
    Expression<String>? recordId,
    Expression<String>? operation,
    Expression<String>? data,
    Expression<DateTime>? createdAt,
    Expression<int>? retryCount,
    Expression<String>? lastError,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (syncTable != null) 'table_name': syncTable,
      if (recordId != null) 'record_id': recordId,
      if (operation != null) 'operation': operation,
      if (data != null) 'data': data,
      if (createdAt != null) 'created_at': createdAt,
      if (retryCount != null) 'retry_count': retryCount,
      if (lastError != null) 'last_error': lastError,
    });
  }

  PendingSyncOperationsCompanion copyWith(
      {Value<int>? id,
      Value<String>? syncTable,
      Value<String>? recordId,
      Value<String>? operation,
      Value<String?>? data,
      Value<DateTime>? createdAt,
      Value<int>? retryCount,
      Value<String?>? lastError}) {
    return PendingSyncOperationsCompanion(
      id: id ?? this.id,
      syncTable: syncTable ?? this.syncTable,
      recordId: recordId ?? this.recordId,
      operation: operation ?? this.operation,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (syncTable.present) {
      map['table_name'] = Variable<String>(syncTable.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingSyncOperationsCompanion(')
          ..write('id: $id, ')
          ..write('syncTable: $syncTable, ')
          ..write('recordId: $recordId, ')
          ..write('operation: $operation, ')
          ..write('data: $data, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $EventsTable events = $EventsTable(this);
  late final $DailyReflectionsTable dailyReflections =
      $DailyReflectionsTable(this);
  late final $FriendshipsTable friendships = $FriendshipsTable(this);
  late final $PokesTable pokes = $PokesTable(this);
  late final $EventSharesTable eventShares = $EventSharesTable(this);
  late final $InboxMessagesTable inboxMessages = $InboxMessagesTable(this);
  late final $StreaksTable streaks = $StreaksTable(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $SyncMetadataTable syncMetadata = $SyncMetadataTable(this);
  late final $PendingSyncOperationsTable pendingSyncOperations =
      $PendingSyncOperationsTable(this);
  late final EventDao eventDao = EventDao(this as AppDatabase);
  late final ReflectionDao reflectionDao = ReflectionDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        events,
        dailyReflections,
        friendships,
        pokes,
        eventShares,
        inboxMessages,
        streaks,
        userProfiles,
        syncMetadata,
        pendingSyncOperations
      ];
}
