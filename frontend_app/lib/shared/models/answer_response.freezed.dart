// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'answer_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnswerResponse {

@JsonKey(name: 'step_index') int get stepIndex;@JsonKey(name: 'is_correct') bool get isCorrect;@JsonKey(name: 'outcome_bucket') String? get outcomeBucket; AnswerFeedback? get feedback;@JsonKey(name: 'progress_update') ProgressUpdate? get progressUpdate;
/// Create a copy of AnswerResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnswerResponseCopyWith<AnswerResponse> get copyWith => _$AnswerResponseCopyWithImpl<AnswerResponse>(this as AnswerResponse, _$identity);

  /// Serializes this AnswerResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnswerResponse&&(identical(other.stepIndex, stepIndex) || other.stepIndex == stepIndex)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.outcomeBucket, outcomeBucket) || other.outcomeBucket == outcomeBucket)&&(identical(other.feedback, feedback) || other.feedback == feedback)&&(identical(other.progressUpdate, progressUpdate) || other.progressUpdate == progressUpdate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stepIndex,isCorrect,outcomeBucket,feedback,progressUpdate);

@override
String toString() {
  return 'AnswerResponse(stepIndex: $stepIndex, isCorrect: $isCorrect, outcomeBucket: $outcomeBucket, feedback: $feedback, progressUpdate: $progressUpdate)';
}


}

/// @nodoc
abstract mixin class $AnswerResponseCopyWith<$Res>  {
  factory $AnswerResponseCopyWith(AnswerResponse value, $Res Function(AnswerResponse) _then) = _$AnswerResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'step_index') int stepIndex,@JsonKey(name: 'is_correct') bool isCorrect,@JsonKey(name: 'outcome_bucket') String? outcomeBucket, AnswerFeedback? feedback,@JsonKey(name: 'progress_update') ProgressUpdate? progressUpdate
});


$AnswerFeedbackCopyWith<$Res>? get feedback;$ProgressUpdateCopyWith<$Res>? get progressUpdate;

}
/// @nodoc
class _$AnswerResponseCopyWithImpl<$Res>
    implements $AnswerResponseCopyWith<$Res> {
  _$AnswerResponseCopyWithImpl(this._self, this._then);

  final AnswerResponse _self;
  final $Res Function(AnswerResponse) _then;

/// Create a copy of AnswerResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stepIndex = null,Object? isCorrect = null,Object? outcomeBucket = freezed,Object? feedback = freezed,Object? progressUpdate = freezed,}) {
  return _then(_self.copyWith(
stepIndex: null == stepIndex ? _self.stepIndex : stepIndex // ignore: cast_nullable_to_non_nullable
as int,isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,outcomeBucket: freezed == outcomeBucket ? _self.outcomeBucket : outcomeBucket // ignore: cast_nullable_to_non_nullable
as String?,feedback: freezed == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as AnswerFeedback?,progressUpdate: freezed == progressUpdate ? _self.progressUpdate : progressUpdate // ignore: cast_nullable_to_non_nullable
as ProgressUpdate?,
  ));
}
/// Create a copy of AnswerResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnswerFeedbackCopyWith<$Res>? get feedback {
    if (_self.feedback == null) {
    return null;
  }

  return $AnswerFeedbackCopyWith<$Res>(_self.feedback!, (value) {
    return _then(_self.copyWith(feedback: value));
  });
}/// Create a copy of AnswerResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProgressUpdateCopyWith<$Res>? get progressUpdate {
    if (_self.progressUpdate == null) {
    return null;
  }

  return $ProgressUpdateCopyWith<$Res>(_self.progressUpdate!, (value) {
    return _then(_self.copyWith(progressUpdate: value));
  });
}
}


