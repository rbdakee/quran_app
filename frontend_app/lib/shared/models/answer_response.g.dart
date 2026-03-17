// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AnswerResponse _$AnswerResponseFromJson(Map<String, dynamic> json) =>
    _AnswerResponse(
      stepIndex: (json['step_index'] as num).toInt(),
      isCorrect: json['is_correct'] as bool,
      outcomeBucket: json['outcome_bucket'] as String?,
      feedback: json['feedback'] == null
          ? null
          : AnswerFeedback.fromJson(json['feedback'] as Map<String, dynamic>),
      progressUpdate: json['progress_update'] == null
          ? null
          : ProgressUpdate.fromJson(
              json['progress_update'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$AnswerResponseToJson(_AnswerResponse instance) =>
    <String, dynamic>{
      'step_index': instance.stepIndex,
      'is_correct': instance.isCorrect,
      'outcome_bucket': instance.outcomeBucket,
      'feedback': instance.feedback,
      'progress_update': instance.progressUpdate,
    };

_AnswerFeedback _$AnswerFeedbackFromJson(Map<String, dynamic> json) =>
    _AnswerFeedback(
      type: json['type'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$AnswerFeedbackToJson(_AnswerFeedback instance) =>
    <String, dynamic>{'type': instance.type, 'message': instance.message};

_ProgressUpdate _$ProgressUpdateFromJson(Map<String, dynamic> json) =>
    _ProgressUpdate(
      tokenId: json['token_id'] as String,
      newState: json['new_state'] as String?,
      stability: (json['stability'] as num?)?.toDouble(),
      nextReviewAt: json['next_review_at'] as String?,
    );

Map<String, dynamic> _$ProgressUpdateToJson(_ProgressUpdate instance) =>
    <String, dynamic>{
      'token_id': instance.tokenId,
      'new_state': instance.newState,
      'stability': instance.stability,
      'next_review_at': instance.nextReviewAt,
    };
