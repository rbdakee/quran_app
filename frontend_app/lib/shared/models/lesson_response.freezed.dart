// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LessonResponse {

@JsonKey(name: 'lesson_id') String get lessonId;@JsonKey(name: 'generated_at_utc') String get generatedAtUtc;@JsonKey(name: 'algorithm_version') String get algorithmVersion; LessonConfig? get config;@JsonKey(name: 'dynamic') LessonDynamic? get lessonDynamic; LessonSelection? get selection; List<LessonStep> get steps; LessonNotes? get notes;
/// Create a copy of LessonResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonResponseCopyWith<LessonResponse> get copyWith => _$LessonResponseCopyWithImpl<LessonResponse>(this as LessonResponse, _$identity);

  /// Serializes this LessonResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonResponse&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.generatedAtUtc, generatedAtUtc) || other.generatedAtUtc == generatedAtUtc)&&(identical(other.algorithmVersion, algorithmVersion) || other.algorithmVersion == algorithmVersion)&&(identical(other.config, config) || other.config == config)&&(identical(other.lessonDynamic, lessonDynamic) || other.lessonDynamic == lessonDynamic)&&(identical(other.selection, selection) || other.selection == selection)&&const DeepCollectionEquality().equals(other.steps, steps)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lessonId,generatedAtUtc,algorithmVersion,config,lessonDynamic,selection,const DeepCollectionEquality().hash(steps),notes);

@override
String toString() {
  return 'LessonResponse(lessonId: $lessonId, generatedAtUtc: $generatedAtUtc, algorithmVersion: $algorithmVersion, config: $config, lessonDynamic: $lessonDynamic, selection: $selection, steps: $steps, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $LessonResponseCopyWith<$Res>  {
  factory $LessonResponseCopyWith(LessonResponse value, $Res Function(LessonResponse) _then) = _$LessonResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'lesson_id') String lessonId,@JsonKey(name: 'generated_at_utc') String generatedAtUtc,@JsonKey(name: 'algorithm_version') String algorithmVersion, LessonConfig? config,@JsonKey(name: 'dynamic') LessonDynamic? lessonDynamic, LessonSelection? selection, List<LessonStep> steps, LessonNotes? notes
});


$LessonConfigCopyWith<$Res>? get config;$LessonDynamicCopyWith<$Res>? get lessonDynamic;$LessonSelectionCopyWith<$Res>? get selection;$LessonNotesCopyWith<$Res>? get notes;

}
/// @nodoc
class _$LessonResponseCopyWithImpl<$Res>
    implements $LessonResponseCopyWith<$Res> {
  _$LessonResponseCopyWithImpl(this._self, this._then);

  final LessonResponse _self;
  final $Res Function(LessonResponse) _then;

/// Create a copy of LessonResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lessonId = null,Object? generatedAtUtc = null,Object? algorithmVersion = null,Object? config = freezed,Object? lessonDynamic = freezed,Object? selection = freezed,Object? steps = null,Object? notes = freezed,}) {
  return _then(_self.copyWith(
lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String,generatedAtUtc: null == generatedAtUtc ? _self.generatedAtUtc : generatedAtUtc // ignore: cast_nullable_to_non_nullable
as String,algorithmVersion: null == algorithmVersion ? _self.algorithmVersion : algorithmVersion // ignore: cast_nullable_to_non_nullable
as String,config: freezed == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as LessonConfig?,lessonDynamic: freezed == lessonDynamic ? _self.lessonDynamic : lessonDynamic // ignore: cast_nullable_to_non_nullable
as LessonDynamic?,selection: freezed == selection ? _self.selection : selection // ignore: cast_nullable_to_non_nullable
as LessonSelection?,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<LessonStep>,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as LessonNotes?,
  ));
}
/// Create a copy of LessonResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonConfigCopyWith<$Res>? get config {
    if (_self.config == null) {
    return null;
  }

  return $LessonConfigCopyWith<$Res>(_self.config!, (value) {
    return _then(_self.copyWith(config: value));
  });
}/// Create a copy of LessonResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonDynamicCopyWith<$Res>? get lessonDynamic {
    if (_self.lessonDynamic == null) {
    return null;
  }

  return $LessonDynamicCopyWith<$Res>(_self.lessonDynamic!, (value) {
    return _then(_self.copyWith(lessonDynamic: value));
  });
}/// Create a copy of LessonResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonSelectionCopyWith<$Res>? get selection {
    if (_self.selection == null) {
    return null;
  }

  return $LessonSelectionCopyWith<$Res>(_self.selection!, (value) {
    return _then(_self.copyWith(selection: value));
  });
}/// Create a copy of LessonResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonNotesCopyWith<$Res>? get notes {
    if (_self.notes == null) {
    return null;
  }

  return $LessonNotesCopyWith<$Res>(_self.notes!, (value) {
    return _then(_self.copyWith(notes: value));
  });
}
}


