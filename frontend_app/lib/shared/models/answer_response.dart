import 'package:freezed_annotation/freezed_annotation.dart';

part 'answer_response.freezed.dart';
part 'answer_response.g.dart';

@freezed
abstract class AnswerResponse with _$AnswerResponse {
  const factory AnswerResponse({
    @JsonKey(name: 'step_index') required int stepIndex,
    @JsonKey(name: 'is_correct') required bool isCorrect,
    @JsonKey(name: 'outcome_bucket') String? outcomeBucket,
    AnswerFeedback? feedback,
    @JsonKey(name: 'progress_update') ProgressUpdate? progressUpdate,
  }) = _AnswerResponse;

  factory AnswerResponse.fromJson(Map<String, dynamic> json) =>
      _$AnswerResponseFromJson(json);
}

@freezed
abstract class AnswerFeedback with _$AnswerFeedback {
  const factory AnswerFeedback({
    required String type,
    required String message,
  }) = _AnswerFeedback;

  factory AnswerFeedback.fromJson(Map<String, dynamic> json) =>
      _$AnswerFeedbackFromJson(json);
}

@freezed
abstract class ProgressUpdate with _$ProgressUpdate {
  const factory ProgressUpdate({
    @JsonKey(name: 'token_id') required String tokenId,
    @JsonKey(name: 'new_state') String? newState,
    double? stability,
    @JsonKey(name: 'next_review_at') String? nextReviewAt,
  }) = _ProgressUpdate;

  factory ProgressUpdate.fromJson(Map<String, dynamic> json) =>
      _$ProgressUpdateFromJson(json);
}