/// Adds pattern-matching-related methods to [AnswerResponse].
extension AnswerResponsePatterns on AnswerResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnswerResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnswerResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnswerResponse value)  $default,){
final _that = this;
switch (_that) {
case _AnswerResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnswerResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AnswerResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'step_index')  int stepIndex, @JsonKey(name: 'is_correct')  bool isCorrect, @JsonKey(name: 'outcome_bucket')  String? outcomeBucket,  AnswerFeedback? feedback, @JsonKey(name: 'progress_update')  ProgressUpdate? progressUpdate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnswerResponse() when $default != null:
return $default(_that.stepIndex,_that.isCorrect,_that.outcomeBucket,_that.feedback,_that.progressUpdate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'step_index')  int stepIndex, @JsonKey(name: 'is_correct')  bool isCorrect, @JsonKey(name: 'outcome_bucket')  String? outcomeBucket,  AnswerFeedback? feedback, @JsonKey(name: 'progress_update')  ProgressUpdate? progressUpdate)  $default,) {final _that = this;
switch (_that) {
case _AnswerResponse():
return $default(_that.stepIndex,_that.isCorrect,_that.outcomeBucket,_that.feedback,_that.progressUpdate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'step_index')  int stepIndex, @JsonKey(name: 'is_correct')  bool isCorrect, @JsonKey(name: 'outcome_bucket')  String? outcomeBucket,  AnswerFeedback? feedback, @JsonKey(name: 'progress_update')  ProgressUpdate? progressUpdate)?  $default,) {final _that = this;
switch (_that) {
case _AnswerResponse() when $default != null:
return $default(_that.stepIndex,_that.isCorrect,_that.outcomeBucket,_that.feedback,_that.progressUpdate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnswerResponse implements AnswerResponse {
  const _AnswerResponse({@JsonKey(name: 'step_index') required this.stepIndex, @JsonKey(name: 'is_correct') required this.isCorrect, @JsonKey(name: 'outcome_bucket') this.outcomeBucket, this.feedback, @JsonKey(name: 'progress_update') this.progressUpdate});
  factory _AnswerResponse.fromJson(Map<String, dynamic> json) => _$AnswerResponseFromJson(json);

@override@JsonKey(name: 'step_index') final  int stepIndex;
@override@JsonKey(name: 'is_correct') final  bool isCorrect;
@override@JsonKey(name: 'outcome_bucket') final  String? outcomeBucket;
@override final  AnswerFeedback? feedback;
@override@JsonKey(name: 'progress_update') final  ProgressUpdate? progressUpdate;

/// Create a copy of AnswerResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnswerResponseCopyWith<_AnswerResponse> get copyWith => __$AnswerResponseCopyWithImpl<_AnswerResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnswerResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnswerResponse&&(identical(other.stepIndex, stepIndex) || other.stepIndex == stepIndex)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.outcomeBucket, outcomeBucket) || other.outcomeBucket == outcomeBucket)&&(identical(other.feedback, feedback) || other.feedback == feedback)&&(identical(other.progressUpdate, progressUpdate) || other.progressUpdate == progressUpdate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stepIndex,isCorrect,outcomeBucket,feedback,progressUpdate);

@override
String toString() {
  return 'AnswerResponse(stepIndex: $stepIndex, isCorrect: $isCorrect, outcomeBucket: $outcomeBucket, feedback: $feedback, progressUpdate: $progressUpdate)';
}


}

/// @nodoc
abstract mixin class _$AnswerResponseCopyWith<$Res> implements $AnswerResponseCopyWith<$Res> {
  factory _$AnswerResponseCopyWith(_AnswerResponse value, $Res Function(_AnswerResponse) _then) = __$AnswerResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'step_index') int stepIndex,@JsonKey(name: 'is_correct') bool isCorrect,@JsonKey(name: 'outcome_bucket') String? outcomeBucket, AnswerFeedback? feedback,@JsonKey(name: 'progress_update') ProgressUpdate? progressUpdate
});


@override $AnswerFeedbackCopyWith<$Res>? get feedback;@override $ProgressUpdateCopyWith<$Res>? get progressUpdate;

}
/// @nodoc
class __$AnswerResponseCopyWithImpl<$Res>
    implements _$AnswerResponseCopyWith<$Res> {
  __$AnswerResponseCopyWithImpl(this._self, this._then);

  final _AnswerResponse _self;
  final $Res Function(_AnswerResponse) _then;

/// Create a copy of AnswerResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stepIndex = null,Object? isCorrect = null,Object? outcomeBucket = freezed,Object? feedback = freezed,Object? progressUpdate = freezed,}) {
  return _then(_AnswerResponse(
stepIndex: null == stepIndex ? _self.stepIndex : stepIndex // ignore: cast_nullable_to_non_nullable
as int,isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,outcomeBucket: freezed == outcomeBucket ? _self.outcomeBucket : outcomeBucket // ignore: cast_nullable_to_non_nullable
as String?,feedback: freezed == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as AnswerFeedback?,progressUpdate: freezed == progressUpdate ? _self.progressUpdate : progressUpdate // ignore: cast_nullable_to_non_nullable
as ProgressUpdate?,
  ));
}

/// Create a copy of AnswerResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnswerFeedbackCopyWith<$Res>? get feedback {
    if (_self.feedback == null) {
    return null;
  }

  return $AnswerFeedbackCopyWith<$Res>(_self.feedback!, (value) {
    return _then(_self.copyWith(feedback: value));
  });
}/// Create a copy of AnswerResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProgressUpdateCopyWith<$Res>? get progressUpdate {
    if (_self.progressUpdate == null) {
    return null;
  }

  return $ProgressUpdateCopyWith<$Res>(_self.progressUpdate!, (value) {
    return _then(_self.copyWith(progressUpdate: value));
  });
}
}