/// Adds pattern-matching-related methods to [LessonResponse].
extension LessonResponsePatterns on LessonResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonResponse value)  $default,){
final _that = this;
switch (_that) {
case _LessonResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonResponse value)?  $default,){
final _that = this;
switch (_that) {
case _LessonResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'lesson_id')  String lessonId, @JsonKey(name: 'generated_at_utc')  String generatedAtUtc, @JsonKey(name: 'algorithm_version')  String algorithmVersion,  LessonConfig? config, @JsonKey(name: 'dynamic')  LessonDynamic? lessonDynamic,  LessonSelection? selection,  List<LessonStep> steps,  LessonNotes? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonResponse() when $default != null:
return $default(_that.lessonId,_that.generatedAtUtc,_that.algorithmVersion,_that.config,_that.lessonDynamic,_that.selection,_that.steps,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'lesson_id')  String lessonId, @JsonKey(name: 'generated_at_utc')  String generatedAtUtc, @JsonKey(name: 'algorithm_version')  String algorithmVersion,  LessonConfig? config, @JsonKey(name: 'dynamic')  LessonDynamic? lessonDynamic,  LessonSelection? selection,  List<LessonStep> steps,  LessonNotes? notes)  $default,) {final _that = this;
switch (_that) {
case _LessonResponse():
return $default(_that.lessonId,_that.generatedAtUtc,_that.algorithmVersion,_that.config,_that.lessonDynamic,_that.selection,_that.steps,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'lesson_id')  String lessonId, @JsonKey(name: 'generated_at_utc')  String generatedAtUtc, @JsonKey(name: 'algorithm_version')  String algorithmVersion,  LessonConfig? config, @JsonKey(name: 'dynamic')  LessonDynamic? lessonDynamic,  LessonSelection? selection,  List<LessonStep> steps,  LessonNotes? notes)?  $default,) {final _that = this;
switch (_that) {
case _LessonResponse() when $default != null:
return $default(_that.lessonId,_that.generatedAtUtc,_that.algorithmVersion,_that.config,_that.lessonDynamic,_that.selection,_that.steps,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LessonResponse implements LessonResponse {
  const _LessonResponse({@JsonKey(name: 'lesson_id') required this.lessonId, @JsonKey(name: 'generated_at_utc') required this.generatedAtUtc, @JsonKey(name: 'algorithm_version') required this.algorithmVersion, this.config, @JsonKey(name: 'dynamic') this.lessonDynamic, this.selection, required final  List<LessonStep> steps, this.notes}): _steps = steps;
  factory _LessonResponse.fromJson(Map<String, dynamic> json) => _$LessonResponseFromJson(json);

@override@JsonKey(name: 'lesson_id') final  String lessonId;
@override@JsonKey(name: 'generated_at_utc') final  String generatedAtUtc;
@override@JsonKey(name: 'algorithm_version') final  String algorithmVersion;
@override final  LessonConfig? config;
@override@JsonKey(name: 'dynamic') final  LessonDynamic? lessonDynamic;
@override final  LessonSelection? selection;
 final  List<LessonStep> _steps;
@override List<LessonStep> get steps {
  if (_steps is EqualUnmodifiableListView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_steps);
}

@override final  LessonNotes? notes;

/// Create a copy of LessonResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonResponseCopyWith<_LessonResponse> get copyWith => __$LessonResponseCopyWithImpl<_LessonResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonResponse&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.generatedAtUtc, generatedAtUtc) || other.generatedAtUtc == generatedAtUtc)&&(identical(other.algorithmVersion, algorithmVersion) || other.algorithmVersion == algorithmVersion)&&(identical(other.config, config) || other.config == config)&&(identical(other.lessonDynamic, lessonDynamic) || other.lessonDynamic == lessonDynamic)&&(identical(other.selection, selection) || other.selection == selection)&&const DeepCollectionEquality().equals(other._steps, _steps)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lessonId,generatedAtUtc,algorithmVersion,config,lessonDynamic,selection,const DeepCollectionEquality().hash(_steps),notes);

@override
String toString() {
  return 'LessonResponse(lessonId: $lessonId, generatedAtUtc: $generatedAtUtc, algorithmVersion: $algorithmVersion, config: $config, lessonDynamic: $lessonDynamic, selection: $selection, steps: $steps, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$LessonResponseCopyWith<$Res> implements $LessonResponseCopyWith<$Res> {
  factory _$LessonResponseCopyWith(_LessonResponse value, $Res Function(_LessonResponse) _then) = __$LessonResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'lesson_id') String lessonId,@JsonKey(name: 'generated_at_utc') String generatedAtUtc,@JsonKey(name: 'algorithm_version') String algorithmVersion, LessonConfig? config,@JsonKey(name: 'dynamic') LessonDynamic? lessonDynamic, LessonSelection? selection, List<LessonStep> steps, LessonNotes? notes
});


@override $LessonConfigCopyWith<$Res>? get config;@override $LessonDynamicCopyWith<$Res>? get lessonDynamic;@override $LessonSelectionCopyWith<$Res>? get selection;@override $LessonNotesCopyWith<$Res>? get notes;

}
/// @nodoc
class __$LessonResponseCopyWithImpl<$Res>
    implements _$LessonResponseCopyWith<$Res> {
  __$LessonResponseCopyWithImpl(this._self, this._then);

  final _LessonResponse _self;
  final $Res Function(_LessonResponse) _then;

/// Create a copy of LessonResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lessonId = null,Object? generatedAtUtc = null,Object? algorithmVersion = null,Object? config = freezed,Object? lessonDynamic = freezed,Object? selection = freezed,Object? steps = null,Object? notes = freezed,}) {
  return _then(_LessonResponse(
lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String,generatedAtUtc: null == generatedAtUtc ? _self.generatedAtUtc : generatedAtUtc // ignore: cast_nullable_to_non_nullable
as String,algorithmVersion: null == algorithmVersion ? _self.algorithmVersion : algorithmVersion // ignore: cast_nullable_to_non_nullable
as String,config: freezed == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as LessonConfig?,lessonDynamic: freezed == lessonDynamic ? _self.lessonDynamic : lessonDynamic // ignore: cast_nullable_to_non_nullable
as LessonDynamic?,selection: freezed == selection ? _self.selection : selection // ignore: cast_nullable_to_non_nullable
as LessonSelection?,steps: null == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as List<LessonStep>,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as LessonNotes?,
  ));
}

/// Create a copy of LessonResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonConfigCopyWith<$Res>? get config {
    if (_self.config == null) {
    return null;
  }

  return $LessonConfigCopyWith<$Res>(_self.config!, (value) {
    return _then(_self.copyWith(config: value));
  });
}/// Create a copy of LessonResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonDynamicCopyWith<$Res>? get lessonDynamic {
    if (_self.lessonDynamic == null) {
    return null;
  }

  return $LessonDynamicCopyWith<$Res>(_self.lessonDynamic!, (value) {
    return _then(_self.copyWith(lessonDynamic: value));
  });
}/// Create a copy of LessonResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonSelectionCopyWith<$Res>? get selection {
    if (_self.selection == null) {
    return null;
  }

  return $LessonSelectionCopyWith<$Res>(_self.selection!, (value) {
    return _then(_self.copyWith(selection: value));
  });
}/// Create a copy of LessonResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonNotesCopyWith<$Res>? get notes {
    if (_self.notes == null) {
    return null;
  }

  return $LessonNotesCopyWith<$Res>(_self.notes!, (value) {
    return _then(_self.copyWith(notes: value));
  });
}
}


