/// Ctrl+Shift+Date - Inbox Screen
/// Encrypted messages and notifications
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../theme.dart';
import '../widgets/message_bubble.dart';

/// Inbox screen showing encrypted messages
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

  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 'n1',
      'type': 'reminder',
      'title': 'Upcoming event',
      'body': 'Team Standup in 15 minutes',
      'is_read': false,
      'created_at': DateTime.now().subtract(const Duration(minutes: 5)),
    },
    {
      'id': 'n2',
      'type': 'streak',
      'title': 'Streak milestone!',
      'body': 'You reached a 7-day streak!',
      'is_read': true,
      'created_at': DateTime.now().subtract(const Duration(hours: 1)),
    },
    {
      'id': 'n3',
      'type': 'ai_suggestion',
      'title': 'New AI suggestion',
      'body': 'We found a better time for your focus block',
      'is_read': true,
      'created_at': DateTime.now().subtract(const Duration(hours: 5)),
    },
  ];

  int get _unreadMessageCount => _messages.where((m) => !m['is_read']).length;
  int get _unreadNotificationCount =>
      _notifications.where((n) => !n['is_read']).length;

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
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Notifications'),
                  if (_unreadNotificationCount > 0) ...[
                    const SizedBox(width: 4),
                    _buildBadge('$_unreadNotificationCount'),
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
          _buildNotificationsList(context),
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

  Widget _buildNotificationsList(BuildContext context) {
    final theme = Theme.of(context);

    if (_notifications.isEmpty) {
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
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return _buildNotificationTile(notification);
        },
      ),
    );
  }

  Widget _buildNotificationTile(Map<String, dynamic> notification) {
    final theme = Theme.of(context);
    final isRead = notification['is_read'] as bool;
    final type = notification['type'] as String;

    IconData icon;
    switch (type) {
      case 'reminder':
        icon = Icons.alarm;
        break;
      case 'streak':
        icon = Icons.local_fire_department;
        break;
      case 'ai_suggestion':
        icon = Icons.auto_awesome;
        break;
      default:
        icon = Icons.notifications;
    }

    return Dismissible(
      key: Key(notification['id']),
      background: Container(
        color: AppColors.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.md),
        child: const Icon(Icons.delete, color: AppColors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _deleteNotification(notification['id']),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isRead ? AppColors.gray100 : AppColors.gray200,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: AppColors.gray700),
        ),
        title: Text(
          notification['title'],
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
          ),
        ),
        subtitle: Text(
          notification['body'],
          style: theme.textTheme.bodySmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatTime(notification['created_at']),
              style: theme.textTheme.labelSmall,
            ),
            if (!isRead) ...[
              const SizedBox(height: 4),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.black,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
        onTap: () => _openNotification(notification),
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

  void _handleMenuAction(String action) {
    switch (action) {
      case 'mark_all_read':
        setState(() {
          for (final m in _messages) {
            m['is_read'] = true;
          }
          for (final n in _notifications) {
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
                    _notifications.clear();
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
      builder: (context) => _ComposeMessageSheet(),
    );
  }

  Future<void> _refreshMessages() async {
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

  void _openNotification(Map<String, dynamic> notification) {
    setState(() {
      notification['is_read'] = true;
    });

    // Navigate based on notification type
    final type = notification['type'] as String;
    switch (type) {
      case 'reminder':
        // Navigate to event
        break;
      case 'streak':
        // Navigate to reflection
        break;
      case 'ai_suggestion':
        // Navigate to AI suggestions
        break;
    }
  }

  void _deleteMessage(String id) {
    setState(() {
      _messages.removeWhere((m) => m['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message deleted')),
    );
  }

  void _deleteNotification(String id) {
    setState(() {
      _notifications.removeWhere((n) => n['id'] == id);
    });
  }
}

/// Compose message sheet
class _ComposeMessageSheet extends StatefulWidget {
  @override
  State<_ComposeMessageSheet> createState() => _ComposeMessageSheetState();
}

class _ComposeMessageSheetState extends State<_ComposeMessageSheet> {
  final _messageController = TextEditingController();
  String? _selectedRecipient;

  // Mock recipients
  final List<Map<String, String>> _recipients = [
    {'id': '2', 'name': 'Alice Johnson'},
    {'id': '3', 'name': 'Bob Smith'},
    {'id': '4', 'name': 'Charlie Brown'},
  ];

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
                items: _recipients.map((r) {
                  return DropdownMenuItem(
                    value: r['id'],
                    child: Text(r['name']!),
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
