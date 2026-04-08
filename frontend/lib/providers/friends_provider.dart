import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/friendship.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';
import 'events_provider.dart';

/// Provider for all friendships
final friendshipsProvider =
    StateNotifierProvider<FriendshipsNotifier, AsyncValue<List<Friendship>>>(
        (ref) {
  return FriendshipsNotifier(ref);
});

/// Provider for accepted friends only
final friendsProvider = FutureProvider<List<Friendship>>((ref) async {
  final friendshipsAsync = ref.watch(friendshipsProvider);

  return friendshipsAsync.maybeWhen(
    data: (friendships) =>
        friendships.where((f) => f.status == FriendshipStatus.accepted).toList(),
    orElse: () => [],
  );
});

/// Provider for pending friend requests (incoming)
final pendingFriendRequestsProvider =
    FutureProvider<List<Friendship>>((ref) async {
  final friendshipsAsync = ref.watch(friendshipsProvider);
  final currentUser = await ref.watch(currentUserProvider.future);

  if (currentUser == null) return [];

  return friendshipsAsync.maybeWhen(
    data: (friendships) => friendships
        .where((f) =>
            f.status == FriendshipStatus.pending &&
            f.addresseeId == currentUser.id)
        .toList(),
    orElse: () => [],
  );
});

/// Provider for outgoing friend requests
final outgoingFriendRequestsProvider =
    FutureProvider<List<Friendship>>((ref) async {
  final friendshipsAsync = ref.watch(friendshipsProvider);
  final currentUser = await ref.watch(currentUserProvider.future);

  if (currentUser == null) return [];

  return friendshipsAsync.maybeWhen(
    data: (friendships) => friendships
        .where((f) =>
            f.status == FriendshipStatus.pending &&
            f.requesterId == currentUser.id)
        .toList(),
    orElse: () => [],
  );
});

/// Provider for favorite friends
final favoriteFriendsProvider = FutureProvider<List<Friendship>>((ref) async {
  final friendsAsync = ref.watch(friendsProvider);

  return friendsAsync.maybeWhen(
    data: (friends) => friends.where((f) => f.isFavorite).toList(),
    orElse: () => [],
  );
});

/// Provider for a single friendship by ID
final friendshipByIdProvider =
    FutureProvider.family<Friendship?, String>((ref, id) async {
  final friendshipsAsync = ref.watch(friendshipsProvider);

  return friendshipsAsync.maybeWhen(
    data: (friendships) =>
        friendships.where((f) => f.id == id).firstOrNull,
    orElse: () => null,
  );
});

/// Provider for pokes
final pokesProvider =
    StateNotifierProvider<PokesNotifier, AsyncValue<List<Poke>>>((ref) {
  return PokesNotifier(ref);
});

/// Provider for unread pokes count
final unreadPokesCountProvider = FutureProvider<int>((ref) async {
  final pokesAsync = ref.watch(pokesProvider);

  return pokesAsync.maybeWhen(
    data: (pokes) => pokes.where((p) => !p.isRead).length,
    orElse: () => 0,
  );
});

/// Provider for event shares
final eventSharesProvider =
    StateNotifierProvider<EventSharesNotifier, AsyncValue<List<EventShare>>>(
        (ref) {
  return EventSharesNotifier(ref);
});

/// Provider for pending event shares
final pendingEventSharesProvider = FutureProvider<List<EventShare>>((ref) async {
  final sharesAsync = ref.watch(eventSharesProvider);

  return sharesAsync.maybeWhen(
    data: (shares) =>
        shares.where((s) => s.status == EventShareStatus.pending).toList(),
    orElse: () => [],
  );
});

/// Notifier for managing friendships state
class FriendshipsNotifier extends StateNotifier<AsyncValue<List<Friendship>>> {
  final Ref _ref;
  RealtimeChannel? _realtimeChannel;

  FriendshipsNotifier(this._ref) : super(const AsyncValue.loading()) {
    _loadFriendships();
    _subscribeToRealtimeUpdates();
  }

  ApiService get _api => _ref.read(apiServiceProvider);