/// @nodoc
mixin _$LessonConfig {

@JsonKey(name: 'target_steps') int? get targetSteps;
/// Create a copy of LessonConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonConfigCopyWith<LessonConfig> get copyWith => _$LessonConfigCopyWithImpl<LessonConfig>(this as LessonConfig, _$identity);

  /// Serializes this LessonConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonConfig&&(identical(other.targetSteps, targetSteps) || other.targetSteps == targetSteps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,targetSteps);

@override
String toString() {
  return 'LessonConfig(targetSteps: $targetSteps)';
}


}

/// @nodoc
abstract mixin class $LessonConfigCopyWith<$Res>  {
  factory $LessonConfigCopyWith(LessonConfig value, $Res Function(LessonConfig) _then) = _$LessonConfigCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'target_steps') int? targetSteps
});




}
/// @nodoc
class _$LessonConfigCopyWithImpl<$Res>
    implements $LessonConfigCopyWith<$Res> {
  _$LessonConfigCopyWithImpl(this._self, this._then);

  final LessonConfig _self;
  final $Res Function(LessonConfig) _then;

/// Create a copy of LessonConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? targetSteps = freezed,}) {
  return _then(_self.copyWith(
targetSteps: freezed == targetSteps ? _self.targetSteps : targetSteps // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [LessonConfig].
extension LessonConfigPatterns on LessonConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonConfig value)  $default,){
final _that = this;
switch (_that) {
case _LessonConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonConfig value)?  $default,){
final _that = this;
switch (_that) {
case _LessonConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'target_steps')  int? targetSteps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonConfig() when $default != null:
return $default(_that.targetSteps);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'target_steps')  int? targetSteps)  $default,) {final _that = this;
switch (_that) {
case _LessonConfig():
return $default(_that.targetSteps);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'target_steps')  int? targetSteps)?  $default,) {final _that = this;
switch (_that) {
case _LessonConfig() when $default != null:
return $default(_that.targetSteps);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LessonConfig implements LessonConfig {
  const _LessonConfig({@JsonKey(name: 'target_steps') this.targetSteps});
  factory _LessonConfig.fromJson(Map<String, dynamic> json) => _$LessonConfigFromJson(json);

@override@JsonKey(name: 'target_steps') final  int? targetSteps;

/// Create a copy of LessonConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonConfigCopyWith<_LessonConfig> get copyWith => __$LessonConfigCopyWithImpl<_LessonConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonConfig&&(identical(other.targetSteps, targetSteps) || other.targetSteps == targetSteps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,targetSteps);

@override
String toString() {
  return 'LessonConfig(targetSteps: $targetSteps)';
}


}

/// @nodoc
abstract mixin class _$LessonConfigCopyWith<$Res> implements $LessonConfigCopyWith<$Res> {
  factory _$LessonConfigCopyWith(_LessonConfig value, $Res Function(_LessonConfig) _then) = __$LessonConfigCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'target_steps') int? targetSteps
});




}
/// @nodoc
class __$LessonConfigCopyWithImpl<$Res>
    implements _$LessonConfigCopyWith<$Res> {
  __$LessonConfigCopyWithImpl(this._self, this._then);

  final _LessonConfig _self;
  final $Res Function(_LessonConfig) _then;

/// Create a copy of LessonConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? targetSteps = freezed,}) {
  return _then(_LessonConfig(
targetSteps: freezed == targetSteps ? _self.targetSteps : targetSteps // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$LessonDynamic {

@JsonKey(name: 'total_known_words') int? get totalKnownWords;@JsonKey(name: 'computed_new') int? get computedNew;@JsonKey(name: 'computed_review') int? get computedReview;@JsonKey(name: 'actual_new') int? get actualNew;@JsonKey(name: 'actual_due') int? get actualDue;@JsonKey(name: 'actual_reinforcement') int? get actualReinforcement;
/// Create a copy of LessonDynamic
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonDynamicCopyWith<LessonDynamic> get copyWith => _$LessonDynamicCopyWithImpl<LessonDynamic>(this as LessonDynamic, _$identity);

  /// Serializes this LessonDynamic to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonDynamic&&(identical(other.totalKnownWords, totalKnownWords) || other.totalKnownWords == totalKnownWords)&&(identical(other.computedNew, computedNew) || other.computedNew == computedNew)&&(identical(other.computedReview, computedReview) || other.computedReview == computedReview)&&(identical(other.actualNew, actualNew) || other.actualNew == actualNew)&&(identical(other.actualDue, actualDue) || other.actualDue == actualDue)&&(identical(other.actualReinforcement, actualReinforcement) || other.actualReinforcement == actualReinforcement));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalKnownWords,computedNew,computedReview,actualNew,actualDue,actualReinforcement);

@override
String toString() {
  return 'LessonDynamic(totalKnownWords: $totalKnownWords, computedNew: $computedNew, computedReview: $computedReview, actualNew: $actualNew, actualDue: $actualDue, actualReinforcement: $actualReinforcement)';
}


}

/// @nodoc
abstract mixin class $LessonDynamicCopyWith<$Res>  {
  factory $LessonDynamicCopyWith(LessonDynamic value, $Res Function(LessonDynamic) _then) = _$LessonDynamicCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_known_words') int? totalKnownWords,@JsonKey(name: 'computed_new') int? computedNew,@JsonKey(name: 'computed_review') int? computedReview,@JsonKey(name: 'actual_new') int? actualNew,@JsonKey(name: 'actual_due') int? actualDue,@JsonKey(name: 'actual_reinforcement') int? actualReinforcement
});




}
/// @nodoc
class _$LessonDynamicCopyWithImpl<$Res>
    implements $LessonDynamicCopyWith<$Res> {
  _$LessonDynamicCopyWithImpl(this._self, this._then);

  final LessonDynamic _self;
  final $Res Function(LessonDynamic) _then;

/// Create a copy of LessonDynamic
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalKnownWords = freezed,Object? computedNew = freezed,Object? computedReview = freezed,Object? actualNew = freezed,Object? actualDue = freezed,Object? actualReinforcement = freezed,}) {
  return _then(_self.copyWith(
totalKnownWords: freezed == totalKnownWords ? _self.totalKnownWords : totalKnownWords // ignore: cast_nullable_to_non_nullable
as int?,computedNew: freezed == computedNew ? _self.computedNew : computedNew // ignore: cast_nullable_to_non_nullable
as int?,computedReview: freezed == computedReview ? _self.computedReview : computedReview // ignore: cast_nullable_to_non_nullable
as int?,actualNew: freezed == actualNew ? _self.actualNew : actualNew // ignore: cast_nullable_to_non_nullable
as int?,actualDue: freezed == actualDue ? _self.actualDue : actualDue // ignore: cast_nullable_to_non_nullable
as int?,actualReinforcement: freezed == actualReinforcement ? _self.actualReinforcement : actualReinforcement // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [LessonDynamic].
extension LessonDynamicPatterns on LessonDynamic {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonDynamic value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonDynamic() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonDynamic value)  $default,){
final _that = this;
switch (_that) {
case _LessonDynamic():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonDynamic value)?  $default,){
final _that = this;
switch (_that) {
case _LessonDynamic() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_known_words')  int? totalKnownWords, @JsonKey(name: 'computed_new')  int? computedNew, @JsonKey(name: 'computed_review')  int? computedReview, @JsonKey(name: 'actual_new')  int? actualNew, @JsonKey(name: 'actual_due')  int? actualDue, @JsonKey(name: 'actual_reinforcement')  int? actualReinforcement)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonDynamic() when $default != null:
return $default(_that.totalKnownWords,_that.computedNew,_that.computedReview,_that.actualNew,_that.actualDue,_that.actualReinforcement);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_known_words')  int? totalKnownWords, @JsonKey(name: 'computed_new')  int? computedNew, @JsonKey(name: 'computed_review')  int? computedReview, @JsonKey(name: 'actual_new')  int? actualNew, @JsonKey(name: 'actual_due')  int? actualDue, @JsonKey(name: 'actual_reinforcement')  int? actualReinforcement)  $default,) {final _that = this;
switch (_that) {
case _LessonDynamic():
return $default(_that.totalKnownWords,_that.computedNew,_that.computedReview,_that.actualNew,_that.actualDue,_that.actualReinforcement);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_known_words')  int? totalKnownWords, @JsonKey(name: 'computed_new')  int? computedNew, @JsonKey(name: 'computed_review')  int? computedReview, @JsonKey(name: 'actual_new')  int? actualNew, @JsonKey(name: 'actual_due')  int? actualDue, @JsonKey(name: 'actual_reinforcement')  int? actualReinforcement)?  $default,) {final _that = this;
switch (_that) {
case _LessonDynamic() when $default != null:
return $default(_that.totalKnownWords,_that.computedNew,_that.computedReview,_that.actualNew,_that.actualDue,_that.actualReinforcement);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LessonDynamic implements LessonDynamic {
  const _LessonDynamic({@JsonKey(name: 'total_known_words') this.totalKnownWords, @JsonKey(name: 'computed_new') this.computedNew, @JsonKey(name: 'computed_review') this.computedReview, @JsonKey(name: 'actual_new') this.actualNew, @JsonKey(name: 'actual_due') this.actualDue, @JsonKey(name: 'actual_reinforcement') this.actualReinforcement});
  factory _LessonDynamic.fromJson(Map<String, dynamic> json) => _$LessonDynamicFromJson(json);

@override@JsonKey(name: 'total_known_words') final  int? totalKnownWords;
@override@JsonKey(name: 'computed_new') final  int? computedNew;
@override@JsonKey(name: 'computed_review') final  int? computedReview;
@override@JsonKey(name: 'actual_new') final  int? actualNew;
@override@JsonKey(name: 'actual_due') final  int? actualDue;
@override@JsonKey(name: 'actual_reinforcement') final  int? actualReinforcement;

/// Create a copy of LessonDynamic
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonDynamicCopyWith<_LessonDynamic> get copyWith => __$LessonDynamicCopyWithImpl<_LessonDynamic>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonDynamicToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonDynamic&&(identical(other.totalKnownWords, totalKnownWords) || other.totalKnownWords == totalKnownWords)&&(identical(other.computedNew, computedNew) || other.computedNew == computedNew)&&(identical(other.computedReview, computedReview) || other.computedReview == computedReview)&&(identical(other.actualNew, actualNew) || other.actualNew == actualNew)&&(identical(other.actualDue, actualDue) || other.actualDue == actualDue)&&(identical(other.actualReinforcement, actualReinforcement) || other.actualReinforcement == actualReinforcement));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalKnownWords,computedNew,computedReview,actualNew,actualDue,actualReinforcement);

@override
String toString() {
  return 'LessonDynamic(totalKnownWords: $totalKnownWords, computedNew: $computedNew, computedReview: $computedReview, actualNew: $actualNew, actualDue: $actualDue, actualReinforcement: $actualReinforcement)';
}


}

/// @nodoc
abstract mixin class _$LessonDynamicCopyWith<$Res> implements $LessonDynamicCopyWith<$Res> {
  factory _$LessonDynamicCopyWith(_LessonDynamic value, $Res Function(_LessonDynamic) _then) = __$LessonDynamicCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_known_words') int? totalKnownWords,@JsonKey(name: 'computed_new') int? computedNew,@JsonKey(name: 'computed_review') int? computedReview,@JsonKey(name: 'actual_new') int? actualNew,@JsonKey(name: 'actual_due') int? actualDue,@JsonKey(name: 'actual_reinforcement') int? actualReinforcement
});




}
/// @nodoc
class __$LessonDynamicCopyWithImpl<$Res>
    implements _$LessonDynamicCopyWith<$Res> {
  __$LessonDynamicCopyWithImpl(this._self, this._then);

  final _LessonDynamic _self;
  final $Res Function(_LessonDynamic) _then;

/// Create a copy of LessonDynamic
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalKnownWords = freezed,Object? computedNew = freezed,Object? computedReview = freezed,Object? actualNew = freezed,Object? actualDue = freezed,Object? actualReinforcement = freezed,}) {
  return _then(_LessonDynamic(
totalKnownWords: freezed == totalKnownWords ? _self.totalKnownWords : totalKnownWords // ignore: cast_nullable_to_non_nullable
as int?,computedNew: freezed == computedNew ? _self.computedNew : computedNew // ignore: cast_nullable_to_non_nullable
as int?,computedReview: freezed == computedReview ? _self.computedReview : computedReview // ignore: cast_nullable_to_non_nullable
as int?,actualNew: freezed == actualNew ? _self.actualNew : actualNew // ignore: cast_nullable_to_non_nullable
as int?,actualDue: freezed == actualDue ? _self.actualDue : actualDue // ignore: cast_nullable_to_non_nullable
as int?,actualReinforcement: freezed == actualReinforcement ? _self.actualReinforcement : actualReinforcement // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$LessonSelection {

 List<dynamic>? get due;@JsonKey(name: 'new') List<dynamic>? get newWords; List<dynamic>? get reinforcement;
/// Create a copy of LessonSelection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonSelectionCopyWith<LessonSelection> get copyWith => _$LessonSelectionCopyWithImpl<LessonSelection>(this as LessonSelection, _$identity);

  /// Serializes this LessonSelection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonSelection&&const DeepCollectionEquality().equals(other.due, due)&&const DeepCollectionEquality().equals(other.newWords, newWords)&&const DeepCollectionEquality().equals(other.reinforcement, reinforcement));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(due),const DeepCollectionEquality().hash(newWords),const DeepCollectionEquality().hash(reinforcement));

@override
String toString() {
  return 'LessonSelection(due: $due, newWords: $newWords, reinforcement: $reinforcement)';
}


}

/// @nodoc
abstract mixin class $LessonSelectionCopyWith<$Res>  {
  factory $LessonSelectionCopyWith(LessonSelection value, $Res Function(LessonSelection) _then) = _$LessonSelectionCopyWithImpl;
@useResult
$Res call({
 List<dynamic>? due,@JsonKey(name: 'new') List<dynamic>? newWords, List<dynamic>? reinforcement
});




}
/// @nodoc
class _$LessonSelectionCopyWithImpl<$Res>
    implements $LessonSelectionCopyWith<$Res> {
  _$LessonSelectionCopyWithImpl(this._self, this._then);

  final LessonSelection _self;
  final $Res Function(LessonSelection) _then;

/// Create a copy of LessonSelection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? due = freezed,Object? newWords = freezed,Object? reinforcement = freezed,}) {
  return _then(_self.copyWith(
due: freezed == due ? _self.due : due // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,newWords: freezed == newWords ? _self.newWords : newWords // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,reinforcement: freezed == reinforcement ? _self.reinforcement : reinforcement // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [LessonSelection].
extension LessonSelectionPatterns on LessonSelection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonSelection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonSelection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonSelection value)  $default,){
final _that = this;
switch (_that) {
case _LessonSelection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonSelection value)?  $default,){
final _that = this;
switch (_that) {
case _LessonSelection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<dynamic>? due, @JsonKey(name: 'new')  List<dynamic>? newWords,  List<dynamic>? reinforcement)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonSelection() when $default != null:
return $default(_that.due,_that.newWords,_that.reinforcement);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<dynamic>? due, @JsonKey(name: 'new')  List<dynamic>? newWords,  List<dynamic>? reinforcement)  $default,) {final _that = this;
switch (_that) {
case _LessonSelection():
return $default(_that.due,_that.newWords,_that.reinforcement);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<dynamic>? due, @JsonKey(name: 'new')  List<dynamic>? newWords,  List<dynamic>? reinforcement)?  $default,) {final _that = this;
switch (_that) {
case _LessonSelection() when $default != null:
return $default(_that.due,_that.newWords,_that.reinforcement);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LessonSelection implements LessonSelection {
  const _LessonSelection({final  List<dynamic>? due, @JsonKey(name: 'new') final  List<dynamic>? newWords, final  List<dynamic>? reinforcement}): _due = due,_newWords = newWords,_reinforcement = reinforcement;
  factory _LessonSelection.fromJson(Map<String, dynamic> json) => _$LessonSelectionFromJson(json);

 final  List<dynamic>? _due;
@override List<dynamic>? get due {
  final value = _due;
  if (value == null) return null;
  if (_due is EqualUnmodifiableListView) return _due;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<dynamic>? _newWords;
@override@JsonKey(name: 'new') List<dynamic>? get newWords {
  final value = _newWords;
  if (value == null) return null;
  if (_newWords is EqualUnmodifiableListView) return _newWords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<dynamic>? _reinforcement;
@override List<dynamic>? get reinforcement {
  final value = _reinforcement;
  if (value == null) return null;
  if (_reinforcement is EqualUnmodifiableListView) return _reinforcement;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of LessonSelection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonSelectionCopyWith<_LessonSelection> get copyWith => __$LessonSelectionCopyWithImpl<_LessonSelection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonSelectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonSelection&&const DeepCollectionEquality().equals(other._due, _due)&&const DeepCollectionEquality().equals(other._newWords, _newWords)&&const DeepCollectionEquality().equals(other._reinforcement, _reinforcement));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_due),const DeepCollectionEquality().hash(_newWords),const DeepCollectionEquality().hash(_reinforcement));

@override
String toString() {
  return 'LessonSelection(due: $due, newWords: $newWords, reinforcement: $reinforcement)';
}


}

/// @nodoc
abstract mixin class _$LessonSelectionCopyWith<$Res> implements $LessonSelectionCopyWith<$Res> {
  factory _$LessonSelectionCopyWith(_LessonSelection value, $Res Function(_LessonSelection) _then) = __$LessonSelectionCopyWithImpl;
@override @useResult
$Res call({
 List<dynamic>? due,@JsonKey(name: 'new') List<dynamic>? newWords, List<dynamic>? reinforcement
});




}
/// @nodoc
class __$LessonSelectionCopyWithImpl<$Res>
    implements _$LessonSelectionCopyWith<$Res> {
  __$LessonSelectionCopyWithImpl(this._self, this._then);

  final _LessonSelection _self;
  final $Res Function(_LessonSelection) _then;

/// Create a copy of LessonSelection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? due = freezed,Object? newWords = freezed,Object? reinforcement = freezed,}) {
  return _then(_LessonSelection(
due: freezed == due ? _self._due : due // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,newWords: freezed == newWords ? _self._newWords : newWords // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,reinforcement: freezed == reinforcement ? _self._reinforcement : reinforcement // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,
  ));
}


}


/// @nodoc
mixin _$LessonNotes {

@JsonKey(name: 'quran_safe') bool? get quranSafe;@JsonKey(name: 'review_only') bool? get reviewOnly;
/// Create a copy of LessonNotes
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonNotesCopyWith<LessonNotes> get copyWith => _$LessonNotesCopyWithImpl<LessonNotes>(this as LessonNotes, _$identity);

  /// Serializes this LessonNotes to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonNotes&&(identical(other.quranSafe, quranSafe) || other.quranSafe == quranSafe)&&(identical(other.reviewOnly, reviewOnly) || other.reviewOnly == reviewOnly));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quranSafe,reviewOnly);

@override
String toString() {
  return 'LessonNotes(quranSafe: $quranSafe, reviewOnly: $reviewOnly)';
}


}

/// @nodoc
abstract mixin class $LessonNotesCopyWith<$Res>  {
  factory $LessonNotesCopyWith(LessonNotes value, $Res Function(LessonNotes) _then) = _$LessonNotesCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'quran_safe') bool? quranSafe,@JsonKey(name: 'review_only') bool? reviewOnly
});




}
/// @nodoc
class _$LessonNotesCopyWithImpl<$Res>
    implements $LessonNotesCopyWith<$Res> {
  _$LessonNotesCopyWithImpl(this._self, this._then);

  final LessonNotes _self;
  final $Res Function(LessonNotes) _then;

/// Create a copy of LessonNotes
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? quranSafe = freezed,Object? reviewOnly = freezed,}) {
  return _then(_self.copyWith(
quranSafe: freezed == quranSafe ? _self.quranSafe : quranSafe // ignore: cast_nullable_to_non_nullable
as bool?,reviewOnly: freezed == reviewOnly ? _self.reviewOnly : reviewOnly // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [LessonNotes].
extension LessonNotesPatterns on LessonNotes {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonNotes value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonNotes() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonNotes value)  $default,){
final _that = this;
switch (_that) {
case _LessonNotes():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonNotes value)?  $default,){
final _that = this;
switch (_that) {
case _LessonNotes() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'quran_safe')  bool? quranSafe, @JsonKey(name: 'review_only')  bool? reviewOnly)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonNotes() when $default != null:
return $default(_that.quranSafe,_that.reviewOnly);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'quran_safe')  bool? quranSafe, @JsonKey(name: 'review_only')  bool? reviewOnly)  $default,) {final _that = this;
switch (_that) {
case _LessonNotes():
return $default(_that.quranSafe,_that.reviewOnly);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'quran_safe')  bool? quranSafe, @JsonKey(name: 'review_only')  bool? reviewOnly)?  $default,) {final _that = this;
switch (_that) {
case _LessonNotes() when $default != null:
return $default(_that.quranSafe,_that.reviewOnly);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LessonNotes implements LessonNotes {
  const _LessonNotes({@JsonKey(name: 'quran_safe') this.quranSafe, @JsonKey(name: 'review_only') this.reviewOnly});
  factory _LessonNotes.fromJson(Map<String, dynamic> json) => _$LessonNotesFromJson(json);

@override@JsonKey(name: 'quran_safe') final  bool? quranSafe;
@override@JsonKey(name: 'review_only') final  bool? reviewOnly;

/// Create a copy of LessonNotes
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonNotesCopyWith<_LessonNotes> get copyWith => __$LessonNotesCopyWithImpl<_LessonNotes>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonNotesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonNotes&&(identical(other.quranSafe, quranSafe) || other.quranSafe == quranSafe)&&(identical(other.reviewOnly, reviewOnly) || other.reviewOnly == reviewOnly));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quranSafe,reviewOnly);

@override
String toString() {
  return 'LessonNotes(quranSafe: $quranSafe, reviewOnly: $reviewOnly)';
}


}

/// @nodoc
abstract mixin class _$LessonNotesCopyWith<$Res> implements $LessonNotesCopyWith<$Res> {
  factory _$LessonNotesCopyWith(_LessonNotes value, $Res Function(_LessonNotes) _then) = __$LessonNotesCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'quran_safe') bool? quranSafe,@JsonKey(name: 'review_only') bool? reviewOnly
});




}
/// @nodoc
class __$LessonNotesCopyWithImpl<$Res>
    implements _$LessonNotesCopyWith<$Res> {
  __$LessonNotesCopyWithImpl(this._self, this._then);

  final _LessonNotes _self;
  final $Res Function(_LessonNotes) _then;

/// Create a copy of LessonNotes
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? quranSafe = freezed,Object? reviewOnly = freezed,}) {
  return _then(_LessonNotes(
quranSafe: freezed == quranSafe ? _self.quranSafe : quranSafe // ignore: cast_nullable_to_non_nullable
as bool?,reviewOnly: freezed == reviewOnly ? _self.reviewOnly : reviewOnly // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
