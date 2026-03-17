// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TokenPayload _$TokenPayloadFromJson(Map<String, dynamic> json) =>
    _TokenPayload(
      tokenId: json['token_id'] as String,
      location: json['location'] as String,
      surah: (json['surah'] as num).toInt(),
      ayah: (json['ayah'] as num).toInt(),
      word: (json['word'] as num).toInt(),
      ar: json['ar'] as String,
      translationEn: json['translation_en'] as String?,
      lemmaAr: json['lemma_ar'] as String?,
      rootAr: json['root_ar'] as String?,
      audioKey: json['audio_key'] as String?,
    );

Map<String, dynamic> _$TokenPayloadToJson(_TokenPayload instance) =>
    <String, dynamic>{
      'token_id': instance.tokenId,
      'location': instance.location,
      'surah': instance.surah,
      'ayah': instance.ayah,
      'word': instance.word,
      'ar': instance.ar,
      'translation_en': instance.translationEn,
      'lemma_ar': instance.lemmaAr,
      'root_ar': instance.rootAr,
      'audio_key': instance.audioKey,
    };