  /// Map backend friend response to Friendship model.
  /// Backend returns flat objects; we reconstruct the model structure.
  Friendship _mapFriendResponse(Map<String, dynamic> json) {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id ?? '';
    final friendId = json['user_id'] as String? ?? '';
    final isRequester = json['is_requester'] as bool? ?? true;

    final friendProfile = UserProfile(
      id: friendId,
      displayName: json['display_name'] as String? ?? 'Unknown',
      email: null,
      avatarUrl: json['avatar_url'] as String?,
    );

    return Friendship(
      id: json['friendship_id'] as String? ?? json['id'] as String? ?? '',
      requesterId: isRequester ? currentUserId : friendId,
      addresseeId: isRequester ? friendId : currentUserId,
      status: _parseStatus(json['status'] as String? ?? 'pending'),
      requester: isRequester ? null : friendProfile,
      addressee: isRequester ? friendProfile : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      acceptedAt: json['accepted_at'] != null
          ? DateTime.tryParse(json['accepted_at'] as String)
          : null,
      streakCount: json['streak_count'] as int? ?? 0,
      longestStreak: json['longest_streak'] as int? ?? 0,
    );
  }

  FriendshipStatus _parseStatus(String status) {
    switch (status) {
      case 'accepted':
        return FriendshipStatus.accepted;
      case 'blocked':
        return FriendshipStatus.blocked;
      case 'declined':
        return FriendshipStatus.declined;
      default:
        return FriendshipStatus.pending;
    }
  }

