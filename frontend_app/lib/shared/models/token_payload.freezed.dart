// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'token_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TokenPayload {

@JsonKey(name: 'token_id') String get tokenId; String get location; int get surah; int get ayah; int get word; String get ar;@JsonKey(name: 'translation_en') String? get translationEn;@JsonKey(name: 'lemma_ar') String? get lemmaAr;@JsonKey(name: 'root_ar') String? get rootAr;@JsonKey(name: 'audio_key') String? get audioKey;
/// Create a copy of TokenPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TokenPayloadCopyWith<TokenPayload> get copyWith => _$TokenPayloadCopyWithImpl<TokenPayload>(this as TokenPayload, _$identity);

  /// Serializes this TokenPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TokenPayload&&(identical(other.tokenId, tokenId) || other.tokenId == tokenId)&&(identical(other.location, location) || other.location == location)&&(identical(other.surah, surah) || other.surah == surah)&&(identical(other.ayah, ayah) || other.ayah == ayah)&&(identical(other.word, word) || other.word == word)&&(identical(other.ar, ar) || other.ar == ar)&&(identical(other.translationEn, translationEn) || other.translationEn == translationEn)&&(identical(other.lemmaAr, lemmaAr) || other.lemmaAr == lemmaAr)&&(identical(other.rootAr, rootAr) || other.rootAr == rootAr)&&(identical(other.audioKey, audioKey) || other.audioKey == audioKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tokenId,location,surah,ayah,word,ar,translationEn,lemmaAr,rootAr,audioKey);

@override
String toString() {
  return 'TokenPayload(tokenId: $tokenId, location: $location, surah: $surah, ayah: $ayah, word: $word, ar: $ar, translationEn: $translationEn, lemmaAr: $lemmaAr, rootAr: $rootAr, audioKey: $audioKey)';
}


}

