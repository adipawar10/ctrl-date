/// Ctrl+Shift+Date - Inbox Screen
/// Encrypted messages, friends, and system notifications
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/inbox.dart';
import '../models/friendship.dart';
import '../providers/inbox_provider.dart';
import '../providers/events_provider.dart';
import '../providers/friends_provider.dart';
import '../services/api_service.dart';
import '../services/encryption_service.dart';
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
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Friends'),
                  Builder(builder: (context) {
                    final friendsCount = ref.watch(friendsProvider).valueOrNull?.length ?? 0;
                    if (friendsCount > 0) {
                      return Row(
                        children: [
                          const SizedBox(width: 4),
                          _buildBadge('$friendsCount'),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  }),
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
          _buildFriendsTab(context),
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
        color: context.csd.onSurface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: context.csd.surface,
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
                color: context.csd.onSurfaceDim,
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
                color: context.csd.onSurfaceDim,
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
        color: notification.isRead ? context.csd.surface : context.csd.surfaceAlt,
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: context.csd.avatarBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: context.csd.iconDefault),
          ),
          title: Text(
            notification.title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w600,
              color: context.csd.onSurfaceAlt,
            ),
          ),
          subtitle: Text(
            notification.body ?? '',
            style: theme.textTheme.bodySmall?.copyWith(
              color: context.csd.onSurfaceDim,
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
                  color: context.csd.onSurfaceDim,
                ),
              ),
              if (!notification.isRead) ...[
                const SizedBox(height: 4),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: context.csd.onSurfaceDim,
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

  Widget _buildFriendsTab(BuildContext context) {
    final theme = Theme.of(context);
    final friendshipsAsync = ref.watch(friendshipsProvider);
    final currentUserId = Supabase.instance.client.auth.currentUser?.id ?? '';

    return friendshipsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: context.csd.onSurfaceDim),
            const SizedBox(height: AppSpacing.md),
            Text('Failed to load friends', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            ElevatedButton(
              onPressed: () => ref.read(friendshipsProvider.notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (friendships) {
        final accepted = friendships
            .where((f) => f.status == FriendshipStatus.accepted)
            .toList();
        final pendingIncoming = friendships
            .where((f) =>
                f.status == FriendshipStatus.pending &&
                f.addresseeId == currentUserId)
            .toList();
        final pendingOutgoing = friendships
            .where((f) =>
                f.status == FriendshipStatus.pending &&
                f.requesterId == currentUserId)
            .toList();

        if (accepted.isEmpty && pendingIncoming.isEmpty && pendingOutgoing.isEmpty) {
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
          child: ListView(
            children: [
              // Add friend button
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: OutlinedButton.icon(
                  onPressed: _showAddFriendDialog,
                  icon: const Icon(Icons.person_add),
                  label: const Text('Add Friend'),
                ),
              ),

              // Pending incoming requests
              if (pendingIncoming.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xs,
                  ),
                  child: Text('Friend Requests', style: theme.textTheme.titleSmall?.copyWith(
                    color: context.csd.onSurfaceDim,
                  )),
                ),
                ...pendingIncoming.map((f) {
                  final profile = f.getFriendProfile(currentUserId);
                  final name = profile?.displayName ?? 'Unknown';
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: context.csd.avatarBg,
                      backgroundImage: profile?.avatarUrl != null
                          ? NetworkImage(profile!.avatarUrl!)
                          : null,
                      child: profile?.avatarUrl == null
                          ? Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
                              style: TextStyle(color: context.csd.onSurface, fontWeight: FontWeight.w600))
                          : null,
                    ),
                    title: Text(name),
                    subtitle: const Text('Wants to be friends'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () async {
                            await ref.read(friendActionsProvider).declineFriendRequest(f.id);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Request declined')),
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () async {
                            await ref.read(friendActionsProvider).acceptFriendRequest(f.id);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Friend request accepted!')),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ],

              // Pending outgoing requests
              if (pendingOutgoing.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.xs,
                  ),
                  child: Text('Sent Requests', style: theme.textTheme.titleSmall?.copyWith(
                    color: context.csd.onSurfaceDim,
                  )),
                ),
                ...pendingOutgoing.map((f) {
                  final profile = f.getFriendProfile(currentUserId);
                  final name = profile?.displayName ?? 'Unknown';
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: context.csd.avatarBg,
                      child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
                          style: TextStyle(color: context.csd.onSurface, fontWeight: FontWeight.w600)),
                    ),
                    title: Text(name),
                    subtitle: const Text('Pending'),
                    trailing: TextButton(
                      onPressed: () async {
                        await ref.read(friendActionsProvider).removeFriend(f.id);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Request cancelled')),
                          );
                        }
                      },
                      child: const Text('Cancel'),
                    ),
                  );
                }),
              ],

              // Accepted friends
              if (accepted.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.xs,
                  ),
                  child: Text('Friends (${accepted.length})', style: theme.textTheme.titleSmall?.copyWith(
                    color: context.csd.onSurfaceDim,
                  )),
                ),
                ...accepted.map((f) {
                  final profile = f.getFriendProfile(currentUserId);
                  final name = profile?.displayName ?? 'Unknown';
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: context.csd.avatarBg,
                      backgroundImage: profile?.avatarUrl != null
                          ? NetworkImage(profile!.avatarUrl!)
                          : null,
                      child: profile?.avatarUrl == null
                          ? Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
                              style: TextStyle(color: context.csd.onSurface, fontWeight: FontWeight.w600))
                          : null,
                    ),
                    title: Text(name),
                    subtitle: f.streakCount > 0
                        ? Text('${f.streakCount} day streak')
                        : null,
                    trailing: IconButton(
                      icon: const Icon(Icons.touch_app_outlined),
                      tooltip: 'Poke',
                      onPressed: () {
                        ref.read(friendActionsProvider).sendPoke(
                          f.getFriendId(currentUserId),
                          PokeType.wave,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Poke sent!')),
                        );
                      },
                    ),
                    onTap: () => _showFriendOptions(f, currentUserId),
                  );
                }),
              ],
            ],
          ),
        );
      },
    );
  }

  void _showAddFriendDialog() {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
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
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final email = emailController.text.trim();
              if (email.isNotEmpty) {
                Navigator.pop(dialogContext);
                _sendFriendRequest(email);
              }
            },
            child: const Text('Send Request'),
          ),
        ],
      ),
    );
  }

  Future<void> _sendFriendRequest(String email) async {
    try {
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

  void _showFriendOptions(Friendship friendship, String currentUserId) {
    final profile = friendship.getFriendProfile(currentUserId);
    final name = profile?.displayName ?? 'Unknown';
    final friendId = friendship.getFriendId(currentUserId);

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
                backgroundImage: profile?.avatarUrl != null
                    ? NetworkImage(profile!.avatarUrl!)
                    : null,
                child: profile?.avatarUrl == null
                    ? Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: TextStyle(color: context.csd.onSurface, fontWeight: FontWeight.w600))
                    : null,
              ),
              title: Text(name),
              subtitle: friendship.streakCount > 0
                  ? Text('${friendship.streakCount} day streak')
                  : null,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.touch_app),
              title: const Text('Poke'),
              onTap: () {
                Navigator.pop(context);
                ref.read(friendActionsProvider).sendPoke(friendId, PokeType.wave);
                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(content: Text('Poke sent!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.message_outlined),
              title: const Text('Send Message'),
              onTap: () {
                Navigator.pop(context);
                _composeMessage();
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.person_remove, color: AppColors.error),
              title: Text('Remove Friend', style: TextStyle(color: AppColors.error)),
              onTap: () {
                Navigator.pop(context);
                _confirmRemoveFriend(friendship.id);
              },
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  void _confirmRemoveFriend(String friendshipId) {
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
                ScaffoldMessenger.of(this.context).showSnackBar(
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
                    color: context.csd.onSurfaceDim,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'End-to-end encrypted',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: context.csd.onSurfaceDim,
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

  Future<void> _sendMessage() async {
    if (_selectedRecipient == null || _messageController.text.isEmpty) return;

    try {
      final api = ApiService.instance;
      final encryption = EncryptionService.instance;

      // Get recipient's public key
      final keyResponse = await api.get(
        '/inbox/public-key',
        queryParams: {'user_id': _selectedRecipient!},
      );

      if (!keyResponse.isSuccess || keyResponse.data == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not get recipient encryption key')),
          );
        }
        return;
      }

      final recipientPublicKey = keyResponse.data['public_key'] as String?;
      if (recipientPublicKey == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Recipient has no encryption key')),
          );
        }
        return;
      }

      // Encrypt the message
      final encryptedData = await encryption.encryptForUser(
        _messageController.text,
        recipientPublicKey,
      );

      // Get our ephemeral public key
      final ephemeralPublicKey = await encryption.getPublicKey();

      // Send via API
      final response = await api.post(
        '/inbox',
        body: {
          'recipient_id': _selectedRecipient,
          'message_type': 'text',
          'ciphertext': encryptedData,
          'ephemeral_public_key': ephemeralPublicKey,
          'nonce': '',
        },
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.isSuccess
                  ? 'Message sent (encrypted)'
                  : 'Failed to send message',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send message')),
        );
      }
    }
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
                  backgroundColor: context.csd.avatarBg,
                  child: Text(
                    (message.sender?.displayName ?? 'U')[0].toUpperCase(),
                    style: TextStyle(
                      color: context.csd.onSurface,
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
