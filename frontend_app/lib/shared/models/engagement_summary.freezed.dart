// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'engagement_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EngagementSummary {

@JsonKey(name: 'current_streak_days') int get currentStreakDays;@JsonKey(name: 'best_streak_days') int get bestStreakDays;@JsonKey(name: 'lessons_completed_total') int get lessonsCompletedTotal;@JsonKey(name: 'days_active_30d') int get daysActive30d;@JsonKey(name: 'last_active_at') String? get lastActiveAt;
/// Create a copy of EngagementSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EngagementSummaryCopyWith<EngagementSummary> get copyWith => _$EngagementSummaryCopyWithImpl<EngagementSummary>(this as EngagementSummary, _$identity);

  /// Serializes this EngagementSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EngagementSummary&&(identical(other.currentStreakDays, currentStreakDays) || other.currentStreakDays == currentStreakDays)&&(identical(other.bestStreakDays, bestStreakDays) || other.bestStreakDays == bestStreakDays)&&(identical(other.lessonsCompletedTotal, lessonsCompletedTotal) || other.lessonsCompletedTotal == lessonsCompletedTotal)&&(identical(other.daysActive30d, daysActive30d) || other.daysActive30d == daysActive30d)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentStreakDays,bestStreakDays,lessonsCompletedTotal,daysActive30d,lastActiveAt);

@override
String toString() {
  return 'EngagementSummary(currentStreakDays: $currentStreakDays, bestStreakDays: $bestStreakDays, lessonsCompletedTotal: $lessonsCompletedTotal, daysActive30d: $daysActive30d, lastActiveAt: $lastActiveAt)';
}


}

