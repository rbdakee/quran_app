import 'package:freezed_annotation/freezed_annotation.dart';

part 'lesson_complete_response.freezed.dart';
part 'lesson_complete_response.g.dart';

@freezed
abstract class LessonCompleteResponse with _$LessonCompleteResponse {
  const factory LessonCompleteResponse({
    required LessonSummary summary,
    EngagementUpdate? engagement,
  }) = _LessonCompleteResponse;

  factory LessonCompleteResponse.fromJson(Map<String, dynamic> json) =>
      _$LessonCompleteResponseFromJson(json);
}

@freezed
abstract class LessonSummary with _$LessonSummary {
  const factory LessonSummary({
    @JsonKey(name: 'lesson_id') required String lessonId,
    @JsonKey(name: 'steps_done') required int stepsDone,
    required double accuracy,
    @JsonKey(name: 'new_concepts_learned') @Default(0) int newConceptsLearned,
    @JsonKey(name: 'reviews_done') @Default(0) int reviewsDone,
    @JsonKey(name: 'ayah_tasks_done') @Default(0) int ayahTasksDone,
  }) = _LessonSummary;

  factory LessonSummary.fromJson(Map<String, dynamic> json) =>
      _$LessonSummaryFromJson(json);
}

@freezed
abstract class EngagementUpdate with _$EngagementUpdate {
  const factory EngagementUpdate({
    @JsonKey(name: 'streak_updated') @Default(false) bool streakUpdated,
  }) = _EngagementUpdate;

  factory EngagementUpdate.fromJson(Map<String, dynamic> json) =>
      _$EngagementUpdateFromJson(json);
}
