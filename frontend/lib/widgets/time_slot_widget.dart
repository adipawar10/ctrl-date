/// Ctrl+Shift+Date - Time Slot Widget
/// Hour slot in day/week view
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme.dart';

/// Time slot widget for day and week views
class TimeSlotWidget extends StatelessWidget {
  /// The hour this slot represents (0-23)
  final int hour;

  /// Height of the slot
  final double height;

  /// Whether this slot is during working hours
  final bool isWorkingHour;

  /// Whether this is the current hour
  final bool isCurrentHour;

  /// Callback when slot is tapped
  final VoidCallback? onTap;

  /// Callback when slot is long pressed
  final VoidCallback? onLongPress;

  const TimeSlotWidget({
    super.key,
    required this.hour,
    this.height = 60,
    this.isWorkingHour = true,
    this.isCurrentHour = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeString = DateFormat('HH:00').format(DateTime(2000, 1, 1, hour));

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outlineVariant,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time label
            SizedBox(
              width: 56,
              child: Padding(
                padding: const EdgeInsets.only(top: 0, right: 8),
                child: Text(
                  timeString,
                  textAlign: TextAlign.right,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isCurrentHour
                        ? AppColors.black
                        : AppColors.gray500,
                    fontWeight:
                        isCurrentHour ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),

            // Slot area
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (isCurrentHour) {
      return AppColors.gray100;
    }
    if (!isWorkingHour) {
      return AppColors.gray100.withValues(alpha: 0.5);
    }
    return Colors.transparent;
  }
}

/// Half-hour time slot for more granular views
class HalfHourSlotWidget extends StatelessWidget {
  /// The hour this slot represents (0-23)
  final int hour;

  /// Whether this is the first half (0-29 min) or second half (30-59 min)
  final bool isFirstHalf;

  /// Height of the slot
  final double height;

  /// Whether this slot is during working hours
  final bool isWorkingHour;

  /// Callback when slot is tapped
  final VoidCallback? onTap;

  const HalfHourSlotWidget({
    super.key,
    required this.hour,
    required this.isFirstHalf,
    this.height = 30,
    this.isWorkingHour = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final minute = isFirstHalf ? 0 : 30;
    final timeString =
        DateFormat('HH:mm').format(DateTime(2000, 1, 1, hour, minute));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: isWorkingHour ? Colors.transparent : AppColors.gray100.withValues(alpha: 0.5),
          border: Border(
            top: BorderSide(
              color: isFirstHalf
                  ? theme.colorScheme.outlineVariant
                  : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              width: isFirstHalf ? 0.5 : 0.25,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time label (only show for first half)
            SizedBox(
              width: 56,
              child: isFirstHalf
                  ? Padding(
                      padding: const EdgeInsets.only(top: 0, right: 8),
                      child: Text(
                        timeString,
                        textAlign: TextAlign.right,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.gray500,
                        ),
                      ),
                    )
                  : null,
            ),

            // Slot area
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Time slot with drag-to-create functionality
class DraggableTimeSlot extends StatefulWidget {
  final int hour;
  final double height;
  final bool isWorkingHour;
  final void Function(int startHour, int endHour)? onCreateEvent;

  const DraggableTimeSlot({
    super.key,
    required this.hour,
    this.height = 60,
    this.isWorkingHour = true,
    this.onCreateEvent,
  });

  @override
  State<DraggableTimeSlot> createState() => _DraggableTimeSlotState();
}

class _DraggableTimeSlotState extends State<DraggableTimeSlot> {
  bool _isDragging = false;
  double _dragStart = 0;
  double _dragEnd = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeString =
        DateFormat('HH:00').format(DateTime(2000, 1, 1, widget.hour));

    return GestureDetector(
      onVerticalDragStart: _handleDragStart,
      onVerticalDragUpdate: _handleDragUpdate,
      onVerticalDragEnd: _handleDragEnd,
      onTap: () {
        widget.onCreateEvent?.call(widget.hour, widget.hour + 1);
      },
      child: Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: _isDragging
              ? AppColors.black.withValues(alpha: 0.05)
              : widget.isWorkingHour
                  ? Colors.transparent
                  : AppColors.gray100.withValues(alpha: 0.5),
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outlineVariant,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 56,
              child: Padding(
                padding: const EdgeInsets.only(top: 0, right: 8),
                child: Text(
                  timeString,
                  textAlign: TextAlign.right,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.gray500,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleDragStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
      _dragStart = details.localPosition.dy;
      _dragEnd = _dragStart;
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragEnd = details.localPosition.dy;
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    final startHour = widget.hour;
    final duration = ((_dragEnd - _dragStart) / widget.height).ceil().abs();
    final endHour = startHour + duration.clamp(1, 4);

    widget.onCreateEvent?.call(startHour, endHour);

    setState(() {
      _isDragging = false;
    });
  }
}
