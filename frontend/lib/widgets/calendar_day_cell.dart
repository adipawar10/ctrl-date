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

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: isSelected
              ? Border.all(color: AppColors.black, width: 2)
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
                color: isToday ? AppColors.black : null,
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
                  color: _getTextColor(),
                ),
              ),
            ),

            const SizedBox(height: 2),

            // Event indicators
            if (eventCount > 0) _buildEventIndicators(),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (isSelected) return AppColors.gray100;
    if (!isCurrentMonth) return AppColors.gray100.withValues(alpha: 0.5);
    return Colors.transparent;
  }

  Color _getTextColor() {
    if (isToday) return AppColors.white;
    if (!isCurrentMonth) return AppColors.gray400;
    if (_isWeekend()) return AppColors.gray500;
    return AppColors.black;
  }

  bool _isWeekend() {
    return date.weekday == DateTime.saturday ||
        date.weekday == DateTime.sunday;
  }

  Widget _buildEventIndicators() {
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
                    ? AppColors.gray400
                    : AppColors.gray300,
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
                  ? AppColors.gray500
                  : AppColors.gray400,
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isToday
              ? AppColors.black
              : isSelected
                  ? AppColors.gray200
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
                    ? AppColors.white
                    : isCurrentMonth
                        ? AppColors.black
                        : AppColors.gray400,
              ),
            ),
            if (hasEvents)
              Positioned(
                bottom: 4,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isToday ? AppColors.white : AppColors.black,
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
