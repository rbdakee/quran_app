import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_payload.freezed.dart';
part 'token_payload.g.dart';

@freezed
abstract class TokenPayload with _$TokenPayload {
  const factory TokenPayload({
    @JsonKey(name: 'token_id') required String tokenId,
    required String location,
    required int surah,
    required int ayah,
    required int word,
    required String ar,
    @JsonKey(name: 'translation_en') String? translationEn,
    @JsonKey(name: 'lemma_ar') String? lemmaAr,
    @JsonKey(name: 'root_ar') String? rootAr,
    @JsonKey(name: 'audio_key') String? audioKey,
  }) = _TokenPayload;

  factory TokenPayload.fromJson(Map<String, dynamic> json) =>
      _$TokenPayloadFromJson(json);
}
