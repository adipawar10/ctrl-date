/// Ctrl+Shift+Date - Event Card Widget
/// Event display card with black/white design
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme.dart';
import 'priority_indicator.dart';
import 'locked_badge.dart';

/// Event card widget for displaying event information
class EventCard extends StatelessWidget {
  /// Event ID
  final String id;

  /// Event title
  final String title;

  /// Start time
  final DateTime startTime;

  /// End time
  final DateTime endTime;

  /// Whether the event is locked
  final bool isLocked;

  /// Priority level (1-4)
  final int priority;

  /// Event status (scheduled, completed, partial, skipped, cancelled)
  final String status;

  /// Description (optional)
  final String? description;

  /// Location (optional)
  final String? location;

  /// Whether to show in compact mode
  final bool compact;

  /// Callback when card is tapped
  final VoidCallback? onTap;

  /// Callback when event is marked complete
  final VoidCallback? onComplete;

  const EventCard({
    super.key,
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    this.isLocked = false,
    this.priority = 2,
    this.status = 'scheduled',
    this.description,
    this.location,
    this.compact = false,
    this.onTap,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompactCard(context);
    }
    return _buildFullCard(context);
  }

  Widget _buildFullCard(BuildContext context) {
    final theme = Theme.of(context);
    final csd = context.csd;
    final isCompleted = status == 'completed';
    final isSkipped = status == 'skipped';
    final isPartial = status == 'partial';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: _getBackgroundColor(context),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: _getBorderColor(context),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Completion checkbox
                if (status == 'scheduled' && onComplete != null)
                  GestureDetector(
                    onTap: onComplete,
                    child: Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.only(right: AppSpacing.sm),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: csd.iconDefault,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.xs),
                      ),
                    ),
                  )
                else if (isCompleted || isPartial || isSkipped)
                  Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.only(right: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: _getStatusColor(),
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                    ),
                    child: Icon(
                      _getStatusIcon(),
                      size: 16,
                      color: csd.surface,
                    ),
                  ),

                // Title and metadata
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                decoration: isCompleted || isSkipped
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: isCompleted || isSkipped
                                    ? csd.onSurfaceDim
                                    : csd.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isLocked) ...[
                            const SizedBox(width: AppSpacing.xs),
                            const LockedBadge(compact: true),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          PriorityIndicator(priority: priority),
                          const SizedBox(width: AppSpacing.sm),
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: csd.onSurfaceDim,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${DateFormat('HH:mm').format(startTime)} - ${DateFormat('HH:mm').format(endTime)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: csd.onSurfaceDim,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Location (if present)
            if (location != null && location!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: csd.onSurfaceDim,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      location!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: csd.onSurfaceDim,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],

            // Description preview (if present)
            if (description != null && description!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                description!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: csd.onSurfaceDim,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCompactCard(BuildContext context) {
    final theme = Theme.of(context);
    final csd = context.csd;
    final isCompleted = status == 'completed';
    final isSkipped = status == 'skipped';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: _getBackgroundColor(context),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: _getBorderColor(context)),
        ),
        child: Row(
          children: [
            // Priority dot
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.getPriorityColor(priority),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),

            // Lock icon
            if (isLocked) ...[
              Icon(
                Icons.lock,
                size: 12,
                color: csd.onSurfaceDim,
              ),
              const SizedBox(width: AppSpacing.xs),
            ],

            // Title
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.labelMedium?.copyWith(
                  decoration: isCompleted || isSkipped
                      ? TextDecoration.lineThrough
                      : null,
                  color: isCompleted || isSkipped
                      ? csd.onSurfaceDim
                      : csd.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Status icon
            if (isCompleted || isSkipped)
              Icon(
                _getStatusIcon(),
                size: 14,
                color: _getStatusColor(),
              ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    final csd = context.csd;
    switch (status) {
      case 'completed':
        return AppColors.completed.withValues(alpha: 0.05);
      case 'partial':
        return AppColors.partial.withValues(alpha: 0.05);
      case 'skipped':
        return csd.surfaceAlt;
      case 'cancelled':
        return AppColors.error.withValues(alpha: 0.05);
      default:
        return csd.surface;
    }
  }

  Color _getBorderColor(BuildContext context) {
    final csd = context.csd;
    switch (status) {
      case 'completed':
        return AppColors.completed.withValues(alpha: 0.3);
      case 'partial':
        return AppColors.partial.withValues(alpha: 0.3);
      case 'skipped':
        return csd.border;
      case 'cancelled':
        return AppColors.error.withValues(alpha: 0.3);
      default:
        return csd.borderLight;
    }
  }

  Color _getStatusColor() {
    switch (status) {
      case 'completed':
        return AppColors.completed;
      case 'partial':
        return AppColors.partial;
      case 'skipped':
        return AppColors.skipped;
      case 'cancelled':
        return AppColors.cancelled;
      default:
        return AppColors.gray500;
    }
  }

  IconData _getStatusIcon() {
    switch (status) {
      case 'completed':
        return Icons.check;
      case 'partial':
        return Icons.timelapse;
      case 'skipped':
        return Icons.skip_next;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.schedule;
    }
  }
}
