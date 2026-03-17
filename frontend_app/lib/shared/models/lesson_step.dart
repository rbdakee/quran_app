import 'package:freezed_annotation/freezed_annotation.dart';
import 'token_payload.dart';

part 'lesson_step.freezed.dart';
part 'lesson_step.g.dart';

@freezed
abstract class LessonStep with _$LessonStep {
  const factory LessonStep({
    @JsonKey(name: 'step_id') required String stepId,
    @JsonKey(name: 'step_index') required int stepIndex,
    required String type,
    @JsonKey(name: 'skill_type') String? skillType,
    TokenPayload? token,
    List<String>? options,
    String? correct,

    // ── Ayah Build fields ──
    int? surah,
    int? ayah,
    @JsonKey(name: 'ayah_segment_index') int? ayahSegmentIndex,
    @JsonKey(name: 'gold_order_token_ids') List<String>? goldOrderTokenIds,
    List<AyahPoolToken>? pool,
    @JsonKey(name: 'prompt_translation_units') List<String>? promptTranslationUnits,
    @JsonKey(name: 'prompt_audio_keys') List<String>? promptAudioKeys,
    @JsonKey(name: 'prompt_ar_tokens') List<String>? promptArTokens,
  }) = _LessonStep;

  factory LessonStep.fromJson(Map<String, dynamic> json) =>
      _$LessonStepFromJson(json);
}

@freezed
abstract class AyahPoolToken with _$AyahPoolToken {
  const factory AyahPoolToken({
    @JsonKey(name: 'token_id') required String tokenId,
    required String text,
    @JsonKey(name: 'is_distractor') @Default(false) bool isDistractor,
  }) = _AyahPoolToken;

  factory AyahPoolToken.fromJson(Map<String, dynamic> json) =>
      _$AyahPoolTokenFromJson(json);
}
