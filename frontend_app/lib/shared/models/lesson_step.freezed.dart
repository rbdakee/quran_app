// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_step.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LessonStep {

@JsonKey(name: 'step_id') String get stepId;@JsonKey(name: 'step_index') int get stepIndex; String get type;@JsonKey(name: 'skill_type') String? get skillType; TokenPayload? get token; List<String>? get options; String? get correct;// ── Ayah Build fields ──
 int? get surah; int? get ayah;@JsonKey(name: 'ayah_segment_index') int? get ayahSegmentIndex;@JsonKey(name: 'gold_order_token_ids') List<String>? get goldOrderTokenIds; List<AyahPoolToken>? get pool;@JsonKey(name: 'prompt_translation_units') List<String>? get promptTranslationUnits;@JsonKey(name: 'prompt_audio_keys') List<String>? get promptAudioKeys;@JsonKey(name: 'prompt_ar_tokens') List<String>? get promptArTokens;
/// Create a copy of LessonStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonStepCopyWith<LessonStep> get copyWith => _$LessonStepCopyWithImpl<LessonStep>(this as LessonStep, _$identity);

  /// Serializes this LessonStep to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonStep&&(identical(other.stepId, stepId) || other.stepId == stepId)&&(identical(other.stepIndex, stepIndex) || other.stepIndex == stepIndex)&&(identical(other.type, type) || other.type == type)&&(identical(other.skillType, skillType) || other.skillType == skillType)&&(identical(other.token, token) || other.token == token)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.surah, surah) || other.surah == surah)&&(identical(other.ayah, ayah) || other.ayah == ayah)&&(identical(other.ayahSegmentIndex, ayahSegmentIndex) || other.ayahSegmentIndex == ayahSegmentIndex)&&const DeepCollectionEquality().equals(other.goldOrderTokenIds, goldOrderTokenIds)&&const DeepCollectionEquality().equals(other.pool, pool)&&const DeepCollectionEquality().equals(other.promptTranslationUnits, promptTranslationUnits)&&const DeepCollectionEquality().equals(other.promptAudioKeys, promptAudioKeys)&&const DeepCollectionEquality().equals(other.promptArTokens, promptArTokens));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stepId,stepIndex,type,skillType,token,const DeepCollectionEquality().hash(options),correct,surah,ayah,ayahSegmentIndex,const DeepCollectionEquality().hash(goldOrderTokenIds),const DeepCollectionEquality().hash(pool),const DeepCollectionEquality().hash(promptTranslationUnits),const DeepCollectionEquality().hash(promptAudioKeys),const DeepCollectionEquality().hash(promptArTokens));

@override
String toString() {
  return 'LessonStep(stepId: $stepId, stepIndex: $stepIndex, type: $type, skillType: $skillType, token: $token, options: $options, correct: $correct, surah: $surah, ayah: $ayah, ayahSegmentIndex: $ayahSegmentIndex, goldOrderTokenIds: $goldOrderTokenIds, pool: $pool, promptTranslationUnits: $promptTranslationUnits, promptAudioKeys: $promptAudioKeys, promptArTokens: $promptArTokens)';
}


}

/// @nodoc
abstract mixin class $LessonStepCopyWith<$Res>  {
  factory $LessonStepCopyWith(LessonStep value, $Res Function(LessonStep) _then) = _$LessonStepCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'step_id') String stepId,@JsonKey(name: 'step_index') int stepIndex, String type,@JsonKey(name: 'skill_type') String? skillType, TokenPayload? token, List<String>? options, String? correct, int? surah, int? ayah,@JsonKey(name: 'ayah_segment_index') int? ayahSegmentIndex,@JsonKey(name: 'gold_order_token_ids') List<String>? goldOrderTokenIds, List<AyahPoolToken>? pool,@JsonKey(name: 'prompt_translation_units') List<String>? promptTranslationUnits,@JsonKey(name: 'prompt_audio_keys') List<String>? promptAudioKeys,@JsonKey(name: 'prompt_ar_tokens') List<String>? promptArTokens
});


