/// Ctrl+Shift+Date - Calendar Day Cell Widget
/// Single day cell in month view
library;

import 'package:flutter/material.dart';

import '../theme.dart';

/// Calendar day cell for month view
class CalendarDayCell extends StatelessWidget {
  /// The date this cell represents
  final DateTime date;

  /// Whether this date is in the current month
  final bool isCurrentMonth;

  /// Whether this date is today
  final bool isToday;

  /// Whether this date is selected
  final bool isSelected;

  /// Number of events on this date
  final int eventCount;

  /// Whether any event on this date is locked
  final bool hasLockedEvent;

  /// Highest priority of events on this date (1-4)
  final int? highestPriority;

  /// Callback when cell is tapped
  final VoidCallback? onTap;

  /// Callback when cell is long pressed
  final VoidCallback? onLongPress;

  const CalendarDayCell({
    super.key,
    required this.date,
    this.isCurrentMonth = true,
    this.isToday = false,
    this.isSelected = false,
    this.eventCount = 0,
    this.hasLockedEvent = false,
    this.highestPriority,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final csd = context.csd;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: _getBackgroundColor(context),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: isSelected
              ? Border.all(color: csd.onSurface, width: 2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Day number
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isToday ? csd.onSurface : null,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isToday || isSelected
                      ? FontWeight.w700
                      : FontWeight.w500,
                  color: _getTextColor(context),
                ),
              ),
            ),

            const SizedBox(height: 2),

            // Event indicators
            if (eventCount > 0) _buildEventIndicators(context),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    final csd = context.csd;
    if (isSelected) return csd.surfaceAlt;
    if (!isCurrentMonth) return csd.surfaceAlt.withValues(alpha: 0.5);
    return Colors.transparent;
  }

  Color _getTextColor(BuildContext context) {
    final csd = context.csd;
    if (isToday) return csd.surface;
    if (!isCurrentMonth) return csd.onSurfaceDim;
    if (_isWeekend()) return csd.onSurfaceDim;
    return csd.onSurface;
  }

  bool _isWeekend() {
    return date.weekday == DateTime.saturday ||
        date.weekday == DateTime.sunday;
  }

  Widget _buildEventIndicators(BuildContext context) {
    final csd = context.csd;
    // Show up to 3 dots for events
    final dotCount = eventCount.clamp(0, 3);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Priority color dot
        if (highestPriority != null)
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.getPriorityColor(highestPriority!),
              shape: BoxShape.circle,
            ),
          ),

        // Additional event dots
        if (eventCount > 1)
          ...List.generate(
            (dotCount - 1).clamp(0, 2),
            (index) => Container(
              margin: const EdgeInsets.only(left: 2),
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: isCurrentMonth
                    ? csd.onSurfaceDim
                    : csd.border,
                shape: BoxShape.circle,
              ),
            ),
          ),

        // Lock indicator
        if (hasLockedEvent)
          Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Icon(
              Icons.lock,
              size: 8,
              color: isCurrentMonth
                  ? csd.onSurfaceDim
                  : csd.iconDefault,
            ),
          ),
      ],
    );
  }
}

/// Compact calendar day cell for smaller displays
class CompactCalendarDayCell extends StatelessWidget {
  final DateTime date;
  final bool isCurrentMonth;
  final bool isToday;
  final bool isSelected;
  final bool hasEvents;
  final VoidCallback? onTap;

  const CompactCalendarDayCell({
    super.key,
    required this.date,
    this.isCurrentMonth = true,
    this.isToday = false,
    this.isSelected = false,
    this.hasEvents = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final csd = context.csd;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isToday
              ? csd.onSurface
              : isSelected
                  ? csd.borderLight
                  : null,
          shape: BoxShape.circle,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: isToday || isSelected
                    ? FontWeight.w700
                    : FontWeight.w500,
                color: isToday
                    ? csd.surface
                    : isCurrentMonth
                        ? csd.onSurface
                        : csd.onSurfaceDim,
              ),
            ),
            if (hasEvents)
              Positioned(
                bottom: 4,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isToday ? csd.surface : csd.onSurface,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
