// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_complete_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LessonCompleteResponse {

 LessonSummary get summary; EngagementUpdate? get engagement;
/// Create a copy of LessonCompleteResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonCompleteResponseCopyWith<LessonCompleteResponse> get copyWith => _$LessonCompleteResponseCopyWithImpl<LessonCompleteResponse>(this as LessonCompleteResponse, _$identity);

  /// Serializes this LessonCompleteResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonCompleteResponse&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.engagement, engagement) || other.engagement == engagement));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,summary,engagement);

@override
String toString() {
  return 'LessonCompleteResponse(summary: $summary, engagement: $engagement)';
}


}

/// @nodoc
abstract mixin class $LessonCompleteResponseCopyWith<$Res>  {
  factory $LessonCompleteResponseCopyWith(LessonCompleteResponse value, $Res Function(LessonCompleteResponse) _then) = _$LessonCompleteResponseCopyWithImpl;
@useResult
$Res call({
 LessonSummary summary, EngagementUpdate? engagement
});


$LessonSummaryCopyWith<$Res> get summary;$EngagementUpdateCopyWith<$Res>? get engagement;

}
/// @nodoc
class _$LessonCompleteResponseCopyWithImpl<$Res>
    implements $LessonCompleteResponseCopyWith<$Res> {
  _$LessonCompleteResponseCopyWithImpl(this._self, this._then);

  final LessonCompleteResponse _self;
  final $Res Function(LessonCompleteResponse) _then;

/// Create a copy of LessonCompleteResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? summary = null,Object? engagement = freezed,}) {
  return _then(_self.copyWith(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as LessonSummary,engagement: freezed == engagement ? _self.engagement : engagement // ignore: cast_nullable_to_non_nullable
as EngagementUpdate?,
  ));
}
/// Create a copy of LessonCompleteResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonSummaryCopyWith<$Res> get summary {
  
  return $LessonSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}/// Create a copy of LessonCompleteResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EngagementUpdateCopyWith<$Res>? get engagement {
    if (_self.engagement == null) {
    return null;
  }

  return $EngagementUpdateCopyWith<$Res>(_self.engagement!, (value) {
    return _then(_self.copyWith(engagement: value));
  });
}
}


/// Adds pattern-matching-related methods to [LessonCompleteResponse].
extension LessonCompleteResponsePatterns on LessonCompleteResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonCompleteResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonCompleteResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonCompleteResponse value)  $default,){
final _that = this;
switch (_that) {
case _LessonCompleteResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonCompleteResponse value)?  $default,){
final _that = this;
switch (_that) {
case _LessonCompleteResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LessonSummary summary,  EngagementUpdate? engagement)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonCompleteResponse() when $default != null:
return $default(_that.summary,_that.engagement);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LessonSummary summary,  EngagementUpdate? engagement)  $default,) {final _that = this;
switch (_that) {
case _LessonCompleteResponse():
return $default(_that.summary,_that.engagement);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LessonSummary summary,  EngagementUpdate? engagement)?  $default,) {final _that = this;
switch (_that) {
case _LessonCompleteResponse() when $default != null:
return $default(_that.summary,_that.engagement);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LessonCompleteResponse implements LessonCompleteResponse {
  const _LessonCompleteResponse({required this.summary, this.engagement});
  factory _LessonCompleteResponse.fromJson(Map<String, dynamic> json) => _$LessonCompleteResponseFromJson(json);

@override final  LessonSummary summary;
@override final  EngagementUpdate? engagement;

/// Create a copy of LessonCompleteResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonCompleteResponseCopyWith<_LessonCompleteResponse> get copyWith => __$LessonCompleteResponseCopyWithImpl<_LessonCompleteResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonCompleteResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonCompleteResponse&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.engagement, engagement) || other.engagement == engagement));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,summary,engagement);

@override
String toString() {
  return 'LessonCompleteResponse(summary: $summary, engagement: $engagement)';
}


}

/// @nodoc
abstract mixin class _$LessonCompleteResponseCopyWith<$Res> implements $LessonCompleteResponseCopyWith<$Res> {
  factory _$LessonCompleteResponseCopyWith(_LessonCompleteResponse value, $Res Function(_LessonCompleteResponse) _then) = __$LessonCompleteResponseCopyWithImpl;
@override @useResult
$Res call({
 LessonSummary summary, EngagementUpdate? engagement
});


@override $LessonSummaryCopyWith<$Res> get summary;@override $EngagementUpdateCopyWith<$Res>? get engagement;

}
/// @nodoc
class __$LessonCompleteResponseCopyWithImpl<$Res>
    implements _$LessonCompleteResponseCopyWith<$Res> {
  __$LessonCompleteResponseCopyWithImpl(this._self, this._then);

  final _LessonCompleteResponse _self;
  final $Res Function(_LessonCompleteResponse) _then;

/// Create a copy of LessonCompleteResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? summary = null,Object? engagement = freezed,}) {
  return _then(_LessonCompleteResponse(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as LessonSummary,engagement: freezed == engagement ? _self.engagement : engagement // ignore: cast_nullable_to_non_nullable
as EngagementUpdate?,
  ));
}

/// Create a copy of LessonCompleteResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonSummaryCopyWith<$Res> get summary {
  
  return $LessonSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}/// Create a copy of LessonCompleteResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EngagementUpdateCopyWith<$Res>? get engagement {
    if (_self.engagement == null) {
    return null;
  }

  return $EngagementUpdateCopyWith<$Res>(_self.engagement!, (value) {
    return _then(_self.copyWith(engagement: value));
  });
}
}