/// @nodoc
mixin _$AnswerFeedback {

 String get type; String get message;
/// Create a copy of AnswerFeedback
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnswerFeedbackCopyWith<AnswerFeedback> get copyWith => _$AnswerFeedbackCopyWithImpl<AnswerFeedback>(this as AnswerFeedback, _$identity);

  /// Serializes this AnswerFeedback to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnswerFeedback&&(identical(other.type, type) || other.type == type)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,message);

@override
String toString() {
  return 'AnswerFeedback(type: $type, message: $message)';
}


}

/// @nodoc
abstract mixin class $AnswerFeedbackCopyWith<$Res>  {
  factory $AnswerFeedbackCopyWith(AnswerFeedback value, $Res Function(AnswerFeedback) _then) = _$AnswerFeedbackCopyWithImpl;
@useResult
$Res call({
 String type, String message
});




}
/// @nodoc
class _$AnswerFeedbackCopyWithImpl<$Res>
    implements $AnswerFeedbackCopyWith<$Res> {
  _$AnswerFeedbackCopyWithImpl(this._self, this._then);

  final AnswerFeedback _self;
  final $Res Function(AnswerFeedback) _then;

/// Create a copy of AnswerFeedback
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? message = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AnswerFeedback].
extension AnswerFeedbackPatterns on AnswerFeedback {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnswerFeedback value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnswerFeedback() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnswerFeedback value)  $default,){
final _that = this;
switch (_that) {
case _AnswerFeedback():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnswerFeedback value)?  $default,){
final _that = this;
switch (_that) {
case _AnswerFeedback() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnswerFeedback() when $default != null:
return $default(_that.type,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String message)  $default,) {final _that = this;
switch (_that) {
case _AnswerFeedback():
return $default(_that.type,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String message)?  $default,) {final _that = this;
switch (_that) {
case _AnswerFeedback() when $default != null:
return $default(_that.type,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnswerFeedback implements AnswerFeedback {
  const _AnswerFeedback({required this.type, required this.message});
  factory _AnswerFeedback.fromJson(Map<String, dynamic> json) => _$AnswerFeedbackFromJson(json);

@override final  String type;
@override final  String message;

/// Create a copy of AnswerFeedback
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnswerFeedbackCopyWith<_AnswerFeedback> get copyWith => __$AnswerFeedbackCopyWithImpl<_AnswerFeedback>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnswerFeedbackToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnswerFeedback&&(identical(other.type, type) || other.type == type)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,message);

@override
String toString() {
  return 'AnswerFeedback(type: $type, message: $message)';
}


}

/// @nodoc
abstract mixin class _$AnswerFeedbackCopyWith<$Res> implements $AnswerFeedbackCopyWith<$Res> {
  factory _$AnswerFeedbackCopyWith(_AnswerFeedback value, $Res Function(_AnswerFeedback) _then) = __$AnswerFeedbackCopyWithImpl;
@override @useResult
$Res call({
 String type, String message
});




}
/// @nodoc
class __$AnswerFeedbackCopyWithImpl<$Res>
    implements _$AnswerFeedbackCopyWith<$Res> {
  __$AnswerFeedbackCopyWithImpl(this._self, this._then);

  final _AnswerFeedback _self;
  final $Res Function(_AnswerFeedback) _then;

/// Create a copy of AnswerFeedback
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? message = null,}) {
  return _then(_AnswerFeedback(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ProgressUpdate {

@JsonKey(name: 'token_id') String get tokenId;@JsonKey(name: 'new_state') String? get newState; double? get stability;@JsonKey(name: 'next_review_at') String? get nextReviewAt;
/// Create a copy of ProgressUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgressUpdateCopyWith<ProgressUpdate> get copyWith => _$ProgressUpdateCopyWithImpl<ProgressUpdate>(this as ProgressUpdate, _$identity);

  /// Serializes this ProgressUpdate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgressUpdate&&(identical(other.tokenId, tokenId) || other.tokenId == tokenId)&&(identical(other.newState, newState) || other.newState == newState)&&(identical(other.stability, stability) || other.stability == stability)&&(identical(other.nextReviewAt, nextReviewAt) || other.nextReviewAt == nextReviewAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tokenId,newState,stability,nextReviewAt);

@override
String toString() {
  return 'ProgressUpdate(tokenId: $tokenId, newState: $newState, stability: $stability, nextReviewAt: $nextReviewAt)';
}


}

/// @nodoc
abstract mixin class $ProgressUpdateCopyWith<$Res>  {
  factory $ProgressUpdateCopyWith(ProgressUpdate value, $Res Function(ProgressUpdate) _then) = _$ProgressUpdateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'token_id') String tokenId,@JsonKey(name: 'new_state') String? newState, double? stability,@JsonKey(name: 'next_review_at') String? nextReviewAt
});




}
/// @nodoc
class _$ProgressUpdateCopyWithImpl<$Res>
    implements $ProgressUpdateCopyWith<$Res> {
  _$ProgressUpdateCopyWithImpl(this._self, this._then);

  final ProgressUpdate _self;
  final $Res Function(ProgressUpdate) _then;

/// Create a copy of ProgressUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tokenId = null,Object? newState = freezed,Object? stability = freezed,Object? nextReviewAt = freezed,}) {
  return _then(_self.copyWith(
tokenId: null == tokenId ? _self.tokenId : tokenId // ignore: cast_nullable_to_non_nullable
as String,newState: freezed == newState ? _self.newState : newState // ignore: cast_nullable_to_non_nullable
as String?,stability: freezed == stability ? _self.stability : stability // ignore: cast_nullable_to_non_nullable
as double?,nextReviewAt: freezed == nextReviewAt ? _self.nextReviewAt : nextReviewAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProgressUpdate].
extension ProgressUpdatePatterns on ProgressUpdate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgressUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgressUpdate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgressUpdate value)  $default,){
final _that = this;
switch (_that) {
case _ProgressUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgressUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _ProgressUpdate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'token_id')  String tokenId, @JsonKey(name: 'new_state')  String? newState,  double? stability, @JsonKey(name: 'next_review_at')  String? nextReviewAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgressUpdate() when $default != null:
return $default(_that.tokenId,_that.newState,_that.stability,_that.nextReviewAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'token_id')  String tokenId, @JsonKey(name: 'new_state')  String? newState,  double? stability, @JsonKey(name: 'next_review_at')  String? nextReviewAt)  $default,) {final _that = this;
switch (_that) {
case _ProgressUpdate():
return $default(_that.tokenId,_that.newState,_that.stability,_that.nextReviewAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'token_id')  String tokenId, @JsonKey(name: 'new_state')  String? newState,  double? stability, @JsonKey(name: 'next_review_at')  String? nextReviewAt)?  $default,) {final _that = this;
switch (_that) {
case _ProgressUpdate() when $default != null:
return $default(_that.tokenId,_that.newState,_that.stability,_that.nextReviewAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProgressUpdate implements ProgressUpdate {
  const _ProgressUpdate({@JsonKey(name: 'token_id') required this.tokenId, @JsonKey(name: 'new_state') this.newState, this.stability, @JsonKey(name: 'next_review_at') this.nextReviewAt});
  factory _ProgressUpdate.fromJson(Map<String, dynamic> json) => _$ProgressUpdateFromJson(json);

@override@JsonKey(name: 'token_id') final  String tokenId;
@override@JsonKey(name: 'new_state') final  String? newState;
@override final  double? stability;
@override@JsonKey(name: 'next_review_at') final  String? nextReviewAt;

/// Create a copy of ProgressUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgressUpdateCopyWith<_ProgressUpdate> get copyWith => __$ProgressUpdateCopyWithImpl<_ProgressUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProgressUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgressUpdate&&(identical(other.tokenId, tokenId) || other.tokenId == tokenId)&&(identical(other.newState, newState) || other.newState == newState)&&(identical(other.stability, stability) || other.stability == stability)&&(identical(other.nextReviewAt, nextReviewAt) || other.nextReviewAt == nextReviewAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tokenId,newState,stability,nextReviewAt);

@override
String toString() {
  return 'ProgressUpdate(tokenId: $tokenId, newState: $newState, stability: $stability, nextReviewAt: $nextReviewAt)';
}


}

/// @nodoc
abstract mixin class _$ProgressUpdateCopyWith<$Res> implements $ProgressUpdateCopyWith<$Res> {
  factory _$ProgressUpdateCopyWith(_ProgressUpdate value, $Res Function(_ProgressUpdate) _then) = __$ProgressUpdateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'token_id') String tokenId,@JsonKey(name: 'new_state') String? newState, double? stability,@JsonKey(name: 'next_review_at') String? nextReviewAt
});




}
/// @nodoc
class __$ProgressUpdateCopyWithImpl<$Res>
    implements _$ProgressUpdateCopyWith<$Res> {
  __$ProgressUpdateCopyWithImpl(this._self, this._then);

  final _ProgressUpdate _self;
  final $Res Function(_ProgressUpdate) _then;

/// Create a copy of ProgressUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tokenId = null,Object? newState = freezed,Object? stability = freezed,Object? nextReviewAt = freezed,}) {
  return _then(_ProgressUpdate(
tokenId: null == tokenId ? _self.tokenId : tokenId // ignore: cast_nullable_to_non_nullable
as String,newState: freezed == newState ? _self.newState : newState // ignore: cast_nullable_to_non_nullable
as String?,stability: freezed == stability ? _self.stability : stability // ignore: cast_nullable_to_non_nullable
as double?,nextReviewAt: freezed == nextReviewAt ? _self.nextReviewAt : nextReviewAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
