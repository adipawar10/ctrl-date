import 'package:freezed_annotation/freezed_annotation.dart';
import 'user.dart';

part 'friendship.freezed.dart';
part 'friendship.g.dart';

/// Friendship status enumeration
enum FriendshipStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('accepted')
  accepted,
  @JsonValue('blocked')
  blocked,
  @JsonValue('declined')
  declined,
}

/// Poke type enumeration
enum PokeType {
  @JsonValue('wave')
  wave,
  @JsonValue('nudge')
  nudge,
  @JsonValue('thinking_of_you')
  thinkingOfYou,
  @JsonValue('miss_you')
  missYou,
  @JsonValue('custom')
  custom,
}

/// Friendship model representing a connection between two users
@freezed
class Friendship with _$Friendship {
  const Friendship._();

  const factory Friendship({
    required String id,
    required String requesterId,
    required String addresseeId,
    @Default(FriendshipStatus.pending) FriendshipStatus status,
    UserProfile? requester,
    UserProfile? addressee,
    String? nickname,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? acceptedAt,
    @Default(false) bool isFavorite,
    @Default(false) bool isMuted,
    String? sharedKey,
  }) = _Friendship;

  factory Friendship.fromJson(Map<String, dynamic> json) =>
      _$FriendshipFromJson(json);

  /// Get the friend's profile based on the current user's ID
  UserProfile? getFriendProfile(String currentUserId) {
    if (requesterId == currentUserId) {
      return addressee;
    } else if (addresseeId == currentUserId) {
      return requester;
    }
    return null;
  }

  /// Get the friend's ID based on the current user's ID
  String getFriendId(String currentUserId) {
    return requesterId == currentUserId ? addresseeId : requesterId;
  }

  /// Check if this friendship is active (accepted)
  bool get isActive => status == FriendshipStatus.accepted;

  /// Check if this friendship is pending
  bool get isPending => status == FriendshipStatus.pending;
}

/// Poke model for sending quick interactions to friends
@freezed
class Poke with _$Poke {
  const factory Poke({
    required String id,
    required String senderId,
    required String receiverId,
    @Default(PokeType.wave) PokeType type,
    String? customMessage,
    @Default(false) bool isRead,
    DateTime? createdAt,
    DateTime? readAt,
    UserProfile? sender,
  }) = _Poke;

  factory Poke.fromJson(Map<String, dynamic> json) => _$PokeFromJson(json);
}

/// Event share model for sharing events between friends
@freezed
class EventShare with _$EventShare {
  const EventShare._();

  const factory EventShare({
    required String id,
    required String eventId,
    required String sharedByUserId,
    required String sharedWithUserId,
    @Default(EventSharePermission.view) EventSharePermission permission,
    @Default(EventShareStatus.pending) EventShareStatus status,
    String? message,
    String? encryptedEventData,
    DateTime? createdAt,
    DateTime? acceptedAt,
    DateTime? expiresAt,
    UserProfile? sharedBy,
    UserProfile? sharedWith,
  }) = _EventShare;

  factory EventShare.fromJson(Map<String, dynamic> json) =>
      _$EventShareFromJson(json);

  /// Check if this share is still valid
  bool get isValid {
    if (status != EventShareStatus.accepted) return false;
    if (expiresAt != null && DateTime.now().isAfter(expiresAt!)) return false;
    return true;
  }

  /// Check if this share has expired
  bool get isExpired =>
      expiresAt != null && DateTime.now().isAfter(expiresAt!);
}

/// Event share permission levels
enum EventSharePermission {
  @JsonValue('view')
  view,
  @JsonValue('edit')
  edit,
  @JsonValue('manage')
  manage,
}

/// Event share status
enum EventShareStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('accepted')
  accepted,
  @JsonValue('declined')
  declined,
  @JsonValue('revoked')
  revoked,
}

/// Friend request model for incoming/outgoing friend requests
@freezed
class FriendRequest with _$FriendRequest {
  const factory FriendRequest({
    required String id,
    required String requesterId,
    required String addresseeId,
    String? message,
    @Default(FriendRequestStatus.pending) FriendRequestStatus status,
    DateTime? createdAt,
    DateTime? respondedAt,
    UserProfile? requester,
    UserProfile? addressee,
  }) = _FriendRequest;

  factory FriendRequest.fromJson(Map<String, dynamic> json) =>
      _$FriendRequestFromJson(json);
}

/// Friend request status
enum FriendRequestStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('accepted')
  accepted,
  @JsonValue('declined')
  declined,
  @JsonValue('cancelled')
  cancelled,
}

/// Friend activity for showing what friends are up to
@freezed
class FriendActivity with _$FriendActivity {
  const factory FriendActivity({
    required String id,
    required String userId,
    required String activityType,
    String? description,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    UserProfile? user,
  }) = _FriendActivity;

  factory FriendActivity.fromJson(Map<String, dynamic> json) =>
      _$FriendActivityFromJson(json);
}
