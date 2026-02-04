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
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(
            color: _getBorderColor(),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIcon(),
              size: 16,
              color: _getIconColor(),
            ),
            const SizedBox(width: 4),
            Text(
              '$count',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: _getTextColor(),
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
          color: _getIconColor(),
        ),
        const SizedBox(width: 2),
        Text(
          '$count',
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: _getTextColor(),
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

  Color _getBackgroundColor() {
    if (count == 0) return AppColors.gray100;
    if (count >= 30) return AppColors.warning.withValues(alpha: 0.15);
    if (count >= 7) return AppColors.completed.withValues(alpha: 0.1);
    return AppColors.gray100;
  }

  Color _getBorderColor() {
    if (count == 0) return AppColors.gray200;
    if (count >= 30) return AppColors.warning.withValues(alpha: 0.3);
    if (count >= 7) return AppColors.completed.withValues(alpha: 0.3);
    return AppColors.gray200;
  }

  Color _getIconColor() {
    if (count == 0) return AppColors.gray400;
    if (count >= 30) return AppColors.warning;
    if (count >= 7) return AppColors.completed;
    return AppColors.gray600;
  }

  Color _getTextColor() {
    if (count == 0) return AppColors.gray500;
    return AppColors.black;
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

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          // Streak icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: _getStreakColor().withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              currentStreak >= 30
                  ? Icons.whatshot
                  : Icons.local_fire_department,
              size: 32,
              color: _getStreakColor(),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Current streak
          Text(
            '$currentStreak',
            style: theme.textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          Text(
            currentStreak == 1 ? 'day streak' : 'day streak',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.gray600,
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
                color: AppColors.gray500,
              ),
              const SizedBox(width: 8),
              Text(
                'Longest streak: ',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.gray600,
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

  Color _getStreakColor() {
    if (currentStreak == 0) return AppColors.gray400;
    if (currentStreak >= 30) return AppColors.warning;
    if (currentStreak >= 7) return AppColors.completed;
    return AppColors.gray600;
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

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: achieved
            ? AppColors.completed.withValues(alpha: 0.1)
            : AppColors.gray100,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: achieved
              ? AppColors.completed.withValues(alpha: 0.3)
              : AppColors.gray200,
        ),
      ),
      child: Column(
        children: [
          Icon(
            achieved ? Icons.check_circle : Icons.circle_outlined,
            size: 24,
            color: achieved ? AppColors.completed : AppColors.gray400,
          ),
          const SizedBox(height: 4),
          Text(
            '$milestone',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: achieved ? AppColors.black : AppColors.gray500,
            ),
          ),
          Text(
            'days',
            style: theme.textTheme.labelSmall?.copyWith(
              color: achieved ? AppColors.gray600 : AppColors.gray400,
            ),
          ),
        ],
      ),
    );
  }
}
