/// Ctrl+Shift+Date - Locked Badge Widget
/// Lock icon for locked events
library;

import 'package:flutter/material.dart';

import '../theme.dart';

/// Badge showing locked status
class LockedBadge extends StatelessWidget {
  /// Whether to show in compact mode (icon only)
  final bool compact;

  /// Custom tooltip message
  final String? tooltip;

  const LockedBadge({
    super.key,
    this.compact = false,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final csd = context.csd;
    final tooltipMessage = tooltip ?? 'Locked - cannot be moved or modified';

    if (compact) {
      return Tooltip(
        message: tooltipMessage,
        child: Icon(
          Icons.lock,
          size: 14,
          color: csd.onSurfaceDim,
        ),
      );
    }

    return Tooltip(
      message: tooltipMessage,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: csd.surfaceAlt,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(color: csd.borderLight),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock,
              size: 12,
              color: csd.onSurfaceDim,
            ),
            const SizedBox(width: 4),
            Text(
              'Locked',
              style: theme.textTheme.labelSmall?.copyWith(
                color: csd.onSurfaceDim,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Lock toggle button for forms
class LockToggle extends StatelessWidget {
  /// Whether the lock is enabled
  final bool isLocked;

  /// Callback when lock state changes
  final ValueChanged<bool>? onChanged;

  /// Whether toggle is enabled
  final bool enabled;

  const LockToggle({
    super.key,
    required this.isLocked,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final csd = context.csd;

    return GestureDetector(
      onTap: enabled ? () => onChanged?.call(!isLocked) : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.5,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isLocked ? csd.borderLight : csd.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: isLocked ? csd.iconDefault : csd.borderLight,
              width: isLocked ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isLocked
                      ? csd.iconDefault.withValues(alpha: 0.2)
                      : csd.surfaceAlt,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  isLocked ? Icons.lock : Icons.lock_open,
                  size: 20,
                  color: isLocked ? csd.iconDefault : csd.iconDefault,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isLocked ? 'Event Locked' : 'Lock Event',
                      style: theme.textTheme.titleSmall,
                    ),
                    Text(
                      isLocked
                          ? 'AI cannot reschedule this event'
                          : 'Tap to prevent AI from moving this event',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: csd.onSurfaceDim,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isLocked,
                onChanged: enabled ? onChanged : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Lock status indicator for list items
class LockStatusIndicator extends StatelessWidget {
  final bool isLocked;

  const LockStatusIndicator({
    super.key,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLocked) return const SizedBox.shrink();

    final csd = context.csd;
    return Tooltip(
      message: 'Locked event',
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: csd.surfaceAlt,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          Icons.lock,
          size: 12,
          color: csd.onSurfaceDim,
        ),
      ),
    );
  }
}

/// Inline locked indicator for event titles
class InlineLockIndicator extends StatelessWidget {
  final bool isLocked;
  final double size;

  const InlineLockIndicator({
    super.key,
    required this.isLocked,
    this.size = 14,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLocked) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Icon(
        Icons.lock,
        size: size,
        color: context.csd.iconDefault,
      ),
    );
  }
}
