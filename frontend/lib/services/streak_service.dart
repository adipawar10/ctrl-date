/// Ctrl+Shift+Date - Streak Service
/// Calculates completion rates and productivity streaks
library;

import '../models/event.dart';
import '../models/reflection.dart';

/// Service for calculating streaks and completion metrics
class StreakService {
  StreakService._();

  /// Calculate the daily completion rate for a given date
  /// Returns a value between 0.0 and 1.0
  ///
  /// Events are weighted by their completion status:
  /// - completed: 1.0
  /// - partial: 0.5
  /// - skipped/cancelled: 0.0
  static double calculateDailyCompletionRate(
    DateTime date,
    List<Map<String, dynamic>> events,
  ) {
    if (events.isEmpty) return 0.0;

    double totalScore = 0.0;
    int countableEvents = 0;

    for (final event in events) {
      final status = event['status'] as String?;
      if (status == null) continue;

      countableEvents++;

      switch (status) {
        case 'completed':
          totalScore += 1.0;
          break;
        case 'partial':
          totalScore += 0.5;
          break;
        case 'skipped':
        case 'cancelled':
        case 'pending':
        default:
          totalScore += 0.0;
          break;
      }
    }

    if (countableEvents == 0) return 0.0;
    return totalScore / countableEvents;
  }

  /// Calculate the daily completion rate using Event models
  static double calculateDailyCompletionRateFromEvents(
    DateTime date,
    List<Event> events,
  ) {
    if (events.isEmpty) return 0.0;

    double totalScore = 0.0;
    int countableEvents = 0;

    for (final event in events) {
      countableEvents++;

      switch (event.status) {
        case EventStatus.completed:
          totalScore += 1.0;
          break;
        case EventStatus.inProgress:
          totalScore += 0.5;
          break;
        case EventStatus.partial:
          totalScore += 0.75;
          break;
        case EventStatus.cancelled:
        case EventStatus.draft:
        case EventStatus.scheduled:
        case EventStatus.skipped:
          totalScore += 0.0;
          break;
      }
    }

    if (countableEvents == 0) return 0.0;
    return totalScore / countableEvents;
  }

  /// Calculate productivity streak - consecutive days with 100% completion
  /// Returns the number of consecutive days ending today (or most recent)
  /// where all events were completed
  static int calculateProductivityStreak(
    List<DailyReflection> reflections,
    List<Map<String, dynamic>> Function(DateTime date) getEventsForDate,
  ) {
    if (reflections.isEmpty) return 0;

    // Sort reflections by date descending (most recent first)
    final sortedReflections = List<DailyReflection>.from(reflections)
      ..sort((a, b) => b.date.compareTo(a.date));

    int streak = 0;
    DateTime? expectedDate;

    for (final reflection in sortedReflections) {
      final events = getEventsForDate(reflection.date);
      final completionRate = calculateDailyCompletionRate(reflection.date, events);

      // Check if this is a consecutive day
      if (expectedDate != null) {
        final dayDifference = expectedDate.difference(reflection.date).inDays;
        if (dayDifference != 1) {
          // Gap in streak
          break;
        }
      }

      // Check if 100% completion
      if (completionRate >= 1.0) {
        streak++;
        expectedDate = reflection.date;
      } else {
        // Streak broken
        break;
      }
    }

    return streak;
  }

  /// Calculate productivity streak from a list of completion rates by date
  /// More efficient when you already have computed rates
  static int calculateProductivityStreakFromRates(
    Map<DateTime, double> completionRatesByDate,
  ) {
    if (completionRatesByDate.isEmpty) return 0;

    // Sort dates descending
    final sortedDates = completionRatesByDate.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    int streak = 0;
    DateTime? expectedDate;

    for (final date in sortedDates) {
      final rate = completionRatesByDate[date] ?? 0.0;

      // Check for consecutive days
      if (expectedDate != null) {
        final normalizedExpected = DateTime(
          expectedDate.year,
          expectedDate.month,
          expectedDate.day,
        );
        final normalizedCurrent = DateTime(date.year, date.month, date.day);
        final dayDifference =
            normalizedExpected.difference(normalizedCurrent).inDays;

        if (dayDifference != 1) break;
      }

      if (rate >= 1.0) {
        streak++;
        expectedDate = date;
      } else {
        break;
      }
    }

    return streak;
  }

  /// Calculate procrastination streak - consecutive days with less than 50% completion
  /// This helps identify patterns that need attention
  static int calculateProcrastinationStreak(
    List<DailyReflection> reflections,
    List<Map<String, dynamic>> Function(DateTime date) getEventsForDate,
  ) {
    if (reflections.isEmpty) return 0;

    // Sort reflections by date descending (most recent first)
    final sortedReflections = List<DailyReflection>.from(reflections)
      ..sort((a, b) => b.date.compareTo(a.date));

    int streak = 0;
    DateTime? expectedDate;

    for (final reflection in sortedReflections) {
      final events = getEventsForDate(reflection.date);
      if (events.isEmpty) continue;

      final completionRate = calculateDailyCompletionRate(reflection.date, events);

      // Check if this is a consecutive day
      if (expectedDate != null) {
        final dayDifference = expectedDate.difference(reflection.date).inDays;
        if (dayDifference != 1) {
          // Gap in streak
          break;
        }
      }

      // Check if below 50% completion
      if (completionRate < 0.5) {
        streak++;
        expectedDate = reflection.date;
      } else {
        // Not a procrastination day
        break;
      }
    }

    return streak;
  }

  /// Calculate procrastination streak from completion rates
  static int calculateProcrastinationStreakFromRates(
    Map<DateTime, double> completionRatesByDate,
  ) {
    if (completionRatesByDate.isEmpty) return 0;

    // Sort dates descending
    final sortedDates = completionRatesByDate.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    int streak = 0;
    DateTime? expectedDate;

    for (final date in sortedDates) {
      final rate = completionRatesByDate[date] ?? 0.0;

      // Check for consecutive days
      if (expectedDate != null) {
        final normalizedExpected = DateTime(
          expectedDate.year,
          expectedDate.month,
          expectedDate.day,
        );
        final normalizedCurrent = DateTime(date.year, date.month, date.day);
        final dayDifference =
            normalizedExpected.difference(normalizedCurrent).inDays;

        if (dayDifference != 1) break;
      }

      if (rate < 0.5) {
        streak++;
        expectedDate = date;
      } else {
        break;
      }
    }

    return streak;
  }

  /// Get supportive message based on completion rate
  /// Messages are encouraging and never punitive
  static String getSupportiveMessage(double completionRate) {
    if (completionRate >= 1.0) {
      return "Great work today! You completed everything you planned.";
    } else if (completionRate >= 0.7) {
      return "Good progress! Most of your goals were achieved.";
    } else if (completionRate >= 0.5) {
      return "You made it halfway. Tomorrow is a new opportunity.";
    } else {
      return "Some days are harder than others. Be kind to yourself.";
    }
  }

  /// Get streak message based on current streak count
  static String getStreakMessage(int streak) {
    if (streak == 0) {
      return "Start building your streak today!";
    } else if (streak == 1) {
      return "Great start! Keep it going tomorrow.";
    } else if (streak < 7) {
      return "$streak days strong! Building momentum.";
    } else if (streak < 30) {
      return "$streak day streak! You're on fire!";
    } else if (streak < 100) {
      return "Incredible $streak day streak! True dedication.";
    } else {
      return "Legendary $streak day streak! Unstoppable!";
    }
  }
}
