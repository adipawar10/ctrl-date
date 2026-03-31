import 'package:flutter_test/flutter_test.dart';
import 'package:ctrl_shift_date/models/event.dart';

void main() {
  group('Event model', () {
    final now = DateTime.now();
    final pastStart = now.subtract(const Duration(hours: 2));
    final pastEnd = now.subtract(const Duration(hours: 1));
    final futureStart = now.add(const Duration(hours: 1));
    final futureEnd = now.add(const Duration(hours: 2));
    final happeningStart = now.subtract(const Duration(minutes: 30));
    final happeningEnd = now.add(const Duration(minutes: 30));

    Event makeEvent({
      DateTime? startTime,
      DateTime? endTime,
      RecurrenceRule? recurrenceRule,
    }) {
      return Event(
        id: 'evt-1',
        userId: 'user-1',
        title: 'Test Event',
        startTime: startTime ?? futureStart,
        endTime: endTime ?? futureEnd,
        recurrenceRule: recurrenceRule,
      );
    }

    test('isPast returns true for past events', () {
      final event = makeEvent(startTime: pastStart, endTime: pastEnd);
      expect(event.isPast, isTrue);
      expect(event.isFuture, isFalse);
    });

    test('isFuture returns true for future events', () {
      final event = makeEvent(startTime: futureStart, endTime: futureEnd);
      expect(event.isFuture, isTrue);
      expect(event.isPast, isFalse);
    });

    test('isHappeningNow returns true for current events', () {
      final event = makeEvent(
        startTime: happeningStart,
        endTime: happeningEnd,
      );
      expect(event.isHappeningNow, isTrue);
    });

    test('duration calculates correctly', () {
      final event = makeEvent(startTime: futureStart, endTime: futureEnd);
      expect(event.duration, const Duration(hours: 1));
    });

    test('isRecurring is true when recurrenceRule is set', () {
      final event = makeEvent(
        recurrenceRule: const RecurrenceRule(
          frequency: RecurrenceFrequency.weekly,
        ),
      );
      expect(event.isRecurring, isTrue);
    });

    test('isRecurring is false when recurrenceRule is null', () {
      final event = makeEvent();
      expect(event.isRecurring, isFalse);
    });

    test('defaults are correct', () {
      final event = makeEvent();
      expect(event.status, EventStatus.scheduled);
      expect(event.priority, EventPriority.medium);
      expect(event.isPrivate, isFalse);
      expect(event.isShared, isFalse);
      expect(event.tags, isEmpty);
      expect(event.reminders, isEmpty);
      expect(event.attachments, isEmpty);
      expect(event.isSynced, isFalse);
    });
  });

  group('RecurrenceRule', () {
    test('hasEndCondition with count', () {
      const rule = RecurrenceRule(
        frequency: RecurrenceFrequency.daily,
        count: 10,
      );
      expect(rule.hasEndCondition, isTrue);
    });

    test('hasEndCondition with until', () {
      final rule = RecurrenceRule(
        frequency: RecurrenceFrequency.weekly,
        until: DateTime(2026, 12, 31),
      );
      expect(rule.hasEndCondition, isTrue);
    });

    test('hasEndCondition is false with no end', () {
      const rule = RecurrenceRule(
        frequency: RecurrenceFrequency.monthly,
      );
      expect(rule.hasEndCondition, isFalse);
    });

    test('description for daily', () {
      const rule = RecurrenceRule(frequency: RecurrenceFrequency.daily);
      expect(rule.description, 'Every day');
    });

    test('description for every 2 weeks', () {
      const rule = RecurrenceRule(
        frequency: RecurrenceFrequency.weekly,
        interval: 2,
      );
      expect(rule.description, 'Every 2 weeks');
    });

    test('description with count', () {
      const rule = RecurrenceRule(
        frequency: RecurrenceFrequency.monthly,
        count: 6,
      );
      expect(rule.description, contains('6 times'));
    });
  });

  group('EventStatus enum', () {
    test('all statuses defined', () {
      expect(EventStatus.values.length, 7);
      expect(EventStatus.values, contains(EventStatus.draft));
      expect(EventStatus.values, contains(EventStatus.completed));
      expect(EventStatus.values, contains(EventStatus.partial));
      expect(EventStatus.values, contains(EventStatus.skipped));
      expect(EventStatus.values, contains(EventStatus.cancelled));
    });
  });

  group('EventPriority enum', () {
    test('all priorities defined', () {
      expect(EventPriority.values.length, 4);
      expect(EventPriority.values, contains(EventPriority.low));
      expect(EventPriority.values, contains(EventPriority.urgent));
    });
  });

  group('EventReminder', () {
    test('creates with defaults', () {
      const reminder = EventReminder(id: 'r1', minutesBefore: 15);
      expect(reminder.type, 'push');
      expect(reminder.isSent, isFalse);
    });
  });

  group('EventFilter', () {
    test('creates with defaults', () {
      const filter = EventFilter();
      expect(filter.includeRecurring, isFalse);
      expect(filter.onlyShared, isFalse);
      expect(filter.startDate, isNull);
    });
  });
}
