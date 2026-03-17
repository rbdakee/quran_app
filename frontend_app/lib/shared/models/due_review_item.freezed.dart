// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'due_review_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DueReviewItem {

@JsonKey(name: 'token_id') String get tokenId;@JsonKey(name: 'concept_key') String? get conceptKey; String get state; double get stability;@JsonKey(name: 'next_review_at') String get nextReviewAt;@JsonKey(name: 'due_score') double get dueScore;
/// Create a copy of DueReviewItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DueReviewItemCopyWith<DueReviewItem> get copyWith => _$DueReviewItemCopyWithImpl<DueReviewItem>(this as DueReviewItem, _$identity);

  /// Serializes this DueReviewItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DueReviewItem&&(identical(other.tokenId, tokenId) || other.tokenId == tokenId)&&(identical(other.conceptKey, conceptKey) || other.conceptKey == conceptKey)&&(identical(other.state, state) || other.state == state)&&(identical(other.stability, stability) || other.stability == stability)&&(identical(other.nextReviewAt, nextReviewAt) || other.nextReviewAt == nextReviewAt)&&(identical(other.dueScore, dueScore) || other.dueScore == dueScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tokenId,conceptKey,state,stability,nextReviewAt,dueScore);

@override
String toString() {
  return 'DueReviewItem(tokenId: $tokenId, conceptKey: $conceptKey, state: $state, stability: $stability, nextReviewAt: $nextReviewAt, dueScore: $dueScore)';
}


}