/// @nodoc
mixin _$LessonSummary {

@JsonKey(name: 'lesson_id') String get lessonId;@JsonKey(name: 'steps_done') int get stepsDone; double get accuracy;@JsonKey(name: 'new_concepts_learned') int get newConceptsLearned;@JsonKey(name: 'reviews_done') int get reviewsDone;@JsonKey(name: 'ayah_tasks_done') int get ayahTasksDone;
/// Create a copy of LessonSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonSummaryCopyWith<LessonSummary> get copyWith => _$LessonSummaryCopyWithImpl<LessonSummary>(this as LessonSummary, _$identity);

  /// Serializes this LessonSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonSummary&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.stepsDone, stepsDone) || other.stepsDone == stepsDone)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.newConceptsLearned, newConceptsLearned) || other.newConceptsLearned == newConceptsLearned)&&(identical(other.reviewsDone, reviewsDone) || other.reviewsDone == reviewsDone)&&(identical(other.ayahTasksDone, ayahTasksDone) || other.ayahTasksDone == ayahTasksDone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lessonId,stepsDone,accuracy,newConceptsLearned,reviewsDone,ayahTasksDone);

@override
String toString() {
  return 'LessonSummary(lessonId: $lessonId, stepsDone: $stepsDone, accuracy: $accuracy, newConceptsLearned: $newConceptsLearned, reviewsDone: $reviewsDone, ayahTasksDone: $ayahTasksDone)';
}


}

