/// Ctrl+Shift+Date - Streak Badge Widget
/// Streak count display
library;

import 'package:flutter/material.dart';

import '../theme.dart';

/// Badge showing current streak count
class StreakBadge extends StatelessWidget {
  /// Current streak count
  final int count;

  /// Whether to show in compact mode
  final bool compact;

  /// Callback when badge is tapped
  final VoidCallback? onTap;

  const StreakBadge({
    super.key,
    required this.count,
    this.compact = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompact(context);
    }
    return _buildFull(context);
  }

  Widget _buildFull(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: _getBackgroundColor(context),
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(
            color: _getBorderColor(context),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIcon(),
              size: 16,
              color: _getIconColor(context),
            ),
            const SizedBox(width: 4),
            Text(
              '$count',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: _getTextColor(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompact(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          _getIcon(),
          size: 14,
          color: _getIconColor(context),
        ),
        const SizedBox(width: 2),
        Text(
          '$count',
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: _getTextColor(context),
          ),
        ),
      ],
    );
  }

  IconData _getIcon() {
    if (count == 0) return Icons.local_fire_department_outlined;
    if (count >= 30) return Icons.whatshot;
    return Icons.local_fire_department;
  }

  Color _getBackgroundColor(BuildContext context) {
    final csd = context.csd;
    if (count == 0) return csd.surfaceAlt;
    if (count >= 30) return AppColors.warning.withValues(alpha: 0.15);
    if (count >= 7) return AppColors.completed.withValues(alpha: 0.1);
    return csd.surfaceAlt;
  }

  Color _getBorderColor(BuildContext context) {
    final csd = context.csd;
    if (count == 0) return csd.borderLight;
    if (count >= 30) return AppColors.warning.withValues(alpha: 0.3);
    if (count >= 7) return AppColors.completed.withValues(alpha: 0.3);
    return csd.borderLight;
  }

  Color _getIconColor(BuildContext context) {
    final csd = context.csd;
    if (count == 0) return csd.iconDefault;
    if (count >= 30) return AppColors.warning;
    if (count >= 7) return AppColors.completed;
    return csd.onSurfaceDim;
  }

  Color _getTextColor(BuildContext context) {
    final csd = context.csd;
    if (count == 0) return csd.onSurfaceDim;
    return csd.onSurface;
  }
}

/// Large streak display for celebration/summary views
class StreakDisplay extends StatelessWidget {
  /// Current streak count
  final int currentStreak;

  /// Longest streak count
  final int longestStreak;

  /// Whether the streak is active today
  final bool isActiveToday;

  const StreakDisplay({
    super.key,
    required this.currentStreak,
    required this.longestStreak,
    this.isActiveToday = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final csd = context.csd;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: csd.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          // Streak icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: _getStreakColor(context).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              currentStreak >= 30
                  ? Icons.whatshot
                  : Icons.local_fire_department,
              size: 32,
              color: _getStreakColor(context),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Current streak
          Text(
            '$currentStreak',
            style: theme.textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: csd.onSurface,
            ),
          ),
          Text(
            currentStreak == 1 ? 'day streak' : 'day streak',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: csd.onSurfaceDim,
            ),
          ),

          // Active today indicator
          if (isActiveToday) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.completed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 14,
                    color: AppColors.completed,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Completed today',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.completed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.lg),
          const Divider(),
          const SizedBox(height: AppSpacing.md),

          // Longest streak
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.emoji_events,
                size: 20,
                color: csd.onSurfaceDim,
              ),
              const SizedBox(width: 8),
              Text(
                'Longest streak: ',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: csd.onSurfaceDim,
                ),
              ),
              Text(
                '$longestStreak days',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStreakColor(BuildContext context) {
    final csd = context.csd;
    if (currentStreak == 0) return csd.iconDefault;
    if (currentStreak >= 30) return AppColors.warning;
    if (currentStreak >= 7) return AppColors.completed;
    return csd.onSurfaceDim;
  }
}

/// Streak milestone celebration widget
class StreakMilestone extends StatelessWidget {
  final int milestone;
  final bool achieved;

  const StreakMilestone({
    super.key,
    required this.milestone,
    required this.achieved,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final csd = context.csd;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: achieved
            ? AppColors.completed.withValues(alpha: 0.1)
            : csd.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: achieved
              ? AppColors.completed.withValues(alpha: 0.3)
              : csd.borderLight,
        ),
      ),
      child: Column(
        children: [
          Icon(
            achieved ? Icons.check_circle : Icons.circle_outlined,
            size: 24,
            color: achieved ? AppColors.completed : csd.iconDefault,
          ),
          const SizedBox(height: 4),
          Text(
            '$milestone',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: achieved ? csd.onSurface : csd.onSurfaceDim,
            ),
          ),
          Text(
            'days',
            style: theme.textTheme.labelSmall?.copyWith(
              color: achieved ? csd.onSurfaceDim : csd.iconDefault,
            ),
          ),
        ],
      ),
    );
  }
}
