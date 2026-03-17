// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'progress_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProgressSummary {

@JsonKey(name: 'total_tokens') int get totalTokens;@JsonKey(name: 'by_state') Map<String, int> get byState;@JsonKey(name: 'due_count') int get dueCount;@JsonKey(name: 'weak_concepts') List<String> get weakConcepts;
/// Create a copy of ProgressSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgressSummaryCopyWith<ProgressSummary> get copyWith => _$ProgressSummaryCopyWithImpl<ProgressSummary>(this as ProgressSummary, _$identity);

  /// Serializes this ProgressSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgressSummary&&(identical(other.totalTokens, totalTokens) || other.totalTokens == totalTokens)&&const DeepCollectionEquality().equals(other.byState, byState)&&(identical(other.dueCount, dueCount) || other.dueCount == dueCount)&&const DeepCollectionEquality().equals(other.weakConcepts, weakConcepts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalTokens,const DeepCollectionEquality().hash(byState),dueCount,const DeepCollectionEquality().hash(weakConcepts));

@override
String toString() {
  return 'ProgressSummary(totalTokens: $totalTokens, byState: $byState, dueCount: $dueCount, weakConcepts: $weakConcepts)';
}


}

/// @nodoc
abstract mixin class $ProgressSummaryCopyWith<$Res>  {
  factory $ProgressSummaryCopyWith(ProgressSummary value, $Res Function(ProgressSummary) _then) = _$ProgressSummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_tokens') int totalTokens,@JsonKey(name: 'by_state') Map<String, int> byState,@JsonKey(name: 'due_count') int dueCount,@JsonKey(name: 'weak_concepts') List<String> weakConcepts
});




}
/// @nodoc
class _$ProgressSummaryCopyWithImpl<$Res>
    implements $ProgressSummaryCopyWith<$Res> {
  _$ProgressSummaryCopyWithImpl(this._self, this._then);

  final ProgressSummary _self;
  final $Res Function(ProgressSummary) _then;

/// Create a copy of ProgressSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalTokens = null,Object? byState = null,Object? dueCount = null,Object? weakConcepts = null,}) {
  return _then(_self.copyWith(
totalTokens: null == totalTokens ? _self.totalTokens : totalTokens // ignore: cast_nullable_to_non_nullable
as int,byState: null == byState ? _self.byState : byState // ignore: cast_nullable_to_non_nullable
as Map<String, int>,dueCount: null == dueCount ? _self.dueCount : dueCount // ignore: cast_nullable_to_non_nullable
as int,weakConcepts: null == weakConcepts ? _self.weakConcepts : weakConcepts // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProgressSummary].
extension ProgressSummaryPatterns on ProgressSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgressSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgressSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgressSummary value)  $default,){
final _that = this;
switch (_that) {
case _ProgressSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgressSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ProgressSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_tokens')  int totalTokens, @JsonKey(name: 'by_state')  Map<String, int> byState, @JsonKey(name: 'due_count')  int dueCount, @JsonKey(name: 'weak_concepts')  List<String> weakConcepts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgressSummary() when $default != null:
return $default(_that.totalTokens,_that.byState,_that.dueCount,_that.weakConcepts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_tokens')  int totalTokens, @JsonKey(name: 'by_state')  Map<String, int> byState, @JsonKey(name: 'due_count')  int dueCount, @JsonKey(name: 'weak_concepts')  List<String> weakConcepts)  $default,) {final _that = this;
switch (_that) {
case _ProgressSummary():
return $default(_that.totalTokens,_that.byState,_that.dueCount,_that.weakConcepts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_tokens')  int totalTokens, @JsonKey(name: 'by_state')  Map<String, int> byState, @JsonKey(name: 'due_count')  int dueCount, @JsonKey(name: 'weak_concepts')  List<String> weakConcepts)?  $default,) {final _that = this;
switch (_that) {
case _ProgressSummary() when $default != null:
return $default(_that.totalTokens,_that.byState,_that.dueCount,_that.weakConcepts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProgressSummary implements ProgressSummary {
  const _ProgressSummary({@JsonKey(name: 'total_tokens') required this.totalTokens, @JsonKey(name: 'by_state') required final  Map<String, int> byState, @JsonKey(name: 'due_count') required this.dueCount, @JsonKey(name: 'weak_concepts') final  List<String> weakConcepts = const []}): _byState = byState,_weakConcepts = weakConcepts;
  factory _ProgressSummary.fromJson(Map<String, dynamic> json) => _$ProgressSummaryFromJson(json);

@override@JsonKey(name: 'total_tokens') final  int totalTokens;
 final  Map<String, int> _byState;
@override@JsonKey(name: 'by_state') Map<String, int> get byState {
  if (_byState is EqualUnmodifiableMapView) return _byState;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_byState);
}

@override@JsonKey(name: 'due_count') final  int dueCount;
 final  List<String> _weakConcepts;
@override@JsonKey(name: 'weak_concepts') List<String> get weakConcepts {
  if (_weakConcepts is EqualUnmodifiableListView) return _weakConcepts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weakConcepts);
}


/// Create a copy of ProgressSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgressSummaryCopyWith<_ProgressSummary> get copyWith => __$ProgressSummaryCopyWithImpl<_ProgressSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProgressSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgressSummary&&(identical(other.totalTokens, totalTokens) || other.totalTokens == totalTokens)&&const DeepCollectionEquality().equals(other._byState, _byState)&&(identical(other.dueCount, dueCount) || other.dueCount == dueCount)&&const DeepCollectionEquality().equals(other._weakConcepts, _weakConcepts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalTokens,const DeepCollectionEquality().hash(_byState),dueCount,const DeepCollectionEquality().hash(_weakConcepts));

@override
String toString() {
  return 'ProgressSummary(totalTokens: $totalTokens, byState: $byState, dueCount: $dueCount, weakConcepts: $weakConcepts)';
}


}

/// @nodoc
abstract mixin class _$ProgressSummaryCopyWith<$Res> implements $ProgressSummaryCopyWith<$Res> {
  factory _$ProgressSummaryCopyWith(_ProgressSummary value, $Res Function(_ProgressSummary) _then) = __$ProgressSummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_tokens') int totalTokens,@JsonKey(name: 'by_state') Map<String, int> byState,@JsonKey(name: 'due_count') int dueCount,@JsonKey(name: 'weak_concepts') List<String> weakConcepts
});




}
/// @nodoc
class __$ProgressSummaryCopyWithImpl<$Res>
    implements _$ProgressSummaryCopyWith<$Res> {
  __$ProgressSummaryCopyWithImpl(this._self, this._then);

  final _ProgressSummary _self;
  final $Res Function(_ProgressSummary) _then;

/// Create a copy of ProgressSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalTokens = null,Object? byState = null,Object? dueCount = null,Object? weakConcepts = null,}) {
  return _then(_ProgressSummary(
totalTokens: null == totalTokens ? _self.totalTokens : totalTokens // ignore: cast_nullable_to_non_nullable
as int,byState: null == byState ? _self._byState : byState // ignore: cast_nullable_to_non_nullable
as Map<String, int>,dueCount: null == dueCount ? _self.dueCount : dueCount // ignore: cast_nullable_to_non_nullable
as int,weakConcepts: null == weakConcepts ? _self._weakConcepts : weakConcepts // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
