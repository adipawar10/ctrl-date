/// Ctrl+Shift+Date - Priority Indicator Widget
/// Colored priority dot
library;

import 'package:flutter/material.dart';

import '../theme.dart';

/// Priority indicator showing colored dot and optional label
class PriorityIndicator extends StatelessWidget {
  /// Priority level (1=low, 2=medium, 3=high, 4=critical)
  final int priority;

  /// Whether to show the label text
  final bool showLabel;

  /// Size of the indicator dot
  final double size;

  const PriorityIndicator({
    super.key,
    required this.priority,
    this.showLabel = false,
    this.size = 8,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = AppColors.getPriorityColor(priority);
    final label = _getLabel();

    if (!showLabel) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _getLabel() {
    switch (priority) {
      case 1:
        return 'Low';
      case 2:
        return 'Medium';
      case 3:
        return 'High';
      case 4:
        return 'Critical';
      default:
        return 'Medium';
    }
  }
}

/// Priority selector for forms
class PrioritySelector extends StatelessWidget {
  /// Currently selected priority
  final int selectedPriority;

  /// Callback when priority changes
  final ValueChanged<int>? onChanged;

  /// Whether selector is enabled
  final bool enabled;

  const PrioritySelector({
    super.key,
    required this.selectedPriority,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [1, 2, 3, 4].map((priority) {
        return _PriorityOption(
          priority: priority,
          isSelected: selectedPriority == priority,
          enabled: enabled,
          onTap: () => onChanged?.call(priority),
        );
      }).toList(),
    );
  }
}

class _PriorityOption extends StatelessWidget {
  final int priority;
  final bool isSelected;
  final bool enabled;
  final VoidCallback? onTap;

  const _PriorityOption({
    required this.priority,
    required this.isSelected,
    required this.enabled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = AppColors.getPriorityColor(priority);
    final label = _getLabel();

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(
              color: isSelected ? color : AppColors.gray200,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isSelected ? color : AppColors.gray600,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLabel() {
    switch (priority) {
      case 1:
        return 'Low';
      case 2:
        return 'Med';
      case 3:
        return 'High';
      case 4:
        return 'Crit';
      default:
        return 'Med';
    }
  }
}

/// Priority badge chip
class PriorityBadge extends StatelessWidget {
  final int priority;
  final bool compact;

  const PriorityBadge({
    super.key,
    required this.priority,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = AppColors.getPriorityColor(priority);
    final label = _getLabel();

    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      );
    }

    return Chip(
      avatar: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      label: Text(label),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide.none,
      labelStyle: theme.textTheme.labelSmall?.copyWith(
        color: color,
        fontWeight: FontWeight.w600,
      ),
      visualDensity: VisualDensity.compact,
    );
  }

  String _getLabel() {
    switch (priority) {
      case 1:
        return 'Low';
      case 2:
        return 'Medium';
      case 3:
        return 'High';
      case 4:
        return 'Critical';
      default:
        return 'Medium';
    }
  }
}