$TokenPayloadCopyWith<$Res>? get token;

}
/// @nodoc
class _$LessonStepCopyWithImpl<$Res>
    implements $LessonStepCopyWith<$Res> {
  _$LessonStepCopyWithImpl(this._self, this._then);

  final LessonStep _self;
  final $Res Function(LessonStep) _then;

/// Create a copy of LessonStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stepId = null,Object? stepIndex = null,Object? type = null,Object? skillType = freezed,Object? token = freezed,Object? options = freezed,Object? correct = freezed,Object? surah = freezed,Object? ayah = freezed,Object? ayahSegmentIndex = freezed,Object? goldOrderTokenIds = freezed,Object? pool = freezed,Object? promptTranslationUnits = freezed,Object? promptAudioKeys = freezed,Object? promptArTokens = freezed,}) {
  return _then(_self.copyWith(
stepId: null == stepId ? _self.stepId : stepId // ignore: cast_nullable_to_non_nullable
as String,stepIndex: null == stepIndex ? _self.stepIndex : stepIndex // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,skillType: freezed == skillType ? _self.skillType : skillType // ignore: cast_nullable_to_non_nullable
as String?,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as TokenPayload?,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,correct: freezed == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as String?,surah: freezed == surah ? _self.surah : surah // ignore: cast_nullable_to_non_nullable
as int?,ayah: freezed == ayah ? _self.ayah : ayah // ignore: cast_nullable_to_non_nullable
as int?,ayahSegmentIndex: freezed == ayahSegmentIndex ? _self.ayahSegmentIndex : ayahSegmentIndex // ignore: cast_nullable_to_non_nullable
as int?,goldOrderTokenIds: freezed == goldOrderTokenIds ? _self.goldOrderTokenIds : goldOrderTokenIds // ignore: cast_nullable_to_non_nullable
as List<String>?,pool: freezed == pool ? _self.pool : pool // ignore: cast_nullable_to_non_nullable
as List<AyahPoolToken>?,promptTranslationUnits: freezed == promptTranslationUnits ? _self.promptTranslationUnits : promptTranslationUnits // ignore: cast_nullable_to_non_nullable
as List<String>?,promptAudioKeys: freezed == promptAudioKeys ? _self.promptAudioKeys : promptAudioKeys // ignore: cast_nullable_to_non_nullable
as List<String>?,promptArTokens: freezed == promptArTokens ? _self.promptArTokens : promptArTokens // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}
/// Create a copy of LessonStep
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TokenPayloadCopyWith<$Res>? get token {
    if (_self.token == null) {
    return null;
  }

  return $TokenPayloadCopyWith<$Res>(_self.token!, (value) {
    return _then(_self.copyWith(token: value));
  });
}
}


/// Adds pattern-matching-related methods to [LessonStep].
extension LessonStepPatterns on LessonStep {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonStep value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonStep() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonStep value)  $default,){
final _that = this;
switch (_that) {
case _LessonStep():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonStep value)?  $default,){
final _that = this;
switch (_that) {
case _LessonStep() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'step_id')  String stepId, @JsonKey(name: 'step_index')  int stepIndex,  String type, @JsonKey(name: 'skill_type')  String? skillType,  TokenPayload? token,  List<String>? options,  String? correct,  int? surah,  int? ayah, @JsonKey(name: 'ayah_segment_index')  int? ayahSegmentIndex, @JsonKey(name: 'gold_order_token_ids')  List<String>? goldOrderTokenIds,  List<AyahPoolToken>? pool, @JsonKey(name: 'prompt_translation_units')  List<String>? promptTranslationUnits, @JsonKey(name: 'prompt_audio_keys')  List<String>? promptAudioKeys, @JsonKey(name: 'prompt_ar_tokens')  List<String>? promptArTokens)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonStep() when $default != null:
return $default(_that.stepId,_that.stepIndex,_that.type,_that.skillType,_that.token,_that.options,_that.correct,_that.surah,_that.ayah,_that.ayahSegmentIndex,_that.goldOrderTokenIds,_that.pool,_that.promptTranslationUnits,_that.promptAudioKeys,_that.promptArTokens);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'step_id')  String stepId, @JsonKey(name: 'step_index')  int stepIndex,  String type, @JsonKey(name: 'skill_type')  String? skillType,  TokenPayload? token,  List<String>? options,  String? correct,  int? surah,  int? ayah, @JsonKey(name: 'ayah_segment_index')  int? ayahSegmentIndex, @JsonKey(name: 'gold_order_token_ids')  List<String>? goldOrderTokenIds,  List<AyahPoolToken>? pool, @JsonKey(name: 'prompt_translation_units')  List<String>? promptTranslationUnits, @JsonKey(name: 'prompt_audio_keys')  List<String>? promptAudioKeys, @JsonKey(name: 'prompt_ar_tokens')  List<String>? promptArTokens)  $default,) {final _that = this;
switch (_that) {
case _LessonStep():
return $default(_that.stepId,_that.stepIndex,_that.type,_that.skillType,_that.token,_that.options,_that.correct,_that.surah,_that.ayah,_that.ayahSegmentIndex,_that.goldOrderTokenIds,_that.pool,_that.promptTranslationUnits,_that.promptAudioKeys,_that.promptArTokens);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'step_id')  String stepId, @JsonKey(name: 'step_index')  int stepIndex,  String type, @JsonKey(name: 'skill_type')  String? skillType,  TokenPayload? token,  List<String>? options,  String? correct,  int? surah,  int? ayah, @JsonKey(name: 'ayah_segment_index')  int? ayahSegmentIndex, @JsonKey(name: 'gold_order_token_ids')  List<String>? goldOrderTokenIds,  List<AyahPoolToken>? pool, @JsonKey(name: 'prompt_translation_units')  List<String>? promptTranslationUnits, @JsonKey(name: 'prompt_audio_keys')  List<String>? promptAudioKeys, @JsonKey(name: 'prompt_ar_tokens')  List<String>? promptArTokens)?  $default,) {final _that = this;
switch (_that) {
case _LessonStep() when $default != null:
return $default(_that.stepId,_that.stepIndex,_that.type,_that.skillType,_that.token,_that.options,_that.correct,_that.surah,_that.ayah,_that.ayahSegmentIndex,_that.goldOrderTokenIds,_that.pool,_that.promptTranslationUnits,_that.promptAudioKeys,_that.promptArTokens);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LessonStep implements LessonStep {
  const _LessonStep({@JsonKey(name: 'step_id') required this.stepId, @JsonKey(name: 'step_index') required this.stepIndex, required this.type, @JsonKey(name: 'skill_type') this.skillType, this.token, final  List<String>? options, this.correct, this.surah, this.ayah, @JsonKey(name: 'ayah_segment_index') this.ayahSegmentIndex, @JsonKey(name: 'gold_order_token_ids') final  List<String>? goldOrderTokenIds, final  List<AyahPoolToken>? pool, @JsonKey(name: 'prompt_translation_units') final  List<String>? promptTranslationUnits, @JsonKey(name: 'prompt_audio_keys') final  List<String>? promptAudioKeys, @JsonKey(name: 'prompt_ar_tokens') final  List<String>? promptArTokens}): _options = options,_goldOrderTokenIds = goldOrderTokenIds,_pool = pool,_promptTranslationUnits = promptTranslationUnits,_promptAudioKeys = promptAudioKeys,_promptArTokens = promptArTokens;
  factory _LessonStep.fromJson(Map<String, dynamic> json) => _$LessonStepFromJson(json);

@override@JsonKey(name: 'step_id') final  String stepId;
@override@JsonKey(name: 'step_index') final  int stepIndex;
@override final  String type;
@override@JsonKey(name: 'skill_type') final  String? skillType;
@override final  TokenPayload? token;
 final  List<String>? _options;
@override List<String>? get options {
  final value = _options;
  if (value == null) return null;
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? correct;
// ── Ayah Build fields ──
@override final  int? surah;
@override final  int? ayah;
@override@JsonKey(name: 'ayah_segment_index') final  int? ayahSegmentIndex;
 final  List<String>? _goldOrderTokenIds;
@override@JsonKey(name: 'gold_order_token_ids') List<String>? get goldOrderTokenIds {
  final value = _goldOrderTokenIds;
  if (value == null) return null;
  if (_goldOrderTokenIds is EqualUnmodifiableListView) return _goldOrderTokenIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<AyahPoolToken>? _pool;
@override List<AyahPoolToken>? get pool {
  final value = _pool;
  if (value == null) return null;
  if (_pool is EqualUnmodifiableListView) return _pool;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _promptTranslationUnits;
@override@JsonKey(name: 'prompt_translation_units') List<String>? get promptTranslationUnits {
  final value = _promptTranslationUnits;
  if (value == null) return null;
  if (_promptTranslationUnits is EqualUnmodifiableListView) return _promptTranslationUnits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _promptAudioKeys;
@override@JsonKey(name: 'prompt_audio_keys') List<String>? get promptAudioKeys {
  final value = _promptAudioKeys;
  if (value == null) return null;
  if (_promptAudioKeys is EqualUnmodifiableListView) return _promptAudioKeys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _promptArTokens;
@override@JsonKey(name: 'prompt_ar_tokens') List<String>? get promptArTokens {
  final value = _promptArTokens;
  if (value == null) return null;
  if (_promptArTokens is EqualUnmodifiableListView) return _promptArTokens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of LessonStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonStepCopyWith<_LessonStep> get copyWith => __$LessonStepCopyWithImpl<_LessonStep>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonStepToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonStep&&(identical(other.stepId, stepId) || other.stepId == stepId)&&(identical(other.stepIndex, stepIndex) || other.stepIndex == stepIndex)&&(identical(other.type, type) || other.type == type)&&(identical(other.skillType, skillType) || other.skillType == skillType)&&(identical(other.token, token) || other.token == token)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.surah, surah) || other.surah == surah)&&(identical(other.ayah, ayah) || other.ayah == ayah)&&(identical(other.ayahSegmentIndex, ayahSegmentIndex) || other.ayahSegmentIndex == ayahSegmentIndex)&&const DeepCollectionEquality().equals(other._goldOrderTokenIds, _goldOrderTokenIds)&&const DeepCollectionEquality().equals(other._pool, _pool)&&const DeepCollectionEquality().equals(other._promptTranslationUnits, _promptTranslationUnits)&&const DeepCollectionEquality().equals(other._promptAudioKeys, _promptAudioKeys)&&const DeepCollectionEquality().equals(other._promptArTokens, _promptArTokens));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stepId,stepIndex,type,skillType,token,const DeepCollectionEquality().hash(_options),correct,surah,ayah,ayahSegmentIndex,const DeepCollectionEquality().hash(_goldOrderTokenIds),const DeepCollectionEquality().hash(_pool),const DeepCollectionEquality().hash(_promptTranslationUnits),const DeepCollectionEquality().hash(_promptAudioKeys),const DeepCollectionEquality().hash(_promptArTokens));

@override
String toString() {
  return 'LessonStep(stepId: $stepId, stepIndex: $stepIndex, type: $type, skillType: $skillType, token: $token, options: $options, correct: $correct, surah: $surah, ayah: $ayah, ayahSegmentIndex: $ayahSegmentIndex, goldOrderTokenIds: $goldOrderTokenIds, pool: $pool, promptTranslationUnits: $promptTranslationUnits, promptAudioKeys: $promptAudioKeys, promptArTokens: $promptArTokens)';
}


}

/// @nodoc
abstract mixin class _$LessonStepCopyWith<$Res> implements $LessonStepCopyWith<$Res> {
  factory _$LessonStepCopyWith(_LessonStep value, $Res Function(_LessonStep) _then) = __$LessonStepCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'step_id') String stepId,@JsonKey(name: 'step_index') int stepIndex, String type,@JsonKey(name: 'skill_type') String? skillType, TokenPayload? token, List<String>? options, String? correct, int? surah, int? ayah,@JsonKey(name: 'ayah_segment_index') int? ayahSegmentIndex,@JsonKey(name: 'gold_order_token_ids') List<String>? goldOrderTokenIds, List<AyahPoolToken>? pool,@JsonKey(name: 'prompt_translation_units') List<String>? promptTranslationUnits,@JsonKey(name: 'prompt_audio_keys') List<String>? promptAudioKeys,@JsonKey(name: 'prompt_ar_tokens') List<String>? promptArTokens
});


@override $TokenPayloadCopyWith<$Res>? get token;

}
/// @nodoc
class __$LessonStepCopyWithImpl<$Res>
    implements _$LessonStepCopyWith<$Res> {
  __$LessonStepCopyWithImpl(this._self, this._then);

  final _LessonStep _self;
  final $Res Function(_LessonStep) _then;

/// Create a copy of LessonStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stepId = null,Object? stepIndex = null,Object? type = null,Object? skillType = freezed,Object? token = freezed,Object? options = freezed,Object? correct = freezed,Object? surah = freezed,Object? ayah = freezed,Object? ayahSegmentIndex = freezed,Object? goldOrderTokenIds = freezed,Object? pool = freezed,Object? promptTranslationUnits = freezed,Object? promptAudioKeys = freezed,Object? promptArTokens = freezed,}) {
  return _then(_LessonStep(
stepId: null == stepId ? _self.stepId : stepId // ignore: cast_nullable_to_non_nullable
as String,stepIndex: null == stepIndex ? _self.stepIndex : stepIndex // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,skillType: freezed == skillType ? _self.skillType : skillType // ignore: cast_nullable_to_non_nullable
as String?,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as TokenPayload?,options: freezed == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,correct: freezed == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as String?,surah: freezed == surah ? _self.surah : surah // ignore: cast_nullable_to_non_nullable
as int?,ayah: freezed == ayah ? _self.ayah : ayah // ignore: cast_nullable_to_non_nullable
as int?,ayahSegmentIndex: freezed == ayahSegmentIndex ? _self.ayahSegmentIndex : ayahSegmentIndex // ignore: cast_nullable_to_non_nullable
as int?,goldOrderTokenIds: freezed == goldOrderTokenIds ? _self._goldOrderTokenIds : goldOrderTokenIds // ignore: cast_nullable_to_non_nullable
as List<String>?,pool: freezed == pool ? _self._pool : pool // ignore: cast_nullable_to_non_nullable
as List<AyahPoolToken>?,promptTranslationUnits: freezed == promptTranslationUnits ? _self._promptTranslationUnits : promptTranslationUnits // ignore: cast_nullable_to_non_nullable
as List<String>?,promptAudioKeys: freezed == promptAudioKeys ? _self._promptAudioKeys : promptAudioKeys // ignore: cast_nullable_to_non_nullable
as List<String>?,promptArTokens: freezed == promptArTokens ? _self._promptArTokens : promptArTokens // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

/// Create a copy of LessonStep
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TokenPayloadCopyWith<$Res>? get token {
    if (_self.token == null) {
    return null;
  }

  return $TokenPayloadCopyWith<$Res>(_self.token!, (value) {
    return _then(_self.copyWith(token: value));
  });
}
}


/// @nodoc
mixin _$AyahPoolToken {

@JsonKey(name: 'token_id') String get tokenId; String get text;@JsonKey(name: 'is_distractor') bool get isDistractor;
/// Create a copy of AyahPoolToken
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AyahPoolTokenCopyWith<AyahPoolToken> get copyWith => _$AyahPoolTokenCopyWithImpl<AyahPoolToken>(this as AyahPoolToken, _$identity);

  /// Serializes this AyahPoolToken to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AyahPoolToken&&(identical(other.tokenId, tokenId) || other.tokenId == tokenId)&&(identical(other.text, text) || other.text == text)&&(identical(other.isDistractor, isDistractor) || other.isDistractor == isDistractor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tokenId,text,isDistractor);

@override
String toString() {
  return 'AyahPoolToken(tokenId: $tokenId, text: $text, isDistractor: $isDistractor)';
}


}

/// @nodoc
abstract mixin class $AyahPoolTokenCopyWith<$Res>  {
  factory $AyahPoolTokenCopyWith(AyahPoolToken value, $Res Function(AyahPoolToken) _then) = _$AyahPoolTokenCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'token_id') String tokenId, String text,@JsonKey(name: 'is_distractor') bool isDistractor
});




}
/// @nodoc
class _$AyahPoolTokenCopyWithImpl<$Res>
    implements $AyahPoolTokenCopyWith<$Res> {
  _$AyahPoolTokenCopyWithImpl(this._self, this._then);

  final AyahPoolToken _self;
  final $Res Function(AyahPoolToken) _then;

/// Create a copy of AyahPoolToken
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tokenId = null,Object? text = null,Object? isDistractor = null,}) {
  return _then(_self.copyWith(
tokenId: null == tokenId ? _self.tokenId : tokenId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,isDistractor: null == isDistractor ? _self.isDistractor : isDistractor // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AyahPoolToken].
extension AyahPoolTokenPatterns on AyahPoolToken {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AyahPoolToken value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AyahPoolToken() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AyahPoolToken value)  $default,){
final _that = this;
switch (_that) {
case _AyahPoolToken():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AyahPoolToken value)?  $default,){
final _that = this;
switch (_that) {
case _AyahPoolToken() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'token_id')  String tokenId,  String text, @JsonKey(name: 'is_distractor')  bool isDistractor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AyahPoolToken() when $default != null:
return $default(_that.tokenId,_that.text,_that.isDistractor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'token_id')  String tokenId,  String text, @JsonKey(name: 'is_distractor')  bool isDistractor)  $default,) {final _that = this;
switch (_that) {
case _AyahPoolToken():
return $default(_that.tokenId,_that.text,_that.isDistractor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'token_id')  String tokenId,  String text, @JsonKey(name: 'is_distractor')  bool isDistractor)?  $default,) {final _that = this;
switch (_that) {
case _AyahPoolToken() when $default != null:
return $default(_that.tokenId,_that.text,_that.isDistractor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AyahPoolToken implements AyahPoolToken {
  const _AyahPoolToken({@JsonKey(name: 'token_id') required this.tokenId, required this.text, @JsonKey(name: 'is_distractor') this.isDistractor = false});
  factory _AyahPoolToken.fromJson(Map<String, dynamic> json) => _$AyahPoolTokenFromJson(json);

@override@JsonKey(name: 'token_id') final  String tokenId;
@override final  String text;
@override@JsonKey(name: 'is_distractor') final  bool isDistractor;

/// Create a copy of AyahPoolToken
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AyahPoolTokenCopyWith<_AyahPoolToken> get copyWith => __$AyahPoolTokenCopyWithImpl<_AyahPoolToken>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AyahPoolTokenToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AyahPoolToken&&(identical(other.tokenId, tokenId) || other.tokenId == tokenId)&&(identical(other.text, text) || other.text == text)&&(identical(other.isDistractor, isDistractor) || other.isDistractor == isDistractor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tokenId,text,isDistractor);

@override
String toString() {
  return 'AyahPoolToken(tokenId: $tokenId, text: $text, isDistractor: $isDistractor)';
}


}

/// @nodoc
abstract mixin class _$AyahPoolTokenCopyWith<$Res> implements $AyahPoolTokenCopyWith<$Res> {
  factory _$AyahPoolTokenCopyWith(_AyahPoolToken value, $Res Function(_AyahPoolToken) _then) = __$AyahPoolTokenCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'token_id') String tokenId, String text,@JsonKey(name: 'is_distractor') bool isDistractor
});




}
/// @nodoc
class __$AyahPoolTokenCopyWithImpl<$Res>
    implements _$AyahPoolTokenCopyWith<$Res> {
  __$AyahPoolTokenCopyWithImpl(this._self, this._then);

  final _AyahPoolToken _self;
  final $Res Function(_AyahPoolToken) _then;

/// Create a copy of AyahPoolToken
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tokenId = null,Object? text = null,Object? isDistractor = null,}) {
  return _then(_AyahPoolToken(
tokenId: null == tokenId ? _self.tokenId : tokenId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,isDistractor: null == isDistractor ? _self.isDistractor : isDistractor // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
