/// Ctrl+Shift+Date - Inbox Screen
/// Encrypted messages, friends, and system notifications
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../theme.dart';
import '../widgets/message_bubble.dart';

/// Inbox screen showing encrypted messages, friends, and system notifications
class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  // Mock data - replace with actual state management
  final List<Map<String, dynamic>> _messages = [
    {
      'id': '1',
      'sender_id': '2',
      'sender_name': 'Alice Johnson',
      'message_type': 'text',
      'preview': 'Hey! Are we still meeting tomorrow?',
      'is_read': false,
      'created_at': DateTime.now().subtract(const Duration(minutes: 15)),
    },
    {
      'id': '2',
      'sender_id': '3',
      'sender_name': 'Bob Smith',
      'message_type': 'event_share',
      'preview': 'Shared: Team Lunch',
      'is_read': false,
      'created_at': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'id': '3',
      'sender_id': '4',
      'sender_name': 'Charlie Brown',
      'message_type': 'poke',
      'preview': 'Poked you!',
      'is_read': true,
      'created_at': DateTime.now().subtract(const Duration(days: 1)),
    },
  ];

  final List<Map<String, dynamic>> _friends = [
    {
      'id': '2',
      'name': 'Alice Johnson',
      'email': 'alice@example.com',
      'status': 'online',
      'last_seen': DateTime.now(),
    },
    {
      'id': '3',
      'name': 'Bob Smith',
      'email': 'bob@example.com',
      'status': 'offline',
      'last_seen': DateTime.now().subtract(const Duration(hours: 3)),
    },
    {
      'id': '4',
      'name': 'Charlie Brown',
      'email': 'charlie@example.com',
      'status': 'offline',
      'last_seen': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'id': '5',
      'name': 'Diana Prince',
      'email': 'diana@example.com',
      'status': 'online',
      'last_seen': DateTime.now(),
    },
  ];

  final List<Map<String, dynamic>> _systemNotifications = [
    {
      'id': 'n1',
      'type': 'friend_request',
      'title': 'Friend Request',
      'body': 'Emma Watson wants to be your friend',
      'is_read': false,
      'created_at': DateTime.now().subtract(const Duration(hours: 1)),
      'data': {'user_id': '6', 'user_name': 'Emma Watson'},
    },
    {
      'id': 'n2',
      'type': 'shared_event',
      'title': 'Shared Event',
      'body': 'Alice shared "Project Review" with you',
      'is_read': false,
      'created_at': DateTime.now().subtract(const Duration(hours: 3)),
      'data': {'event_id': 'e1', 'event_title': 'Project Review'},
    },
    {
      'id': 'n3',
      'type': 'friend_request',
      'title': 'Friend Request Accepted',
      'body': 'Bob Smith accepted your friend request',
      'is_read': true,
      'created_at': DateTime.now().subtract(const Duration(days: 1)),
      'data': {'user_id': '3', 'user_name': 'Bob Smith'},
    },
    {
      'id': 'n4',
      'type': 'shared_event',
      'title': 'Event Updated',
      'body': 'Charlie updated "Team Lunch" - time changed',
      'is_read': true,
      'created_at': DateTime.now().subtract(const Duration(days: 2)),
      'data': {'event_id': 'e2', 'event_title': 'Team Lunch'},
    },
  ];

  int get _unreadMessageCount => _messages.where((m) => !m['is_read']).length;
  int get _unreadSystemCount =>
      _systemNotifications.where((n) => !n['is_read']).length;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: const Text('Inbox'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'mark_all_read',
                child: Text('Mark all as read'),
              ),
              const PopupMenuItem(
                value: 'clear_all',
                child: Text('Clear all'),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Messages'),
                  if (_unreadMessageCount > 0) ...[
                    const SizedBox(width: 4),
                    _buildBadge('$_unreadMessageCount'),
                  ],
                ],
              ),
            ),
            const Tab(text: 'Friends'),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('System'),
                  if (_unreadSystemCount > 0) ...[
                    const SizedBox(width: 4),
                    _buildBadge('$_unreadSystemCount'),
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
          _buildMessagesList(context),
          _buildFriendsList(context),
          _buildSystemList(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _composeMessage,
        tooltip: 'New message',
        child: const Icon(Icons.edit),
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

  Widget _buildMessagesList(BuildContext context) {
    final theme = Theme.of(context);

    if (_messages.isEmpty) {
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
              'No messages',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Messages from friends will appear here',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.gray600,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshMessages,
      child: ListView.builder(
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[index];
          return MessageBubble(
            id: message['id'],
            senderName: message['sender_name'],
            messageType: message['message_type'],
            preview: message['preview'],
            isRead: message['is_read'],
            createdAt: message['created_at'],
            onTap: () => _openMessage(message),
            onDismiss: () => _deleteMessage(message['id']),
          );
        },
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
              'Add friends to start collaborating',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.gray600,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton.icon(
              onPressed: _addFriend,
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
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        itemCount: _friends.length + 1, // +1 for add friend button
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: OutlinedButton.icon(
                onPressed: _addFriend,
                icon: const Icon(Icons.person_add),
                label: const Text('Add Friend'),
              ),
            );
          }
          final friend = _friends[index - 1];
          return _buildFriendTile(friend);
        },
      ),
    );
  }

  Widget _buildFriendTile(Map<String, dynamic> friend) {
    final theme = Theme.of(context);
    final isOnline = friend['status'] == 'online';

    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.gray200,
            child: Text(
              friend['name'][0].toUpperCase(),
              style: const TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isOnline ? AppColors.success : AppColors.gray400,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 2),
              ),
            ),
          ),
        ],
      ),
      title: Text(
        friend['name'],
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
      ),
      subtitle: Text(
        isOnline ? 'Online' : 'Last seen ${_formatLastSeen(friend['last_seen'])}',
        style: theme.textTheme.bodySmall?.copyWith(
          color: isOnline ? AppColors.success : AppColors.gray500,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.message_outlined),
            onPressed: () => _startConversation(friend),
            tooltip: 'Send message',
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined),
            onPressed: () => _shareEvent(friend),
            tooltip: 'Share event',
          ),
        ],
      ),
      onTap: () => _showFriendOptions(friend),
    );
  }

  Widget _buildSystemList(BuildContext context) {
    final theme = Theme.of(context);

    if (_systemNotifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No notifications',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'System notifications will appear here',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.gray600,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshNotifications,
      child: ListView.builder(
        itemCount: _systemNotifications.length,
        itemBuilder: (context, index) {
          final notification = _systemNotifications[index];
          return _buildSystemNotificationTile(notification);
        },
      ),
    );
  }

  Widget _buildSystemNotificationTile(Map<String, dynamic> notification) {
    final theme = Theme.of(context);
    final isRead = notification['is_read'] as bool;
    final type = notification['type'] as String;

    IconData icon;
    switch (type) {
      case 'friend_request':
        icon = Icons.person_add;
        break;
      case 'shared_event':
        icon = Icons.event_available;
        break;
      default:
        icon = Icons.notifications;
    }

    // System notifications have a distinct gray styling
    return Dismissible(
      key: Key(notification['id']),
      background: Container(
        color: AppColors.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.md),
        child: const Icon(Icons.delete, color: AppColors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _deleteSystemNotification(notification['id']),
      child: Container(
        color: isRead ? AppColors.white : AppColors.gray100,
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.gray200,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: AppColors.gray600),
          ),
          title: Text(
            notification['title'],
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
              color: AppColors.gray700,
            ),
          ),
          subtitle: Text(
            notification['body'],
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.gray500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatTime(notification['created_at']),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.gray500,
                ),
              ),
              if (!isRead) ...[
                const SizedBox(height: 4),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.gray600,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
          onTap: () => _openSystemNotification(notification),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(time);
    }
  }

  String _formatLastSeen(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(time);
    }
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'mark_all_read':
        setState(() {
          for (final m in _messages) {
            m['is_read'] = true;
          }
          for (final n in _systemNotifications) {
            n['is_read'] = true;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All marked as read')),
        );
        break;
      case 'clear_all':
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Clear All'),
            content: const Text(
              'Are you sure you want to clear all messages and notifications?',
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
                    _messages.clear();
                    _systemNotifications.clear();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All cleared')),
                  );
                },
                child: Text('Clear', style: TextStyle(color: AppColors.error)),
              ),
            ],
          ),
        );
        break;
    }
  }

  void _composeMessage() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _ComposeMessageSheet(friends: _friends),
    );
  }

  void _addFriend() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _AddFriendSheet(),
    );
  }

  Future<void> _refreshMessages() async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> _refreshFriends() async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> _refreshNotifications() async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 1));
  }

  void _openMessage(Map<String, dynamic> message) {
    setState(() {
      message['is_read'] = true;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _MessageDetailSheet(message: message),
    );
  }

  void _openSystemNotification(Map<String, dynamic> notification) {
    setState(() {
      notification['is_read'] = true;
    });

    final type = notification['type'] as String;
    final data = notification['data'] as Map<String, dynamic>;

    if (type == 'friend_request' && notification['title'] == 'Friend Request') {
      _showFriendRequestDialog(data);
    } else if (type == 'shared_event') {
      // TODO: Navigate to event details
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Opening event: ${data['event_title']}')),
      );
    }
  }

  void _showFriendRequestDialog(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Friend Request'),
        content: Text('${data['user_name']} wants to be your friend.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Friend request declined')),
              );
            },
            child: const Text('Decline'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${data['user_name']} added as friend')),
              );
            },
            child: const Text('Accept'),
          ),
        ],
      ),
    );
  }

  void _deleteMessage(String id) {
    setState(() {
      _messages.removeWhere((m) => m['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message deleted')),
    );
  }

  void _deleteSystemNotification(String id) {
    setState(() {
      _systemNotifications.removeWhere((n) => n['id'] == id);
    });
  }

  void _startConversation(Map<String, dynamic> friend) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _ComposeMessageSheet(
        friends: _friends,
        preselectedFriendId: friend['id'],
      ),
    );
  }

  void _shareEvent(Map<String, dynamic> friend) {
    // TODO: Implement event sharing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Share event with ${friend['name']}')),
    );
  }

  void _showFriendOptions(Map<String, dynamic> friend) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.gray200,
                child: Text(
                  friend['name'][0].toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              title: Text(friend['name']),
              subtitle: Text(friend['email']),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.message_outlined),
              title: const Text('Send message'),
              onTap: () {
                Navigator.pop(context);
                _startConversation(friend);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today_outlined),
              title: const Text('Share event'),
              onTap: () {
                Navigator.pop(context);
                _shareEvent(friend);
              },
            ),
            ListTile(
              leading: Icon(Icons.person_remove, color: AppColors.error),
              title: Text('Remove friend', style: TextStyle(color: AppColors.error)),
              onTap: () {
                Navigator.pop(context);
                _confirmRemoveFriend(friend);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmRemoveFriend(Map<String, dynamic> friend) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Friend'),
        content: Text('Are you sure you want to remove ${friend['name']} from your friends?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _friends.removeWhere((f) => f['id'] == friend['id']);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${friend['name']} removed from friends')),
              );
            },
            child: Text('Remove', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

/// Compose message sheet
class _ComposeMessageSheet extends StatefulWidget {
  final List<Map<String, dynamic>> friends;
  final String? preselectedFriendId;

  const _ComposeMessageSheet({
    required this.friends,
    this.preselectedFriendId,
  });

  @override
  State<_ComposeMessageSheet> createState() => _ComposeMessageSheetState();
}

class _ComposeMessageSheetState extends State<_ComposeMessageSheet> {
  final _messageController = TextEditingController();
  String? _selectedRecipient;

  @override
  void initState() {
    super.initState();
    _selectedRecipient = widget.preselectedFriendId;
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'New Message',
                    style: theme.textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Recipient selector
              DropdownButtonFormField<String>(
                value: _selectedRecipient,
                decoration: const InputDecoration(
                  labelText: 'To',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                items: widget.friends.map((r) {
                  return DropdownMenuItem<String>(
                    value: r['id'] as String,
                    child: Text(r['name'] as String),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedRecipient = value);
                },
              ),

              const SizedBox(height: AppSpacing.md),

              // Message input
              TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  hintText: 'Write your message...',
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
              ),

              const SizedBox(height: AppSpacing.md),

              // Send button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _selectedRecipient != null &&
                          _messageController.text.isNotEmpty
                      ? _sendMessage
                      : null,
                  icon: const Icon(Icons.send),
                  label: const Text('Send'),
                ),
              ),

              // E2E encryption notice
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock,
                    size: 14,
                    color: AppColors.gray500,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'End-to-end encrypted',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.gray500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendMessage() {
    // TODO: Implement E2E encryption and send
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message sent')),
    );
  }
}

