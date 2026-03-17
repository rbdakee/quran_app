// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LessonStep _$LessonStepFromJson(Map<String, dynamic> json) => _LessonStep(
  stepId: json['step_id'] as String,
  stepIndex: (json['step_index'] as num).toInt(),
  type: json['type'] as String,
  skillType: json['skill_type'] as String?,
  token: json['token'] == null
      ? null
      : TokenPayload.fromJson(json['token'] as Map<String, dynamic>),
  options: (json['options'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  correct: json['correct'] as String?,
  surah: (json['surah'] as num?)?.toInt(),
  ayah: (json['ayah'] as num?)?.toInt(),
  ayahSegmentIndex: (json['ayah_segment_index'] as num?)?.toInt(),
  goldOrderTokenIds: (json['gold_order_token_ids'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  pool: (json['pool'] as List<dynamic>?)
      ?.map((e) => AyahPoolToken.fromJson(e as Map<String, dynamic>))
      .toList(),
  promptTranslationUnits: (json['prompt_translation_units'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  promptAudioKeys: (json['prompt_audio_keys'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  promptArTokens: (json['prompt_ar_tokens'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$LessonStepToJson(_LessonStep instance) =>
    <String, dynamic>{
      'step_id': instance.stepId,
      'step_index': instance.stepIndex,
      'type': instance.type,
      'skill_type': instance.skillType,
      'token': instance.token,
      'options': instance.options,
      'correct': instance.correct,
      'surah': instance.surah,
      'ayah': instance.ayah,
      'ayah_segment_index': instance.ayahSegmentIndex,
      'gold_order_token_ids': instance.goldOrderTokenIds,
      'pool': instance.pool,
      'prompt_translation_units': instance.promptTranslationUnits,
      'prompt_audio_keys': instance.promptAudioKeys,
      'prompt_ar_tokens': instance.promptArTokens,
    };

_AyahPoolToken _$AyahPoolTokenFromJson(Map<String, dynamic> json) =>
    _AyahPoolToken(
      tokenId: json['token_id'] as String,
      text: json['text'] as String,
      isDistractor: json['is_distractor'] as bool? ?? false,
    );

Map<String, dynamic> _$AyahPoolTokenToJson(_AyahPoolToken instance) =>
    <String, dynamic>{
      'token_id': instance.tokenId,
      'text': instance.text,
      'is_distractor': instance.isDistractor,
    };