/// @nodoc
abstract mixin class $DueReviewItemCopyWith<$Res>  {
  factory $DueReviewItemCopyWith(DueReviewItem value, $Res Function(DueReviewItem) _then) = _$DueReviewItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'token_id') String tokenId,@JsonKey(name: 'concept_key') String? conceptKey, String state, double stability,@JsonKey(name: 'next_review_at') String nextReviewAt,@JsonKey(name: 'due_score') double dueScore
});




}
/// @nodoc
class _$DueReviewItemCopyWithImpl<$Res>
    implements $DueReviewItemCopyWith<$Res> {
  _$DueReviewItemCopyWithImpl(this._self, this._then);

  final DueReviewItem _self;
  final $Res Function(DueReviewItem) _then;

/// Create a copy of DueReviewItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tokenId = null,Object? conceptKey = freezed,Object? state = null,Object? stability = null,Object? nextReviewAt = null,Object? dueScore = null,}) {
  return _then(_self.copyWith(
tokenId: null == tokenId ? _self.tokenId : tokenId // ignore: cast_nullable_to_non_nullable
as String,conceptKey: freezed == conceptKey ? _self.conceptKey : conceptKey // ignore: cast_nullable_to_non_nullable
as String?,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,stability: null == stability ? _self.stability : stability // ignore: cast_nullable_to_non_nullable
as double,nextReviewAt: null == nextReviewAt ? _self.nextReviewAt : nextReviewAt // ignore: cast_nullable_to_non_nullable
as String,dueScore: null == dueScore ? _self.dueScore : dueScore // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [DueReviewItem].
extension DueReviewItemPatterns on DueReviewItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DueReviewItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DueReviewItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DueReviewItem value)  $default,){
final _that = this;
switch (_that) {
case _DueReviewItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DueReviewItem value)?  $default,){
final _that = this;
switch (_that) {
case _DueReviewItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'token_id')  String tokenId, @JsonKey(name: 'concept_key')  String? conceptKey,  String state,  double stability, @JsonKey(name: 'next_review_at')  String nextReviewAt, @JsonKey(name: 'due_score')  double dueScore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DueReviewItem() when $default != null:
return $default(_that.tokenId,_that.conceptKey,_that.state,_that.stability,_that.nextReviewAt,_that.dueScore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'token_id')  String tokenId, @JsonKey(name: 'concept_key')  String? conceptKey,  String state,  double stability, @JsonKey(name: 'next_review_at')  String nextReviewAt, @JsonKey(name: 'due_score')  double dueScore)  $default,) {final _that = this;
switch (_that) {
case _DueReviewItem():
return $default(_that.tokenId,_that.conceptKey,_that.state,_that.stability,_that.nextReviewAt,_that.dueScore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'token_id')  String tokenId, @JsonKey(name: 'concept_key')  String? conceptKey,  String state,  double stability, @JsonKey(name: 'next_review_at')  String nextReviewAt, @JsonKey(name: 'due_score')  double dueScore)?  $default,) {final _that = this;
switch (_that) {
case _DueReviewItem() when $default != null:
return $default(_that.tokenId,_that.conceptKey,_that.state,_that.stability,_that.nextReviewAt,_that.dueScore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DueReviewItem implements DueReviewItem {
  const _DueReviewItem({@JsonKey(name: 'token_id') required this.tokenId, @JsonKey(name: 'concept_key') this.conceptKey, required this.state, required this.stability, @JsonKey(name: 'next_review_at') required this.nextReviewAt, @JsonKey(name: 'due_score') required this.dueScore});
  factory _DueReviewItem.fromJson(Map<String, dynamic> json) => _$DueReviewItemFromJson(json);

@override@JsonKey(name: 'token_id') final  String tokenId;
@override@JsonKey(name: 'concept_key') final  String? conceptKey;
@override final  String state;
@override final  double stability;
@override@JsonKey(name: 'next_review_at') final  String nextReviewAt;
@override@JsonKey(name: 'due_score') final  double dueScore;

/// Create a copy of DueReviewItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DueReviewItemCopyWith<_DueReviewItem> get copyWith => __$DueReviewItemCopyWithImpl<_DueReviewItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DueReviewItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DueReviewItem&&(identical(other.tokenId, tokenId) || other.tokenId == tokenId)&&(identical(other.conceptKey, conceptKey) || other.conceptKey == conceptKey)&&(identical(other.state, state) || other.state == state)&&(identical(other.stability, stability) || other.stability == stability)&&(identical(other.nextReviewAt, nextReviewAt) || other.nextReviewAt == nextReviewAt)&&(identical(other.dueScore, dueScore) || other.dueScore == dueScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tokenId,conceptKey,state,stability,nextReviewAt,dueScore);

@override
String toString() {
  return 'DueReviewItem(tokenId: $tokenId, conceptKey: $conceptKey, state: $state, stability: $stability, nextReviewAt: $nextReviewAt, dueScore: $dueScore)';
}


}

/// @nodoc
abstract mixin class _$DueReviewItemCopyWith<$Res> implements $DueReviewItemCopyWith<$Res> {
  factory _$DueReviewItemCopyWith(_DueReviewItem value, $Res Function(_DueReviewItem) _then) = __$DueReviewItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'token_id') String tokenId,@JsonKey(name: 'concept_key') String? conceptKey, String state, double stability,@JsonKey(name: 'next_review_at') String nextReviewAt,@JsonKey(name: 'due_score') double dueScore
});




}
/// @nodoc
class __$DueReviewItemCopyWithImpl<$Res>
    implements _$DueReviewItemCopyWith<$Res> {
  __$DueReviewItemCopyWithImpl(this._self, this._then);

  final _DueReviewItem _self;
  final $Res Function(_DueReviewItem) _then;

/// Create a copy of DueReviewItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tokenId = null,Object? conceptKey = freezed,Object? state = null,Object? stability = null,Object? nextReviewAt = null,Object? dueScore = null,}) {
  return _then(_DueReviewItem(
tokenId: null == tokenId ? _self.tokenId : tokenId // ignore: cast_nullable_to_non_nullable
as String,conceptKey: freezed == conceptKey ? _self.conceptKey : conceptKey // ignore: cast_nullable_to_non_nullable
as String?,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,stability: null == stability ? _self.stability : stability // ignore: cast_nullable_to_non_nullable
as double,nextReviewAt: null == nextReviewAt ? _self.nextReviewAt : nextReviewAt // ignore: cast_nullable_to_non_nullable
as String,dueScore: null == dueScore ? _self.dueScore : dueScore // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
