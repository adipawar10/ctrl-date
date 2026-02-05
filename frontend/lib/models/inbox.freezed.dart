// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inbox.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InboxMessage _$InboxMessageFromJson(Map<String, dynamic> json) {
  return _InboxMessage.fromJson(json);
}

/// @nodoc
mixin _$InboxMessage {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  MessageType get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get body => throw _privateConstructorUsedError;
  String? get senderId => throw _privateConstructorUsedError;
  UserProfile? get sender => throw _privateConstructorUsedError;
  MessagePriority get priority => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;
  bool get isArchived => throw _privateConstructorUsedError;
  bool get isDeleted => throw _privateConstructorUsedError;
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;
  String? get actionUrl => throw _privateConstructorUsedError;
  List<MessageAction>? get actions => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get readAt => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InboxMessageCopyWith<InboxMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InboxMessageCopyWith<$Res> {
  factory $InboxMessageCopyWith(
          InboxMessage value, $Res Function(InboxMessage) then) =
      _$InboxMessageCopyWithImpl<$Res, InboxMessage>;
  @useResult
  $Res call(
      {String id,
      String userId,
      MessageType type,
      String title,
      String? body,
      String? senderId,
      UserProfile? sender,
      MessagePriority priority,
      bool isRead,
      bool isArchived,
      bool isDeleted,
      Map<String, dynamic>? data,
      String? actionUrl,
      List<MessageAction>? actions,
      DateTime? createdAt,
      DateTime? readAt,
      DateTime? expiresAt});

  $UserProfileCopyWith<$Res>? get sender;
}

/// @nodoc
class _$InboxMessageCopyWithImpl<$Res, $Val extends InboxMessage>
    implements $InboxMessageCopyWith<$Res> {
  _$InboxMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? title = null,
    Object? body = freezed,
    Object? senderId = freezed,
    Object? sender = freezed,
    Object? priority = null,
    Object? isRead = null,
    Object? isArchived = null,
    Object? isDeleted = null,
    Object? data = freezed,
    Object? actionUrl = freezed,
    Object? actions = freezed,
    Object? createdAt = freezed,
    Object? readAt = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MessageType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      senderId: freezed == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String?,
      sender: freezed == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as MessagePriority,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      actionUrl: freezed == actionUrl
          ? _value.actionUrl
          : actionUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      actions: freezed == actions
          ? _value.actions
          : actions // ignore: cast_nullable_to_non_nullable
              as List<MessageAction>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<$Res>? get sender {
    if (_value.sender == null) {
      return null;
    }

    return $UserProfileCopyWith<$Res>(_value.sender!, (value) {
      return _then(_value.copyWith(sender: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$InboxMessageImplCopyWith<$Res>
    implements $InboxMessageCopyWith<$Res> {
  factory _$$InboxMessageImplCopyWith(
          _$InboxMessageImpl value, $Res Function(_$InboxMessageImpl) then) =
      __$$InboxMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      MessageType type,
      String title,
      String? body,
      String? senderId,
      UserProfile? sender,
      MessagePriority priority,
      bool isRead,
      bool isArchived,
      bool isDeleted,
      Map<String, dynamic>? data,
      String? actionUrl,
      List<MessageAction>? actions,
      DateTime? createdAt,
      DateTime? readAt,
      DateTime? expiresAt});

  @override
  $UserProfileCopyWith<$Res>? get sender;
}

/// @nodoc
class __$$InboxMessageImplCopyWithImpl<$Res>
    extends _$InboxMessageCopyWithImpl<$Res, _$InboxMessageImpl>
    implements _$$InboxMessageImplCopyWith<$Res> {
  __$$InboxMessageImplCopyWithImpl(
      _$InboxMessageImpl _value, $Res Function(_$InboxMessageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? title = null,
    Object? body = freezed,
    Object? senderId = freezed,
    Object? sender = freezed,
    Object? priority = null,
    Object? isRead = null,
    Object? isArchived = null,
    Object? isDeleted = null,
    Object? data = freezed,
    Object? actionUrl = freezed,
    Object? actions = freezed,
    Object? createdAt = freezed,
    Object? readAt = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(_$InboxMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MessageType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      senderId: freezed == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String?,
      sender: freezed == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as MessagePriority,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      actionUrl: freezed == actionUrl
          ? _value.actionUrl
          : actionUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      actions: freezed == actions
          ? _value._actions
          : actions // ignore: cast_nullable_to_non_nullable
              as List<MessageAction>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InboxMessageImpl extends _InboxMessage {
  const _$InboxMessageImpl(
      {required this.id,
      required this.userId,
      required this.type,
      required this.title,
      this.body,
      this.senderId,
      this.sender,
      this.priority = MessagePriority.normal,
      this.isRead = false,
      this.isArchived = false,
      this.isDeleted = false,
      final Map<String, dynamic>? data,
      this.actionUrl,
      final List<MessageAction>? actions,
      this.createdAt,
      this.readAt,
      this.expiresAt})
      : _data = data,
        _actions = actions,
        super._();

  factory _$InboxMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$InboxMessageImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final MessageType type;
  @override
  final String title;
  @override
  final String? body;
  @override
  final String? senderId;
  @override
  final UserProfile? sender;
  @override
  @JsonKey()
  final MessagePriority priority;
  @override
  @JsonKey()
  final bool isRead;
  @override
  @JsonKey()
  final bool isArchived;
  @override
  @JsonKey()
  final bool isDeleted;
  final Map<String, dynamic>? _data;
  @override
  Map<String, dynamic>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? actionUrl;
  final List<MessageAction>? _actions;
  @override
  List<MessageAction>? get actions {
    final value = _actions;
    if (value == null) return null;
    if (_actions is EqualUnmodifiableListView) return _actions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? readAt;
  @override
  final DateTime? expiresAt;

  @override
  String toString() {
    return 'InboxMessage(id: $id, userId: $userId, type: $type, title: $title, body: $body, senderId: $senderId, sender: $sender, priority: $priority, isRead: $isRead, isArchived: $isArchived, isDeleted: $isDeleted, data: $data, actionUrl: $actionUrl, actions: $actions, createdAt: $createdAt, readAt: $readAt, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InboxMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.actionUrl, actionUrl) ||
                other.actionUrl == actionUrl) &&
            const DeepCollectionEquality().equals(other._actions, _actions) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      type,
      title,
      body,
      senderId,
      sender,
      priority,
      isRead,
      isArchived,
      isDeleted,
      const DeepCollectionEquality().hash(_data),
      actionUrl,
      const DeepCollectionEquality().hash(_actions),
      createdAt,
      readAt,
      expiresAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InboxMessageImplCopyWith<_$InboxMessageImpl> get copyWith =>
      __$$InboxMessageImplCopyWithImpl<_$InboxMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InboxMessageImplToJson(
      this,
    );
  }
}

abstract class _InboxMessage extends InboxMessage {
  const factory _InboxMessage(
      {required final String id,
      required final String userId,
      required final MessageType type,
      required final String title,
      final String? body,
      final String? senderId,
      final UserProfile? sender,
      final MessagePriority priority,
      final bool isRead,
      final bool isArchived,
      final bool isDeleted,
      final Map<String, dynamic>? data,
      final String? actionUrl,
      final List<MessageAction>? actions,
      final DateTime? createdAt,
      final DateTime? readAt,
      final DateTime? expiresAt}) = _$InboxMessageImpl;
  const _InboxMessage._() : super._();

  factory _InboxMessage.fromJson(Map<String, dynamic> json) =
      _$InboxMessageImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  MessageType get type;
  @override
  String get title;
  @override
  String? get body;
  @override
  String? get senderId;
  @override
  UserProfile? get sender;
  @override
  MessagePriority get priority;
  @override
  bool get isRead;
  @override
  bool get isArchived;
  @override
  bool get isDeleted;
  @override
  Map<String, dynamic>? get data;
  @override
  String? get actionUrl;
  @override
  List<MessageAction>? get actions;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get readAt;
  @override
  DateTime? get expiresAt;
  @override
  @JsonKey(ignore: true)
  _$$InboxMessageImplCopyWith<_$InboxMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MessageAction _$MessageActionFromJson(Map<String, dynamic> json) {
  return _MessageAction.fromJson(json);
}

/// @nodoc
mixin _$MessageAction {
  String get id => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String get actionType => throw _privateConstructorUsedError;
  Map<String, dynamic>? get actionData => throw _privateConstructorUsedError;
  bool get isPrimary => throw _privateConstructorUsedError;
  bool get isDestructive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessageActionCopyWith<MessageAction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageActionCopyWith<$Res> {
  factory $MessageActionCopyWith(
          MessageAction value, $Res Function(MessageAction) then) =
      _$MessageActionCopyWithImpl<$Res, MessageAction>;
  @useResult
  $Res call(
      {String id,
      String label,
      String actionType,
      Map<String, dynamic>? actionData,
      bool isPrimary,
      bool isDestructive});
}

/// @nodoc
class _$MessageActionCopyWithImpl<$Res, $Val extends MessageAction>
    implements $MessageActionCopyWith<$Res> {
  _$MessageActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? actionType = null,
    Object? actionData = freezed,
    Object? isPrimary = null,
    Object? isDestructive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      actionType: null == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String,
      actionData: freezed == actionData
          ? _value.actionData
          : actionData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isPrimary: null == isPrimary
          ? _value.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
      isDestructive: null == isDestructive
          ? _value.isDestructive
          : isDestructive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageActionImplCopyWith<$Res>
    implements $MessageActionCopyWith<$Res> {
  factory _$$MessageActionImplCopyWith(
          _$MessageActionImpl value, $Res Function(_$MessageActionImpl) then) =
      __$$MessageActionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String label,
      String actionType,
      Map<String, dynamic>? actionData,
      bool isPrimary,
      bool isDestructive});
}

/// @nodoc
class __$$MessageActionImplCopyWithImpl<$Res>
    extends _$MessageActionCopyWithImpl<$Res, _$MessageActionImpl>
    implements _$$MessageActionImplCopyWith<$Res> {
  __$$MessageActionImplCopyWithImpl(
      _$MessageActionImpl _value, $Res Function(_$MessageActionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? actionType = null,
    Object? actionData = freezed,
    Object? isPrimary = null,
    Object? isDestructive = null,
  }) {
    return _then(_$MessageActionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      actionType: null == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String,
      actionData: freezed == actionData
          ? _value._actionData
          : actionData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isPrimary: null == isPrimary
          ? _value.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
      isDestructive: null == isDestructive
          ? _value.isDestructive
          : isDestructive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageActionImpl implements _MessageAction {
  const _$MessageActionImpl(
      {required this.id,
      required this.label,
      required this.actionType,
      final Map<String, dynamic>? actionData,
      this.isPrimary = false,
      this.isDestructive = false})
      : _actionData = actionData;

  factory _$MessageActionImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageActionImplFromJson(json);

  @override
  final String id;
  @override
  final String label;
  @override
  final String actionType;
  final Map<String, dynamic>? _actionData;
  @override
  Map<String, dynamic>? get actionData {
    final value = _actionData;
    if (value == null) return null;
    if (_actionData is EqualUnmodifiableMapView) return _actionData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final bool isPrimary;
  @override
  @JsonKey()
  final bool isDestructive;

  @override
  String toString() {
    return 'MessageAction(id: $id, label: $label, actionType: $actionType, actionData: $actionData, isPrimary: $isPrimary, isDestructive: $isDestructive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageActionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.actionType, actionType) ||
                other.actionType == actionType) &&
            const DeepCollectionEquality()
                .equals(other._actionData, _actionData) &&
            (identical(other.isPrimary, isPrimary) ||
                other.isPrimary == isPrimary) &&
            (identical(other.isDestructive, isDestructive) ||
                other.isDestructive == isDestructive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      label,
      actionType,
      const DeepCollectionEquality().hash(_actionData),
      isPrimary,
      isDestructive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageActionImplCopyWith<_$MessageActionImpl> get copyWith =>
      __$$MessageActionImplCopyWithImpl<_$MessageActionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageActionImplToJson(
      this,
    );
  }
}

abstract class _MessageAction implements MessageAction {
  const factory _MessageAction(
      {required final String id,
      required final String label,
      required final String actionType,
      final Map<String, dynamic>? actionData,
      final bool isPrimary,
      final bool isDestructive}) = _$MessageActionImpl;

  factory _MessageAction.fromJson(Map<String, dynamic> json) =
      _$MessageActionImpl.fromJson;

  @override
  String get id;
  @override
  String get label;
  @override
  String get actionType;
  @override
  Map<String, dynamic>? get actionData;
  @override
  bool get isPrimary;
  @override
  bool get isDestructive;
  @override
  @JsonKey(ignore: true)
  _$$MessageActionImplCopyWith<_$MessageActionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InboxState _$InboxStateFromJson(Map<String, dynamic> json) {
  return _InboxState.fromJson(json);
}

/// @nodoc
mixin _$InboxState {
  List<InboxMessage> get messages => throw _privateConstructorUsedError;
  int get unreadCount => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  InboxFilter? get filter => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InboxStateCopyWith<InboxState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InboxStateCopyWith<$Res> {
  factory $InboxStateCopyWith(
          InboxState value, $Res Function(InboxState) then) =
      _$InboxStateCopyWithImpl<$Res, InboxState>;
  @useResult
  $Res call(
      {List<InboxMessage> messages,
      int unreadCount,
      bool isLoading,
      bool hasMore,
      String? error,
      InboxFilter? filter});

  $InboxFilterCopyWith<$Res>? get filter;
}

/// @nodoc
class _$InboxStateCopyWithImpl<$Res, $Val extends InboxState>
    implements $InboxStateCopyWith<$Res> {
  _$InboxStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messages = null,
    Object? unreadCount = null,
    Object? isLoading = null,
    Object? hasMore = null,
    Object? error = freezed,
    Object? filter = freezed,
  }) {
    return _then(_value.copyWith(
      messages: null == messages
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<InboxMessage>,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      filter: freezed == filter
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as InboxFilter?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $InboxFilterCopyWith<$Res>? get filter {
    if (_value.filter == null) {
      return null;
    }

    return $InboxFilterCopyWith<$Res>(_value.filter!, (value) {
      return _then(_value.copyWith(filter: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$InboxStateImplCopyWith<$Res>
    implements $InboxStateCopyWith<$Res> {
  factory _$$InboxStateImplCopyWith(
          _$InboxStateImpl value, $Res Function(_$InboxStateImpl) then) =
      __$$InboxStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<InboxMessage> messages,
      int unreadCount,
      bool isLoading,
      bool hasMore,
      String? error,
      InboxFilter? filter});

  @override
  $InboxFilterCopyWith<$Res>? get filter;
}

/// @nodoc
class __$$InboxStateImplCopyWithImpl<$Res>
    extends _$InboxStateCopyWithImpl<$Res, _$InboxStateImpl>
    implements _$$InboxStateImplCopyWith<$Res> {
  __$$InboxStateImplCopyWithImpl(
      _$InboxStateImpl _value, $Res Function(_$InboxStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messages = null,
    Object? unreadCount = null,
    Object? isLoading = null,
    Object? hasMore = null,
    Object? error = freezed,
    Object? filter = freezed,
  }) {
    return _then(_$InboxStateImpl(
      messages: null == messages
          ? _value._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<InboxMessage>,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      filter: freezed == filter
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as InboxFilter?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InboxStateImpl implements _InboxState {
  const _$InboxStateImpl(
      {final List<InboxMessage> messages = const [],
      this.unreadCount = 0,
      this.isLoading = false,
      this.hasMore = false,
      this.error,
      this.filter})
      : _messages = messages;

  factory _$InboxStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$InboxStateImplFromJson(json);

  final List<InboxMessage> _messages;
  @override
  @JsonKey()
  List<InboxMessage> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  @JsonKey()
  final int unreadCount;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool hasMore;
  @override
  final String? error;
  @override
  final InboxFilter? filter;

  @override
  String toString() {
    return 'InboxState(messages: $messages, unreadCount: $unreadCount, isLoading: $isLoading, hasMore: $hasMore, error: $error, filter: $filter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InboxStateImpl &&
            const DeepCollectionEquality().equals(other._messages, _messages) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.filter, filter) || other.filter == filter));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_messages),
      unreadCount,
      isLoading,
      hasMore,
      error,
      filter);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InboxStateImplCopyWith<_$InboxStateImpl> get copyWith =>
      __$$InboxStateImplCopyWithImpl<_$InboxStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InboxStateImplToJson(
      this,
    );
  }
}

abstract class _InboxState implements InboxState {
  const factory _InboxState(
      {final List<InboxMessage> messages,
      final int unreadCount,
      final bool isLoading,
      final bool hasMore,
      final String? error,
      final InboxFilter? filter}) = _$InboxStateImpl;

  factory _InboxState.fromJson(Map<String, dynamic> json) =
      _$InboxStateImpl.fromJson;

  @override
  List<InboxMessage> get messages;
  @override
  int get unreadCount;
  @override
  bool get isLoading;
  @override
  bool get hasMore;
  @override
  String? get error;
  @override
  InboxFilter? get filter;
  @override
  @JsonKey(ignore: true)
  _$$InboxStateImplCopyWith<_$InboxStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InboxFilter _$InboxFilterFromJson(Map<String, dynamic> json) {
  return _InboxFilter.fromJson(json);
}

/// @nodoc
mixin _$InboxFilter {
  List<MessageType>? get types => throw _privateConstructorUsedError;
  bool get unreadOnly => throw _privateConstructorUsedError;
  bool get archivedOnly => throw _privateConstructorUsedError;
  DateTime? get fromDate => throw _privateConstructorUsedError;
  DateTime? get toDate => throw _privateConstructorUsedError;
  String? get searchQuery => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InboxFilterCopyWith<InboxFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InboxFilterCopyWith<$Res> {
  factory $InboxFilterCopyWith(
          InboxFilter value, $Res Function(InboxFilter) then) =
      _$InboxFilterCopyWithImpl<$Res, InboxFilter>;
  @useResult
  $Res call(
      {List<MessageType>? types,
      bool unreadOnly,
      bool archivedOnly,
      DateTime? fromDate,
      DateTime? toDate,
      String? searchQuery});
}

/// @nodoc
class _$InboxFilterCopyWithImpl<$Res, $Val extends InboxFilter>
    implements $InboxFilterCopyWith<$Res> {
  _$InboxFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? types = freezed,
    Object? unreadOnly = null,
    Object? archivedOnly = null,
    Object? fromDate = freezed,
    Object? toDate = freezed,
    Object? searchQuery = freezed,
  }) {
    return _then(_value.copyWith(
      types: freezed == types
          ? _value.types
          : types // ignore: cast_nullable_to_non_nullable
              as List<MessageType>?,
      unreadOnly: null == unreadOnly
          ? _value.unreadOnly
          : unreadOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      archivedOnly: null == archivedOnly
          ? _value.archivedOnly
          : archivedOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      fromDate: freezed == fromDate
          ? _value.fromDate
          : fromDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      toDate: freezed == toDate
          ? _value.toDate
          : toDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InboxFilterImplCopyWith<$Res>
    implements $InboxFilterCopyWith<$Res> {
  factory _$$InboxFilterImplCopyWith(
          _$InboxFilterImpl value, $Res Function(_$InboxFilterImpl) then) =
      __$$InboxFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<MessageType>? types,
      bool unreadOnly,
      bool archivedOnly,
      DateTime? fromDate,
      DateTime? toDate,
      String? searchQuery});
}

/// @nodoc
class __$$InboxFilterImplCopyWithImpl<$Res>
    extends _$InboxFilterCopyWithImpl<$Res, _$InboxFilterImpl>
    implements _$$InboxFilterImplCopyWith<$Res> {
  __$$InboxFilterImplCopyWithImpl(
      _$InboxFilterImpl _value, $Res Function(_$InboxFilterImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? types = freezed,
    Object? unreadOnly = null,
    Object? archivedOnly = null,
    Object? fromDate = freezed,
    Object? toDate = freezed,
    Object? searchQuery = freezed,
  }) {
    return _then(_$InboxFilterImpl(
      types: freezed == types
          ? _value._types
          : types // ignore: cast_nullable_to_non_nullable
              as List<MessageType>?,
      unreadOnly: null == unreadOnly
          ? _value.unreadOnly
          : unreadOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      archivedOnly: null == archivedOnly
          ? _value.archivedOnly
          : archivedOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      fromDate: freezed == fromDate
          ? _value.fromDate
          : fromDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      toDate: freezed == toDate
          ? _value.toDate
          : toDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InboxFilterImpl implements _InboxFilter {
  const _$InboxFilterImpl(
      {final List<MessageType>? types,
      this.unreadOnly = false,
      this.archivedOnly = false,
      this.fromDate,
      this.toDate,
      this.searchQuery})
      : _types = types;

  factory _$InboxFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$InboxFilterImplFromJson(json);

  final List<MessageType>? _types;
  @override
  List<MessageType>? get types {
    final value = _types;
    if (value == null) return null;
    if (_types is EqualUnmodifiableListView) return _types;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final bool unreadOnly;
  @override
  @JsonKey()
  final bool archivedOnly;
  @override
  final DateTime? fromDate;
  @override
  final DateTime? toDate;
  @override
  final String? searchQuery;

  @override
  String toString() {
    return 'InboxFilter(types: $types, unreadOnly: $unreadOnly, archivedOnly: $archivedOnly, fromDate: $fromDate, toDate: $toDate, searchQuery: $searchQuery)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InboxFilterImpl &&
            const DeepCollectionEquality().equals(other._types, _types) &&
            (identical(other.unreadOnly, unreadOnly) ||
                other.unreadOnly == unreadOnly) &&
            (identical(other.archivedOnly, archivedOnly) ||
                other.archivedOnly == archivedOnly) &&
            (identical(other.fromDate, fromDate) ||
                other.fromDate == fromDate) &&
            (identical(other.toDate, toDate) || other.toDate == toDate) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_types),
      unreadOnly,
      archivedOnly,
      fromDate,
      toDate,
      searchQuery);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InboxFilterImplCopyWith<_$InboxFilterImpl> get copyWith =>
      __$$InboxFilterImplCopyWithImpl<_$InboxFilterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InboxFilterImplToJson(
      this,
    );
  }
}

abstract class _InboxFilter implements InboxFilter {
  const factory _InboxFilter(
      {final List<MessageType>? types,
      final bool unreadOnly,
      final bool archivedOnly,
      final DateTime? fromDate,
      final DateTime? toDate,
      final String? searchQuery}) = _$InboxFilterImpl;

  factory _InboxFilter.fromJson(Map<String, dynamic> json) =
      _$InboxFilterImpl.fromJson;

  @override
  List<MessageType>? get types;
  @override
  bool get unreadOnly;
  @override
  bool get archivedOnly;
  @override
  DateTime? get fromDate;
  @override
  DateTime? get toDate;
  @override
  String? get searchQuery;
  @override
  @JsonKey(ignore: true)
  _$$InboxFilterImplCopyWith<_$InboxFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NotificationSettings _$NotificationSettingsFromJson(Map<String, dynamic> json) {
  return _NotificationSettings.fromJson(json);
}

/// @nodoc
mixin _$NotificationSettings {
  bool get friendRequests => throw _privateConstructorUsedError;
  bool get pokes => throw _privateConstructorUsedError;
  bool get eventShares => throw _privateConstructorUsedError;
  bool get eventReminders => throw _privateConstructorUsedError;
  bool get eventUpdates => throw _privateConstructorUsedError;
  bool get reflectionReminders => throw _privateConstructorUsedError;
  bool get streakMilestones => throw _privateConstructorUsedError;
  bool get systemMessages => throw _privateConstructorUsedError;
  bool get announcements => throw _privateConstructorUsedError;
  bool get soundEnabled => throw _privateConstructorUsedError;
  bool get vibrationEnabled => throw _privateConstructorUsedError;
  String get quietHoursStart => throw _privateConstructorUsedError;
  String get quietHoursEnd => throw _privateConstructorUsedError;
  bool get quietHoursEnabled => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationSettingsCopyWith<NotificationSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationSettingsCopyWith<$Res> {
  factory $NotificationSettingsCopyWith(NotificationSettings value,
          $Res Function(NotificationSettings) then) =
      _$NotificationSettingsCopyWithImpl<$Res, NotificationSettings>;
  @useResult
  $Res call(
      {bool friendRequests,
      bool pokes,
      bool eventShares,
      bool eventReminders,
      bool eventUpdates,
      bool reflectionReminders,
      bool streakMilestones,
      bool systemMessages,
      bool announcements,
      bool soundEnabled,
      bool vibrationEnabled,
      String quietHoursStart,
      String quietHoursEnd,
      bool quietHoursEnabled});
}

/// @nodoc
class _$NotificationSettingsCopyWithImpl<$Res,
        $Val extends NotificationSettings>
    implements $NotificationSettingsCopyWith<$Res> {
  _$NotificationSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? friendRequests = null,
    Object? pokes = null,
    Object? eventShares = null,
    Object? eventReminders = null,
    Object? eventUpdates = null,
    Object? reflectionReminders = null,
    Object? streakMilestones = null,
    Object? systemMessages = null,
    Object? announcements = null,
    Object? soundEnabled = null,
    Object? vibrationEnabled = null,
    Object? quietHoursStart = null,
    Object? quietHoursEnd = null,
    Object? quietHoursEnabled = null,
  }) {
    return _then(_value.copyWith(
      friendRequests: null == friendRequests
          ? _value.friendRequests
          : friendRequests // ignore: cast_nullable_to_non_nullable
              as bool,
      pokes: null == pokes
          ? _value.pokes
          : pokes // ignore: cast_nullable_to_non_nullable
              as bool,
      eventShares: null == eventShares
          ? _value.eventShares
          : eventShares // ignore: cast_nullable_to_non_nullable
              as bool,
      eventReminders: null == eventReminders
          ? _value.eventReminders
          : eventReminders // ignore: cast_nullable_to_non_nullable
              as bool,
      eventUpdates: null == eventUpdates
          ? _value.eventUpdates
          : eventUpdates // ignore: cast_nullable_to_non_nullable
              as bool,
      reflectionReminders: null == reflectionReminders
          ? _value.reflectionReminders
          : reflectionReminders // ignore: cast_nullable_to_non_nullable
              as bool,
      streakMilestones: null == streakMilestones
          ? _value.streakMilestones
          : streakMilestones // ignore: cast_nullable_to_non_nullable
              as bool,
      systemMessages: null == systemMessages
          ? _value.systemMessages
          : systemMessages // ignore: cast_nullable_to_non_nullable
              as bool,
      announcements: null == announcements
          ? _value.announcements
          : announcements // ignore: cast_nullable_to_non_nullable
              as bool,
      soundEnabled: null == soundEnabled
          ? _value.soundEnabled
          : soundEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      vibrationEnabled: null == vibrationEnabled
          ? _value.vibrationEnabled
          : vibrationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      quietHoursStart: null == quietHoursStart
          ? _value.quietHoursStart
          : quietHoursStart // ignore: cast_nullable_to_non_nullable
              as String,
      quietHoursEnd: null == quietHoursEnd
          ? _value.quietHoursEnd
          : quietHoursEnd // ignore: cast_nullable_to_non_nullable
              as String,
      quietHoursEnabled: null == quietHoursEnabled
          ? _value.quietHoursEnabled
          : quietHoursEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationSettingsImplCopyWith<$Res>
    implements $NotificationSettingsCopyWith<$Res> {
  factory _$$NotificationSettingsImplCopyWith(_$NotificationSettingsImpl value,
          $Res Function(_$NotificationSettingsImpl) then) =
      __$$NotificationSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool friendRequests,
      bool pokes,
      bool eventShares,
      bool eventReminders,
      bool eventUpdates,
      bool reflectionReminders,
      bool streakMilestones,
      bool systemMessages,
      bool announcements,
      bool soundEnabled,
      bool vibrationEnabled,
      String quietHoursStart,
      String quietHoursEnd,
      bool quietHoursEnabled});
}

/// @nodoc
class __$$NotificationSettingsImplCopyWithImpl<$Res>
    extends _$NotificationSettingsCopyWithImpl<$Res, _$NotificationSettingsImpl>
    implements _$$NotificationSettingsImplCopyWith<$Res> {
  __$$NotificationSettingsImplCopyWithImpl(_$NotificationSettingsImpl _value,
      $Res Function(_$NotificationSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? friendRequests = null,
    Object? pokes = null,
    Object? eventShares = null,
    Object? eventReminders = null,
    Object? eventUpdates = null,
    Object? reflectionReminders = null,
    Object? streakMilestones = null,
    Object? systemMessages = null,
    Object? announcements = null,
    Object? soundEnabled = null,
    Object? vibrationEnabled = null,
    Object? quietHoursStart = null,
    Object? quietHoursEnd = null,
    Object? quietHoursEnabled = null,
  }) {
    return _then(_$NotificationSettingsImpl(
      friendRequests: null == friendRequests
          ? _value.friendRequests
          : friendRequests // ignore: cast_nullable_to_non_nullable
              as bool,
      pokes: null == pokes
          ? _value.pokes
          : pokes // ignore: cast_nullable_to_non_nullable
              as bool,
      eventShares: null == eventShares
          ? _value.eventShares
          : eventShares // ignore: cast_nullable_to_non_nullable
              as bool,
      eventReminders: null == eventReminders
          ? _value.eventReminders
          : eventReminders // ignore: cast_nullable_to_non_nullable
              as bool,
      eventUpdates: null == eventUpdates
          ? _value.eventUpdates
          : eventUpdates // ignore: cast_nullable_to_non_nullable
              as bool,
      reflectionReminders: null == reflectionReminders
          ? _value.reflectionReminders
          : reflectionReminders // ignore: cast_nullable_to_non_nullable
              as bool,
      streakMilestones: null == streakMilestones
          ? _value.streakMilestones
          : streakMilestones // ignore: cast_nullable_to_non_nullable
              as bool,
      systemMessages: null == systemMessages
          ? _value.systemMessages
          : systemMessages // ignore: cast_nullable_to_non_nullable
              as bool,
      announcements: null == announcements
          ? _value.announcements
          : announcements // ignore: cast_nullable_to_non_nullable
              as bool,
      soundEnabled: null == soundEnabled
          ? _value.soundEnabled
          : soundEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      vibrationEnabled: null == vibrationEnabled
          ? _value.vibrationEnabled
          : vibrationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      quietHoursStart: null == quietHoursStart
          ? _value.quietHoursStart
          : quietHoursStart // ignore: cast_nullable_to_non_nullable
              as String,
      quietHoursEnd: null == quietHoursEnd
          ? _value.quietHoursEnd
          : quietHoursEnd // ignore: cast_nullable_to_non_nullable
              as String,
      quietHoursEnabled: null == quietHoursEnabled
          ? _value.quietHoursEnabled
          : quietHoursEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationSettingsImpl implements _NotificationSettings {
  const _$NotificationSettingsImpl(
      {this.friendRequests = true,
      this.pokes = true,
      this.eventShares = true,
      this.eventReminders = true,
      this.eventUpdates = true,
      this.reflectionReminders = true,
      this.streakMilestones = true,
      this.systemMessages = true,
      this.announcements = false,
      this.soundEnabled = true,
      this.vibrationEnabled = true,
      this.quietHoursStart = '08:00',
      this.quietHoursEnd = '22:00',
      this.quietHoursEnabled = false});

  factory _$NotificationSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationSettingsImplFromJson(json);

  @override
  @JsonKey()
  final bool friendRequests;
  @override
  @JsonKey()
  final bool pokes;
  @override
  @JsonKey()
  final bool eventShares;
  @override
  @JsonKey()
  final bool eventReminders;
  @override
  @JsonKey()
  final bool eventUpdates;
  @override
  @JsonKey()
  final bool reflectionReminders;
  @override
  @JsonKey()
  final bool streakMilestones;
  @override
  @JsonKey()
  final bool systemMessages;
  @override
  @JsonKey()
  final bool announcements;
  @override
  @JsonKey()
  final bool soundEnabled;
  @override
  @JsonKey()
  final bool vibrationEnabled;
  @override
  @JsonKey()
  final String quietHoursStart;
  @override
  @JsonKey()
  final String quietHoursEnd;
  @override
  @JsonKey()
  final bool quietHoursEnabled;

  @override
  String toString() {
    return 'NotificationSettings(friendRequests: $friendRequests, pokes: $pokes, eventShares: $eventShares, eventReminders: $eventReminders, eventUpdates: $eventUpdates, reflectionReminders: $reflectionReminders, streakMilestones: $streakMilestones, systemMessages: $systemMessages, announcements: $announcements, soundEnabled: $soundEnabled, vibrationEnabled: $vibrationEnabled, quietHoursStart: $quietHoursStart, quietHoursEnd: $quietHoursEnd, quietHoursEnabled: $quietHoursEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationSettingsImpl &&
            (identical(other.friendRequests, friendRequests) ||
                other.friendRequests == friendRequests) &&
            (identical(other.pokes, pokes) || other.pokes == pokes) &&
            (identical(other.eventShares, eventShares) ||
                other.eventShares == eventShares) &&
            (identical(other.eventReminders, eventReminders) ||
                other.eventReminders == eventReminders) &&
            (identical(other.eventUpdates, eventUpdates) ||
                other.eventUpdates == eventUpdates) &&
            (identical(other.reflectionReminders, reflectionReminders) ||
                other.reflectionReminders == reflectionReminders) &&
            (identical(other.streakMilestones, streakMilestones) ||
                other.streakMilestones == streakMilestones) &&
            (identical(other.systemMessages, systemMessages) ||
                other.systemMessages == systemMessages) &&
            (identical(other.announcements, announcements) ||
                other.announcements == announcements) &&
            (identical(other.soundEnabled, soundEnabled) ||
                other.soundEnabled == soundEnabled) &&
            (identical(other.vibrationEnabled, vibrationEnabled) ||
                other.vibrationEnabled == vibrationEnabled) &&
            (identical(other.quietHoursStart, quietHoursStart) ||
                other.quietHoursStart == quietHoursStart) &&
            (identical(other.quietHoursEnd, quietHoursEnd) ||
                other.quietHoursEnd == quietHoursEnd) &&
            (identical(other.quietHoursEnabled, quietHoursEnabled) ||
                other.quietHoursEnabled == quietHoursEnabled));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      friendRequests,
      pokes,
      eventShares,
      eventReminders,
      eventUpdates,
      reflectionReminders,
      streakMilestones,
      systemMessages,
      announcements,
      soundEnabled,
      vibrationEnabled,
      quietHoursStart,
      quietHoursEnd,
      quietHoursEnabled);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationSettingsImplCopyWith<_$NotificationSettingsImpl>
      get copyWith =>
          __$$NotificationSettingsImplCopyWithImpl<_$NotificationSettingsImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationSettingsImplToJson(
      this,
    );
  }
}

abstract class _NotificationSettings implements NotificationSettings {
  const factory _NotificationSettings(
      {final bool friendRequests,
      final bool pokes,
      final bool eventShares,
      final bool eventReminders,
      final bool eventUpdates,
      final bool reflectionReminders,
      final bool streakMilestones,
      final bool systemMessages,
      final bool announcements,
      final bool soundEnabled,
      final bool vibrationEnabled,
      final String quietHoursStart,
      final String quietHoursEnd,
      final bool quietHoursEnabled}) = _$NotificationSettingsImpl;

  factory _NotificationSettings.fromJson(Map<String, dynamic> json) =
      _$NotificationSettingsImpl.fromJson;

  @override
  bool get friendRequests;
  @override
  bool get pokes;
  @override
  bool get eventShares;
  @override
  bool get eventReminders;
  @override
  bool get eventUpdates;
  @override
  bool get reflectionReminders;
  @override
  bool get streakMilestones;
  @override
  bool get systemMessages;
  @override
  bool get announcements;
  @override
  bool get soundEnabled;
  @override
  bool get vibrationEnabled;
  @override
  String get quietHoursStart;
  @override
  String get quietHoursEnd;
  @override
  bool get quietHoursEnabled;
  @override
  @JsonKey(ignore: true)
  _$$NotificationSettingsImplCopyWith<_$NotificationSettingsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

InboxBatchResult _$InboxBatchResultFromJson(Map<String, dynamic> json) {
  return _InboxBatchResult.fromJson(json);
}

/// @nodoc
mixin _$InboxBatchResult {
  int get successCount => throw _privateConstructorUsedError;
  int get failureCount => throw _privateConstructorUsedError;
  List<String> get failedIds => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InboxBatchResultCopyWith<InboxBatchResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InboxBatchResultCopyWith<$Res> {
  factory $InboxBatchResultCopyWith(
          InboxBatchResult value, $Res Function(InboxBatchResult) then) =
      _$InboxBatchResultCopyWithImpl<$Res, InboxBatchResult>;
  @useResult
  $Res call(
      {int successCount,
      int failureCount,
      List<String> failedIds,
      String? error});
}

/// @nodoc
class _$InboxBatchResultCopyWithImpl<$Res, $Val extends InboxBatchResult>
    implements $InboxBatchResultCopyWith<$Res> {
  _$InboxBatchResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? successCount = null,
    Object? failureCount = null,
    Object? failedIds = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      successCount: null == successCount
          ? _value.successCount
          : successCount // ignore: cast_nullable_to_non_nullable
              as int,
      failureCount: null == failureCount
          ? _value.failureCount
          : failureCount // ignore: cast_nullable_to_non_nullable
              as int,
      failedIds: null == failedIds
          ? _value.failedIds
          : failedIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InboxBatchResultImplCopyWith<$Res>
    implements $InboxBatchResultCopyWith<$Res> {
  factory _$$InboxBatchResultImplCopyWith(_$InboxBatchResultImpl value,
          $Res Function(_$InboxBatchResultImpl) then) =
      __$$InboxBatchResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int successCount,
      int failureCount,
      List<String> failedIds,
      String? error});
}

/// @nodoc
class __$$InboxBatchResultImplCopyWithImpl<$Res>
    extends _$InboxBatchResultCopyWithImpl<$Res, _$InboxBatchResultImpl>
    implements _$$InboxBatchResultImplCopyWith<$Res> {
  __$$InboxBatchResultImplCopyWithImpl(_$InboxBatchResultImpl _value,
      $Res Function(_$InboxBatchResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? successCount = null,
    Object? failureCount = null,
    Object? failedIds = null,
    Object? error = freezed,
  }) {
    return _then(_$InboxBatchResultImpl(
      successCount: null == successCount
          ? _value.successCount
          : successCount // ignore: cast_nullable_to_non_nullable
              as int,
      failureCount: null == failureCount
          ? _value.failureCount
          : failureCount // ignore: cast_nullable_to_non_nullable
              as int,
      failedIds: null == failedIds
          ? _value._failedIds
          : failedIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InboxBatchResultImpl implements _InboxBatchResult {
  const _$InboxBatchResultImpl(
      {required this.successCount,
      required this.failureCount,
      final List<String> failedIds = const [],
      this.error})
      : _failedIds = failedIds;

  factory _$InboxBatchResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$InboxBatchResultImplFromJson(json);

  @override
  final int successCount;
  @override
  final int failureCount;
  final List<String> _failedIds;
  @override
  @JsonKey()
  List<String> get failedIds {
    if (_failedIds is EqualUnmodifiableListView) return _failedIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_failedIds);
  }

  @override
  final String? error;

  @override
  String toString() {
    return 'InboxBatchResult(successCount: $successCount, failureCount: $failureCount, failedIds: $failedIds, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InboxBatchResultImpl &&
            (identical(other.successCount, successCount) ||
                other.successCount == successCount) &&
            (identical(other.failureCount, failureCount) ||
                other.failureCount == failureCount) &&
            const DeepCollectionEquality()
                .equals(other._failedIds, _failedIds) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, successCount, failureCount,
      const DeepCollectionEquality().hash(_failedIds), error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InboxBatchResultImplCopyWith<_$InboxBatchResultImpl> get copyWith =>
      __$$InboxBatchResultImplCopyWithImpl<_$InboxBatchResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InboxBatchResultImplToJson(
      this,
    );
  }
}

abstract class _InboxBatchResult implements InboxBatchResult {
  const factory _InboxBatchResult(
      {required final int successCount,
      required final int failureCount,
      final List<String> failedIds,
      final String? error}) = _$InboxBatchResultImpl;

  factory _InboxBatchResult.fromJson(Map<String, dynamic> json) =
      _$InboxBatchResultImpl.fromJson;

  @override
  int get successCount;
  @override
  int get failureCount;
  @override
  List<String> get failedIds;
  @override
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$InboxBatchResultImplCopyWith<_$InboxBatchResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
