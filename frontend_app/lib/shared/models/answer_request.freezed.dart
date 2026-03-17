// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'answer_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnswerRequest {

@JsonKey(name: 'step_index') int get stepIndex;@JsonKey(name: 'step_type') String get stepType;@JsonKey(name: 'token_id') String get tokenId; AnswerBody get answer; AnswerTelemetry? get telemetry;
/// Create a copy of AnswerRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnswerRequestCopyWith<AnswerRequest> get copyWith => _$AnswerRequestCopyWithImpl<AnswerRequest>(this as AnswerRequest, _$identity);

  /// Serializes this AnswerRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnswerRequest&&(identical(other.stepIndex, stepIndex) || other.stepIndex == stepIndex)&&(identical(other.stepType, stepType) || other.stepType == stepType)&&(identical(other.tokenId, tokenId) || other.tokenId == tokenId)&&(identical(other.answer, answer) || other.answer == answer)&&(identical(other.telemetry, telemetry) || other.telemetry == telemetry));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stepIndex,stepType,tokenId,answer,telemetry);

@override
String toString() {
  return 'AnswerRequest(stepIndex: $stepIndex, stepType: $stepType, tokenId: $tokenId, answer: $answer, telemetry: $telemetry)';
}


}

/// @nodoc
abstract mixin class $AnswerRequestCopyWith<$Res>  {
  factory $AnswerRequestCopyWith(AnswerRequest value, $Res Function(AnswerRequest) _then) = _$AnswerRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'step_index') int stepIndex,@JsonKey(name: 'step_type') String stepType,@JsonKey(name: 'token_id') String tokenId, AnswerBody answer, AnswerTelemetry? telemetry
});


$AnswerBodyCopyWith<$Res> get answer;$AnswerTelemetryCopyWith<$Res>? get telemetry;

}
/// @nodoc
class _$AnswerRequestCopyWithImpl<$Res>
    implements $AnswerRequestCopyWith<$Res> {
  _$AnswerRequestCopyWithImpl(this._self, this._then);

  final AnswerRequest _self;
  final $Res Function(AnswerRequest) _then;

/// Create a copy of AnswerRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stepIndex = null,Object? stepType = null,Object? tokenId = null,Object? answer = null,Object? telemetry = freezed,}) {
  return _then(_self.copyWith(
stepIndex: null == stepIndex ? _self.stepIndex : stepIndex // ignore: cast_nullable_to_non_nullable
as int,stepType: null == stepType ? _self.stepType : stepType // ignore: cast_nullable_to_non_nullable
as String,tokenId: null == tokenId ? _self.tokenId : tokenId // ignore: cast_nullable_to_non_nullable
as String,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as AnswerBody,telemetry: freezed == telemetry ? _self.telemetry : telemetry // ignore: cast_nullable_to_non_nullable
as AnswerTelemetry?,
  ));
}
/// Create a copy of AnswerRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnswerBodyCopyWith<$Res> get answer {
  
  return $AnswerBodyCopyWith<$Res>(_self.answer, (value) {
    return _then(_self.copyWith(answer: value));
  });
}/// Create a copy of AnswerRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnswerTelemetryCopyWith<$Res>? get telemetry {
    if (_self.telemetry == null) {
    return null;
  }

  return $AnswerTelemetryCopyWith<$Res>(_self.telemetry!, (value) {
    return _then(_self.copyWith(telemetry: value));
  });
}
}


