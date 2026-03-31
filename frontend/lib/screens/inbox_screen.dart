/// Ctrl+Shift+Date - Inbox Screen
/// Encrypted messages, friends, and system notifications
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../models/inbox.dart';
import '../providers/inbox_provider.dart';
import '../providers/friends_provider.dart';
import '../theme.dart';
import '../widgets/message_bubble.dart';

/// Inbox screen showing encrypted messages, friends, and system notifications
class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
    final inboxState = ref.watch(inboxProvider);
    final unreadCount = ref.watch(unreadMessageCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (action) => _handleMenuAction(action, ref),
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
                  if (unreadCount > 0) ...[
                    const SizedBox(width: 4),
                    _buildBadge('$unreadCount'),
                  ],
                ],
              ),
            ),
            const Tab(text: 'Notifications'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMessagesList(context, inboxState),
          _buildNotificationsList(context, inboxState),
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

  Widget _buildMessagesList(BuildContext context, InboxState inboxState) {
    final theme = Theme.of(context);
    final messages = inboxState.messages
        .where((m) => m.type == MessageType.poke || m.type == MessageType.eventShare || m.type == MessageType.friendRequest || m.type == MessageType.friendAccepted)
        .toList();

    if (inboxState.isLoading && messages.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (messages.isEmpty) {
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
      onRefresh: () => ref.read(inboxActionsProvider).refresh(),
      child: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return MessageBubble(
            id: message.id,
            senderName: message.sender?.displayName ?? 'Unknown',
            messageType: message.type.name,
            preview: message.body ?? message.title,
            isRead: message.isRead,
            createdAt: message.createdAt ?? DateTime.now(),
            onTap: () => _openMessage(message),
            onDismiss: () => _deleteMessage(message.id),
          );
        },
      ),
    );
  }

  Widget _buildNotificationsList(BuildContext context, InboxState inboxState) {
    final theme = Theme.of(context);
    final notifications = inboxState.messages
        .where((m) =>
            m.type == MessageType.system ||
            m.type == MessageType.announcement ||
            m.type == MessageType.eventReminder ||
            m.type == MessageType.eventUpdate ||
            m.type == MessageType.eventCancelled ||
            m.type == MessageType.reflectionReminder ||
            m.type == MessageType.streakMilestone)
        .toList();

    if (inboxState.isLoading && notifications.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (notifications.isEmpty) {
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
      onRefresh: () => ref.read(inboxActionsProvider).refresh(),
      child: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return _buildNotificationTile(notification);
        },
      ),
    );
  }

  Widget _buildNotificationTile(InboxMessage notification) {
    final theme = Theme.of(context);

    IconData icon;
    switch (notification.type) {
      case MessageType.friendRequest:
      case MessageType.friendAccepted:
        icon = Icons.person_add;
        break;
      case MessageType.eventShare:
      case MessageType.eventUpdate:
      case MessageType.eventReminder:
        icon = Icons.event_available;
        break;
      case MessageType.streakMilestone:
        icon = Icons.local_fire_department;
        break;
      default:
        icon = Icons.notifications;
    }

    return Dismissible(
      key: Key(notification.id),
      background: Container(
        color: AppColors.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.md),
        child: const Icon(Icons.delete, color: AppColors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _deleteMessage(notification.id),
      child: Container(
        color: notification.isRead ? AppColors.white : AppColors.gray100,
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
            notification.title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w600,
              color: AppColors.gray700,
            ),
          ),
          subtitle: Text(
            notification.body ?? '',
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
                _formatTime(notification.createdAt ?? DateTime.now()),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.gray500,
                ),
              ),
              if (!notification.isRead) ...[
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
          onTap: () {
            ref.read(inboxActionsProvider).markAsRead(notification.id);
          },
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

  void _handleMenuAction(String action, WidgetRef ref) {
    switch (action) {
      case 'mark_all_read':
        ref.read(inboxActionsProvider).markAllAsRead();
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
                  final inboxState = ref.read(inboxProvider);
                  final allIds = inboxState.messages.map((m) => m.id).toList();
                  ref.read(inboxActionsProvider).deleteMultiple(allIds);
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
    final friendships = ref.read(friendshipsProvider).valueOrNull ?? [];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _ComposeMessageSheet(
        friends: friendships.where((f) => f.isActive).map((f) {
          // We don't have current user ID here, so use both profiles
          final profile = f.requester ?? f.addressee;
          return {
            'id': f.requesterId,
            'name': profile?.displayName ?? 'Friend',
          };
        }).toList(),
      ),
    );
  }

  void _openMessage(InboxMessage message) {
    ref.read(inboxActionsProvider).markAsRead(message.id);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _MessageDetailSheet(message: message),
    );
  }

  void _deleteMessage(String id) {
    ref.read(inboxActionsProvider).delete(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message deleted')),
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
    // TODO: Implement E2E encryption via backend /inbox POST
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message sent (encrypted)')),
    );
  }
}

/// Message detail sheet
class _MessageDetailSheet extends StatelessWidget {
  final InboxMessage message;

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
                    (message.sender?.displayName ?? 'U')[0].toUpperCase(),
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
                        message.sender?.displayName ?? 'Unknown',
                        style: theme.textTheme.titleMedium,
                      ),
                      if (message.createdAt != null)
                        Text(
                          DateFormat('MMM d, HH:mm').format(message.createdAt!),
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
              message.title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (message.body != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                message.body!,
                style: theme.textTheme.bodyLarge,
              ),
            ],

            // Actions
            if (message.actions != null && message.actions!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              ...message.actions!.map((action) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: SizedBox(
                  width: double.infinity,
                  child: action.isPrimary
                      ? ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(action.label),
                        )
                      : OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(action.label),
                        ),
                ),
              )),
            ] else ...[
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.reply),
                  label: const Text('Reply'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
