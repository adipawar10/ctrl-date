/// Ctrl+Shift+Date - Friends Screen
/// Friend list and friend request management
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/friendship.dart';
import '../providers/auth_provider.dart';
import '../providers/events_provider.dart';
import '../providers/friends_provider.dart';
import '../theme.dart';
import '../widgets/friend_tile.dart';
import '../widgets/streak_badge.dart';

/// Friends screen showing friend list and requests
class FriendsScreen extends ConsumerStatefulWidget {
  const FriendsScreen({super.key});

  @override
  ConsumerState<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends ConsumerState<FriendsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String get _currentUserId =>
      Supabase.instance.client.auth.currentUser?.id ?? '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final friendshipsAsync = ref.watch(friendshipsProvider);
    final friendsAsync = ref.watch(friendsProvider);
    final pendingAsync = ref.watch(pendingFriendRequestsProvider);
    final outgoingAsync = ref.watch(outgoingFriendRequestsProvider);

    final friendsCount = friendsAsync.valueOrNull?.length ?? 0;
    final pendingCount = (pendingAsync.valueOrNull?.length ?? 0) +
        (outgoingAsync.valueOrNull?.length ?? 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_outlined),
            onPressed: _showAddFriendDialog,
            tooltip: 'Add friend',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Friends'),
                  if (friendsCount > 0) ...[
                    const SizedBox(width: 4),
                    _buildBadge('$friendsCount'),
                  ],
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Requests'),
                  if (pendingCount > 0) ...[
                    const SizedBox(width: 4),
                    _buildBadge('$pendingCount'),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      body: friendshipsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: context.csd.onSurfaceDim),
              const SizedBox(height: AppSpacing.md),
              Text('Failed to load friends', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              ElevatedButton(
                onPressed: () => ref.read(friendshipsProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (_) => TabBarView(
          controller: _tabController,
          children: [
            _buildFriendsList(context),
            _buildRequestsList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildFriendsList(BuildContext context) {
    final theme = Theme.of(context);
    final friendsAsync = ref.watch(friendsProvider);

    return friendsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (friends) {
        if (friends.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 64, color: theme.colorScheme.outline),
                const SizedBox(height: AppSpacing.md),
                Text('No friends yet', style: theme.textTheme.titleLarge),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Add friends to share events and stay accountable',
                  style: theme.textTheme.bodyMedium?.copyWith(color: context.csd.onSurfaceDim),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                ElevatedButton.icon(
                  onPressed: _showAddFriendDialog,
                  icon: const Icon(Icons.person_add),
                  label: const Text('Add Friend'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => ref.read(friendshipsProvider.notifier).refresh(),
          child: ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final friendship = friends[index];
              final friendProfile = friendship.getFriendProfile(_currentUserId);
              return FriendTile(
                id: friendship.getFriendId(_currentUserId),
                displayName: friendProfile?.displayName ?? 'Unknown',
                email: friendProfile?.email ?? '',
                avatarUrl: friendProfile?.avatarUrl,
                isOnline: false,
                lastActive: friendship.updatedAt,
                streakCount: friendship.streakCount,
                longestStreak: friendship.longestStreak,
                onTap: () => _showFriendOptions(friendship),
                onPoke: () => _pokeFriend(friendship.getFriendId(_currentUserId)),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildRequestsList(BuildContext context) {
    final theme = Theme.of(context);
    final pendingAsync = ref.watch(pendingFriendRequestsProvider);
    final outgoingAsync = ref.watch(outgoingFriendRequestsProvider);

    final incoming = pendingAsync.valueOrNull ?? [];
    final outgoing = outgoingAsync.valueOrNull ?? [];

    if (incoming.isEmpty && outgoing.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mail_outline, size: 64, color: theme.colorScheme.outline),
            const SizedBox(height: AppSpacing.md),
            Text('No pending requests', style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Friend requests will appear here',
              style: theme.textTheme.bodyMedium?.copyWith(color: context.csd.onSurfaceDim),
            ),
          ],
        ),
      );
    }

    return ListView(
      children: [
        if (incoming.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.sm,
            ),
            child: Text('Incoming Requests', style: theme.textTheme.titleMedium),
          ),
          ...incoming.map((f) => _buildRequestTile(f, true)),
        ],
        if (outgoing.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md, AppSpacing.lg, AppSpacing.md, AppSpacing.sm,
            ),
            child: Text('Sent Requests', style: theme.textTheme.titleMedium),
          ),
          ...outgoing.map((f) => _buildRequestTile(f, false)),
        ],
      ],
    );
  }

  Widget _buildRequestTile(Friendship friendship, bool isIncoming) {
    final friendProfile = friendship.getFriendProfile(_currentUserId);
    final name = friendProfile?.displayName ?? 'Unknown';
    final email = friendProfile?.email ?? '';

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: context.csd.avatarBg,
        backgroundImage: friendProfile?.avatarUrl != null
            ? NetworkImage(friendProfile!.avatarUrl!)
            : null,
        child: friendProfile?.avatarUrl == null
            ? Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: TextStyle(
                  color: context.csd.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              )
            : null,
      ),
      title: Text(name),
      subtitle: Text(email),
      trailing: isIncoming
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => _declineRequest(friendship.id),
                  tooltip: 'Decline',
                ),
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () => _acceptRequest(friendship.id),
                  tooltip: 'Accept',
                ),
              ],
            )
          : TextButton(
              onPressed: () => _cancelRequest(friendship.id),
              child: const Text('Cancel'),
            ),
    );
  }

  void _showAddFriendDialog() {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Friend'),
        content: TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Email address',
            hintText: 'friend@example.com',
          ),
          keyboardType: TextInputType.emailAddress,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final email = emailController.text.trim();
              if (email.isNotEmpty) {
                Navigator.pop(context);
                _sendFriendRequest(email);
              }
            },
            child: const Text('Send Request'),
          ),
        ],
      ),
    );
  }

  void _showFriendOptions(Friendship friendship) {
    final friendProfile = friendship.getFriendProfile(_currentUserId);
    final name = friendProfile?.displayName ?? 'Unknown';
    final email = friendProfile?.email ?? '';
    final friendId = friendship.getFriendId(_currentUserId);

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.md),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: context.csd.avatarBg,
                backgroundImage: friendProfile?.avatarUrl != null
                    ? NetworkImage(friendProfile!.avatarUrl!)
                    : null,
                child: friendProfile?.avatarUrl == null
                    ? Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: TextStyle(
                          color: this.context.csd.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : null,
              ),
              title: Text(name),
              subtitle: Text(email),
              trailing: friendship.streakCount > 0
                  ? StreakBadge(count: friendship.streakCount)
                  : null,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.touch_app),
              title: const Text('Poke'),
              subtitle: const Text('Send a friendly reminder'),
              onTap: () {
                Navigator.pop(context);
                _pokeFriend(friendId);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share Event'),
              onTap: () {
                Navigator.pop(context);
                this.context.go('/inbox');
              },
            ),
            ListTile(
              leading: const Icon(Icons.message_outlined),
              title: const Text('Send Message'),
              onTap: () {
                Navigator.pop(context);
                this.context.go('/inbox');
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.block, color: AppColors.error),
              title: Text('Block', style: TextStyle(color: AppColors.error)),
              onTap: () {
                Navigator.pop(context);
                _blockFriend(friendship.id);
              },
            ),
            ListTile(
              leading: Icon(Icons.person_remove, color: AppColors.error),
              title: Text('Remove Friend', style: TextStyle(color: AppColors.error)),
              onTap: () {
                Navigator.pop(context);
                _removeFriend(friendship.id);
              },
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  Future<void> _sendFriendRequest(String email) async {
    try {
      // The backend friend request endpoint accepts email
      final api = ref.read(apiServiceProvider);
      final response = await api.post('/friends/request', body: {'email': email});

      if (mounted) {
        if (response.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Friend request sent to $email')),
          );
          ref.read(friendshipsProvider.notifier).refresh();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.error?.message ?? 'Failed to send request'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send request: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _acceptRequest(String friendshipId) async {
    try {
      await ref.read(friendActionsProvider).acceptFriendRequest(friendshipId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Friend request accepted')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _declineRequest(String friendshipId) async {
    try {
      await ref.read(friendActionsProvider).declineFriendRequest(friendshipId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Friend request declined')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _cancelRequest(String friendshipId) async {
    try {
      await ref.read(friendActionsProvider).removeFriend(friendshipId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Friend request cancelled')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  void _pokeFriend(String friendId) {
    ref.read(friendActionsProvider).sendPoke(friendId, PokeType.wave);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Poke sent!')),
    );
  }

  void _blockFriend(String friendshipId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Block User'),
        content: const Text(
          'Are you sure you want to block this user? They will no longer be able to see your profile or send you messages.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(friendActionsProvider).blockUser(friendshipId);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User blocked')),
                );
              }
            },
            child: Text('Block', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _removeFriend(String friendshipId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Friend'),
        content: const Text('Are you sure you want to remove this friend?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(friendActionsProvider).removeFriend(friendshipId);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Friend removed')),
                );
              }
            },
            child: Text('Remove', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