/// Adds pattern-matching-related methods to [AnswerRequest].
extension AnswerRequestPatterns on AnswerRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnswerRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnswerRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnswerRequest value)  $default,){
final _that = this;
switch (_that) {
case _AnswerRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnswerRequest value)?  $default,){
final _that = this;
switch (_that) {
case _AnswerRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'step_index')  int stepIndex, @JsonKey(name: 'step_type')  String stepType, @JsonKey(name: 'token_id')  String tokenId,  AnswerBody answer,  AnswerTelemetry? telemetry)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnswerRequest() when $default != null:
return $default(_that.stepIndex,_that.stepType,_that.tokenId,_that.answer,_that.telemetry);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'step_index')  int stepIndex, @JsonKey(name: 'step_type')  String stepType, @JsonKey(name: 'token_id')  String tokenId,  AnswerBody answer,  AnswerTelemetry? telemetry)  $default,) {final _that = this;
switch (_that) {
case _AnswerRequest():
return $default(_that.stepIndex,_that.stepType,_that.tokenId,_that.answer,_that.telemetry);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'step_index')  int stepIndex, @JsonKey(name: 'step_type')  String stepType, @JsonKey(name: 'token_id')  String tokenId,  AnswerBody answer,  AnswerTelemetry? telemetry)?  $default,) {final _that = this;
switch (_that) {
case _AnswerRequest() when $default != null:
return $default(_that.stepIndex,_that.stepType,_that.tokenId,_that.answer,_that.telemetry);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnswerRequest implements AnswerRequest {
  const _AnswerRequest({@JsonKey(name: 'step_index') required this.stepIndex, @JsonKey(name: 'step_type') required this.stepType, @JsonKey(name: 'token_id') required this.tokenId, required this.answer, this.telemetry});
  factory _AnswerRequest.fromJson(Map<String, dynamic> json) => _$AnswerRequestFromJson(json);

@override@JsonKey(name: 'step_index') final  int stepIndex;
@override@JsonKey(name: 'step_type') final  String stepType;
@override@JsonKey(name: 'token_id') final  String tokenId;
@override final  AnswerBody answer;
@override final  AnswerTelemetry? telemetry;

/// Create a copy of AnswerRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnswerRequestCopyWith<_AnswerRequest> get copyWith => __$AnswerRequestCopyWithImpl<_AnswerRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnswerRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnswerRequest&&(identical(other.stepIndex, stepIndex) || other.stepIndex == stepIndex)&&(identical(other.stepType, stepType) || other.stepType == stepType)&&(identical(other.tokenId, tokenId) || other.tokenId == tokenId)&&(identical(other.answer, answer) || other.answer == answer)&&(identical(other.telemetry, telemetry) || other.telemetry == telemetry));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stepIndex,stepType,tokenId,answer,telemetry);

@override
String toString() {
  return 'AnswerRequest(stepIndex: $stepIndex, stepType: $stepType, tokenId: $tokenId, answer: $answer, telemetry: $telemetry)';
}


}

/// @nodoc
abstract mixin class _$AnswerRequestCopyWith<$Res> implements $AnswerRequestCopyWith<$Res> {
  factory _$AnswerRequestCopyWith(_AnswerRequest value, $Res Function(_AnswerRequest) _then) = __$AnswerRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'step_index') int stepIndex,@JsonKey(name: 'step_type') String stepType,@JsonKey(name: 'token_id') String tokenId, AnswerBody answer, AnswerTelemetry? telemetry
});


@override $AnswerBodyCopyWith<$Res> get answer;@override $AnswerTelemetryCopyWith<$Res>? get telemetry;

}
/// @nodoc
class __$AnswerRequestCopyWithImpl<$Res>
    implements _$AnswerRequestCopyWith<$Res> {
  __$AnswerRequestCopyWithImpl(this._self, this._then);

  final _AnswerRequest _self;
  final $Res Function(_AnswerRequest) _then;

/// Create a copy of AnswerRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stepIndex = null,Object? stepType = null,Object? tokenId = null,Object? answer = null,Object? telemetry = freezed,}) {
  return _then(_AnswerRequest(
stepIndex: null == stepIndex ? _self.stepIndex : stepIndex // ignore: cast_nullable_to_non_nullable
as int,stepType: null == stepType ? _self.stepType : stepType // ignore: cast_nullable_to_non_nullable
as String,tokenId: null == tokenId ? _self.tokenId : tokenId // ignore: cast_nullable_to_non_nullable
as String,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as AnswerBody,telemetry: freezed == telemetry ? _self.telemetry : telemetry // ignore: cast_nullable_to_non_nullable
as AnswerTelemetry?,
  ));
}

/// Create a copy of AnswerRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnswerBodyCopyWith<$Res> get answer {
  
  return $AnswerBodyCopyWith<$Res>(_self.answer, (value) {
    return _then(_self.copyWith(answer: value));
  });
}/// Create a copy of AnswerRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnswerTelemetryCopyWith<$Res>? get telemetry {
    if (_self.telemetry == null) {
    return null;
  }

  return $AnswerTelemetryCopyWith<$Res>(_self.telemetry!, (value) {
    return _then(_self.copyWith(telemetry: value));
  });
}
}


