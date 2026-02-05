import 'package:freezed_annotation/freezed_annotation.dart';

part 'suggestion.freezed.dart';
part 'suggestion.g.dart';

/// Suggestion model representing a scheduling suggestion
@freezed
class Suggestion with _$Suggestion {
  const Suggestion._();

  const factory Suggestion({
    required String id,
    required String title,
    required int durationMinutes,
    required DateTime suggestedStart,
    required DateTime suggestedEnd,
    required String reason,
  }) = _Suggestion;

  factory Suggestion.fromJson(Map<String, dynamic> json) =>
      _$SuggestionFromJson(json);

  /// Get the duration as a Duration object
  Duration get duration => Duration(minutes: durationMinutes);

  /// Get a formatted duration string (e.g., "30 min", "1 hr", "1 hr 30 min")
  String get formattedDuration {
    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;

    if (hours == 0) {
      return '$minutes min';
    } else if (minutes == 0) {
      return hours == 1 ? '1 hr' : '$hours hrs';
    } else {
      return hours == 1 ? '1 hr $minutes min' : '$hours hrs $minutes min';
    }
  }
}
