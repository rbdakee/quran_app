import 'package:freezed_annotation/freezed_annotation.dart';

part 'answer_request.freezed.dart';
part 'answer_request.g.dart';

@freezed
abstract class AnswerRequest with _$AnswerRequest {
  const factory AnswerRequest({
    @JsonKey(name: 'step_index') required int stepIndex,
    @JsonKey(name: 'step_type') required String stepType,
    @JsonKey(name: 'token_id') required String tokenId,
    required AnswerBody answer,
    AnswerTelemetry? telemetry,
  }) = _AnswerRequest;

  factory AnswerRequest.fromJson(Map<String, dynamic> json) =>
      _$AnswerRequestFromJson(json);
}

@freezed
abstract class AnswerBody with _$AnswerBody {
  const factory AnswerBody({
    @JsonKey(name: 'selected_option') String? selectedOption,
    @JsonKey(name: 'ordered_token_ids') List<String>? orderedTokenIds,
    bool? acknowledged,
  }) = _AnswerBody;

  factory AnswerBody.fromJson(Map<String, dynamic> json) =>
      _$AnswerBodyFromJson(json);
}

@freezed
abstract class AnswerTelemetry with _$AnswerTelemetry {
  const factory AnswerTelemetry({
    @JsonKey(name: 'latency_ms') int? latencyMs,
    @JsonKey(name: 'attempt_count') @Default(1) int attemptCount,
    @JsonKey(name: 'used_hint') @Default(false) bool usedHint,
    @JsonKey(name: 'client_ts') String? clientTs,
  }) = _AnswerTelemetry;

  factory AnswerTelemetry.fromJson(Map<String, dynamic> json) =>
      _$AnswerTelemetryFromJson(json);
}