/// @nodoc
abstract mixin class $LessonSummaryCopyWith<$Res>  {
  factory $LessonSummaryCopyWith(LessonSummary value, $Res Function(LessonSummary) _then) = _$LessonSummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'lesson_id') String lessonId,@JsonKey(name: 'steps_done') int stepsDone, double accuracy,@JsonKey(name: 'new_concepts_learned') int newConceptsLearned,@JsonKey(name: 'reviews_done') int reviewsDone,@JsonKey(name: 'ayah_tasks_done') int ayahTasksDone
});




}
/// @nodoc
class _$LessonSummaryCopyWithImpl<$Res>
    implements $LessonSummaryCopyWith<$Res> {
  _$LessonSummaryCopyWithImpl(this._self, this._then);

  final LessonSummary _self;
  final $Res Function(LessonSummary) _then;

/// Create a copy of LessonSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lessonId = null,Object? stepsDone = null,Object? accuracy = null,Object? newConceptsLearned = null,Object? reviewsDone = null,Object? ayahTasksDone = null,}) {
  return _then(_self.copyWith(
lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String,stepsDone: null == stepsDone ? _self.stepsDone : stepsDone // ignore: cast_nullable_to_non_nullable
as int,accuracy: null == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double,newConceptsLearned: null == newConceptsLearned ? _self.newConceptsLearned : newConceptsLearned // ignore: cast_nullable_to_non_nullable
as int,reviewsDone: null == reviewsDone ? _self.reviewsDone : reviewsDone // ignore: cast_nullable_to_non_nullable
as int,ayahTasksDone: null == ayahTasksDone ? _self.ayahTasksDone : ayahTasksDone // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LessonSummary].
extension LessonSummaryPatterns on LessonSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonSummary value)  $default,){
final _that = this;
switch (_that) {
case _LessonSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonSummary value)?  $default,){
final _that = this;
switch (_that) {
case _LessonSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'lesson_id')  String lessonId, @JsonKey(name: 'steps_done')  int stepsDone,  double accuracy, @JsonKey(name: 'new_concepts_learned')  int newConceptsLearned, @JsonKey(name: 'reviews_done')  int reviewsDone, @JsonKey(name: 'ayah_tasks_done')  int ayahTasksDone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonSummary() when $default != null:
return $default(_that.lessonId,_that.stepsDone,_that.accuracy,_that.newConceptsLearned,_that.reviewsDone,_that.ayahTasksDone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'lesson_id')  String lessonId, @JsonKey(name: 'steps_done')  int stepsDone,  double accuracy, @JsonKey(name: 'new_concepts_learned')  int newConceptsLearned, @JsonKey(name: 'reviews_done')  int reviewsDone, @JsonKey(name: 'ayah_tasks_done')  int ayahTasksDone)  $default,) {final _that = this;
switch (_that) {
case _LessonSummary():
return $default(_that.lessonId,_that.stepsDone,_that.accuracy,_that.newConceptsLearned,_that.reviewsDone,_that.ayahTasksDone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'lesson_id')  String lessonId, @JsonKey(name: 'steps_done')  int stepsDone,  double accuracy, @JsonKey(name: 'new_concepts_learned')  int newConceptsLearned, @JsonKey(name: 'reviews_done')  int reviewsDone, @JsonKey(name: 'ayah_tasks_done')  int ayahTasksDone)?  $default,) {final _that = this;
switch (_that) {
case _LessonSummary() when $default != null:
return $default(_that.lessonId,_that.stepsDone,_that.accuracy,_that.newConceptsLearned,_that.reviewsDone,_that.ayahTasksDone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LessonSummary implements LessonSummary {
  const _LessonSummary({@JsonKey(name: 'lesson_id') required this.lessonId, @JsonKey(name: 'steps_done') required this.stepsDone, required this.accuracy, @JsonKey(name: 'new_concepts_learned') this.newConceptsLearned = 0, @JsonKey(name: 'reviews_done') this.reviewsDone = 0, @JsonKey(name: 'ayah_tasks_done') this.ayahTasksDone = 0});
  factory _LessonSummary.fromJson(Map<String, dynamic> json) => _$LessonSummaryFromJson(json);

@override@JsonKey(name: 'lesson_id') final  String lessonId;
@override@JsonKey(name: 'steps_done') final  int stepsDone;
@override final  double accuracy;
@override@JsonKey(name: 'new_concepts_learned') final  int newConceptsLearned;
@override@JsonKey(name: 'reviews_done') final  int reviewsDone;
@override@JsonKey(name: 'ayah_tasks_done') final  int ayahTasksDone;

/// Create a copy of LessonSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonSummaryCopyWith<_LessonSummary> get copyWith => __$LessonSummaryCopyWithImpl<_LessonSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonSummary&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.stepsDone, stepsDone) || other.stepsDone == stepsDone)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.newConceptsLearned, newConceptsLearned) || other.newConceptsLearned == newConceptsLearned)&&(identical(other.reviewsDone, reviewsDone) || other.reviewsDone == reviewsDone)&&(identical(other.ayahTasksDone, ayahTasksDone) || other.ayahTasksDone == ayahTasksDone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lessonId,stepsDone,accuracy,newConceptsLearned,reviewsDone,ayahTasksDone);

@override
String toString() {
  return 'LessonSummary(lessonId: $lessonId, stepsDone: $stepsDone, accuracy: $accuracy, newConceptsLearned: $newConceptsLearned, reviewsDone: $reviewsDone, ayahTasksDone: $ayahTasksDone)';
}


}

/// @nodoc
abstract mixin class _$LessonSummaryCopyWith<$Res> implements $LessonSummaryCopyWith<$Res> {
  factory _$LessonSummaryCopyWith(_LessonSummary value, $Res Function(_LessonSummary) _then) = __$LessonSummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'lesson_id') String lessonId,@JsonKey(name: 'steps_done') int stepsDone, double accuracy,@JsonKey(name: 'new_concepts_learned') int newConceptsLearned,@JsonKey(name: 'reviews_done') int reviewsDone,@JsonKey(name: 'ayah_tasks_done') int ayahTasksDone
});




}
/// @nodoc
class __$LessonSummaryCopyWithImpl<$Res>
    implements _$LessonSummaryCopyWith<$Res> {
  __$LessonSummaryCopyWithImpl(this._self, this._then);

  final _LessonSummary _self;
  final $Res Function(_LessonSummary) _then;

/// Create a copy of LessonSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lessonId = null,Object? stepsDone = null,Object? accuracy = null,Object? newConceptsLearned = null,Object? reviewsDone = null,Object? ayahTasksDone = null,}) {
  return _then(_LessonSummary(
lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String,stepsDone: null == stepsDone ? _self.stepsDone : stepsDone // ignore: cast_nullable_to_non_nullable
as int,accuracy: null == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double,newConceptsLearned: null == newConceptsLearned ? _self.newConceptsLearned : newConceptsLearned // ignore: cast_nullable_to_non_nullable
as int,reviewsDone: null == reviewsDone ? _self.reviewsDone : reviewsDone // ignore: cast_nullable_to_non_nullable
as int,ayahTasksDone: null == ayahTasksDone ? _self.ayahTasksDone : ayahTasksDone // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$EngagementUpdate {

@JsonKey(name: 'streak_updated') bool get streakUpdated;
/// Create a copy of EngagementUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EngagementUpdateCopyWith<EngagementUpdate> get copyWith => _$EngagementUpdateCopyWithImpl<EngagementUpdate>(this as EngagementUpdate, _$identity);

  /// Serializes this EngagementUpdate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EngagementUpdate&&(identical(other.streakUpdated, streakUpdated) || other.streakUpdated == streakUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,streakUpdated);

@override
String toString() {
  return 'EngagementUpdate(streakUpdated: $streakUpdated)';
}


}

/// @nodoc
abstract mixin class $EngagementUpdateCopyWith<$Res>  {
  factory $EngagementUpdateCopyWith(EngagementUpdate value, $Res Function(EngagementUpdate) _then) = _$EngagementUpdateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'streak_updated') bool streakUpdated
});




}
/// @nodoc
class _$EngagementUpdateCopyWithImpl<$Res>
    implements $EngagementUpdateCopyWith<$Res> {
  _$EngagementUpdateCopyWithImpl(this._self, this._then);

  final EngagementUpdate _self;
  final $Res Function(EngagementUpdate) _then;

/// Create a copy of EngagementUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? streakUpdated = null,}) {
  return _then(_self.copyWith(
streakUpdated: null == streakUpdated ? _self.streakUpdated : streakUpdated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [EngagementUpdate].
extension EngagementUpdatePatterns on EngagementUpdate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EngagementUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EngagementUpdate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EngagementUpdate value)  $default,){
final _that = this;
switch (_that) {
case _EngagementUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EngagementUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _EngagementUpdate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'streak_updated')  bool streakUpdated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EngagementUpdate() when $default != null:
return $default(_that.streakUpdated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'streak_updated')  bool streakUpdated)  $default,) {final _that = this;
switch (_that) {
case _EngagementUpdate():
return $default(_that.streakUpdated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'streak_updated')  bool streakUpdated)?  $default,) {final _that = this;
switch (_that) {
case _EngagementUpdate() when $default != null:
return $default(_that.streakUpdated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EngagementUpdate implements EngagementUpdate {
  const _EngagementUpdate({@JsonKey(name: 'streak_updated') this.streakUpdated = false});
  factory _EngagementUpdate.fromJson(Map<String, dynamic> json) => _$EngagementUpdateFromJson(json);

@override@JsonKey(name: 'streak_updated') final  bool streakUpdated;

/// Create a copy of EngagementUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EngagementUpdateCopyWith<_EngagementUpdate> get copyWith => __$EngagementUpdateCopyWithImpl<_EngagementUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EngagementUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EngagementUpdate&&(identical(other.streakUpdated, streakUpdated) || other.streakUpdated == streakUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,streakUpdated);

@override
String toString() {
  return 'EngagementUpdate(streakUpdated: $streakUpdated)';
}


}

/// @nodoc
abstract mixin class _$EngagementUpdateCopyWith<$Res> implements $EngagementUpdateCopyWith<$Res> {
  factory _$EngagementUpdateCopyWith(_EngagementUpdate value, $Res Function(_EngagementUpdate) _then) = __$EngagementUpdateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'streak_updated') bool streakUpdated
});




}
/// @nodoc
class __$EngagementUpdateCopyWithImpl<$Res>
    implements _$EngagementUpdateCopyWith<$Res> {
  __$EngagementUpdateCopyWithImpl(this._self, this._then);

  final _EngagementUpdate _self;
  final $Res Function(_EngagementUpdate) _then;

/// Create a copy of EngagementUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? streakUpdated = null,}) {
  return _then(_EngagementUpdate(
streakUpdated: null == streakUpdated ? _self.streakUpdated : streakUpdated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
