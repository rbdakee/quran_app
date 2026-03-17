import 'package:freezed_annotation/freezed_annotation.dart';
import 'lesson_step.dart';

part 'lesson_response.freezed.dart';
part 'lesson_response.g.dart';

@freezed
abstract class LessonResponse with _$LessonResponse {
  const factory LessonResponse({
    @JsonKey(name: 'lesson_id') required String lessonId,
    @JsonKey(name: 'generated_at_utc') required String generatedAtUtc,
    @JsonKey(name: 'algorithm_version') required String algorithmVersion,
    LessonConfig? config,
    @JsonKey(name: 'dynamic') LessonDynamic? lessonDynamic,
    LessonSelection? selection,
    required List<LessonStep> steps,
    LessonNotes? notes,
  }) = _LessonResponse;

  factory LessonResponse.fromJson(Map<String, dynamic> json) =>
      _$LessonResponseFromJson(json);
}

@freezed
abstract class LessonConfig with _$LessonConfig {
  const factory LessonConfig({
    @JsonKey(name: 'target_steps') int? targetSteps,
  }) = _LessonConfig;

  factory LessonConfig.fromJson(Map<String, dynamic> json) =>
      _$LessonConfigFromJson(json);
}

@freezed
abstract class LessonDynamic with _$LessonDynamic {
  const factory LessonDynamic({
    @JsonKey(name: 'total_known_words') int? totalKnownWords,
    @JsonKey(name: 'computed_new') int? computedNew,
    @JsonKey(name: 'computed_review') int? computedReview,
    @JsonKey(name: 'actual_new') int? actualNew,
    @JsonKey(name: 'actual_due') int? actualDue,
    @JsonKey(name: 'actual_reinforcement') int? actualReinforcement,
  }) = _LessonDynamic;

  factory LessonDynamic.fromJson(Map<String, dynamic> json) =>
      _$LessonDynamicFromJson(json);
}

@freezed
abstract class LessonSelection with _$LessonSelection {
  const factory LessonSelection({
    List<dynamic>? due,
    @JsonKey(name: 'new') List<dynamic>? newWords,
    List<dynamic>? reinforcement,
  }) = _LessonSelection;

  factory LessonSelection.fromJson(Map<String, dynamic> json) =>
      _$LessonSelectionFromJson(json);
}

@freezed
abstract class LessonNotes with _$LessonNotes {
  const factory LessonNotes({
    @JsonKey(name: 'quran_safe') bool? quranSafe,
    @JsonKey(name: 'review_only') bool? reviewOnly,
  }) = _LessonNotes;

  factory LessonNotes.fromJson(Map<String, dynamic> json) =>
      _$LessonNotesFromJson(json);
}
