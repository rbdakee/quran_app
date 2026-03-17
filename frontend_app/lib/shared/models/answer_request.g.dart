// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AnswerRequest _$AnswerRequestFromJson(Map<String, dynamic> json) =>
    _AnswerRequest(
      stepIndex: (json['step_index'] as num).toInt(),
      stepType: json['step_type'] as String,
      tokenId: json['token_id'] as String,
      answer: AnswerBody.fromJson(json['answer'] as Map<String, dynamic>),
      telemetry: json['telemetry'] == null
          ? null
          : AnswerTelemetry.fromJson(json['telemetry'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AnswerRequestToJson(_AnswerRequest instance) =>
    <String, dynamic>{
      'step_index': instance.stepIndex,
      'step_type': instance.stepType,
      'token_id': instance.tokenId,
      'answer': instance.answer,
      'telemetry': instance.telemetry,
    };

_AnswerBody _$AnswerBodyFromJson(Map<String, dynamic> json) => _AnswerBody(
  selectedOption: json['selected_option'] as String?,
  orderedTokenIds: (json['ordered_token_ids'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  acknowledged: json['acknowledged'] as bool?,
);

Map<String, dynamic> _$AnswerBodyToJson(_AnswerBody instance) =>
    <String, dynamic>{
      'selected_option': instance.selectedOption,
      'ordered_token_ids': instance.orderedTokenIds,
      'acknowledged': instance.acknowledged,
    };

_AnswerTelemetry _$AnswerTelemetryFromJson(Map<String, dynamic> json) =>
    _AnswerTelemetry(
      latencyMs: (json['latency_ms'] as num?)?.toInt(),
      attemptCount: (json['attempt_count'] as num?)?.toInt() ?? 1,
      usedHint: json['used_hint'] as bool? ?? false,
      clientTs: json['client_ts'] as String?,
    );

Map<String, dynamic> _$AnswerTelemetryToJson(_AnswerTelemetry instance) =>
    <String, dynamic>{
      'latency_ms': instance.latencyMs,
      'attempt_count': instance.attemptCount,
      'used_hint': instance.usedHint,
      'client_ts': instance.clientTs,
    };