/// Add friend sheet
class _AddFriendSheet extends StatefulWidget {
  @override
  State<_AddFriendSheet> createState() => _AddFriendSheetState();
}

class _AddFriendSheetState extends State<_AddFriendSheet> {
  final _emailController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add Friend',
                    style: theme.textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email address',
                  hintText: 'Enter friend\'s email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: AppSpacing.md),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _emailController.text.isNotEmpty ? _sendFriendRequest : null,
                  icon: _isSearching
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : const Icon(Icons.person_add),
                  label: Text(_isSearching ? 'Sending...' : 'Send Friend Request'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendFriendRequest() {
    setState(() => _isSearching = true);
    // TODO: Implement friend request
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Friend request sent')),
      );
    });
  }
}

/// Message detail sheet
class _MessageDetailSheet extends StatelessWidget {
  final Map<String, dynamic> message;

  const _MessageDetailSheet({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.gray200,
                  child: Text(
                    message['sender_name'][0].toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message['sender_name'],
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        DateFormat('MMM d, HH:mm').format(message['created_at']),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(),
            const SizedBox(height: AppSpacing.md),

            // Message content
            Text(
              message['preview'],
              style: theme.textTheme.bodyLarge,
            ),

            const SizedBox(height: AppSpacing.lg),

            // Reply button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Open reply composer
                },
                icon: const Icon(Icons.reply),
                label: const Text('Reply'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
