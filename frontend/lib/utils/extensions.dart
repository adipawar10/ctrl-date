import 'package:intl/intl.dart';

/// DateTime extensions for common date/time operations
extension DateTimeExtensions on DateTime {
  /// Get the start of the day (midnight)
  DateTime get startOfDay => DateTime(year, month, day);

  /// Get the end of the day (23:59:59.999)
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Get the start of the week (Monday)
  DateTime get startOfWeek {
    final daysFromMonday = weekday - 1;
    return subtract(Duration(days: daysFromMonday)).startOfDay;
  }

  /// Get the end of the week (Sunday)
  DateTime get endOfWeek {
    final daysUntilSunday = 7 - weekday;
    return add(Duration(days: daysUntilSunday)).endOfDay;
  }

  /// Get the start of the month
  DateTime get startOfMonth => DateTime(year, month, 1);

  /// Get the end of the month
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);

  /// Get the start of the year
  DateTime get startOfYear => DateTime(year, 1, 1);

  /// Get the end of the year
  DateTime get endOfYear => DateTime(year, 12, 31, 23, 59, 59, 999);

  /// Check if this date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if this date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Check if this date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Check if this date is in the past
  bool get isPast => isBefore(DateTime.now());

  /// Check if this date is in the future
  bool get isFuture => isAfter(DateTime.now());

  /// Check if this date is on the same day as another date
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Check if this date is in the same week as another date
  bool isSameWeek(DateTime other) {
    return startOfWeek.isSameDay(other.startOfWeek);
  }

  /// Check if this date is in the same month as another date
  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  /// Check if this date is in the same year as another date
  bool isSameYear(DateTime other) {
    return year == other.year;
  }

  /// Get the number of days in the current month
  int get daysInMonth => DateTime(year, month + 1, 0).day;

  /// Get the week number of the year
  int get weekOfYear {
    final firstDayOfYear = DateTime(year, 1, 1);
    final dayOfYear = difference(firstDayOfYear).inDays;
    return ((dayOfYear - weekday + 10) / 7).floor();
  }

  /// Add a specific number of days
  DateTime addDays(int days) => add(Duration(days: days));

  /// Subtract a specific number of days
  DateTime subtractDays(int days) => subtract(Duration(days: days));

  /// Add a specific number of months
  DateTime addMonths(int months) {
    var newMonth = month + months;
    var newYear = year;

    while (newMonth > 12) {
      newMonth -= 12;
      newYear++;
    }
    while (newMonth < 1) {
      newMonth += 12;
      newYear--;
    }

    final lastDayOfNewMonth = DateTime(newYear, newMonth + 1, 0).day;
    final newDay = day > lastDayOfNewMonth ? lastDayOfNewMonth : day;

    return DateTime(newYear, newMonth, newDay, hour, minute, second);
  }

  /// Subtract a specific number of months
  DateTime subtractMonths(int months) => addMonths(-months);

  /// Format date as "Today", "Yesterday", or a formatted string
  String toRelativeString({String format = 'MMM d, yyyy'}) {
    if (isToday) return 'Today';
    if (isYesterday) return 'Yesterday';
    if (isTomorrow) return 'Tomorrow';
    return DateFormat(format).format(this);
  }

  /// Format date for display (e.g., "Jan 15, 2024")
  String toDisplayDate() => DateFormat('MMM d, yyyy').format(this);

  /// Format time for display (e.g., "2:30 PM")
  String toDisplayTime() => DateFormat('h:mm a').format(this);

  /// Format date and time for display (e.g., "Jan 15, 2024 2:30 PM")
  String toDisplayDateTime() => DateFormat('MMM d, yyyy h:mm a').format(this);

  /// Format as ISO 8601 date only (e.g., "2024-01-15")
  String toIsoDate() => DateFormat('yyyy-MM-dd').format(this);

  /// Format as ISO 8601 time only (e.g., "14:30:00")
  String toIsoTime() => DateFormat('HH:mm:ss').format(this);

  /// Format for API (ISO 8601 with timezone)
  String toApiFormat() => toUtc().toIso8601String();

  /// Get a human-readable relative time (e.g., "2 hours ago")
  String toRelativeTime() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.isNegative) {
      // Future
      final futureDiff = this.difference(now);
      if (futureDiff.inDays > 365) {
        return 'in ${(futureDiff.inDays / 365).floor()} years';
      } else if (futureDiff.inDays > 30) {
        return 'in ${(futureDiff.inDays / 30).floor()} months';
      } else if (futureDiff.inDays > 0) {
        return 'in ${futureDiff.inDays} days';
      } else if (futureDiff.inHours > 0) {
        return 'in ${futureDiff.inHours} hours';
      } else if (futureDiff.inMinutes > 0) {
        return 'in ${futureDiff.inMinutes} minutes';
      } else {
        return 'in a moment';
      }
    } else {
      // Past
      if (difference.inDays > 365) {
        return '${(difference.inDays / 365).floor()} years ago';
      } else if (difference.inDays > 30) {
        return '${(difference.inDays / 30).floor()} months ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} days ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hours ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minutes ago';
      } else {
        return 'just now';
      }
    }
  }

  /// Copy with specific fields replaced
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }
}

