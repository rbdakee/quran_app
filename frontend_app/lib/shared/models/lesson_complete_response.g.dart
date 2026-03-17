// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_complete_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LessonCompleteResponse _$LessonCompleteResponseFromJson(
  Map<String, dynamic> json,
) => _LessonCompleteResponse(
  summary: LessonSummary.fromJson(json['summary'] as Map<String, dynamic>),
  engagement: json['engagement'] == null
      ? null
      : EngagementUpdate.fromJson(json['engagement'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LessonCompleteResponseToJson(
  _LessonCompleteResponse instance,
) => <String, dynamic>{
  'summary': instance.summary,
  'engagement': instance.engagement,
};

_LessonSummary _$LessonSummaryFromJson(Map<String, dynamic> json) =>
    _LessonSummary(
      lessonId: json['lesson_id'] as String,
      stepsDone: (json['steps_done'] as num).toInt(),
      accuracy: (json['accuracy'] as num).toDouble(),
      newConceptsLearned: (json['new_concepts_learned'] as num?)?.toInt() ?? 0,
      reviewsDone: (json['reviews_done'] as num?)?.toInt() ?? 0,
      ayahTasksDone: (json['ayah_tasks_done'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$LessonSummaryToJson(_LessonSummary instance) =>
    <String, dynamic>{
      'lesson_id': instance.lessonId,
      'steps_done': instance.stepsDone,
      'accuracy': instance.accuracy,
      'new_concepts_learned': instance.newConceptsLearned,
      'reviews_done': instance.reviewsDone,
      'ayah_tasks_done': instance.ayahTasksDone,
    };

_EngagementUpdate _$EngagementUpdateFromJson(Map<String, dynamic> json) =>
    _EngagementUpdate(streakUpdated: json['streak_updated'] as bool? ?? false);

Map<String, dynamic> _$EngagementUpdateToJson(_EngagementUpdate instance) =>
    <String, dynamic>{'streak_updated': instance.streakUpdated};
