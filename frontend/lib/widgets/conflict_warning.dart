/// Ctrl+Shift+Date - Conflict Warning Widget
/// Conflict indicator for scheduling conflicts
library;

import 'package:flutter/material.dart';

import '../theme.dart';

/// Warning banner for scheduling conflicts
class ConflictWarning extends StatelessWidget {
  /// Warning message
  final String? message;

  /// List of conflicting event titles
  final List<String>? conflictingEvents;

  /// Callback when warning is tapped
  final VoidCallback? onTap;

  /// Callback when warning is dismissed
  final VoidCallback? onDismiss;

  const ConflictWarning({
    super.key,
    this.message,
    this.conflictingEvents,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.warning.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: AppColors.warning.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 20,
              color: AppColors.warning,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scheduling Conflict',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: AppColors.warning,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message ?? 'This event overlaps with existing events.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.gray700,
                    ),
                  ),
                  if (conflictingEvents != null &&
                      conflictingEvents!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: conflictingEvents!.map((event) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Text(
                            event,
                            style: theme.textTheme.labelSmall,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
            if (onDismiss != null)
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: onDismiss,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                ),
                color: AppColors.gray500,
              ),
          ],
        ),
      ),
    );
  }
}

/// Compact conflict indicator for list items
class ConflictIndicator extends StatelessWidget {
  /// Number of conflicts
  final int conflictCount;

  /// Callback when indicator is tapped
  final VoidCallback? onTap;

  const ConflictIndicator({
    super.key,
    required this.conflictCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (conflictCount == 0) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onTap,
      child: Tooltip(
        message: '$conflictCount conflict${conflictCount > 1 ? 's' : ''}',
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 12,
                color: AppColors.warning,
              ),
              if (conflictCount > 1) ...[
                const SizedBox(width: 2),
                Text(
                  '$conflictCount',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.warning,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Conflict resolution dialog
class ConflictResolutionSheet extends StatelessWidget {
  /// List of conflicting events
  final List<Map<String, dynamic>> conflicts;

  /// Callback when a resolution is selected
  final void Function(String action, String? eventId)? onResolve;

  const ConflictResolutionSheet({
    super.key,
    required this.conflicts,
    this.onResolve,
  });

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
                Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.warning,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Resolve Conflicts',
                  style: theme.textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'This event conflicts with ${conflicts.length} existing event${conflicts.length > 1 ? 's' : ''}:',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),

            // Conflict list
            ...conflicts.map((conflict) => _buildConflictItem(context, conflict)),

            const SizedBox(height: AppSpacing.lg),
            const Divider(),
            const SizedBox(height: AppSpacing.md),

            // Resolution options
            Text(
              'Resolution Options',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: AppSpacing.sm),

            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Keep both'),
              subtitle: const Text('Allow overlapping events'),
              onTap: () => onResolve?.call('keep_both', null),
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: const Text('Find alternative time'),
              subtitle: const Text('Let AI suggest a better time'),
              onTap: () => onResolve?.call('find_alternative', null),
            ),
            ListTile(
              leading: Icon(Icons.cancel, color: AppColors.error),
              title: Text(
                'Cancel new event',
                style: TextStyle(color: AppColors.error),
              ),
              onTap: () => onResolve?.call('cancel', null),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConflictItem(BuildContext context, Map<String, dynamic> conflict) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.getPriorityColor(conflict['priority'] ?? 2),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  conflict['title'] ?? 'Untitled Event',
                  style: theme.textTheme.titleSmall,
                ),
                Text(
                  conflict['time'] ?? '',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if (conflict['is_locked'] == true)
            Icon(
              Icons.lock,
              size: 14,
              color: AppColors.gray500,
            ),
        ],
      ),
    );
  }
}

/// Inline conflict warning for time pickers
class InlineConflictWarning extends StatelessWidget {
  final bool hasConflict;
  final String? message;

  const InlineConflictWarning({
    super.key,
    required this.hasConflict,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasConflict) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 14,
            color: AppColors.warning,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              message ?? 'Conflicts with existing event',
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
