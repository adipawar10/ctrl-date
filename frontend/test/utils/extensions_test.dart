import 'package:flutter_test/flutter_test.dart';
import 'package:ctrl_shift_date/utils/extensions.dart';

void main() {
  group('DateTimeExtensions', () {
    test('startOfDay returns midnight', () {
      final dt = DateTime(2026, 3, 15, 14, 30, 45);
      expect(dt.startOfDay, DateTime(2026, 3, 15));
    });

    test('endOfDay returns 23:59:59.999', () {
      final dt = DateTime(2026, 3, 15, 10, 0);
      final end = dt.endOfDay;
      expect(end.hour, 23);
      expect(end.minute, 59);
      expect(end.second, 59);
    });

    test('startOfWeek returns Monday', () {
      // 2026-03-18 is a Wednesday
      final wednesday = DateTime(2026, 3, 18, 14, 30);
      final monday = wednesday.startOfWeek;
      expect(monday.weekday, DateTime.monday);
      expect(monday.day, 16);
    });

    test('endOfWeek returns Sunday', () {
      final wednesday = DateTime(2026, 3, 18, 14, 30);
      final sunday = wednesday.endOfWeek;
      expect(sunday.weekday, DateTime.sunday);
      expect(sunday.day, 22);
    });

    test('startOfMonth returns first day', () {
      final dt = DateTime(2026, 3, 15);
      expect(dt.startOfMonth, DateTime(2026, 3, 1));
    });

    test('endOfMonth returns last day', () {
      final dt = DateTime(2026, 3, 15);
      final end = dt.endOfMonth;
      expect(end.day, 31);
      expect(end.hour, 23);
    });

    test('isSameDay works correctly', () {
      final a = DateTime(2026, 3, 15, 10, 0);
      final b = DateTime(2026, 3, 15, 22, 30);
      final c = DateTime(2026, 3, 16, 10, 0);
      expect(a.isSameDay(b), isTrue);
      expect(a.isSameDay(c), isFalse);
    });

    test('isSameMonth works correctly', () {
      final a = DateTime(2026, 3, 1);
      final b = DateTime(2026, 3, 31);
      final c = DateTime(2026, 4, 1);
      expect(a.isSameMonth(b), isTrue);
      expect(a.isSameMonth(c), isFalse);
    });

    test('daysInMonth for March = 31', () {
      final dt = DateTime(2026, 3, 15);
      expect(dt.daysInMonth, 31);
    });

    test('daysInMonth for February non-leap = 28', () {
      final dt = DateTime(2026, 2, 15);
      expect(dt.daysInMonth, 28);
    });

    test('addDays works', () {
      final dt = DateTime(2026, 3, 15);
      expect(dt.addDays(5).day, 20);
    });

    test('subtractDays works', () {
      final dt = DateTime(2026, 3, 15);
      expect(dt.subtractDays(5).day, 10);
    });

    test('addMonths works', () {
      final dt = DateTime(2026, 1, 15);
      final result = dt.addMonths(2);
      expect(result.month, 3);
      expect(result.day, 15);
    });

    test('addMonths clamps to last day of month', () {
      final dt = DateTime(2026, 1, 31);
      final result = dt.addMonths(1);
      expect(result.month, 2);
      expect(result.day, 28); // Feb 28 in non-leap year
    });

    test('toDisplayDate formats correctly', () {
      final dt = DateTime(2026, 1, 15);
      expect(dt.toDisplayDate(), contains('Jan'));
      expect(dt.toDisplayDate(), contains('15'));
      expect(dt.toDisplayDate(), contains('2026'));
    });

    test('toIsoDate formats as yyyy-MM-dd', () {
      final dt = DateTime(2026, 3, 15);
      expect(dt.toIsoDate(), '2026-03-15');
    });

    test('copyWith replaces specific fields', () {
      final dt = DateTime(2026, 3, 15, 10, 30);
      final result = dt.copyWith(hour: 14, minute: 0);
      expect(result.year, 2026);
      expect(result.month, 3);
      expect(result.day, 15);
      expect(result.hour, 14);
      expect(result.minute, 0);
    });
  });

  group('DurationExtensions', () {
    test('toHoursMinutes for hours only', () {
      const d = Duration(hours: 2);
      expect(d.toHoursMinutes(), '2h');
    });

    test('toHoursMinutes for minutes only', () {
      const d = Duration(minutes: 45);
      expect(d.toHoursMinutes(), '45m');
    });

    test('toHoursMinutes for hours and minutes', () {
      const d = Duration(hours: 1, minutes: 30);
      expect(d.toHoursMinutes(), '1h 30m');
    });

    test('toHumanReadable', () {
      const d = Duration(hours: 2, minutes: 15);
      final result = d.toHumanReadable();
      expect(result, contains('2 hours'));
      expect(result, contains('15 minutes'));
    });

    test('toHumanReadable for zero', () {
      const d = Duration.zero;
      expect(d.toHumanReadable(), '0 seconds');
    });
  });

  group('StringExtensions', () {
    test('capitalized capitalizes first letter', () {
      expect('hello'.capitalized, 'Hello');
    });

    test('capitalized on empty returns empty', () {
      expect(''.capitalized, '');
    });

    test('titleCase capitalizes each word', () {
      expect('hello world'.titleCase, 'Hello World');
    });

    test('truncate when shorter than max', () {
      expect('short'.truncate(10), 'short');
    });

    test('truncate when longer than max', () {
      final result = 'a very long string'.truncate(10);
      expect(result.length, 10);
      expect(result, endsWith('...'));
    });

    test('isValidEmail for valid email', () {
      expect('user@test.com'.isValidEmail, isTrue);
    });

    test('isValidEmail for invalid email', () {
      expect('notanemail'.isValidEmail, isFalse);
    });

    test('removeWhitespace', () {
      expect('hello world test'.removeWhitespace, 'helloworldtest');
    });

    test('nullIfEmpty returns null for empty', () {
      expect(''.nullIfEmpty, isNull);
    });

    test('nullIfEmpty returns string for non-empty', () {
      expect('hello'.nullIfEmpty, 'hello');
    });

    test('toDateTime parses valid date', () {
      expect('2026-03-15'.toDateTime(), isNotNull);
    });

    test('toDateTime returns null for invalid', () {
      expect('not-a-date'.toDateTime(), isNull);
    });
  });

  group('ListExtensions', () {
    test('firstOrNull returns first when non-empty', () {
      expect([1, 2, 3].firstOrNull, 1);
    });

    test('firstOrNull returns null when empty', () {
      expect(<int>[].firstOrNull, isNull);
    });

    test('lastOrNull returns last when non-empty', () {
      expect([1, 2, 3].lastOrNull, 3);
    });

    test('elementAtOrNull returns null for out of bounds', () {
      expect([1, 2].elementAtOrNull(5), isNull);
      expect([1, 2].elementAtOrNull(-1), isNull);
    });

    test('elementAtOrNull returns element for valid index', () {
      expect([10, 20, 30].elementAtOrNull(1), 20);
    });

    test('chunked splits list correctly', () {
      final chunks = [1, 2, 3, 4, 5].chunked(2);
      expect(chunks.length, 3);
      expect(chunks[0], [1, 2]);
      expect(chunks[1], [3, 4]);
      expect(chunks[2], [5]);
    });
  });

  group('MapExtensions', () {
    test('getOrDefault returns value when exists', () {
      expect({'a': 1}.getOrDefault('a', 0), 1);
    });

    test('getOrDefault returns default when missing', () {
      expect(<String, int>{}.getOrDefault('a', 0), 0);
    });

    test('filterKeys filters correctly', () {
      final m = {'apple': 1, 'banana': 2, 'avocado': 3};
      final result = m.filterKeys((k) => k.startsWith('a'));
      expect(result.length, 2);
      expect(result.containsKey('banana'), isFalse);
    });

    test('filterValues filters correctly', () {
      final m = {'a': 1, 'b': 5, 'c': 3};
      final result = m.filterValues((v) => v > 2);
      expect(result.length, 2);
      expect(result.containsKey('a'), isFalse);
    });
  });

  group('IntExtensions', () {
    test('ordinal for 1st, 2nd, 3rd', () {
      expect(1.ordinal, '1st');
      expect(2.ordinal, '2nd');
      expect(3.ordinal, '3rd');
    });

    test('ordinal for 4th-20th', () {
      expect(4.ordinal, '4th');
      expect(11.ordinal, '11th');
      expect(12.ordinal, '12th');
      expect(13.ordinal, '13th');
    });

    test('ordinal for 21st, 22nd, 23rd', () {
      expect(21.ordinal, '21st');
      expect(22.ordinal, '22nd');
      expect(23.ordinal, '23rd');
    });

    test('duration extensions', () {
      expect(5.seconds, const Duration(seconds: 5));
      expect(2.minutes, const Duration(minutes: 2));
      expect(1.hours, const Duration(hours: 1));
      expect(3.days, const Duration(days: 3));
    });
  });

  group('NullableExtensions', () {
    test('let applies function when non-null', () {
      const int? val = 5;
      expect(val.let((v) => v * 2), 10);
    });

    test('let returns null when null', () {
      const int? val = null;
      expect(val.let((v) => v * 2), isNull);
    });

    test('orDefault returns value when non-null', () {
      const int? val = 5;
      expect(val.orDefault(0), 5);
    });

    test('orDefault returns default when null', () {
      const int? val = null;
      expect(val.orDefault(0), 0);
    });
  });
}
