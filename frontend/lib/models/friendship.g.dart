// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friendship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FriendshipImpl _$$FriendshipImplFromJson(Map<String, dynamic> json) =>
    _$FriendshipImpl(
      id: json['id'] as String,
      requesterId: json['requesterId'] as String,
      addresseeId: json['addresseeId'] as String,
      status: $enumDecodeNullable(_$FriendshipStatusEnumMap, json['status']) ??
          FriendshipStatus.pending,
      requester: json['requester'] == null
          ? null
          : UserProfile.fromJson(json['requester'] as Map<String, dynamic>),
      addressee: json['addressee'] == null
          ? null
          : UserProfile.fromJson(json['addressee'] as Map<String, dynamic>),
      nickname: json['nickname'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      acceptedAt: json['acceptedAt'] == null
          ? null
          : DateTime.parse(json['acceptedAt'] as String),
      isFavorite: json['isFavorite'] as bool? ?? false,
      isMuted: json['isMuted'] as bool? ?? false,
      sharedKey: json['sharedKey'] as String?,
    );

Map<String, dynamic> _$$FriendshipImplToJson(_$FriendshipImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requesterId': instance.requesterId,
      'addresseeId': instance.addresseeId,
      'status': _$FriendshipStatusEnumMap[instance.status]!,
      'requester': instance.requester,
      'addressee': instance.addressee,
      'nickname': instance.nickname,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'acceptedAt': instance.acceptedAt?.toIso8601String(),
      'isFavorite': instance.isFavorite,
      'isMuted': instance.isMuted,
      'sharedKey': instance.sharedKey,
    };

const _$FriendshipStatusEnumMap = {
  FriendshipStatus.pending: 'pending',
  FriendshipStatus.accepted: 'accepted',
  FriendshipStatus.blocked: 'blocked',
  FriendshipStatus.declined: 'declined',
};

_$PokeImpl _$$PokeImplFromJson(Map<String, dynamic> json) => _$PokeImpl(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      type:
          $enumDecodeNullable(_$PokeTypeEnumMap, json['type']) ?? PokeType.wave,
      customMessage: json['customMessage'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      readAt: json['readAt'] == null
          ? null
          : DateTime.parse(json['readAt'] as String),
      sender: json['sender'] == null
          ? null
          : UserProfile.fromJson(json['sender'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PokeImplToJson(_$PokeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'type': _$PokeTypeEnumMap[instance.type]!,
      'customMessage': instance.customMessage,
      'isRead': instance.isRead,
      'createdAt': instance.createdAt?.toIso8601String(),
      'readAt': instance.readAt?.toIso8601String(),
      'sender': instance.sender,
    };

const _$PokeTypeEnumMap = {
  PokeType.wave: 'wave',
  PokeType.nudge: 'nudge',
  PokeType.thinkingOfYou: 'thinking_of_you',
  PokeType.missYou: 'miss_you',
  PokeType.custom: 'custom',
};

_$EventShareImpl _$$EventShareImplFromJson(Map<String, dynamic> json) =>
    _$EventShareImpl(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      sharedByUserId: json['sharedByUserId'] as String,
      sharedWithUserId: json['sharedWithUserId'] as String,
      permission: $enumDecodeNullable(
              _$EventSharePermissionEnumMap, json['permission']) ??
          EventSharePermission.view,
      status: $enumDecodeNullable(_$EventShareStatusEnumMap, json['status']) ??
          EventShareStatus.pending,
      message: json['message'] as String?,
      encryptedEventData: json['encryptedEventData'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      acceptedAt: json['acceptedAt'] == null
          ? null
          : DateTime.parse(json['acceptedAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      sharedBy: json['sharedBy'] == null
          ? null
          : UserProfile.fromJson(json['sharedBy'] as Map<String, dynamic>),
      sharedWith: json['sharedWith'] == null
          ? null
          : UserProfile.fromJson(json['sharedWith'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$EventShareImplToJson(_$EventShareImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'sharedByUserId': instance.sharedByUserId,
      'sharedWithUserId': instance.sharedWithUserId,
      'permission': _$EventSharePermissionEnumMap[instance.permission]!,
      'status': _$EventShareStatusEnumMap[instance.status]!,
      'message': instance.message,
      'encryptedEventData': instance.encryptedEventData,
      'createdAt': instance.createdAt?.toIso8601String(),
      'acceptedAt': instance.acceptedAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'sharedBy': instance.sharedBy,
      'sharedWith': instance.sharedWith,
    };

const _$EventSharePermissionEnumMap = {
  EventSharePermission.view: 'view',
  EventSharePermission.edit: 'edit',
  EventSharePermission.manage: 'manage',
};

const _$EventShareStatusEnumMap = {
  EventShareStatus.pending: 'pending',
  EventShareStatus.accepted: 'accepted',
  EventShareStatus.declined: 'declined',
  EventShareStatus.revoked: 'revoked',
};

_$FriendRequestImpl _$$FriendRequestImplFromJson(Map<String, dynamic> json) =>
    _$FriendRequestImpl(
      id: json['id'] as String,
      requesterId: json['requesterId'] as String,
      addresseeId: json['addresseeId'] as String,
      message: json['message'] as String?,
      status:
          $enumDecodeNullable(_$FriendRequestStatusEnumMap, json['status']) ??
              FriendRequestStatus.pending,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      respondedAt: json['respondedAt'] == null
          ? null
          : DateTime.parse(json['respondedAt'] as String),
      requester: json['requester'] == null
          ? null
          : UserProfile.fromJson(json['requester'] as Map<String, dynamic>),
      addressee: json['addressee'] == null
          ? null
          : UserProfile.fromJson(json['addressee'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$FriendRequestImplToJson(_$FriendRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requesterId': instance.requesterId,
      'addresseeId': instance.addresseeId,
      'message': instance.message,
      'status': _$FriendRequestStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt?.toIso8601String(),
      'respondedAt': instance.respondedAt?.toIso8601String(),
      'requester': instance.requester,
      'addressee': instance.addressee,
    };

const _$FriendRequestStatusEnumMap = {
  FriendRequestStatus.pending: 'pending',
  FriendRequestStatus.accepted: 'accepted',
  FriendRequestStatus.declined: 'declined',
  FriendRequestStatus.cancelled: 'cancelled',
};

_$FriendActivityImpl _$$FriendActivityImplFromJson(Map<String, dynamic> json) =>
    _$FriendActivityImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      activityType: json['activityType'] as String,
      description: json['description'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      user: json['user'] == null
          ? null
          : UserProfile.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$FriendActivityImplToJson(
        _$FriendActivityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'activityType': instance.activityType,
      'description': instance.description,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt?.toIso8601String(),
      'user': instance.user,
    };