/// Duration extensions
extension DurationExtensions on Duration {
  /// Format duration as "Xh Ym" (e.g., "2h 30m")
  String toHoursMinutes() {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }

  /// Format duration as human readable (e.g., "2 hours, 30 minutes")
  String toHumanReadable() {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);

    final parts = <String>[];

    if (hours > 0) {
      parts.add('$hours ${hours == 1 ? 'hour' : 'hours'}');
    }
    if (minutes > 0) {
      parts.add('$minutes ${minutes == 1 ? 'minute' : 'minutes'}');
    }
    if (seconds > 0 && hours == 0) {
      parts.add('$seconds ${seconds == 1 ? 'second' : 'seconds'}');
    }

    if (parts.isEmpty) return '0 seconds';
    return parts.join(', ');
  }
}

/// String extensions
extension StringExtensions on String {
  /// Capitalize the first letter
  String get capitalized {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalize each word
  String get titleCase {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalized).join(' ');
  }

  /// Truncate string with ellipsis
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  /// Check if string is a valid email
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  /// Check if string is a valid URL
  bool get isValidUrl {
    return Uri.tryParse(this)?.hasAbsolutePath ?? false;
  }

  /// Remove all whitespace
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Convert to null if empty
  String? get nullIfEmpty => isEmpty ? null : this;

  /// Parse to DateTime or return null
  DateTime? toDateTime() => DateTime.tryParse(this);
}

/// List extensions
extension ListExtensions<T> on List<T> {
  /// Get the first element or null if empty
  T? get firstOrNull => isEmpty ? null : first;

  /// Get the last element or null if empty
  T? get lastOrNull => isEmpty ? null : last;

  /// Get element at index or null if out of bounds
  T? elementAtOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  /// Separate list into chunks of specified size
  List<List<T>> chunked(int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, i + size > length ? length : i + size));
    }
    return chunks;
  }
}

/// Map extensions
extension MapExtensions<K, V> on Map<K, V> {
  /// Get value or default
  V getOrDefault(K key, V defaultValue) {
    return containsKey(key) ? this[key]! : defaultValue;
  }

  /// Filter map by keys
  Map<K, V> filterKeys(bool Function(K key) predicate) {
    return Map.fromEntries(entries.where((e) => predicate(e.key)));
  }

  /// Filter map by values
  Map<K, V> filterValues(bool Function(V value) predicate) {
    return Map.fromEntries(entries.where((e) => predicate(e.value)));
  }
}

/// Nullable extensions
extension NullableExtensions<T> on T? {
  /// Execute function if not null
  R? let<R>(R Function(T value) operation) {
    if (this == null) return null;
    return operation(this as T);
  }

  /// Get value or default
  T orDefault(T defaultValue) {
    return this ?? defaultValue;
  }
}

/// Int extensions
extension IntExtensions on int {
  /// Check if number is even
  bool get isEven => this % 2 == 0;

  /// Check if number is odd
  bool get isOdd => this % 2 != 0;

  /// Convert to duration in milliseconds
  Duration get milliseconds => Duration(milliseconds: this);

  /// Convert to duration in seconds
  Duration get seconds => Duration(seconds: this);

  /// Convert to duration in minutes
  Duration get minutes => Duration(minutes: this);

  /// Convert to duration in hours
  Duration get hours => Duration(hours: this);

  /// Convert to duration in days
  Duration get days => Duration(days: this);

  /// Format as ordinal (1st, 2nd, 3rd, etc.)
  String get ordinal {
    if (this >= 11 && this <= 13) {
      return '${this}th';
    }
    switch (this % 10) {
      case 1:
        return '${this}st';
      case 2:
        return '${this}nd';
      case 3:
        return '${this}rd';
      default:
        return '${this}th';
    }
  }
}
