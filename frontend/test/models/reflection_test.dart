import 'package:flutter_test/flutter_test.dart';
import 'package:ctrl_shift_date/models/reflection.dart';

void main() {
  group('MoodRating', () {
    test('all 5 ratings defined', () {
      expect(MoodRating.values.length, 5);
    });

    test('values are 1-5', () {
      expect(MoodRating.veryBad.value, 1);
      expect(MoodRating.bad.value, 2);
      expect(MoodRating.neutral.value, 3);
      expect(MoodRating.good.value, 4);
      expect(MoodRating.veryGood.value, 5);
    });

    test('labels are human-readable', () {
      expect(MoodRating.veryGood.label, 'Very Good');
      expect(MoodRating.neutral.label, 'Neutral');
    });
  });

  group('EnergyLevel', () {
    test('all 5 levels defined', () {
      expect(EnergyLevel.values.length, 5);
    });

    test('values are 1-5', () {
      expect(EnergyLevel.exhausted.value, 1);
      expect(EnergyLevel.veryEnergized.value, 5);
    });
  });

  group('ProductivityRating', () {
    test('all 5 levels defined', () {
      expect(ProductivityRating.values.length, 5);
    });

    test('values are 1-5', () {
      expect(ProductivityRating.veryLow.value, 1);
      expect(ProductivityRating.veryHigh.value, 5);
    });
  });

  group('DailyReflection model', () {
    test('hasMinimumData with mood', () {
      final r = DailyReflection(
        id: 'r-1',
        userId: 'u-1',
        date: DateTime(2026, 3, 31),
        mood: MoodRating.good,
      );
      expect(r.hasMinimumData, isTrue);
    });

    test('hasMinimumData with gratitude', () {
      final r = DailyReflection(
        id: 'r-1',
        userId: 'u-1',
        date: DateTime(2026, 3, 31),
        gratitude: 'Thankful for sunshine',
      );
      expect(r.hasMinimumData, isTrue);
    });

    test('hasMinimumData returns false when empty', () {
      final r = DailyReflection(
        id: 'r-1',
        userId: 'u-1',
        date: DateTime(2026, 3, 31),
      );
      expect(r.hasMinimumData, isFalse);
    });

    test('overallScore averages mood, energy, productivity', () {
      final r = DailyReflection(
        id: 'r-1',
        userId: 'u-1',
        date: DateTime(2026, 3, 31),
        mood: MoodRating.good, // 4
        energy: EnergyLevel.energized, // 4
        productivity: ProductivityRating.high, // 4
      );
      expect(r.overallScore, 4.0);
    });

    test('overallScore handles partial data', () {
      final r = DailyReflection(
        id: 'r-1',
        userId: 'u-1',
        date: DateTime(2026, 3, 31),
        mood: MoodRating.veryGood, // 5
        energy: EnergyLevel.moderate, // 3
      );
      expect(r.overallScore, 4.0);
    });

    test('overallScore returns null when all empty', () {
      final r = DailyReflection(
        id: 'r-1',
        userId: 'u-1',
        date: DateTime(2026, 3, 31),
      );
      expect(r.overallScore, isNull);
    });

    test('isToday for today date', () {
      final today = DateTime.now();
      final r = DailyReflection(
        id: 'r-1',
        userId: 'u-1',
        date: today,
      );
      expect(r.isToday, isTrue);
    });

    test('isToday returns false for yesterday', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final r = DailyReflection(
        id: 'r-1',
        userId: 'u-1',
        date: yesterday,
      );
      expect(r.isToday, isFalse);
    });

    test('defaults are correct', () {
      final r = DailyReflection(
        id: 'r-1',
        userId: 'u-1',
        date: DateTime(2026, 3, 31),
      );
      expect(r.isPrivate, isFalse);
      expect(r.isComplete, isFalse);
      expect(r.isSynced, isFalse);
      expect(r.tags, isEmpty);
    });
  });

  group('Streak model', () {
    test('isActive when reflected today', () {
      final s = Streak(
        id: 's-1',
        userId: 'u-1',
        currentStreak: 5,
        longestStreak: 10,
        lastReflectionDate: DateTime.now(),
      );
      expect(s.isActive, isTrue);
      expect(s.reflectedToday, isTrue);
    });

    test('isActive when reflected yesterday', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final s = Streak(
        id: 's-1',
        userId: 'u-1',
        currentStreak: 5,
        longestStreak: 10,
        lastReflectionDate: yesterday,
      );
      expect(s.isActive, isTrue);
      expect(s.reflectedToday, isFalse);
    });

    test('isActive returns false when no reflection date', () {
      const s = Streak(
        id: 's-1',
        userId: 'u-1',
      );
      expect(s.isActive, isFalse);
    });

    test('daysUntilStreakBreaks = 2 after reflecting today', () {
      final s = Streak(
        id: 's-1',
        userId: 'u-1',
        currentStreak: 5,
        longestStreak: 10,
        lastReflectionDate: DateTime.now(),
      );
      expect(s.daysUntilStreakBreaks, 2);
    });

    test('daysUntilStreakBreaks = 1 when need to reflect today', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final s = Streak(
        id: 's-1',
        userId: 'u-1',
        currentStreak: 5,
        longestStreak: 10,
        lastReflectionDate: yesterday,
      );
      expect(s.daysUntilStreakBreaks, 1);
    });

    test('nextMilestone returns 7 for streak of 3', () {
      const s = Streak(
        id: 's-1',
        userId: 'u-1',
        currentStreak: 3,
      );
      expect(s.nextMilestone?.days, 7);
    });

    test('nextMilestone returns 30 for streak of 20', () {
      const s = Streak(
        id: 's-1',
        userId: 'u-1',
        currentStreak: 20,
      );
      expect(s.nextMilestone?.days, 30);
    });
  });

  group('StreakMilestone', () {
    test('isAchieved when achievedAt set', () {
      final m = StreakMilestone(
        days: 7,
        achievedAt: DateTime(2026, 3, 15),
      );
      expect(m.isAchieved, isTrue);
    });

    test('isAchieved false when achievedAt is null', () {
      const m = StreakMilestone(days: 7);
      expect(m.isAchieved, isFalse);
    });

    test('milestone names', () {
      const m7 = StreakMilestone(days: 7);
      expect(m7.name, 'One Week');
      const m30 = StreakMilestone(days: 30);
      expect(m30.name, 'One Month');
      const m365 = StreakMilestone(days: 365);
      expect(m365.name, 'One Year');
      const m42 = StreakMilestone(days: 42);
      expect(m42.name, '42 Days');
    });
  });

  group('ReflectionStats', () {
    test('creates with required fields', () {
      const stats = ReflectionStats(
        totalReflections: 50,
        currentStreak: 7,
        longestStreak: 14,
      );
      expect(stats.totalReflections, 50);
      expect(stats.averageMood, isNull);
      expect(stats.trends, isEmpty);
    });
  });
}
