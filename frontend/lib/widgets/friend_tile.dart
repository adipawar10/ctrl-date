/// Ctrl+Shift+Date - Friend Tile Widget
/// Friend list item
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme.dart';
import 'streak_badge.dart';

/// Friend tile widget for displaying friend in a list
class FriendTile extends StatelessWidget {
  /// Friend ID
  final String id;

  /// Display name
  final String displayName;

  /// Email address
  final String email;

  /// Avatar URL (optional)
  final String? avatarUrl;

  /// Whether friend is currently online
  final bool isOnline;

  /// Last active timestamp
  final DateTime? lastActive;

  /// Current streak count
  final int streakCount;

  /// Longest streak count
  final int longestStreak;

  /// Callback when tile is tapped
  final VoidCallback? onTap;

  /// Callback when poke button is pressed
  final VoidCallback? onPoke;

  const FriendTile({
    super.key,
    required this.id,
    required this.displayName,
    required this.email,
    this.avatarUrl,
    this.isOnline = false,
    this.lastActive,
    this.streakCount = 0,
    this.longestStreak = 0,
    this.onTap,
    this.onPoke,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: onTap,
      leading: _buildAvatar(context),
      title: Text(
        displayName,
        style: theme.textTheme.titleSmall,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        _getSubtitle(),
        style: theme.textTheme.bodySmall?.copyWith(
          color: isOnline ? AppColors.completed : context.csd.onSurfaceDim,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (streakCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xs),
              child: StreakBadge(count: streakCount, compact: true),
            ),
          if (onPoke != null)
            IconButton(
              icon: const Icon(Icons.touch_app_outlined),
              onPressed: onPoke,
              tooltip: 'Poke',
            ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final csd = context.csd;
    return Stack(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: csd.avatarBg,
          backgroundImage:
              avatarUrl != null ? NetworkImage(avatarUrl!) : null,
          child: avatarUrl == null
              ? Text(
                  displayName.isNotEmpty
                      ? displayName[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    color: csd.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                )
              : null,
        ),
        if (isOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: AppColors.completed,
                shape: BoxShape.circle,
                border: Border.all(
                  color: csd.surface,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _getSubtitle() {
    if (isOnline) return 'Online';
    if (lastActive == null) return email;

    final now = DateTime.now();
    final diff = now.difference(lastActive!);

    if (diff.inMinutes < 60) {
      return 'Active ${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return 'Active ${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return 'Active ${diff.inDays}d ago';
    } else {
      return 'Active ${DateFormat('MMM d').format(lastActive!)}';
    }
  }
}

/// Compact friend tile for smaller displays
class CompactFriendTile extends StatelessWidget {
  final String displayName;
  final String? avatarUrl;
  final bool isOnline;
  final bool isSelected;
  final VoidCallback? onTap;

  const CompactFriendTile({
    super.key,
    required this.displayName,
    this.avatarUrl,
    this.isOnline = false,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final csd = context.csd;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected ? csd.borderLight : csd.surface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
            color: isSelected ? csd.onSurface : csd.borderLight,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: csd.avatarBg,
                  backgroundImage:
                      avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                  child: avatarUrl == null
                      ? Text(
                          displayName.isNotEmpty
                              ? displayName[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            color: csd.onSurface,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        )
                      : null,
                ),
                if (isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.completed,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: csd.surface,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: AppSpacing.xs),
            Flexible(
              child: Text(
                displayName,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: AppSpacing.xs),
              const Icon(Icons.check, size: 16),
            ],
          ],
        ),
      ),
    );
  }
}

/// Friend request tile with accept/decline actions
class FriendRequestTile extends StatelessWidget {
  final String id;
  final String displayName;
  final String email;
  final String? avatarUrl;
  final DateTime requestedAt;
  final bool isIncoming;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final VoidCallback? onCancel;

  const FriendRequestTile({
    super.key,
    required this.id,
    required this.displayName,
    required this.email,
    this.avatarUrl,
    required this.requestedAt,
    required this.isIncoming,
    this.onAccept,
    this.onDecline,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final csd = context.csd;

    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: csd.avatarBg,
        backgroundImage:
            avatarUrl != null ? NetworkImage(avatarUrl!) : null,
        child: avatarUrl == null
            ? Text(
                displayName.isNotEmpty
                    ? displayName[0].toUpperCase()
                    : '?',
                style: TextStyle(
                  color: csd.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              )
            : null,
      ),
      title: Text(
        displayName,
        style: theme.textTheme.titleSmall,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        _getSubtitle(),
        style: theme.textTheme.bodySmall,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: isIncoming
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onDecline,
                  tooltip: 'Decline',
                  color: csd.onSurfaceDim,
                ),
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: onAccept,
                  tooltip: 'Accept',
                  color: AppColors.completed,
                ),
              ],
            )
          : TextButton(
              onPressed: onCancel,
              child: const Text('Cancel'),
            ),
    );
  }

  String _getSubtitle() {
    final diff = DateTime.now().difference(requestedAt);
    final timeAgo = diff.inDays > 0
        ? '${diff.inDays}d ago'
        : diff.inHours > 0
            ? '${diff.inHours}h ago'
            : '${diff.inMinutes}m ago';

    return isIncoming ? 'Sent you a request $timeAgo' : 'Pending - $timeAgo';
  }
}
