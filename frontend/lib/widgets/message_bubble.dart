/// Ctrl+Shift+Date - Message Bubble Widget
/// Inbox message display
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme.dart';

/// Message bubble for inbox display
class MessageBubble extends StatelessWidget {
  /// Message ID
  final String id;

  /// Sender name
  final String senderName;

  /// Message type (text, event_share, poke, system)
  final String messageType;

  /// Message preview/content
  final String preview;

  /// Whether message has been read
  final bool isRead;

  /// When message was created
  final DateTime createdAt;

  /// Callback when bubble is tapped
  final VoidCallback? onTap;

  /// Callback when bubble is dismissed
  final VoidCallback? onDismiss;

  const MessageBubble({
    super.key,
    required this.id,
    required this.senderName,
    required this.messageType,
    required this.preview,
    this.isRead = false,
    required this.createdAt,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final csd = context.csd;

    final content = Dismissible(
      key: Key(id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss?.call(),
      background: Container(
        color: AppColors.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.md),
        child: Icon(Icons.delete, color: csd.surface),
      ),
      child: ListTile(
        onTap: onTap,
        leading: _buildLeadingIcon(context),
        title: Row(
          children: [
            Expanded(
              child: Text(
                senderName,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              _formatTime(createdAt),
              style: theme.textTheme.labelSmall?.copyWith(
                color: csd.onSurfaceDim,
              ),
            ),
          ],
        ),
        subtitle: Row(
          children: [
            if (messageType != 'text') ...[
              _buildTypeIcon(),
              const SizedBox(width: 4),
            ],
            Expanded(
              child: Text(
                preview,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isRead ? csd.onSurfaceDim : csd.onSurfaceAlt,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (!isRead) ...[
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: csd.onSurface,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );

    return content;
  }

  Widget _buildLeadingIcon(BuildContext context) {
    final csd = context.csd;
    IconData icon;
    Color backgroundColor;

    switch (messageType) {
      case 'event_share':
        icon = Icons.event;
        backgroundColor = AppColors.priorityMedium.withValues(alpha: 0.1);
        break;
      case 'poke':
        icon = Icons.touch_app;
        backgroundColor = AppColors.warning.withValues(alpha: 0.1);
        break;
      case 'system':
        icon = Icons.info;
        backgroundColor = csd.surfaceAlt;
        break;
      default:
        // For text messages, show sender avatar
        return CircleAvatar(
          radius: 24,
          backgroundColor: csd.avatarBg,
          child: Text(
            senderName.isNotEmpty ? senderName[0].toUpperCase() : '?',
            style: TextStyle(
              color: csd.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        );
    }

    return CircleAvatar(
      radius: 24,
      backgroundColor: backgroundColor,
      child: Icon(
        icon,
        size: 20,
        color: csd.iconDefault,
      ),
    );
  }

  Widget _buildTypeIcon() {
    IconData icon;
    Color color;

    switch (messageType) {
      case 'event_share':
        icon = Icons.event;
        color = AppColors.priorityMedium;
        break;
      case 'poke':
        icon = Icons.touch_app;
        color = AppColors.warning;
        break;
      case 'system':
        icon = Icons.info;
        color = AppColors.gray500;
        break;
      default:
        return const SizedBox.shrink();
    }

    return Icon(icon, size: 14, color: color);
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d';
    } else {
      return DateFormat('MMM d').format(time);
    }
  }
}

/// Full message view for expanded message display
class MessageView extends StatelessWidget {
  final String senderName;
  final String? senderAvatarUrl;
  final String messageType;
  final String content;
  final DateTime createdAt;
  final VoidCallback? onReply;

  const MessageView({
    super.key,
    required this.senderName,
    this.senderAvatarUrl,
    required this.messageType,
    required this.content,
    required this.createdAt,
    this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final csd = context.csd;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sender info
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: csd.avatarBg,
              backgroundImage: senderAvatarUrl != null
                  ? NetworkImage(senderAvatarUrl!)
                  : null,
              child: senderAvatarUrl == null
                  ? Text(
                      senderName.isNotEmpty
                          ? senderName[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: csd.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    senderName,
                    style: theme.textTheme.titleSmall,
                  ),
                  Text(
                    DateFormat('MMM d, yyyy at HH:mm').format(createdAt),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: csd.onSurfaceDim,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        // Message type badge
        if (messageType != 'text') ...[
          _buildTypeBadge(context),
          const SizedBox(height: AppSpacing.sm),
        ],

        // Content
        Text(
          content,
          style: theme.textTheme.bodyLarge,
        ),

        const SizedBox(height: AppSpacing.lg),

        // E2E encryption indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock, size: 12, color: csd.iconDefault),
            const SizedBox(width: 4),
            Text(
              'End-to-end encrypted',
              style: theme.textTheme.labelSmall?.copyWith(
                color: csd.onSurfaceDim,
              ),
            ),
          ],
        ),

        if (onReply != null) ...[
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onReply,
              icon: const Icon(Icons.reply),
              label: const Text('Reply'),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTypeBadge(BuildContext context) {
    final theme = Theme.of(context);

    String label;
    IconData icon;
    Color color;

    switch (messageType) {
      case 'event_share':
        label = 'Event Share';
        icon = Icons.event;
        color = AppColors.priorityMedium;
        break;
      case 'poke':
        label = 'Poke';
        icon = Icons.touch_app;
        color = AppColors.warning;
        break;
      case 'system':
        label = 'System';
        icon = Icons.info;
        color = AppColors.gray500;
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Chat-style message bubble for conversation view
class ChatBubble extends StatelessWidget {
  final String content;
  final DateTime timestamp;
  final bool isFromMe;
  final bool isRead;

  const ChatBubble({
    super.key,
    required this.content,
    required this.timestamp,
    required this.isFromMe,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final csd = context.csd;

    return Align(
      alignment: isFromMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(
          vertical: AppSpacing.xs,
          horizontal: AppSpacing.md,
        ),
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: isFromMe ? csd.onSurface : csd.surfaceAlt,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppRadius.md),
            topRight: const Radius.circular(AppRadius.md),
            bottomLeft: Radius.circular(isFromMe ? AppRadius.md : 0),
            bottomRight: Radius.circular(isFromMe ? 0 : AppRadius.md),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              content,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isFromMe ? csd.surface : csd.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('HH:mm').format(timestamp),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isFromMe
                        ? csd.surface.withValues(alpha: 0.7)
                        : csd.onSurfaceDim,
                  ),
                ),
                if (isFromMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    isRead ? Icons.done_all : Icons.check,
                    size: 14,
                    color: csd.surface.withValues(alpha: 0.7),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