/// @nodoc
mixin _$AnswerBody {

@JsonKey(name: 'selected_option') String? get selectedOption;@JsonKey(name: 'ordered_token_ids') List<String>? get orderedTokenIds; bool? get acknowledged;
/// Create a copy of AnswerBody
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnswerBodyCopyWith<AnswerBody> get copyWith => _$AnswerBodyCopyWithImpl<AnswerBody>(this as AnswerBody, _$identity);

  /// Serializes this AnswerBody to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnswerBody&&(identical(other.selectedOption, selectedOption) || other.selectedOption == selectedOption)&&const DeepCollectionEquality().equals(other.orderedTokenIds, orderedTokenIds)&&(identical(other.acknowledged, acknowledged) || other.acknowledged == acknowledged));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,selectedOption,const DeepCollectionEquality().hash(orderedTokenIds),acknowledged);

@override
String toString() {
  return 'AnswerBody(selectedOption: $selectedOption, orderedTokenIds: $orderedTokenIds, acknowledged: $acknowledged)';
}


}

/// @nodoc
abstract mixin class $AnswerBodyCopyWith<$Res>  {
  factory $AnswerBodyCopyWith(AnswerBody value, $Res Function(AnswerBody) _then) = _$AnswerBodyCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'selected_option') String? selectedOption,@JsonKey(name: 'ordered_token_ids') List<String>? orderedTokenIds, bool? acknowledged
});




}
/// @nodoc
class _$AnswerBodyCopyWithImpl<$Res>
    implements $AnswerBodyCopyWith<$Res> {
  _$AnswerBodyCopyWithImpl(this._self, this._then);

  final AnswerBody _self;
  final $Res Function(AnswerBody) _then;

/// Create a copy of AnswerBody
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedOption = freezed,Object? orderedTokenIds = freezed,Object? acknowledged = freezed,}) {
  return _then(_self.copyWith(
selectedOption: freezed == selectedOption ? _self.selectedOption : selectedOption // ignore: cast_nullable_to_non_nullable
as String?,orderedTokenIds: freezed == orderedTokenIds ? _self.orderedTokenIds : orderedTokenIds // ignore: cast_nullable_to_non_nullable
as List<String>?,acknowledged: freezed == acknowledged ? _self.acknowledged : acknowledged // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [AnswerBody].
extension AnswerBodyPatterns on AnswerBody {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnswerBody value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnswerBody() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnswerBody value)  $default,){
final _that = this;
switch (_that) {
case _AnswerBody():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnswerBody value)?  $default,){
final _that = this;
switch (_that) {
case _AnswerBody() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'selected_option')  String? selectedOption, @JsonKey(name: 'ordered_token_ids')  List<String>? orderedTokenIds,  bool? acknowledged)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnswerBody() when $default != null:
return $default(_that.selectedOption,_that.orderedTokenIds,_that.acknowledged);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'selected_option')  String? selectedOption, @JsonKey(name: 'ordered_token_ids')  List<String>? orderedTokenIds,  bool? acknowledged)  $default,) {final _that = this;
switch (_that) {
case _AnswerBody():
return $default(_that.selectedOption,_that.orderedTokenIds,_that.acknowledged);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'selected_option')  String? selectedOption, @JsonKey(name: 'ordered_token_ids')  List<String>? orderedTokenIds,  bool? acknowledged)?  $default,) {final _that = this;
switch (_that) {
case _AnswerBody() when $default != null:
return $default(_that.selectedOption,_that.orderedTokenIds,_that.acknowledged);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnswerBody implements AnswerBody {
  const _AnswerBody({@JsonKey(name: 'selected_option') this.selectedOption, @JsonKey(name: 'ordered_token_ids') final  List<String>? orderedTokenIds, this.acknowledged}): _orderedTokenIds = orderedTokenIds;
  factory _AnswerBody.fromJson(Map<String, dynamic> json) => _$AnswerBodyFromJson(json);

@override@JsonKey(name: 'selected_option') final  String? selectedOption;
 final  List<String>? _orderedTokenIds;
@override@JsonKey(name: 'ordered_token_ids') List<String>? get orderedTokenIds {
  final value = _orderedTokenIds;
  if (value == null) return null;
  if (_orderedTokenIds is EqualUnmodifiableListView) return _orderedTokenIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  bool? acknowledged;

/// Create a copy of AnswerBody
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnswerBodyCopyWith<_AnswerBody> get copyWith => __$AnswerBodyCopyWithImpl<_AnswerBody>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnswerBodyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnswerBody&&(identical(other.selectedOption, selectedOption) || other.selectedOption == selectedOption)&&const DeepCollectionEquality().equals(other._orderedTokenIds, _orderedTokenIds)&&(identical(other.acknowledged, acknowledged) || other.acknowledged == acknowledged));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,selectedOption,const DeepCollectionEquality().hash(_orderedTokenIds),acknowledged);

@override
String toString() {
  return 'AnswerBody(selectedOption: $selectedOption, orderedTokenIds: $orderedTokenIds, acknowledged: $acknowledged)';
}


}

/// @nodoc
abstract mixin class _$AnswerBodyCopyWith<$Res> implements $AnswerBodyCopyWith<$Res> {
  factory _$AnswerBodyCopyWith(_AnswerBody value, $Res Function(_AnswerBody) _then) = __$AnswerBodyCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'selected_option') String? selectedOption,@JsonKey(name: 'ordered_token_ids') List<String>? orderedTokenIds, bool? acknowledged
});




}
/// @nodoc
class __$AnswerBodyCopyWithImpl<$Res>
    implements _$AnswerBodyCopyWith<$Res> {
  __$AnswerBodyCopyWithImpl(this._self, this._then);

  final _AnswerBody _self;
  final $Res Function(_AnswerBody) _then;

/// Create a copy of AnswerBody
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedOption = freezed,Object? orderedTokenIds = freezed,Object? acknowledged = freezed,}) {
  return _then(_AnswerBody(
selectedOption: freezed == selectedOption ? _self.selectedOption : selectedOption // ignore: cast_nullable_to_non_nullable
as String?,orderedTokenIds: freezed == orderedTokenIds ? _self._orderedTokenIds : orderedTokenIds // ignore: cast_nullable_to_non_nullable
as List<String>?,acknowledged: freezed == acknowledged ? _self.acknowledged : acknowledged // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$AnswerTelemetry {

@JsonKey(name: 'latency_ms') int? get latencyMs;@JsonKey(name: 'attempt_count') int get attemptCount;@JsonKey(name: 'used_hint') bool get usedHint;@JsonKey(name: 'client_ts') String? get clientTs;
/// Create a copy of AnswerTelemetry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnswerTelemetryCopyWith<AnswerTelemetry> get copyWith => _$AnswerTelemetryCopyWithImpl<AnswerTelemetry>(this as AnswerTelemetry, _$identity);

  /// Serializes this AnswerTelemetry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnswerTelemetry&&(identical(other.latencyMs, latencyMs) || other.latencyMs == latencyMs)&&(identical(other.attemptCount, attemptCount) || other.attemptCount == attemptCount)&&(identical(other.usedHint, usedHint) || other.usedHint == usedHint)&&(identical(other.clientTs, clientTs) || other.clientTs == clientTs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latencyMs,attemptCount,usedHint,clientTs);

@override
String toString() {
  return 'AnswerTelemetry(latencyMs: $latencyMs, attemptCount: $attemptCount, usedHint: $usedHint, clientTs: $clientTs)';
}


}

/// @nodoc
abstract mixin class $AnswerTelemetryCopyWith<$Res>  {
  factory $AnswerTelemetryCopyWith(AnswerTelemetry value, $Res Function(AnswerTelemetry) _then) = _$AnswerTelemetryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'latency_ms') int? latencyMs,@JsonKey(name: 'attempt_count') int attemptCount,@JsonKey(name: 'used_hint') bool usedHint,@JsonKey(name: 'client_ts') String? clientTs
});




}
/// @nodoc
class _$AnswerTelemetryCopyWithImpl<$Res>
    implements $AnswerTelemetryCopyWith<$Res> {
  _$AnswerTelemetryCopyWithImpl(this._self, this._then);

  final AnswerTelemetry _self;
  final $Res Function(AnswerTelemetry) _then;

/// Create a copy of AnswerTelemetry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latencyMs = freezed,Object? attemptCount = null,Object? usedHint = null,Object? clientTs = freezed,}) {
  return _then(_self.copyWith(
latencyMs: freezed == latencyMs ? _self.latencyMs : latencyMs // ignore: cast_nullable_to_non_nullable
as int?,attemptCount: null == attemptCount ? _self.attemptCount : attemptCount // ignore: cast_nullable_to_non_nullable
as int,usedHint: null == usedHint ? _self.usedHint : usedHint // ignore: cast_nullable_to_non_nullable
as bool,clientTs: freezed == clientTs ? _self.clientTs : clientTs // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AnswerTelemetry].
extension AnswerTelemetryPatterns on AnswerTelemetry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnswerTelemetry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnswerTelemetry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnswerTelemetry value)  $default,){
final _that = this;
switch (_that) {
case _AnswerTelemetry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnswerTelemetry value)?  $default,){
final _that = this;
switch (_that) {
case _AnswerTelemetry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'latency_ms')  int? latencyMs, @JsonKey(name: 'attempt_count')  int attemptCount, @JsonKey(name: 'used_hint')  bool usedHint, @JsonKey(name: 'client_ts')  String? clientTs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnswerTelemetry() when $default != null:
return $default(_that.latencyMs,_that.attemptCount,_that.usedHint,_that.clientTs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'latency_ms')  int? latencyMs, @JsonKey(name: 'attempt_count')  int attemptCount, @JsonKey(name: 'used_hint')  bool usedHint, @JsonKey(name: 'client_ts')  String? clientTs)  $default,) {final _that = this;
switch (_that) {
case _AnswerTelemetry():
return $default(_that.latencyMs,_that.attemptCount,_that.usedHint,_that.clientTs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'latency_ms')  int? latencyMs, @JsonKey(name: 'attempt_count')  int attemptCount, @JsonKey(name: 'used_hint')  bool usedHint, @JsonKey(name: 'client_ts')  String? clientTs)?  $default,) {final _that = this;
switch (_that) {
case _AnswerTelemetry() when $default != null:
return $default(_that.latencyMs,_that.attemptCount,_that.usedHint,_that.clientTs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnswerTelemetry implements AnswerTelemetry {
  const _AnswerTelemetry({@JsonKey(name: 'latency_ms') this.latencyMs, @JsonKey(name: 'attempt_count') this.attemptCount = 1, @JsonKey(name: 'used_hint') this.usedHint = false, @JsonKey(name: 'client_ts') this.clientTs});
  factory _AnswerTelemetry.fromJson(Map<String, dynamic> json) => _$AnswerTelemetryFromJson(json);

@override@JsonKey(name: 'latency_ms') final  int? latencyMs;
@override@JsonKey(name: 'attempt_count') final  int attemptCount;
@override@JsonKey(name: 'used_hint') final  bool usedHint;
@override@JsonKey(name: 'client_ts') final  String? clientTs;

/// Create a copy of AnswerTelemetry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnswerTelemetryCopyWith<_AnswerTelemetry> get copyWith => __$AnswerTelemetryCopyWithImpl<_AnswerTelemetry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnswerTelemetryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnswerTelemetry&&(identical(other.latencyMs, latencyMs) || other.latencyMs == latencyMs)&&(identical(other.attemptCount, attemptCount) || other.attemptCount == attemptCount)&&(identical(other.usedHint, usedHint) || other.usedHint == usedHint)&&(identical(other.clientTs, clientTs) || other.clientTs == clientTs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latencyMs,attemptCount,usedHint,clientTs);

@override
String toString() {
  return 'AnswerTelemetry(latencyMs: $latencyMs, attemptCount: $attemptCount, usedHint: $usedHint, clientTs: $clientTs)';
}


}

/// @nodoc
abstract mixin class _$AnswerTelemetryCopyWith<$Res> implements $AnswerTelemetryCopyWith<$Res> {
  factory _$AnswerTelemetryCopyWith(_AnswerTelemetry value, $Res Function(_AnswerTelemetry) _then) = __$AnswerTelemetryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'latency_ms') int? latencyMs,@JsonKey(name: 'attempt_count') int attemptCount,@JsonKey(name: 'used_hint') bool usedHint,@JsonKey(name: 'client_ts') String? clientTs
});




}
/// @nodoc
class __$AnswerTelemetryCopyWithImpl<$Res>
    implements _$AnswerTelemetryCopyWith<$Res> {
  __$AnswerTelemetryCopyWithImpl(this._self, this._then);

  final _AnswerTelemetry _self;
  final $Res Function(_AnswerTelemetry) _then;

/// Create a copy of AnswerTelemetry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latencyMs = freezed,Object? attemptCount = null,Object? usedHint = null,Object? clientTs = freezed,}) {
  return _then(_AnswerTelemetry(
latencyMs: freezed == latencyMs ? _self.latencyMs : latencyMs // ignore: cast_nullable_to_non_nullable
as int?,attemptCount: null == attemptCount ? _self.attemptCount : attemptCount // ignore: cast_nullable_to_non_nullable
as int,usedHint: null == usedHint ? _self.usedHint : usedHint // ignore: cast_nullable_to_non_nullable
as bool,clientTs: freezed == clientTs ? _self.clientTs : clientTs // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
