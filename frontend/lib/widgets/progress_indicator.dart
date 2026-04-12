/// Ctrl+Shift+Date - Progress Indicator Widget
/// Completion progress bar
library;

import 'package:flutter/material.dart';

import '../theme.dart';

/// Linear progress indicator with completion styling
class ProgressIndicator extends StatelessWidget {
  /// Progress value (0.0 to 1.0)
  final double value;

  /// Height of the progress bar
  final double height;

  /// Background color
  final Color? backgroundColor;

  /// Progress color (auto-calculated based on value if not provided)
  final Color? progressColor;

  /// Whether to animate changes
  final bool animated;

  /// Animation duration
  final Duration animationDuration;

  /// Whether to show percentage text
  final bool showLabel;

  const ProgressIndicator({
    super.key,
    required this.value,
    this.height = 8,
    this.backgroundColor,
    this.progressColor,
    this.animated = true,
    this.animationDuration = const Duration(milliseconds: 300),
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final clampedValue = value.clamp(0.0, 1.0);
    final effectiveBackgroundColor = backgroundColor ?? context.csd.borderLight;
    final effectiveProgressColor = progressColor ?? _getProgressColor(clampedValue);

    if (showLabel) {
      return Row(
        children: [
          Expanded(
            child: _buildProgressBar(
              effectiveBackgroundColor,
              effectiveProgressColor,
              clampedValue,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '${(clampedValue * 100).toInt()}%',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return _buildProgressBar(
      effectiveBackgroundColor,
      effectiveProgressColor,
      clampedValue,
    );
  }

  Widget _buildProgressBar(
    Color backgroundColor,
    Color progressColor,
    double value,
  ) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: animated
          ? TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: value),
              duration: animationDuration,
              curve: Curves.easeOut,
              builder: (context, animatedValue, child) {
                return FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: animatedValue,
                  child: Container(
                    decoration: BoxDecoration(
                      color: progressColor,
                      borderRadius: BorderRadius.circular(height / 2),
                    ),
                  ),
                );
              },
            )
          : FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: value,
              child: Container(
                decoration: BoxDecoration(
                  color: progressColor,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
            ),
    );
  }

  Color _getProgressColor(double value) {
    if (value >= 0.8) return AppColors.completed;
    if (value >= 0.5) return AppColors.partial;
    if (value > 0) return AppColors.warning;
    return AppColors.gray400;
  }
}

/// Circular progress indicator with completion styling
class CircularProgressIndicator extends StatelessWidget {
  /// Progress value (0.0 to 1.0)
  final double value;

  /// Size of the indicator
  final double size;

  /// Stroke width
  final double strokeWidth;

  /// Background color
  final Color? backgroundColor;

  /// Progress color
  final Color? progressColor;

  /// Whether to show percentage in center
  final bool showLabel;

  /// Child widget to display in center (overrides label)
  final Widget? child;

  const CircularProgressIndicator({
    super.key,
    required this.value,
    this.size = 48,
    this.strokeWidth = 4,
    this.backgroundColor,
    this.progressColor,
    this.showLabel = false,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final clampedValue = value.clamp(0.0, 1.0);
    final effectiveBackgroundColor = backgroundColor ?? context.csd.borderLight;
    final effectiveProgressColor = progressColor ?? _getProgressColor(clampedValue);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: strokeWidth,
              backgroundColor: Colors.transparent,
              progressColor: effectiveBackgroundColor,
            ),
          ),

          // Progress circle
          SizedBox(
            width: size,
            height: size,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: clampedValue),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
              builder: (context, animatedValue, _) {
                return Transform.rotate(
                  angle: -3.14159 / 2, // Start from top
                  child: CustomPaint(
                    painter: _CircularProgressPainter(
                      progress: animatedValue,
                      color: effectiveProgressColor,
                      strokeWidth: strokeWidth,
                    ),
                  ),
                );
              },
            ),
          ),

          // Center content
          if (child != null)
            child!
          else if (showLabel)
            Text(
              '${(clampedValue * 100).toInt()}%',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }

  Color _getProgressColor(double value) {
    if (value >= 0.8) return AppColors.completed;
    if (value >= 0.5) return AppColors.partial;
    if (value > 0) return AppColors.warning;
    return AppColors.gray400;
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final sweepAngle = 2 * 3.14159 * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

/// Segmented progress indicator showing discrete steps
class SegmentedProgressIndicator extends StatelessWidget {
  /// Total number of segments
  final int total;

  /// Number of completed segments
  final int completed;

  /// Height of each segment
  final double height;

  /// Gap between segments
  final double gap;

  /// Color for completed segments
  final Color? completedColor;

  /// Color for incomplete segments
  final Color? incompleteColor;

  const SegmentedProgressIndicator({
    super.key,
    required this.total,
    required this.completed,
    this.height = 4,
    this.gap = 4,
    this.completedColor,
    this.incompleteColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveCompletedColor = completedColor ?? context.csd.onSurface;
    final effectiveIncompleteColor = incompleteColor ?? context.csd.borderLight;

    return Row(
      children: List.generate(total, (index) {
        final isCompleted = index < completed;
        return Expanded(
          child: Container(
            height: height,
            margin: EdgeInsets.only(left: index > 0 ? gap : 0),
            decoration: BoxDecoration(
              color: isCompleted
                  ? effectiveCompletedColor
                  : effectiveIncompleteColor,
              borderRadius: BorderRadius.circular(height / 2),
            ),
          ),
        );
      }),
    );
  }
}
