// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggestion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SuggestionImpl _$$SuggestionImplFromJson(Map<String, dynamic> json) =>
    _$SuggestionImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      suggestedStart: DateTime.parse(json['suggestedStart'] as String),
      suggestedEnd: DateTime.parse(json['suggestedEnd'] as String),
      reason: json['reason'] as String,
    );

Map<String, dynamic> _$$SuggestionImplToJson(_$SuggestionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'durationMinutes': instance.durationMinutes,
      'suggestedStart': instance.suggestedStart.toIso8601String(),
      'suggestedEnd': instance.suggestedEnd.toIso8601String(),
      'reason': instance.reason,
    };
