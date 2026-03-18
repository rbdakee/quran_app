// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LessonResponse _$LessonResponseFromJson(Map<String, dynamic> json) =>
    _LessonResponse(
      lessonId: json['lesson_id'] as String,
      generatedAtUtc: json['generated_at_utc'] as String,
      algorithmVersion: json['algorithm_version'] as String,
      status: json['status'] as String?,
      readOnly: json['read_only'] as bool? ?? false,
      config: json['config'] == null
          ? null
          : LessonConfig.fromJson(json['config'] as Map<String, dynamic>),
      lessonDynamic: json['dynamic'] == null
          ? null
          : LessonDynamic.fromJson(json['dynamic'] as Map<String, dynamic>),
      selection: json['selection'] == null
          ? null
          : LessonSelection.fromJson(json['selection'] as Map<String, dynamic>),
      steps: (json['steps'] as List<dynamic>)
          .map((e) => LessonStep.fromJson(e as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] == null
          ? null
          : LessonNotes.fromJson(json['notes'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LessonResponseToJson(_LessonResponse instance) =>
    <String, dynamic>{
      'lesson_id': instance.lessonId,
      'generated_at_utc': instance.generatedAtUtc,
      'algorithm_version': instance.algorithmVersion,
      'status': instance.status,
      'read_only': instance.readOnly,
      'config': instance.config,
      'dynamic': instance.lessonDynamic,
      'selection': instance.selection,
      'steps': instance.steps,
      'notes': instance.notes,
    };

_LessonConfig _$LessonConfigFromJson(Map<String, dynamic> json) =>
    _LessonConfig(targetSteps: (json['target_steps'] as num?)?.toInt());

Map<String, dynamic> _$LessonConfigToJson(_LessonConfig instance) =>
    <String, dynamic>{'target_steps': instance.targetSteps};

_LessonDynamic _$LessonDynamicFromJson(Map<String, dynamic> json) =>
    _LessonDynamic(
      totalKnownWords: (json['total_known_words'] as num?)?.toInt(),
      computedNew: (json['computed_new'] as num?)?.toInt(),
      computedReview: (json['computed_review'] as num?)?.toInt(),
      actualNew: (json['actual_new'] as num?)?.toInt(),
      actualDue: (json['actual_due'] as num?)?.toInt(),
      actualReinforcement: (json['actual_reinforcement'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LessonDynamicToJson(_LessonDynamic instance) =>
    <String, dynamic>{
      'total_known_words': instance.totalKnownWords,
      'computed_new': instance.computedNew,
      'computed_review': instance.computedReview,
      'actual_new': instance.actualNew,
      'actual_due': instance.actualDue,
      'actual_reinforcement': instance.actualReinforcement,
    };

_LessonSelection _$LessonSelectionFromJson(Map<String, dynamic> json) =>
    _LessonSelection(
      due: json['due'] as List<dynamic>?,
      newWords: json['new'] as List<dynamic>?,
      reinforcement: json['reinforcement'] as List<dynamic>?,
    );

Map<String, dynamic> _$LessonSelectionToJson(_LessonSelection instance) =>
    <String, dynamic>{
      'due': instance.due,
      'new': instance.newWords,
      'reinforcement': instance.reinforcement,
    };

_LessonNotes _$LessonNotesFromJson(Map<String, dynamic> json) => _LessonNotes(
  quranSafe: json['quran_safe'] as bool?,
  reviewOnly: json['review_only'] as bool?,
);

Map<String, dynamic> _$LessonNotesToJson(_LessonNotes instance) =>
    <String, dynamic>{
      'quran_safe': instance.quranSafe,
      'review_only': instance.reviewOnly,
    };
