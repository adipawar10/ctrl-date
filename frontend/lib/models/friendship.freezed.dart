// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friendship.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Friendship _$FriendshipFromJson(Map<String, dynamic> json) {
  return _Friendship.fromJson(json);
}

/// @nodoc
mixin _$Friendship {
  String get id => throw _privateConstructorUsedError;
  String get requesterId => throw _privateConstructorUsedError;
  String get addresseeId => throw _privateConstructorUsedError;
  FriendshipStatus get status => throw _privateConstructorUsedError;
  UserProfile? get requester => throw _privateConstructorUsedError;
  UserProfile? get addressee => throw _privateConstructorUsedError;
  String? get nickname => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  DateTime? get acceptedAt => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  bool get isMuted => throw _privateConstructorUsedError;
  String? get sharedKey => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FriendshipCopyWith<Friendship> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendshipCopyWith<$Res> {
  factory $FriendshipCopyWith(
          Friendship value, $Res Function(Friendship) then) =
      _$FriendshipCopyWithImpl<$Res, Friendship>;
  @useResult
  $Res call(
      {String id,
      String requesterId,
      String addresseeId,
      FriendshipStatus status,
      UserProfile? requester,
      UserProfile? addressee,
      String? nickname,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? acceptedAt,
      bool isFavorite,
      bool isMuted,
      String? sharedKey});

  $UserProfileCopyWith<$Res>? get requester;
  $UserProfileCopyWith<$Res>? get addressee;
}

/// @nodoc
class _$FriendshipCopyWithImpl<$Res, $Val extends Friendship>
    implements $FriendshipCopyWith<$Res> {
  _$FriendshipCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requesterId = null,
    Object? addresseeId = null,
    Object? status = null,
    Object? requester = freezed,
    Object? addressee = freezed,
    Object? nickname = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? acceptedAt = freezed,
    Object? isFavorite = null,
    Object? isMuted = null,
    Object? sharedKey = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      requesterId: null == requesterId
          ? _value.requesterId
          : requesterId // ignore: cast_nullable_to_non_nullable
              as String,
      addresseeId: null == addresseeId
          ? _value.addresseeId
          : addresseeId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FriendshipStatus,
      requester: freezed == requester
          ? _value.requester
          : requester // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
      addressee: freezed == addressee
          ? _value.addressee
          : addressee // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
      nickname: freezed == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      acceptedAt: freezed == acceptedAt
          ? _value.acceptedAt
          : acceptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      isMuted: null == isMuted
          ? _value.isMuted
          : isMuted // ignore: cast_nullable_to_non_nullable
              as bool,
      sharedKey: freezed == sharedKey
          ? _value.sharedKey
          : sharedKey // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<$Res>? get requester {
    if (_value.requester == null) {
      return null;
    }

    return $UserProfileCopyWith<$Res>(_value.requester!, (value) {
      return _then(_value.copyWith(requester: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<$Res>? get addressee {
    if (_value.addressee == null) {
      return null;
    }

    return $UserProfileCopyWith<$Res>(_value.addressee!, (value) {
      return _then(_value.copyWith(addressee: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FriendshipImplCopyWith<$Res>
    implements $FriendshipCopyWith<$Res> {
  factory _$$FriendshipImplCopyWith(
          _$FriendshipImpl value, $Res Function(_$FriendshipImpl) then) =
      __$$FriendshipImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String requesterId,
      String addresseeId,
      FriendshipStatus status,
      UserProfile? requester,
      UserProfile? addressee,
      String? nickname,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? acceptedAt,
      bool isFavorite,
      bool isMuted,
      String? sharedKey});

  @override
  $UserProfileCopyWith<$Res>? get requester;
  @override
  $UserProfileCopyWith<$Res>? get addressee;
}

/// @nodoc
class __$$FriendshipImplCopyWithImpl<$Res>
    extends _$FriendshipCopyWithImpl<$Res, _$FriendshipImpl>
    implements _$$FriendshipImplCopyWith<$Res> {
  __$$FriendshipImplCopyWithImpl(
      _$FriendshipImpl _value, $Res Function(_$FriendshipImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requesterId = null,
    Object? addresseeId = null,
    Object? status = null,
    Object? requester = freezed,
    Object? addressee = freezed,
    Object? nickname = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? acceptedAt = freezed,
    Object? isFavorite = null,
    Object? isMuted = null,
    Object? sharedKey = freezed,
  }) {
    return _then(_$FriendshipImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      requesterId: null == requesterId
          ? _value.requesterId
          : requesterId // ignore: cast_nullable_to_non_nullable
              as String,
      addresseeId: null == addresseeId
          ? _value.addresseeId
          : addresseeId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FriendshipStatus,
      requester: freezed == requester
          ? _value.requester
          : requester // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
      addressee: freezed == addressee
          ? _value.addressee
          : addressee // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
      nickname: freezed == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      acceptedAt: freezed == acceptedAt
          ? _value.acceptedAt
          : acceptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      isMuted: null == isMuted
          ? _value.isMuted
          : isMuted // ignore: cast_nullable_to_non_nullable
              as bool,
      sharedKey: freezed == sharedKey
          ? _value.sharedKey
          : sharedKey // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FriendshipImpl extends _Friendship {
  const _$FriendshipImpl(
      {required this.id,
      required this.requesterId,
      required this.addresseeId,
      this.status = FriendshipStatus.pending,
      this.requester,
      this.addressee,
      this.nickname,
      this.createdAt,
      this.updatedAt,
      this.acceptedAt,
      this.isFavorite = false,
      this.isMuted = false,
      this.sharedKey})
      : super._();

  factory _$FriendshipImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendshipImplFromJson(json);

  @override
  final String id;
  @override
  final String requesterId;
  @override
  final String addresseeId;
  @override
  @JsonKey()
  final FriendshipStatus status;
  @override
  final UserProfile? requester;
  @override
  final UserProfile? addressee;
  @override
  final String? nickname;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? acceptedAt;
  @override
  @JsonKey()
  final bool isFavorite;
  @override
  @JsonKey()
  final bool isMuted;
  @override
  final String? sharedKey;

  @override
  String toString() {
    return 'Friendship(id: $id, requesterId: $requesterId, addresseeId: $addresseeId, status: $status, requester: $requester, addressee: $addressee, nickname: $nickname, createdAt: $createdAt, updatedAt: $updatedAt, acceptedAt: $acceptedAt, isFavorite: $isFavorite, isMuted: $isMuted, sharedKey: $sharedKey)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendshipImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.requesterId, requesterId) ||
                other.requesterId == requesterId) &&
            (identical(other.addresseeId, addresseeId) ||
                other.addresseeId == addresseeId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.requester, requester) ||
                other.requester == requester) &&
            (identical(other.addressee, addressee) ||
                other.addressee == addressee) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.acceptedAt, acceptedAt) ||
                other.acceptedAt == acceptedAt) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.isMuted, isMuted) || other.isMuted == isMuted) &&
            (identical(other.sharedKey, sharedKey) ||
                other.sharedKey == sharedKey));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      requesterId,
      addresseeId,
      status,
      requester,
      addressee,
      nickname,
      createdAt,
      updatedAt,
      acceptedAt,
      isFavorite,
      isMuted,
      sharedKey);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendshipImplCopyWith<_$FriendshipImpl> get copyWith =>
      __$$FriendshipImplCopyWithImpl<_$FriendshipImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendshipImplToJson(
      this,
    );
  }
}

abstract class _Friendship extends Friendship {
  const factory _Friendship(
      {required final String id,
      required final String requesterId,
      required final String addresseeId,
      final FriendshipStatus status,
      final UserProfile? requester,
      final UserProfile? addressee,
      final String? nickname,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final DateTime? acceptedAt,
      final bool isFavorite,
      final bool isMuted,
      final String? sharedKey}) = _$FriendshipImpl;
  const _Friendship._() : super._();

  factory _Friendship.fromJson(Map<String, dynamic> json) =
      _$FriendshipImpl.fromJson;

  @override
  String get id;
  @override
  String get requesterId;
  @override
  String get addresseeId;
  @override
  FriendshipStatus get status;
  @override
  UserProfile? get requester;
  @override
  UserProfile? get addressee;
  @override
  String? get nickname;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  DateTime? get acceptedAt;
  @override
  bool get isFavorite;
  @override
  bool get isMuted;
  @override
  String? get sharedKey;
  @override
  @JsonKey(ignore: true)
  _$$FriendshipImplCopyWith<_$FriendshipImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Poke _$PokeFromJson(Map<String, dynamic> json) {
  return _Poke.fromJson(json);
}

/// @nodoc
mixin _$Poke {
  String get id => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String get receiverId => throw _privateConstructorUsedError;
  PokeType get type => throw _privateConstructorUsedError;
  String? get customMessage => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get readAt => throw _privateConstructorUsedError;
  UserProfile? get sender => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PokeCopyWith<Poke> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PokeCopyWith<$Res> {
  factory $PokeCopyWith(Poke value, $Res Function(Poke) then) =
      _$PokeCopyWithImpl<$Res, Poke>;
  @useResult
  $Res call(
      {String id,
      String senderId,
      String receiverId,
      PokeType type,
      String? customMessage,
      bool isRead,
      DateTime? createdAt,
      DateTime? readAt,
      UserProfile? sender});

  $UserProfileCopyWith<$Res>? get sender;
}

/// @nodoc
class _$PokeCopyWithImpl<$Res, $Val extends Poke>
    implements $PokeCopyWith<$Res> {
  _$PokeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderId = null,
    Object? receiverId = null,
    Object? type = null,
    Object? customMessage = freezed,
    Object? isRead = null,
    Object? createdAt = freezed,
    Object? readAt = freezed,
    Object? sender = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      receiverId: null == receiverId
          ? _value.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PokeType,
      customMessage: freezed == customMessage
          ? _value.customMessage
          : customMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sender: freezed == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
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
abstract class _$$PokeImplCopyWith<$Res> implements $PokeCopyWith<$Res> {
  factory _$$PokeImplCopyWith(
          _$PokeImpl value, $Res Function(_$PokeImpl) then) =
      __$$PokeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String senderId,
      String receiverId,
      PokeType type,
      String? customMessage,
      bool isRead,
      DateTime? createdAt,
      DateTime? readAt,
      UserProfile? sender});

  @override
  $UserProfileCopyWith<$Res>? get sender;
}

/// @nodoc
class __$$PokeImplCopyWithImpl<$Res>
    extends _$PokeCopyWithImpl<$Res, _$PokeImpl>
    implements _$$PokeImplCopyWith<$Res> {
  __$$PokeImplCopyWithImpl(_$PokeImpl _value, $Res Function(_$PokeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderId = null,
    Object? receiverId = null,
    Object? type = null,
    Object? customMessage = freezed,
    Object? isRead = null,
    Object? createdAt = freezed,
    Object? readAt = freezed,
    Object? sender = freezed,
  }) {
    return _then(_$PokeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      receiverId: null == receiverId
          ? _value.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PokeType,
      customMessage: freezed == customMessage
          ? _value.customMessage
          : customMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sender: freezed == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PokeImpl implements _Poke {
  const _$PokeImpl(
      {required this.id,
      required this.senderId,
      required this.receiverId,
      this.type = PokeType.wave,
      this.customMessage,
      this.isRead = false,
      this.createdAt,
      this.readAt,
      this.sender});

  factory _$PokeImpl.fromJson(Map<String, dynamic> json) =>
      _$$PokeImplFromJson(json);

  @override
  final String id;
  @override
  final String senderId;
  @override
  final String receiverId;
  @override
  @JsonKey()
  final PokeType type;
  @override
  final String? customMessage;
  @override
  @JsonKey()
  final bool isRead;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? readAt;
  @override
  final UserProfile? sender;

  @override
  String toString() {
    return 'Poke(id: $id, senderId: $senderId, receiverId: $receiverId, type: $type, customMessage: $customMessage, isRead: $isRead, createdAt: $createdAt, readAt: $readAt, sender: $sender)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PokeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.receiverId, receiverId) ||
                other.receiverId == receiverId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.customMessage, customMessage) ||
                other.customMessage == customMessage) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.sender, sender) || other.sender == sender));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, senderId, receiverId, type,
      customMessage, isRead, createdAt, readAt, sender);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PokeImplCopyWith<_$PokeImpl> get copyWith =>
      __$$PokeImplCopyWithImpl<_$PokeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PokeImplToJson(
      this,
    );
  }
}

abstract class _Poke implements Poke {
  const factory _Poke(
      {required final String id,
      required final String senderId,
      required final String receiverId,
      final PokeType type,
      final String? customMessage,
      final bool isRead,
      final DateTime? createdAt,
      final DateTime? readAt,
      final UserProfile? sender}) = _$PokeImpl;

  factory _Poke.fromJson(Map<String, dynamic> json) = _$PokeImpl.fromJson;

  @override
  String get id;
  @override
  String get senderId;
  @override
  String get receiverId;
  @override
  PokeType get type;
  @override
  String? get customMessage;
  @override
  bool get isRead;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get readAt;
  @override
  UserProfile? get sender;
  @override
  @JsonKey(ignore: true)
  _$$PokeImplCopyWith<_$PokeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EventShare _$EventShareFromJson(Map<String, dynamic> json) {
  return _EventShare.fromJson(json);
}

/// @nodoc
mixin _$EventShare {
  String get id => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  String get sharedByUserId => throw _privateConstructorUsedError;
  String get sharedWithUserId => throw _privateConstructorUsedError;
  EventSharePermission get permission => throw _privateConstructorUsedError;
  EventShareStatus get status => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  String? get encryptedEventData => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get acceptedAt => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  UserProfile? get sharedBy => throw _privateConstructorUsedError;
  UserProfile? get sharedWith => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventShareCopyWith<EventShare> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventShareCopyWith<$Res> {
  factory $EventShareCopyWith(
          EventShare value, $Res Function(EventShare) then) =
      _$EventShareCopyWithImpl<$Res, EventShare>;
  @useResult
  $Res call(
      {String id,
      String eventId,
      String sharedByUserId,
      String sharedWithUserId,
      EventSharePermission permission,
      EventShareStatus status,
      String? message,
      String? encryptedEventData,
      DateTime? createdAt,
      DateTime? acceptedAt,
      DateTime? expiresAt,
      UserProfile? sharedBy,
      UserProfile? sharedWith});

  $UserProfileCopyWith<$Res>? get sharedBy;
  $UserProfileCopyWith<$Res>? get sharedWith;
}

/// @nodoc
class _$EventShareCopyWithImpl<$Res, $Val extends EventShare>
    implements $EventShareCopyWith<$Res> {
  _$EventShareCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? sharedByUserId = null,
    Object? sharedWithUserId = null,
    Object? permission = null,
    Object? status = null,
    Object? message = freezed,
    Object? encryptedEventData = freezed,
    Object? createdAt = freezed,
    Object? acceptedAt = freezed,
    Object? expiresAt = freezed,
    Object? sharedBy = freezed,
    Object? sharedWith = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      sharedByUserId: null == sharedByUserId
          ? _value.sharedByUserId
          : sharedByUserId // ignore: cast_nullable_to_non_nullable
              as String,
      sharedWithUserId: null == sharedWithUserId
          ? _value.sharedWithUserId
          : sharedWithUserId // ignore: cast_nullable_to_non_nullable
              as String,
      permission: null == permission
          ? _value.permission
          : permission // ignore: cast_nullable_to_non_nullable
              as EventSharePermission,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EventShareStatus,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      encryptedEventData: freezed == encryptedEventData
          ? _value.encryptedEventData
          : encryptedEventData // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      acceptedAt: freezed == acceptedAt
          ? _value.acceptedAt
          : acceptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sharedBy: freezed == sharedBy
          ? _value.sharedBy
          : sharedBy // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
      sharedWith: freezed == sharedWith
          ? _value.sharedWith
          : sharedWith // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<$Res>? get sharedBy {
    if (_value.sharedBy == null) {
      return null;
    }

    return $UserProfileCopyWith<$Res>(_value.sharedBy!, (value) {
      return _then(_value.copyWith(sharedBy: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<$Res>? get sharedWith {
    if (_value.sharedWith == null) {
      return null;
    }

    return $UserProfileCopyWith<$Res>(_value.sharedWith!, (value) {
      return _then(_value.copyWith(sharedWith: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EventShareImplCopyWith<$Res>
    implements $EventShareCopyWith<$Res> {
  factory _$$EventShareImplCopyWith(
          _$EventShareImpl value, $Res Function(_$EventShareImpl) then) =
      __$$EventShareImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String eventId,
      String sharedByUserId,
      String sharedWithUserId,
      EventSharePermission permission,
      EventShareStatus status,
      String? message,
      String? encryptedEventData,
      DateTime? createdAt,
      DateTime? acceptedAt,
      DateTime? expiresAt,
      UserProfile? sharedBy,
      UserProfile? sharedWith});

  @override
  $UserProfileCopyWith<$Res>? get sharedBy;
  @override
  $UserProfileCopyWith<$Res>? get sharedWith;
}

/// @nodoc
class __$$EventShareImplCopyWithImpl<$Res>
    extends _$EventShareCopyWithImpl<$Res, _$EventShareImpl>
    implements _$$EventShareImplCopyWith<$Res> {
  __$$EventShareImplCopyWithImpl(
      _$EventShareImpl _value, $Res Function(_$EventShareImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? sharedByUserId = null,
    Object? sharedWithUserId = null,
    Object? permission = null,
    Object? status = null,
    Object? message = freezed,
    Object? encryptedEventData = freezed,
    Object? createdAt = freezed,
    Object? acceptedAt = freezed,
    Object? expiresAt = freezed,
    Object? sharedBy = freezed,
    Object? sharedWith = freezed,
  }) {
    return _then(_$EventShareImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      sharedByUserId: null == sharedByUserId
          ? _value.sharedByUserId
          : sharedByUserId // ignore: cast_nullable_to_non_nullable
              as String,
      sharedWithUserId: null == sharedWithUserId
          ? _value.sharedWithUserId
          : sharedWithUserId // ignore: cast_nullable_to_non_nullable
              as String,
      permission: null == permission
          ? _value.permission
          : permission // ignore: cast_nullable_to_non_nullable
              as EventSharePermission,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EventShareStatus,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      encryptedEventData: freezed == encryptedEventData
          ? _value.encryptedEventData
          : encryptedEventData // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      acceptedAt: freezed == acceptedAt
          ? _value.acceptedAt
          : acceptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sharedBy: freezed == sharedBy
          ? _value.sharedBy
          : sharedBy // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
      sharedWith: freezed == sharedWith
          ? _value.sharedWith
          : sharedWith // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventShareImpl extends _EventShare {
  const _$EventShareImpl(
      {required this.id,
      required this.eventId,
      required this.sharedByUserId,
      required this.sharedWithUserId,
      this.permission = EventSharePermission.view,
      this.status = EventShareStatus.pending,
      this.message,
      this.encryptedEventData,
      this.createdAt,
      this.acceptedAt,
      this.expiresAt,
      this.sharedBy,
      this.sharedWith})
      : super._();

  factory _$EventShareImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventShareImplFromJson(json);

  @override
  final String id;
  @override
  final String eventId;
  @override
  final String sharedByUserId;
  @override
  final String sharedWithUserId;
  @override
  @JsonKey()
  final EventSharePermission permission;
  @override
  @JsonKey()
  final EventShareStatus status;
  @override
  final String? message;
  @override
  final String? encryptedEventData;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? acceptedAt;
  @override
  final DateTime? expiresAt;
  @override
  final UserProfile? sharedBy;
  @override
  final UserProfile? sharedWith;

  @override
  String toString() {
    return 'EventShare(id: $id, eventId: $eventId, sharedByUserId: $sharedByUserId, sharedWithUserId: $sharedWithUserId, permission: $permission, status: $status, message: $message, encryptedEventData: $encryptedEventData, createdAt: $createdAt, acceptedAt: $acceptedAt, expiresAt: $expiresAt, sharedBy: $sharedBy, sharedWith: $sharedWith)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventShareImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.sharedByUserId, sharedByUserId) ||
                other.sharedByUserId == sharedByUserId) &&
            (identical(other.sharedWithUserId, sharedWithUserId) ||
                other.sharedWithUserId == sharedWithUserId) &&
            (identical(other.permission, permission) ||
                other.permission == permission) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.encryptedEventData, encryptedEventData) ||
                other.encryptedEventData == encryptedEventData) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.acceptedAt, acceptedAt) ||
                other.acceptedAt == acceptedAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.sharedBy, sharedBy) ||
                other.sharedBy == sharedBy) &&
            (identical(other.sharedWith, sharedWith) ||
                other.sharedWith == sharedWith));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
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
      expiresAt,
      sharedBy,
      sharedWith);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventShareImplCopyWith<_$EventShareImpl> get copyWith =>
      __$$EventShareImplCopyWithImpl<_$EventShareImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventShareImplToJson(
      this,
    );
  }
}

abstract class _EventShare extends EventShare {
  const factory _EventShare(
      {required final String id,
      required final String eventId,
      required final String sharedByUserId,
      required final String sharedWithUserId,
      final EventSharePermission permission,
      final EventShareStatus status,
      final String? message,
      final String? encryptedEventData,
      final DateTime? createdAt,
      final DateTime? acceptedAt,
      final DateTime? expiresAt,
      final UserProfile? sharedBy,
      final UserProfile? sharedWith}) = _$EventShareImpl;
  const _EventShare._() : super._();

  factory _EventShare.fromJson(Map<String, dynamic> json) =
      _$EventShareImpl.fromJson;

  @override
  String get id;
  @override
  String get eventId;
  @override
  String get sharedByUserId;
  @override
  String get sharedWithUserId;
  @override
  EventSharePermission get permission;
  @override
  EventShareStatus get status;
  @override
  String? get message;
  @override
  String? get encryptedEventData;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get acceptedAt;
  @override
  DateTime? get expiresAt;
  @override
  UserProfile? get sharedBy;
  @override
  UserProfile? get sharedWith;
  @override
  @JsonKey(ignore: true)
  _$$EventShareImplCopyWith<_$EventShareImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FriendRequest _$FriendRequestFromJson(Map<String, dynamic> json) {
  return _FriendRequest.fromJson(json);
}

/// @nodoc
mixin _$FriendRequest {
  String get id => throw _privateConstructorUsedError;
  String get requesterId => throw _privateConstructorUsedError;
  String get addresseeId => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  FriendRequestStatus get status => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get respondedAt => throw _privateConstructorUsedError;
  UserProfile? get requester => throw _privateConstructorUsedError;
  UserProfile? get addressee => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FriendRequestCopyWith<FriendRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendRequestCopyWith<$Res> {
  factory $FriendRequestCopyWith(
          FriendRequest value, $Res Function(FriendRequest) then) =
      _$FriendRequestCopyWithImpl<$Res, FriendRequest>;
  @useResult
  $Res call(
      {String id,
      String requesterId,
      String addresseeId,
      String? message,
      FriendRequestStatus status,
      DateTime? createdAt,
      DateTime? respondedAt,
      UserProfile? requester,
      UserProfile? addressee});

  $UserProfileCopyWith<$Res>? get requester;
  $UserProfileCopyWith<$Res>? get addressee;
}

/// @nodoc
class _$FriendRequestCopyWithImpl<$Res, $Val extends FriendRequest>
    implements $FriendRequestCopyWith<$Res> {
  _$FriendRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requesterId = null,
    Object? addresseeId = null,
    Object? message = freezed,
    Object? status = null,
    Object? createdAt = freezed,
    Object? respondedAt = freezed,
    Object? requester = freezed,
    Object? addressee = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      requesterId: null == requesterId
          ? _value.requesterId
          : requesterId // ignore: cast_nullable_to_non_nullable
              as String,
      addresseeId: null == addresseeId
          ? _value.addresseeId
          : addresseeId // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FriendRequestStatus,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      requester: freezed == requester
          ? _value.requester
          : requester // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
      addressee: freezed == addressee
          ? _value.addressee
          : addressee // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<$Res>? get requester {
    if (_value.requester == null) {
      return null;
    }

    return $UserProfileCopyWith<$Res>(_value.requester!, (value) {
      return _then(_value.copyWith(requester: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<$Res>? get addressee {
    if (_value.addressee == null) {
      return null;
    }

    return $UserProfileCopyWith<$Res>(_value.addressee!, (value) {
      return _then(_value.copyWith(addressee: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FriendRequestImplCopyWith<$Res>
    implements $FriendRequestCopyWith<$Res> {
  factory _$$FriendRequestImplCopyWith(
          _$FriendRequestImpl value, $Res Function(_$FriendRequestImpl) then) =
      __$$FriendRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String requesterId,
      String addresseeId,
      String? message,
      FriendRequestStatus status,
      DateTime? createdAt,
      DateTime? respondedAt,
      UserProfile? requester,
      UserProfile? addressee});

  @override
  $UserProfileCopyWith<$Res>? get requester;
  @override
  $UserProfileCopyWith<$Res>? get addressee;
}

/// @nodoc
class __$$FriendRequestImplCopyWithImpl<$Res>
    extends _$FriendRequestCopyWithImpl<$Res, _$FriendRequestImpl>
    implements _$$FriendRequestImplCopyWith<$Res> {
  __$$FriendRequestImplCopyWithImpl(
      _$FriendRequestImpl _value, $Res Function(_$FriendRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requesterId = null,
    Object? addresseeId = null,
    Object? message = freezed,
    Object? status = null,
    Object? createdAt = freezed,
    Object? respondedAt = freezed,
    Object? requester = freezed,
    Object? addressee = freezed,
  }) {
    return _then(_$FriendRequestImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      requesterId: null == requesterId
          ? _value.requesterId
          : requesterId // ignore: cast_nullable_to_non_nullable
              as String,
      addresseeId: null == addresseeId
          ? _value.addresseeId
          : addresseeId // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FriendRequestStatus,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      requester: freezed == requester
          ? _value.requester
          : requester // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
      addressee: freezed == addressee
          ? _value.addressee
          : addressee // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FriendRequestImpl implements _FriendRequest {
  const _$FriendRequestImpl(
      {required this.id,
      required this.requesterId,
      required this.addresseeId,
      this.message,
      this.status = FriendRequestStatus.pending,
      this.createdAt,
      this.respondedAt,
      this.requester,
      this.addressee});

  factory _$FriendRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendRequestImplFromJson(json);

  @override
  final String id;
  @override
  final String requesterId;
  @override
  final String addresseeId;
  @override
  final String? message;
  @override
  @JsonKey()
  final FriendRequestStatus status;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? respondedAt;
  @override
  final UserProfile? requester;
  @override
  final UserProfile? addressee;

  @override
  String toString() {
    return 'FriendRequest(id: $id, requesterId: $requesterId, addresseeId: $addresseeId, message: $message, status: $status, createdAt: $createdAt, respondedAt: $respondedAt, requester: $requester, addressee: $addressee)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.requesterId, requesterId) ||
                other.requesterId == requesterId) &&
            (identical(other.addresseeId, addresseeId) ||
                other.addresseeId == addresseeId) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.respondedAt, respondedAt) ||
                other.respondedAt == respondedAt) &&
            (identical(other.requester, requester) ||
                other.requester == requester) &&
            (identical(other.addressee, addressee) ||
                other.addressee == addressee));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, requesterId, addresseeId,
      message, status, createdAt, respondedAt, requester, addressee);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendRequestImplCopyWith<_$FriendRequestImpl> get copyWith =>
      __$$FriendRequestImplCopyWithImpl<_$FriendRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendRequestImplToJson(
      this,
    );
  }
}

abstract class _FriendRequest implements FriendRequest {
  const factory _FriendRequest(
      {required final String id,
      required final String requesterId,
      required final String addresseeId,
      final String? message,
      final FriendRequestStatus status,
      final DateTime? createdAt,
      final DateTime? respondedAt,
      final UserProfile? requester,
      final UserProfile? addressee}) = _$FriendRequestImpl;

  factory _FriendRequest.fromJson(Map<String, dynamic> json) =
      _$FriendRequestImpl.fromJson;

  @override
  String get id;
  @override
  String get requesterId;
  @override
  String get addresseeId;
  @override
  String? get message;
  @override
  FriendRequestStatus get status;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get respondedAt;
  @override
  UserProfile? get requester;
  @override
  UserProfile? get addressee;
  @override
  @JsonKey(ignore: true)
  _$$FriendRequestImplCopyWith<_$FriendRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FriendActivity _$FriendActivityFromJson(Map<String, dynamic> json) {
  return _FriendActivity.fromJson(json);
}

/// @nodoc
mixin _$FriendActivity {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get activityType => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  UserProfile? get user => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FriendActivityCopyWith<FriendActivity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendActivityCopyWith<$Res> {
  factory $FriendActivityCopyWith(
          FriendActivity value, $Res Function(FriendActivity) then) =
      _$FriendActivityCopyWithImpl<$Res, FriendActivity>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String activityType,
      String? description,
      Map<String, dynamic>? metadata,
      DateTime? createdAt,
      UserProfile? user});

  $UserProfileCopyWith<$Res>? get user;
}

/// @nodoc
class _$FriendActivityCopyWithImpl<$Res, $Val extends FriendActivity>
    implements $FriendActivityCopyWith<$Res> {
  _$FriendActivityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? activityType = null,
    Object? description = freezed,
    Object? metadata = freezed,
    Object? createdAt = freezed,
    Object? user = freezed,
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
      activityType: null == activityType
          ? _value.activityType
          : activityType // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserProfileCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FriendActivityImplCopyWith<$Res>
    implements $FriendActivityCopyWith<$Res> {
  factory _$$FriendActivityImplCopyWith(_$FriendActivityImpl value,
          $Res Function(_$FriendActivityImpl) then) =
      __$$FriendActivityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String activityType,
      String? description,
      Map<String, dynamic>? metadata,
      DateTime? createdAt,
      UserProfile? user});

  @override
  $UserProfileCopyWith<$Res>? get user;
}

/// @nodoc
class __$$FriendActivityImplCopyWithImpl<$Res>
    extends _$FriendActivityCopyWithImpl<$Res, _$FriendActivityImpl>
    implements _$$FriendActivityImplCopyWith<$Res> {
  __$$FriendActivityImplCopyWithImpl(
      _$FriendActivityImpl _value, $Res Function(_$FriendActivityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? activityType = null,
    Object? description = freezed,
    Object? metadata = freezed,
    Object? createdAt = freezed,
    Object? user = freezed,
  }) {
    return _then(_$FriendActivityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      activityType: null == activityType
          ? _value.activityType
          : activityType // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FriendActivityImpl implements _FriendActivity {
  const _$FriendActivityImpl(
      {required this.id,
      required this.userId,
      required this.activityType,
      this.description,
      final Map<String, dynamic>? metadata,
      this.createdAt,
      this.user})
      : _metadata = metadata;

  factory _$FriendActivityImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendActivityImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String activityType;
  @override
  final String? description;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime? createdAt;
  @override
  final UserProfile? user;

  @override
  String toString() {
    return 'FriendActivity(id: $id, userId: $userId, activityType: $activityType, description: $description, metadata: $metadata, createdAt: $createdAt, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendActivityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.activityType, activityType) ||
                other.activityType == activityType) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.user, user) || other.user == user));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      activityType,
      description,
      const DeepCollectionEquality().hash(_metadata),
      createdAt,
      user);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendActivityImplCopyWith<_$FriendActivityImpl> get copyWith =>
      __$$FriendActivityImplCopyWithImpl<_$FriendActivityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendActivityImplToJson(
      this,
    );
  }
}

abstract class _FriendActivity implements FriendActivity {
  const factory _FriendActivity(
      {required final String id,
      required final String userId,
      required final String activityType,
      final String? description,
      final Map<String, dynamic>? metadata,
      final DateTime? createdAt,
      final UserProfile? user}) = _$FriendActivityImpl;

  factory _FriendActivity.fromJson(Map<String, dynamic> json) =
      _$FriendActivityImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get activityType;
  @override
  String? get description;
  @override
  Map<String, dynamic>? get metadata;
  @override
  DateTime? get createdAt;
  @override
  UserProfile? get user;
  @override
  @JsonKey(ignore: true)
  _$$FriendActivityImplCopyWith<_$FriendActivityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