  Future<void> _loadFriendships() async {
    try {
      // Fetch accepted and pending friendships in parallel
      final results = await Future.wait([
        _api.get<Map<String, dynamic>>(
          '/friends',
          queryParams: {'status': 'accepted'},
        ),
        _api.get<Map<String, dynamic>>(
          '/friends',
          queryParams: {'status': 'pending'},
        ),
      ]);

      final response = results[0];
      final pendingResponse = results[1];

      final List<Friendship> friendships = [];

      if (response.isSuccess && response.data != null) {
        final friends = (response.data!['friends'] as List?) ?? [];
        friendships.addAll(
          friends.map((json) => _mapFriendResponse(json as Map<String, dynamic>)),
        );
      }

      if (pendingResponse.isSuccess && pendingResponse.data != null) {
        final pending = (pendingResponse.data!['friends'] as List?) ?? [];
        friendships.addAll(
          pending.map((json) => _mapFriendResponse(json as Map<String, dynamic>)),
        );
      }

      state = AsyncValue.data(friendships);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void _subscribeToRealtimeUpdates() {
    _realtimeChannel = Supabase.instance.client
        .channel('friendships')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'friendships',
          callback: (payload) {
            _loadFriendships();
          },
        )
        .subscribe();
  }

  /// Send a friend request
  Future<Friendship?> sendFriendRequest(String userId, {String? message}) async {
    try {
      final response = await _api.post(
        '/friends/request',
        body: {
          'user_id': userId,
          if (message != null) 'message': message,
        },
      );

      if (response.isSuccess && response.data != null) {
        final friendship =
            Friendship.fromJson(response.data as Map<String, dynamic>);
        await _loadFriendships();
        return friendship;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Accept a friend request
  Future<void> acceptFriendRequest(String friendshipId) async {
    try {
      await _api.put(
        '/friends/$friendshipId/respond',
        body: {'action': 'accept'},
      );
      await _loadFriendships();
    } catch (e) {
      rethrow;
    }
  }

  /// Decline a friend request
  Future<void> declineFriendRequest(String friendshipId) async {
    try {
      await _api.put(
        '/friends/$friendshipId/respond',
        body: {'action': 'decline'},
      );
      await _loadFriendships();
    } catch (e) {
      rethrow;
    }
  }

  /// Block a user
  Future<void> blockUser(String friendshipId) async {
    try {
      await _api.put(
        '/friends/$friendshipId/respond',
        body: {'action': 'block'},
      );
      await _loadFriendships();
    } catch (e) {
      rethrow;
    }
  }

  /// Unblock a user
  Future<void> unblockUser(String friendshipId) async {
    try {
      await _api.delete('/friends/$friendshipId');
      await _loadFriendships();
    } catch (e) {
      rethrow;
    }
  }

  /// Remove a friend
  Future<void> removeFriend(String friendshipId) async {
    try {
      await _api.delete('/friends/$friendshipId');
      await _loadFriendships();
    } catch (e) {
      rethrow;
    }
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(String friendshipId) async {
    final friendships = state.valueOrNull;
    if (friendships == null) return;

    final friendship = friendships.firstWhere(
      (f) => f.id == friendshipId,
      orElse: () => throw Exception('Friendship not found'),
    );

    try {
      await _api.patch(
        '/friends/$friendshipId',
        body: {'is_favorite': !friendship.isFavorite},
      );
      await _loadFriendships();
    } catch (e) {
      rethrow;
    }
  }

  /// Toggle mute status
  Future<void> toggleMute(String friendshipId) async {
    final friendships = state.valueOrNull;
    if (friendships == null) return;

    final friendship = friendships.firstWhere(
      (f) => f.id == friendshipId,
      orElse: () => throw Exception('Friendship not found'),
    );

    try {
      await _api.patch(
        '/friends/$friendshipId',
        body: {'is_muted': !friendship.isMuted},
      );
      await _loadFriendships();
    } catch (e) {
      rethrow;
    }
  }

  /// Update nickname
  Future<void> updateNickname(String friendshipId, String? nickname) async {
    try {
      await _api.patch(
        '/friends/$friendshipId',
        body: {'nickname': nickname},
      );
      await _loadFriendships();
    } catch (e) {
      rethrow;
    }
  }

  /// Refresh friendships
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _loadFriendships();
  }

  @override
  void dispose() {
    _realtimeChannel?.unsubscribe();
    super.dispose();
  }
}

/// Notifier for managing pokes state
class PokesNotifier extends StateNotifier<AsyncValue<List<Poke>>> {
  final Ref _ref;
  RealtimeChannel? _realtimeChannel;

  PokesNotifier(this._ref) : super(const AsyncValue.loading()) {
    _loadPokes();
    _subscribeToRealtimeUpdates();
  }

  ApiService get _api => _ref.read(apiServiceProvider);

  Future<void> _loadPokes() async {
    try {
      final response = await _api.get<Map<String, dynamic>>('/friends/pokes');

      if (response.isSuccess && response.data != null) {
        final pokesList = (response.data!['pokes'] as List?) ?? [];
        final pokes = pokesList
            .map((json) => Poke.fromJson(json as Map<String, dynamic>))
            .toList();
        state = AsyncValue.data(pokes);
      } else {
        state = AsyncValue.data([]);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void _subscribeToRealtimeUpdates() {
    _realtimeChannel = Supabase.instance.client
        .channel('pokes')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'pokes',
          callback: (payload) {
            _loadPokes();
          },
        )
        .subscribe();
  }

  /// Send a poke
  Future<Poke?> sendPoke(String userId, PokeType type,
      {String? customMessage}) async {
    try {
      final response = await _api.post(
        '/friends/$userId/poke',
        body: {
          'type': type.name,
          if (customMessage != null) 'custom_message': customMessage,
        },
      );

      if (response.isSuccess && response.data != null) {
        final poke = Poke.fromJson(response.data as Map<String, dynamic>);
        await _loadPokes();
        return poke;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Mark a poke as read
  Future<void> markAsRead(String pokeId) async {
    try {
      await _api.patch(
        '/friends/pokes/$pokeId',
        body: {'is_read': true},
      );
      await _loadPokes();
    } catch (e) {
      rethrow;
    }
  }

  /// Mark all pokes as read
  Future<void> markAllAsRead() async {
    try {
      await _api.post('/friends/pokes/mark-all-read');
      await _loadPokes();
    } catch (e) {
      rethrow;
    }
  }

  /// Refresh pokes
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _loadPokes();
  }

  @override
  void dispose() {
    _realtimeChannel?.unsubscribe();
    super.dispose();
  }
}

/// Notifier for managing event shares state
class EventSharesNotifier extends StateNotifier<AsyncValue<List<EventShare>>> {
  final Ref _ref;
  RealtimeChannel? _realtimeChannel;

  EventSharesNotifier(this._ref) : super(const AsyncValue.loading()) {
    _loadEventShares();
    _subscribeToRealtimeUpdates();
  }

  ApiService get _api => _ref.read(apiServiceProvider);

  Future<void> _loadEventShares() async {
    try {
      final response = await _api.get<List>('/event-shares');

      if (response.isSuccess && response.data != null) {
        final shares = response.data!
            .map((json) => EventShare.fromJson(json as Map<String, dynamic>))
            .toList();
        state = AsyncValue.data(shares);
      } else {
        state = AsyncValue.data([]);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void _subscribeToRealtimeUpdates() {
    _realtimeChannel = Supabase.instance.client
        .channel('event_shares')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'event_shares',
          callback: (payload) {
            _loadEventShares();
          },
        )
        .subscribe();
  }

  /// Accept an event share
  Future<void> acceptShare(String shareId) async {
    try {
      await _api.patch(
        '/event-shares/$shareId',
        body: {'status': 'accepted'},
      );
      await _loadEventShares();
    } catch (e) {
      rethrow;
    }
  }

  /// Decline an event share
  Future<void> declineShare(String shareId) async {
    try {
      await _api.patch(
        '/event-shares/$shareId',
        body: {'status': 'declined'},
      );
      await _loadEventShares();
    } catch (e) {
      rethrow;
    }
  }

  /// Revoke an event share
  Future<void> revokeShare(String shareId) async {
    try {
      await _api.patch(
        '/event-shares/$shareId',
        body: {'status': 'revoked'},
      );
      await _loadEventShares();
    } catch (e) {
      rethrow;
    }
  }

  /// Refresh event shares
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _loadEventShares();
  }

  @override
  void dispose() {
    _realtimeChannel?.unsubscribe();
    super.dispose();
  }
}

/// Provider for friend actions
final friendActionsProvider = Provider<FriendActions>((ref) {
  return FriendActions(ref);
});

/// Class containing friend actions
class FriendActions {
  final Ref _ref;

  FriendActions(this._ref);

  FriendshipsNotifier get _friendshipsNotifier =>
      _ref.read(friendshipsProvider.notifier);
  PokesNotifier get _pokesNotifier => _ref.read(pokesProvider.notifier);
  EventSharesNotifier get _eventSharesNotifier =>
      _ref.read(eventSharesProvider.notifier);

  // Friendship actions
  Future<Friendship?> sendFriendRequest(String userId, {String? message}) =>
      _friendshipsNotifier.sendFriendRequest(userId, message: message);

  Future<void> acceptFriendRequest(String friendshipId) =>
      _friendshipsNotifier.acceptFriendRequest(friendshipId);

  Future<void> declineFriendRequest(String friendshipId) =>
      _friendshipsNotifier.declineFriendRequest(friendshipId);

  Future<void> blockUser(String friendshipId) =>
      _friendshipsNotifier.blockUser(friendshipId);

  Future<void> unblockUser(String friendshipId) =>
      _friendshipsNotifier.unblockUser(friendshipId);

  Future<void> removeFriend(String friendshipId) =>
      _friendshipsNotifier.removeFriend(friendshipId);

  Future<void> toggleFavorite(String friendshipId) =>
      _friendshipsNotifier.toggleFavorite(friendshipId);

  Future<void> toggleMute(String friendshipId) =>
      _friendshipsNotifier.toggleMute(friendshipId);

  Future<void> updateNickname(String friendshipId, String? nickname) =>
      _friendshipsNotifier.updateNickname(friendshipId, nickname);

  // Poke actions
  Future<Poke?> sendPoke(String userId, PokeType type,
          {String? customMessage}) =>
      _pokesNotifier.sendPoke(userId, type, customMessage: customMessage);

  Future<void> markPokeAsRead(String pokeId) =>
      _pokesNotifier.markAsRead(pokeId);

  Future<void> markAllPokesAsRead() => _pokesNotifier.markAllAsRead();

  // Event share actions
  Future<void> acceptEventShare(String shareId) =>
      _eventSharesNotifier.acceptShare(shareId);

  Future<void> declineEventShare(String shareId) =>
      _eventSharesNotifier.declineShare(shareId);

  Future<void> revokeEventShare(String shareId) =>
      _eventSharesNotifier.revokeShare(shareId);

  // Refresh all
  Future<void> refreshAll() async {
    await Future.wait([
      _friendshipsNotifier.refresh(),
      _pokesNotifier.refresh(),
      _eventSharesNotifier.refresh(),
    ]);
  }
}

/// Provider for searching users
final userSearchProvider =
    FutureProvider.family<List<UserProfile>, String>((ref, query) async {
  if (query.isEmpty || query.length < 3) return [];

  final api = ref.read(apiServiceProvider);
  final response = await api.get<List>(
    '/users/search',
    queryParams: {'q': query},
  );

  if (response.isSuccess && response.data != null) {
    return response.data!
        .map((json) => UserProfile.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  return [];
});
