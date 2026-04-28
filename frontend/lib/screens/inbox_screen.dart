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
import '../router.dart';
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
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          isScrollable: true,
          tabs: [
            Tab(
              child: FittedBox(
                fit: BoxFit.scaleDown,
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
            ),
            Tab(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Friends'),
                    Builder(builder: (context) {
                      final friendsCount =
                          ref.watch(friendsProvider).valueOrNull?.length ?? 0;
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
            ),
            const Tab(text: 'Notifications'),
            const Tab(text: 'Events'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMessagesList(context, inboxState),
          _buildFriendsTab(context),
          _buildNotificationsList(context, inboxState),
          _buildEventsTab(context),
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
    final allMessages = inboxState.messages
        .where((m) => m.type == MessageType.text)
        .toList()
      ..sort((a, b) =>
          (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));

    final latestByConversation = <String, InboxMessage>{};
    for (final m in allMessages) {
      final cid = (m.data?['counterpartId'] as String?) ??
          m.sender?.id ??
          m.senderId ??
          '';
      if (cid.isEmpty) continue;
      latestByConversation.putIfAbsent(cid, () => m);
    }
    final messages = latestByConversation.values.toList()
      ..sort((a, b) =>
          (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));

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
            onTap: () {
              if (message.type == MessageType.text) {
                final threadId = (message.data?['counterpartId'] as String?) ??
                    message.sender?.id ??
                    message.senderId;
                if (threadId != null && threadId.isNotEmpty) {
                  _openChatThread(
                    threadId,
                    (message.data?['counterpartName'] as String?) ??
                        message.sender?.displayName ??
                        'Chat',
                  );
                  return;
                }
              }
              _openMessage(message);
            },
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
        color:
            notification.isRead ? context.csd.surface : context.csd.surfaceAlt,
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
              fontWeight:
                  notification.isRead ? FontWeight.w500 : FontWeight.w600,
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
            Icon(Icons.error_outline,
                size: 48, color: context.csd.onSurfaceDim),
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

        if (accepted.isEmpty &&
            pendingIncoming.isEmpty &&
            pendingOutgoing.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline,
                    size: 64, color: theme.colorScheme.outline),
                const SizedBox(height: AppSpacing.md),
                Text('No friends yet', style: theme.textTheme.titleLarge),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Add friends to share events and stay accountable',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: context.csd.onSurfaceDim),
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
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.md,
                    AppSpacing.xs,
                  ),
                  child: Text('Friend Requests',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: context.csd.onSurfaceDim,
                      )),
                ),
                ...pendingIncoming.map((f) {
                  final profile = f.getFriendProfile(currentUserId) ??
                      f.requester ??
                      f.addressee;
                  final name = profile?.displayName ?? 'Unknown';
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: context.csd.avatarBg,
                      backgroundImage: profile?.avatarUrl != null
                          ? NetworkImage(profile!.avatarUrl!)
                          : null,
                      child: profile?.avatarUrl == null
                          ? Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
                              style: TextStyle(
                                  color: context.csd.onSurface,
                                  fontWeight: FontWeight.w600))
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
                            await ref
                                .read(friendActionsProvider)
                                .declineFriendRequest(f.id);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Request declined')),
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () async {
                            await ref
                                .read(friendActionsProvider)
                                .acceptFriendRequest(f.id);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Friend request accepted!')),
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
                    AppSpacing.md,
                    AppSpacing.md,
                    AppSpacing.md,
                    AppSpacing.xs,
                  ),
                  child: Text('Sent Requests',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: context.csd.onSurfaceDim,
                      )),
                ),
                ...pendingOutgoing.map((f) {
                  final profile = f.getFriendProfile(currentUserId) ??
                      f.requester ??
                      f.addressee;
                  final name = profile?.displayName ?? 'Unknown';
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: context.csd.avatarBg,
                      child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
                          style: TextStyle(
                              color: context.csd.onSurface,
                              fontWeight: FontWeight.w600)),
                    ),
                    title: Text(name),
                    subtitle: const Text('Pending'),
                    trailing: TextButton(
                      onPressed: () async {
                        await ref
                            .read(friendActionsProvider)
                            .removeFriend(f.id);
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
                    AppSpacing.md,
                    AppSpacing.md,
                    AppSpacing.md,
                    AppSpacing.xs,
                  ),
                  child: Text('Friends (${accepted.length})',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: context.csd.onSurfaceDim,
                      )),
                ),
                ...accepted.map((f) {
                  final profile = f.getFriendProfile(currentUserId) ??
                      f.requester ??
                      f.addressee;
                  final name = profile?.displayName ?? 'Unknown';
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: context.csd.avatarBg,
                      backgroundImage: profile?.avatarUrl != null
                          ? NetworkImage(profile!.avatarUrl!)
                          : null,
                      child: profile?.avatarUrl == null
                          ? Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
                              style: TextStyle(
                                  color: context.csd.onSurface,
                                  fontWeight: FontWeight.w600))
                          : null,
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Tooltip(
                          message: 'Friend streak (daily completion)',
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.local_fire_department,
                                size: 18,
                                color: AppColors.warning,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${f.streakCount}',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.touch_app_outlined),
                      tooltip: 'Poke',
                      onPressed: () {
                        ref.read(friendActionsProvider).sendPoke(
                              profile?.id ?? f.getFriendId(currentUserId),
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

  Widget _buildEventsTab(BuildContext context) {
    return _CommunityEventsTab();
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
      final response =
          await api.post('/friends/request', body: {'email': email});

      if (mounted) {
        if (response.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Friend request sent to $email')),
          );
          ref.read(friendshipsProvider.notifier).refresh();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(response.error?.message ?? 'Failed to send request'),
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
                        style: TextStyle(
                            color: context.csd.onSurface,
                            fontWeight: FontWeight.w600))
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
                ref
                    .read(friendActionsProvider)
                    .sendPoke(friendId, PokeType.wave);
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
                final friendId =
                    profile?.id ?? friendship.getFriendId(currentUserId);
                _openChatThread(friendId, name);
              },
            ),
            ListTile(
              leading: const Icon(Icons.compare_arrows),
              title: const Text('Compare Calendar'),
              onTap: () {
                Navigator.pop(context);
                final date = DateTime.now().toIso8601String().split('T').first;
                this.context.go(
                      '${AppRoutes.dualCalendar}?friendUserId=$friendId&date=$date',
                    );
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.person_remove, color: AppColors.error),
              title: Text('Remove Friend',
                  style: TextStyle(color: AppColors.error)),
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
    final currentUserId = Supabase.instance.client.auth.currentUser?.id ?? '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _ComposeMessageSheet(
        friends: friendships.where((f) => f.isActive).map((f) {
          final profile =
              f.getFriendProfile(currentUserId) ?? f.requester ?? f.addressee;
          final friendId = profile?.id ?? f.getFriendId(currentUserId);
          return {
            'id': friendId,
            'name': profile?.displayName ?? 'Friend',
            'public_key': f.friendPublicKey,
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

  void _openChatThread(String friendId, String friendName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _ChatThreadSheet(
        friendId: friendId,
        friendName: friendName,
      ),
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

              // Message input — onChanged triggers setState so Send enables when typing
              TextField(
                controller: _messageController,
                onChanged: (_) => setState(() {}),
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

      final ciphertext = _messageController.text;
      const String ephemeralPublicKey = '';

      final response = await api.post(
        '/inbox',
        body: {
          'recipient_id': _selectedRecipient,
          'message_type': 'text',
          'ciphertext': ciphertext,
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
                  ? 'Message sent'
                  : (response.error?.message ?? 'Failed to send message'),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: $e')),
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

class _ChatThreadSheet extends StatefulWidget {
  final String friendId;
  final String friendName;

  const _ChatThreadSheet({required this.friendId, required this.friendName});

  @override
  State<_ChatThreadSheet> createState() => _ChatThreadSheetState();
}

class _ChatThreadSheetState extends State<_ChatThreadSheet> {
  final _controller = TextEditingController();
  bool _loading = true;
  bool _sending = false;
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadThread();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadThread() async {
    setState(() => _loading = true);
    final resp = await ApiService.instance.get<Map<String, dynamic>>(
      '/inbox/thread/${widget.friendId}',
    );
    if (!mounted) return;
    if (resp.isSuccess && resp.data != null) {
      final raw =
          (resp.data!['messages'] as List? ?? []).cast<Map<String, dynamic>>();
      final out = <Map<String, dynamic>>[];
      final me = Supabase.instance.client.auth.currentUser?.id;
      final publicKeyCache = <String, String?>{};

      for (final m in raw) {
        var text = (m['ciphertext'] ?? '').toString();
        final senderId = (m['sender_id'] ?? '').toString();
        final isMine = senderId == me;
        final senderKeyFromMsg = (m['ephemeral_public_key'] ?? '').toString();

        if (!isMine) {
          var decrypted = false;

          if (senderKeyFromMsg.isNotEmpty) {
            try {
              text = await EncryptionService.instance
                  .decryptFromUser(text, senderKeyFromMsg);
              decrypted = true;
            } catch (_) {}
          }

          if (!decrypted) {
            String? senderPublicKey = publicKeyCache[senderId];
            if (!publicKeyCache.containsKey(senderId)) {
              final keyResp =
                  await ApiService.instance.get<Map<String, dynamic>>(
                '/inbox/public-key/$senderId',
              );
              if (keyResp.isSuccess && keyResp.data != null) {
                senderPublicKey = keyResp.data!['public_key'] as String?;
              } else {
                senderPublicKey = null;
              }
              publicKeyCache[senderId] = senderPublicKey;
            }

            if (senderPublicKey != null && senderPublicKey.isNotEmpty) {
              try {
                text = await EncryptionService.instance
                    .decryptFromUser(text, senderPublicKey);
                decrypted = true;
              } catch (_) {}
            }
          }

          if (!decrypted) {
            if (senderKeyFromMsg.isEmpty) {
              // Sender used non-encrypted fallback; show plain text.
              text = (m['ciphertext'] ?? '').toString();
            } else {
              text = '[Encrypted message]';
            }
          }
        }

        out.add({...m, 'display_text': text});
      }
      setState(() {
        _messages = out;
        _loading = false;
      });
      return;
    }
    setState(() => _loading = false);
  }

  Future<void> _send() async {
    final txt = _controller.text.trim();
    if (txt.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      final resp = await ApiService.instance.post('/inbox', body: {
        'recipient_id': widget.friendId,
        'message_type': 'text',
        'ciphertext': txt,
        'ephemeral_public_key': '',
        'nonce': '',
      });
      if (resp.isSuccess) {
        _controller.clear();
        await _loadThread();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(resp.error?.message ?? 'Failed to send')),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final me = Supabase.instance.client.auth.currentUser?.id;
    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            children: [
              ListTile(
                title: Text(widget.friendName,
                    style: Theme.of(context).textTheme.titleLarge),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        itemCount: _messages.length,
                        itemBuilder: (context, i) {
                          final m = _messages[i];
                          final mine = (m['sender_id'] ?? '') == me;
                          return Align(
                            alignment: mine
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: mine
                                    ? context.csd.onSurface
                                    : context.csd.surfaceAlt,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                (m['display_text'] ?? '').toString(),
                                style: TextStyle(
                                  color: mine
                                      ? context.csd.surface
                                      : context.csd.onSurface,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration:
                            const InputDecoration(hintText: 'Type a message'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _sending ? null : _send,
                      icon: _sending
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommunityEventsTab extends StatefulWidget {
  @override
  State<_CommunityEventsTab> createState() => _CommunityEventsTabState();
}

class _CommunityEventsTabState extends State<_CommunityEventsTab> {
  bool _loading = true;
  List<Map<String, dynamic>> _events = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final resp = await ApiService.instance
        .get<Map<String, dynamic>>('/inbox/community-events');
    if (!mounted) return;
    setState(() {
      _events =
          (resp.data?['events'] as List? ?? []).cast<Map<String, dynamic>>();
      _loading = false;
    });
  }

  Future<void> _createEvent() async {
    await showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.event),
                title: const Text('Add Event'),
                subtitle: const Text('Create a community event'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showCreateEventSheet();
                },
              ),
              ListTile(
                leading: const Icon(Icons.poll),
                title: const Text('Add Event Poll'),
                subtitle: const Text('Ask a question with 2 options'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showCreatePollSheet();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showCreateEventSheet() async {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final locCtrl = TextEditingController();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Event title')),
            const SizedBox(height: 8),
            TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Description')),
            const SizedBox(height: 8),
            TextField(
                controller: locCtrl,
                decoration: const InputDecoration(labelText: 'Location')),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await ApiService.instance
                      .post('/inbox/community-events', body: {
                    'kind': 'event',
                    'title': titleCtrl.text.trim(),
                    'description': descCtrl.text.trim(),
                    'location': locCtrl.text.trim(),
                  });
                  if (!ctx.mounted) return;
                  Navigator.pop(ctx);
                },
                child: const Text('Post Event'),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
    await _load();
  }

  Future<void> _showCreatePollSheet() async {
    final questionCtrl = TextEditingController();
    final option1Ctrl = TextEditingController();
    final option2Ctrl = TextEditingController();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: questionCtrl,
              decoration: const InputDecoration(labelText: 'Poll question'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: option1Ctrl,
              decoration: const InputDecoration(labelText: 'Option 1'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: option2Ctrl,
              decoration: const InputDecoration(labelText: 'Option 2'),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await ApiService.instance
                      .post('/inbox/community-events', body: {
                    'kind': 'poll',
                    'question': questionCtrl.text.trim(),
                    'option_1': option1Ctrl.text.trim(),
                    'option_2': option2Ctrl.text.trim(),
                  });
                  if (!ctx.mounted) return;
                  Navigator.pop(ctx);
                },
                child: const Text('Create Poll'),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
    await _load();
  }

  Future<void> _toggleGoing(Map<String, dynamic> event) async {
    final id = event['id'].toString();
    final going = !(event['is_going'] as bool? ?? false);
    await ApiService.instance
        .post('/inbox/community-events/$id/rsvp', body: {'going': going});
    await _load();
  }

  Future<void> _showAttendees(String eventId) async {
    final resp = await ApiService.instance.get<Map<String, dynamic>>(
        '/inbox/community-events/$eventId/attendees');
    if (!mounted) return;
    final attendees =
        (resp.data?['attendees'] as List? ?? []).cast<Map<String, dynamic>>();
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            const ListTile(title: Text('Going')),
            ...attendees.map((a) => ListTile(
                  leading: CircleAvatar(
                      child: Text((a['display_name'] ?? 'U')
                          .toString()
                          .substring(0, 1)
                          .toUpperCase())),
                  title: Text((a['display_name'] ?? 'Unknown').toString()),
                )),
            if (attendees.isEmpty)
              const ListTile(title: Text('No attendees yet')),
          ],
        ),
      ),
    );
  }

  Future<void> _voteOnPoll(String eventId, int optionIndex) async {
    await ApiService.instance.post(
      '/inbox/community-events/$eventId/vote',
      body: {'option_index': optionIndex},
    );
    await _load();
  }

  Future<void> _editEventNotes(Map<String, dynamic> event) async {
    final notesCtrl =
        TextEditingController(text: (event['notes'] ?? '').toString());
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Event Notes', style: Theme.of(ctx).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: notesCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Add notes for this event',
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await ApiService.instance.put(
                    '/inbox/community-events/${event['id']}/notes',
                    body: {'notes': notesCtrl.text.trim()},
                  );
                  if (!ctx.mounted) return;
                  Navigator.pop(ctx);
                },
                child: const Text('Save Notes'),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final me = Supabase.instance.client.auth.currentUser?.id;
    if (_loading) return const Center(child: CircularProgressIndicator());
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: ElevatedButton.icon(
              onPressed: _createEvent,
              icon: const Icon(Icons.add),
              label: const Text('Post Event'),
            ),
          ),
          ..._events.map((e) => Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: (e['kind'] ?? 'event') == 'poll'
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (e['question'] ?? 'Untitled poll').toString(),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Posted by ${(e['creator_name'] ?? 'Unknown')}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 8),
                            ...((e['options'] as List? ?? [])
                                .asMap()
                                .entries
                                .map((entry) {
                              final idx = entry.key;
                              final opt = entry.value as Map<String, dynamic>;
                              final total =
                                  ((e['vote_totals'] as List?) ?? const [0, 0])
                                      .elementAt(idx);
                              final selected =
                                  (e['selected_option'] as int?) == idx;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: selected
                                        ? context.csd.surfaceAlt
                                        : null,
                                  ),
                                  onPressed: () =>
                                      _voteOnPoll(e['id'].toString(), idx),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child: Text(opt['label'].toString())),
                                      Text('$total votes'),
                                    ],
                                  ),
                                ),
                              );
                            })),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    (e['title'] ?? 'Untitled').toString(),
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () => _toggleGoing(e),
                                  child: Text((e['is_going'] ?? false)
                                      ? 'Going'
                                      : 'Join'),
                                ),
                              ],
                            ),
                            if ((e['description'] ?? '').toString().isNotEmpty)
                              Text((e['description'] ?? '').toString()),
                            if ((e['location'] ?? '').toString().isNotEmpty)
                              Text('Location: ${e['location']}'),
                            Text(
                                'Posted by ${(e['creator_name'] ?? 'Unknown')}'),
                            if ((e['notes'] ?? '').toString().isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text('Notes: ${e['notes']}'),
                              ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () =>
                                      _showAttendees(e['id'].toString()),
                                  child: Text(
                                      "See who's going (${e['attendee_count'] ?? 0})"),
                                ),
                                if ((e['creator_id'] ?? '').toString() ==
                                    (me ?? ''))
                                  TextButton(
                                    onPressed: () => _editEventNotes(e),
                                    child: const Text('Add/Edit Notes'),
                                  ),
                              ],
                            ),
                          ],
                        ),
                ),
              )),
          if (_events.isEmpty)
            const Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Center(child: Text('No community events yet')),
            ),
        ],
      ),
    );
  }
}
