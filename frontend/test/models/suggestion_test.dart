import 'package:flutter_test/flutter_test.dart';
import 'package:ctrl_shift_date/models/suggestion.dart';

void main() {
  group('Suggestion model', () {
    test('duration returns correct Duration', () {
      final s = Suggestion(
        id: 'sug-1',
        title: 'Focus Block',
        durationMinutes: 90,
        suggestedStart: DateTime(2026, 4, 1, 10, 0),
        suggestedEnd: DateTime(2026, 4, 1, 11, 30),
        reason: 'You have a gap in your schedule',
      );
      expect(s.duration, const Duration(minutes: 90));
    });

    test('formattedDuration for minutes only', () {
      final s = Suggestion(
        id: 'sug-1',
        title: 'Quick Break',
        durationMinutes: 15,
        suggestedStart: DateTime(2026, 4, 1, 10, 0),
        suggestedEnd: DateTime(2026, 4, 1, 10, 15),
        reason: 'Take a breather',
      );
      expect(s.formattedDuration, '15 min');
    });

    test('formattedDuration for exactly 1 hour', () {
      final s = Suggestion(
        id: 'sug-1',
        title: 'Meeting',
        durationMinutes: 60,
        suggestedStart: DateTime(2026, 4, 1, 10, 0),
        suggestedEnd: DateTime(2026, 4, 1, 11, 0),
        reason: 'Time to meet',
      );
      expect(s.formattedDuration, '1 hr');
    });

    test('formattedDuration for multiple hours', () {
      final s = Suggestion(
        id: 'sug-1',
        title: 'Deep Work',
        durationMinutes: 120,
        suggestedStart: DateTime(2026, 4, 1, 10, 0),
        suggestedEnd: DateTime(2026, 4, 1, 12, 0),
        reason: 'Block for deep work',
      );
      expect(s.formattedDuration, '2 hrs');
    });

    test('formattedDuration for hours and minutes', () {
      final s = Suggestion(
        id: 'sug-1',
        title: 'Workshop',
        durationMinutes: 90,
        suggestedStart: DateTime(2026, 4, 1, 10, 0),
        suggestedEnd: DateTime(2026, 4, 1, 11, 30),
        reason: 'Attend workshop',
      );
      expect(s.formattedDuration, '1 hr 30 min');
    });

    test('formattedDuration for multi-hour with minutes', () {
      final s = Suggestion(
        id: 'sug-1',
        title: 'Long Workshop',
        durationMinutes: 150,
        suggestedStart: DateTime(2026, 4, 1, 10, 0),
        suggestedEnd: DateTime(2026, 4, 1, 12, 30),
        reason: 'Extended session',
      );
      expect(s.formattedDuration, '2 hrs 30 min');
    });
  });
}