/// @nodoc
abstract mixin class $TokenPayloadCopyWith<$Res>  {
  factory $TokenPayloadCopyWith(TokenPayload value, $Res Function(TokenPayload) _then) = _$TokenPayloadCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'token_id') String tokenId, String location, int surah, int ayah, int word, String ar,@JsonKey(name: 'translation_en') String? translationEn,@JsonKey(name: 'lemma_ar') String? lemmaAr,@JsonKey(name: 'root_ar') String? rootAr,@JsonKey(name: 'audio_key') String? audioKey
});




}
/// @nodoc
class _$TokenPayloadCopyWithImpl<$Res>
    implements $TokenPayloadCopyWith<$Res> {
  _$TokenPayloadCopyWithImpl(this._self, this._then);

  final TokenPayload _self;
  final $Res Function(TokenPayload) _then;

/// Create a copy of TokenPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tokenId = null,Object? location = null,Object? surah = null,Object? ayah = null,Object? word = null,Object? ar = null,Object? translationEn = freezed,Object? lemmaAr = freezed,Object? rootAr = freezed,Object? audioKey = freezed,}) {
  return _then(_self.copyWith(
tokenId: null == tokenId ? _self.tokenId : tokenId // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,surah: null == surah ? _self.surah : surah // ignore: cast_nullable_to_non_nullable
as int,ayah: null == ayah ? _self.ayah : ayah // ignore: cast_nullable_to_non_nullable
as int,word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as int,ar: null == ar ? _self.ar : ar // ignore: cast_nullable_to_non_nullable
as String,translationEn: freezed == translationEn ? _self.translationEn : translationEn // ignore: cast_nullable_to_non_nullable
as String?,lemmaAr: freezed == lemmaAr ? _self.lemmaAr : lemmaAr // ignore: cast_nullable_to_non_nullable
as String?,rootAr: freezed == rootAr ? _self.rootAr : rootAr // ignore: cast_nullable_to_non_nullable
as String?,audioKey: freezed == audioKey ? _self.audioKey : audioKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TokenPayload].
extension TokenPayloadPatterns on TokenPayload {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TokenPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TokenPayload() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TokenPayload value)  $default,){
final _that = this;
switch (_that) {
case _TokenPayload():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TokenPayload value)?  $default,){
final _that = this;
switch (_that) {
case _TokenPayload() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'token_id')  String tokenId,  String location,  int surah,  int ayah,  int word,  String ar, @JsonKey(name: 'translation_en')  String? translationEn, @JsonKey(name: 'lemma_ar')  String? lemmaAr, @JsonKey(name: 'root_ar')  String? rootAr, @JsonKey(name: 'audio_key')  String? audioKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TokenPayload() when $default != null:
return $default(_that.tokenId,_that.location,_that.surah,_that.ayah,_that.word,_that.ar,_that.translationEn,_that.lemmaAr,_that.rootAr,_that.audioKey);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'token_id')  String tokenId,  String location,  int surah,  int ayah,  int word,  String ar, @JsonKey(name: 'translation_en')  String? translationEn, @JsonKey(name: 'lemma_ar')  String? lemmaAr, @JsonKey(name: 'root_ar')  String? rootAr, @JsonKey(name: 'audio_key')  String? audioKey)  $default,) {final _that = this;
switch (_that) {
case _TokenPayload():
return $default(_that.tokenId,_that.location,_that.surah,_that.ayah,_that.word,_that.ar,_that.translationEn,_that.lemmaAr,_that.rootAr,_that.audioKey);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'token_id')  String tokenId,  String location,  int surah,  int ayah,  int word,  String ar, @JsonKey(name: 'translation_en')  String? translationEn, @JsonKey(name: 'lemma_ar')  String? lemmaAr, @JsonKey(name: 'root_ar')  String? rootAr, @JsonKey(name: 'audio_key')  String? audioKey)?  $default,) {final _that = this;
switch (_that) {
case _TokenPayload() when $default != null:
return $default(_that.tokenId,_that.location,_that.surah,_that.ayah,_that.word,_that.ar,_that.translationEn,_that.lemmaAr,_that.rootAr,_that.audioKey);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TokenPayload implements TokenPayload {
  const _TokenPayload({@JsonKey(name: 'token_id') required this.tokenId, required this.location, required this.surah, required this.ayah, required this.word, required this.ar, @JsonKey(name: 'translation_en') this.translationEn, @JsonKey(name: 'lemma_ar') this.lemmaAr, @JsonKey(name: 'root_ar') this.rootAr, @JsonKey(name: 'audio_key') this.audioKey});
  factory _TokenPayload.fromJson(Map<String, dynamic> json) => _$TokenPayloadFromJson(json);

@override@JsonKey(name: 'token_id') final  String tokenId;
@override final  String location;
@override final  int surah;
@override final  int ayah;
@override final  int word;
@override final  String ar;
@override@JsonKey(name: 'translation_en') final  String? translationEn;
@override@JsonKey(name: 'lemma_ar') final  String? lemmaAr;
@override@JsonKey(name: 'root_ar') final  String? rootAr;
@override@JsonKey(name: 'audio_key') final  String? audioKey;

/// Create a copy of TokenPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TokenPayloadCopyWith<_TokenPayload> get copyWith => __$TokenPayloadCopyWithImpl<_TokenPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TokenPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TokenPayload&&(identical(other.tokenId, tokenId) || other.tokenId == tokenId)&&(identical(other.location, location) || other.location == location)&&(identical(other.surah, surah) || other.surah == surah)&&(identical(other.ayah, ayah) || other.ayah == ayah)&&(identical(other.word, word) || other.word == word)&&(identical(other.ar, ar) || other.ar == ar)&&(identical(other.translationEn, translationEn) || other.translationEn == translationEn)&&(identical(other.lemmaAr, lemmaAr) || other.lemmaAr == lemmaAr)&&(identical(other.rootAr, rootAr) || other.rootAr == rootAr)&&(identical(other.audioKey, audioKey) || other.audioKey == audioKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tokenId,location,surah,ayah,word,ar,translationEn,lemmaAr,rootAr,audioKey);

@override
String toString() {
  return 'TokenPayload(tokenId: $tokenId, location: $location, surah: $surah, ayah: $ayah, word: $word, ar: $ar, translationEn: $translationEn, lemmaAr: $lemmaAr, rootAr: $rootAr, audioKey: $audioKey)';
}


}

/// @nodoc
abstract mixin class _$TokenPayloadCopyWith<$Res> implements $TokenPayloadCopyWith<$Res> {
  factory _$TokenPayloadCopyWith(_TokenPayload value, $Res Function(_TokenPayload) _then) = __$TokenPayloadCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'token_id') String tokenId, String location, int surah, int ayah, int word, String ar,@JsonKey(name: 'translation_en') String? translationEn,@JsonKey(name: 'lemma_ar') String? lemmaAr,@JsonKey(name: 'root_ar') String? rootAr,@JsonKey(name: 'audio_key') String? audioKey
});




}
/// @nodoc
class __$TokenPayloadCopyWithImpl<$Res>
    implements _$TokenPayloadCopyWith<$Res> {
  __$TokenPayloadCopyWithImpl(this._self, this._then);

  final _TokenPayload _self;
  final $Res Function(_TokenPayload) _then;

/// Create a copy of TokenPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tokenId = null,Object? location = null,Object? surah = null,Object? ayah = null,Object? word = null,Object? ar = null,Object? translationEn = freezed,Object? lemmaAr = freezed,Object? rootAr = freezed,Object? audioKey = freezed,}) {
  return _then(_TokenPayload(
tokenId: null == tokenId ? _self.tokenId : tokenId // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,surah: null == surah ? _self.surah : surah // ignore: cast_nullable_to_non_nullable
as int,ayah: null == ayah ? _self.ayah : ayah // ignore: cast_nullable_to_non_nullable
as int,word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as int,ar: null == ar ? _self.ar : ar // ignore: cast_nullable_to_non_nullable
as String,translationEn: freezed == translationEn ? _self.translationEn : translationEn // ignore: cast_nullable_to_non_nullable
as String?,lemmaAr: freezed == lemmaAr ? _self.lemmaAr : lemmaAr // ignore: cast_nullable_to_non_nullable
as String?,rootAr: freezed == rootAr ? _self.rootAr : rootAr // ignore: cast_nullable_to_non_nullable
as String?,audioKey: freezed == audioKey ? _self.audioKey : audioKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
