/// Ctrl+Shift+Date - Friends Screen
/// Friend list and friend request management
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme.dart';
import '../widgets/friend_tile.dart';

/// Friends screen showing friend list and requests
class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  // Mock data - replace with actual state management
  final List<Map<String, dynamic>> _friends = [
    {
      'id': '1',
      'display_name': 'Alice Johnson',
      'email': 'alice@example.com',
      'avatar_url': null,
      'is_online': true,
      'last_active': DateTime.now(),
    },
    {
      'id': '2',
      'display_name': 'Bob Smith',
      'email': 'bob@example.com',
      'avatar_url': null,
      'is_online': false,
      'last_active': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'id': '3',
      'display_name': 'Charlie Brown',
      'email': 'charlie@example.com',
      'avatar_url': null,
      'is_online': true,
      'last_active': DateTime.now(),
    },
  ];

  final List<Map<String, dynamic>> _pendingRequests = [
    {
      'id': '4',
      'display_name': 'Diana Prince',
      'email': 'diana@example.com',
      'avatar_url': null,
      'is_incoming': true,
      'created_at': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'id': '5',
      'display_name': 'Eve Wilson',
      'email': 'eve@example.com',
      'avatar_url': null,
      'is_incoming': false,
      'created_at': DateTime.now().subtract(const Duration(days: 2)),
    },
  ];

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
    final theme = Theme.of(context);

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
                  if (_friends.isNotEmpty) ...[
                    const SizedBox(width: 4),
                    _buildBadge('${_friends.length}'),
                  ],
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Requests'),
                  if (_pendingRequests.isNotEmpty) ...[
                    const SizedBox(width: 4),
                    _buildBadge('${_pendingRequests.length}'),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFriendsList(context),
          _buildRequestsList(context),
        ],
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildFriendsList(BuildContext context) {
    final theme = Theme.of(context);

    if (_friends.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No friends yet',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Add friends to share events and stay accountable',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.gray600,
              ),
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
      onRefresh: _refreshFriends,
      child: ListView.builder(
        itemCount: _friends.length,
        itemBuilder: (context, index) {
          final friend = _friends[index];
          return FriendTile(
            id: friend['id'],
            displayName: friend['display_name'],
            email: friend['email'],
            avatarUrl: friend['avatar_url'],
            isOnline: friend['is_online'],
            lastActive: friend['last_active'],
            onTap: () => _showFriendOptions(friend),
            onPoke: () => _pokeFriend(friend['id']),
          );
        },
      ),
    );
  }

  Widget _buildRequestsList(BuildContext context) {
    final theme = Theme.of(context);

    final incoming = _pendingRequests.where((r) => r['is_incoming']).toList();
    final outgoing = _pendingRequests.where((r) => !r['is_incoming']).toList();

    if (_pendingRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mail_outline,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No pending requests',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Friend requests will appear here',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.gray600,
              ),
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
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: Text(
              'Incoming Requests',
              style: theme.textTheme.titleMedium,
            ),
          ),
          ...incoming.map((request) => _buildRequestTile(request, true)),
        ],
        if (outgoing.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: Text(
              'Sent Requests',
              style: theme.textTheme.titleMedium,
            ),
          ),
          ...outgoing.map((request) => _buildRequestTile(request, false)),
        ],
      ],
    );
  }

  Widget _buildRequestTile(Map<String, dynamic> request, bool isIncoming) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.gray200,
        child: Text(
          request['display_name'][0].toUpperCase(),
          style: const TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      title: Text(request['display_name']),
      subtitle: Text(request['email']),
      trailing: isIncoming
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => _declineRequest(request['id']),
                  tooltip: 'Decline',
                ),
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () => _acceptRequest(request['id']),
                  tooltip: 'Accept',
                ),
              ],
            )
          : TextButton(
              onPressed: () => _cancelRequest(request['id']),
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
                _sendFriendRequest(email);
                Navigator.pop(context);
              }
            },
            child: const Text('Send Request'),
          ),
        ],
      ),
    );
  }

  void _showFriendOptions(Map<String, dynamic> friend) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.md),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.gray200,
                child: Text(
                  friend['display_name'][0].toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              title: Text(friend['display_name']),
              subtitle: Text(friend['email']),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.touch_app),
              title: const Text('Poke'),
              subtitle: const Text('Send a friendly reminder'),
              onTap: () {
                Navigator.pop(context);
                _pokeFriend(friend['id']);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share Event'),
              onTap: () {
                Navigator.pop(context);
                _shareEventWith(friend['id']);
              },
            ),
            ListTile(
              leading: const Icon(Icons.message_outlined),
              title: const Text('Send Message'),
              onTap: () {
                Navigator.pop(context);
                _sendMessage(friend['id']);
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.block, color: AppColors.error),
              title: Text(
                'Block',
                style: TextStyle(color: AppColors.error),
              ),
              onTap: () {
                Navigator.pop(context);
                _blockFriend(friend['id']);
              },
            ),
            ListTile(
              leading: Icon(Icons.person_remove, color: AppColors.error),
              title: Text(
                'Remove Friend',
                style: TextStyle(color: AppColors.error),
              ),
              onTap: () {
                Navigator.pop(context);
                _removeFriend(friend['id']);
              },
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshFriends() async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 1));
  }

  void _sendFriendRequest(String email) {
    // TODO: Implement API call
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Friend request sent to $email')),
    );
  }

  void _acceptRequest(String requestId) {
    setState(() {
      final request = _pendingRequests.firstWhere((r) => r['id'] == requestId);
      _pendingRequests.removeWhere((r) => r['id'] == requestId);
      _friends.add({
        ...request,
        'is_online': false,
        'last_active': DateTime.now(),
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Friend request accepted')),
    );
  }

  void _declineRequest(String requestId) {
    setState(() {
      _pendingRequests.removeWhere((r) => r['id'] == requestId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Friend request declined')),
    );
  }

  void _cancelRequest(String requestId) {
    setState(() {
      _pendingRequests.removeWhere((r) => r['id'] == requestId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Friend request cancelled')),
    );
  }

  void _pokeFriend(String friendId) {
    // TODO: Implement poke API call
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Poke sent!')),
    );
  }

  void _shareEventWith(String friendId) {
    // TODO: Navigate to event selection
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Event sharing coming soon')),
    );
  }

  void _sendMessage(String friendId) {
    // TODO: Navigate to message composer
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Messaging coming soon')),
    );
  }

  void _blockFriend(String friendId) {
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
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _friends.removeWhere((f) => f['id'] == friendId);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User blocked')),
              );
            },
            child: Text('Block', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _removeFriend(String friendId) {
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
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _friends.removeWhere((f) => f['id'] == friendId);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Friend removed')),
              );
            },
            child: Text('Remove', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