/// @nodoc
abstract mixin class $EngagementSummaryCopyWith<$Res>  {
  factory $EngagementSummaryCopyWith(EngagementSummary value, $Res Function(EngagementSummary) _then) = _$EngagementSummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'current_streak_days') int currentStreakDays,@JsonKey(name: 'best_streak_days') int bestStreakDays,@JsonKey(name: 'lessons_completed_total') int lessonsCompletedTotal,@JsonKey(name: 'days_active_30d') int daysActive30d,@JsonKey(name: 'last_active_at') String? lastActiveAt
});




}
/// @nodoc
class _$EngagementSummaryCopyWithImpl<$Res>
    implements $EngagementSummaryCopyWith<$Res> {
  _$EngagementSummaryCopyWithImpl(this._self, this._then);

  final EngagementSummary _self;
  final $Res Function(EngagementSummary) _then;

/// Create a copy of EngagementSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentStreakDays = null,Object? bestStreakDays = null,Object? lessonsCompletedTotal = null,Object? daysActive30d = null,Object? lastActiveAt = freezed,}) {
  return _then(_self.copyWith(
currentStreakDays: null == currentStreakDays ? _self.currentStreakDays : currentStreakDays // ignore: cast_nullable_to_non_nullable
as int,bestStreakDays: null == bestStreakDays ? _self.bestStreakDays : bestStreakDays // ignore: cast_nullable_to_non_nullable
as int,lessonsCompletedTotal: null == lessonsCompletedTotal ? _self.lessonsCompletedTotal : lessonsCompletedTotal // ignore: cast_nullable_to_non_nullable
as int,daysActive30d: null == daysActive30d ? _self.daysActive30d : daysActive30d // ignore: cast_nullable_to_non_nullable
as int,lastActiveAt: freezed == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EngagementSummary].
extension EngagementSummaryPatterns on EngagementSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EngagementSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EngagementSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EngagementSummary value)  $default,){
final _that = this;
switch (_that) {
case _EngagementSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EngagementSummary value)?  $default,){
final _that = this;
switch (_that) {
case _EngagementSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'current_streak_days')  int currentStreakDays, @JsonKey(name: 'best_streak_days')  int bestStreakDays, @JsonKey(name: 'lessons_completed_total')  int lessonsCompletedTotal, @JsonKey(name: 'days_active_30d')  int daysActive30d, @JsonKey(name: 'last_active_at')  String? lastActiveAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EngagementSummary() when $default != null:
return $default(_that.currentStreakDays,_that.bestStreakDays,_that.lessonsCompletedTotal,_that.daysActive30d,_that.lastActiveAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'current_streak_days')  int currentStreakDays, @JsonKey(name: 'best_streak_days')  int bestStreakDays, @JsonKey(name: 'lessons_completed_total')  int lessonsCompletedTotal, @JsonKey(name: 'days_active_30d')  int daysActive30d, @JsonKey(name: 'last_active_at')  String? lastActiveAt)  $default,) {final _that = this;
switch (_that) {
case _EngagementSummary():
return $default(_that.currentStreakDays,_that.bestStreakDays,_that.lessonsCompletedTotal,_that.daysActive30d,_that.lastActiveAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'current_streak_days')  int currentStreakDays, @JsonKey(name: 'best_streak_days')  int bestStreakDays, @JsonKey(name: 'lessons_completed_total')  int lessonsCompletedTotal, @JsonKey(name: 'days_active_30d')  int daysActive30d, @JsonKey(name: 'last_active_at')  String? lastActiveAt)?  $default,) {final _that = this;
switch (_that) {
case _EngagementSummary() when $default != null:
return $default(_that.currentStreakDays,_that.bestStreakDays,_that.lessonsCompletedTotal,_that.daysActive30d,_that.lastActiveAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EngagementSummary implements EngagementSummary {
  const _EngagementSummary({@JsonKey(name: 'current_streak_days') required this.currentStreakDays, @JsonKey(name: 'best_streak_days') required this.bestStreakDays, @JsonKey(name: 'lessons_completed_total') required this.lessonsCompletedTotal, @JsonKey(name: 'days_active_30d') required this.daysActive30d, @JsonKey(name: 'last_active_at') this.lastActiveAt});
  factory _EngagementSummary.fromJson(Map<String, dynamic> json) => _$EngagementSummaryFromJson(json);

@override@JsonKey(name: 'current_streak_days') final  int currentStreakDays;
@override@JsonKey(name: 'best_streak_days') final  int bestStreakDays;
@override@JsonKey(name: 'lessons_completed_total') final  int lessonsCompletedTotal;
@override@JsonKey(name: 'days_active_30d') final  int daysActive30d;
@override@JsonKey(name: 'last_active_at') final  String? lastActiveAt;

/// Create a copy of EngagementSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EngagementSummaryCopyWith<_EngagementSummary> get copyWith => __$EngagementSummaryCopyWithImpl<_EngagementSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EngagementSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EngagementSummary&&(identical(other.currentStreakDays, currentStreakDays) || other.currentStreakDays == currentStreakDays)&&(identical(other.bestStreakDays, bestStreakDays) || other.bestStreakDays == bestStreakDays)&&(identical(other.lessonsCompletedTotal, lessonsCompletedTotal) || other.lessonsCompletedTotal == lessonsCompletedTotal)&&(identical(other.daysActive30d, daysActive30d) || other.daysActive30d == daysActive30d)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentStreakDays,bestStreakDays,lessonsCompletedTotal,daysActive30d,lastActiveAt);

@override
String toString() {
  return 'EngagementSummary(currentStreakDays: $currentStreakDays, bestStreakDays: $bestStreakDays, lessonsCompletedTotal: $lessonsCompletedTotal, daysActive30d: $daysActive30d, lastActiveAt: $lastActiveAt)';
}


}

/// @nodoc
abstract mixin class _$EngagementSummaryCopyWith<$Res> implements $EngagementSummaryCopyWith<$Res> {
  factory _$EngagementSummaryCopyWith(_EngagementSummary value, $Res Function(_EngagementSummary) _then) = __$EngagementSummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'current_streak_days') int currentStreakDays,@JsonKey(name: 'best_streak_days') int bestStreakDays,@JsonKey(name: 'lessons_completed_total') int lessonsCompletedTotal,@JsonKey(name: 'days_active_30d') int daysActive30d,@JsonKey(name: 'last_active_at') String? lastActiveAt
});




}
/// @nodoc
class __$EngagementSummaryCopyWithImpl<$Res>
    implements _$EngagementSummaryCopyWith<$Res> {
  __$EngagementSummaryCopyWithImpl(this._self, this._then);

  final _EngagementSummary _self;
  final $Res Function(_EngagementSummary) _then;

/// Create a copy of EngagementSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentStreakDays = null,Object? bestStreakDays = null,Object? lessonsCompletedTotal = null,Object? daysActive30d = null,Object? lastActiveAt = freezed,}) {
  return _then(_EngagementSummary(
currentStreakDays: null == currentStreakDays ? _self.currentStreakDays : currentStreakDays // ignore: cast_nullable_to_non_nullable
as int,bestStreakDays: null == bestStreakDays ? _self.bestStreakDays : bestStreakDays // ignore: cast_nullable_to_non_nullable
as int,lessonsCompletedTotal: null == lessonsCompletedTotal ? _self.lessonsCompletedTotal : lessonsCompletedTotal // ignore: cast_nullable_to_non_nullable
as int,daysActive30d: null == daysActive30d ? _self.daysActive30d : daysActive30d // ignore: cast_nullable_to_non_nullable
as int,lastActiveAt: freezed == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
