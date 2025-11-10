// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Failure {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Failure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Failure()';
}


}

/// @nodoc
class $FailureCopyWith<$Res>  {
$FailureCopyWith(Failure _, $Res Function(Failure) __);
}


/// Adds pattern-matching-related methods to [Failure].
extension FailurePatterns on Failure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NetworkFailure value)?  network,TResult Function( ApiFailure value)?  api,TResult Function( ParsingFailure value)?  parsing,TResult Function( EmptyFailure value)?  empty,TResult Function( UnknownFailure value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NetworkFailure() when network != null:
return network(_that);case ApiFailure() when api != null:
return api(_that);case ParsingFailure() when parsing != null:
return parsing(_that);case EmptyFailure() when empty != null:
return empty(_that);case UnknownFailure() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NetworkFailure value)  network,required TResult Function( ApiFailure value)  api,required TResult Function( ParsingFailure value)  parsing,required TResult Function( EmptyFailure value)  empty,required TResult Function( UnknownFailure value)  unknown,}){
final _that = this;
switch (_that) {
case NetworkFailure():
return network(_that);case ApiFailure():
return api(_that);case ParsingFailure():
return parsing(_that);case EmptyFailure():
return empty(_that);case UnknownFailure():
return unknown(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NetworkFailure value)?  network,TResult? Function( ApiFailure value)?  api,TResult? Function( ParsingFailure value)?  parsing,TResult? Function( EmptyFailure value)?  empty,TResult? Function( UnknownFailure value)?  unknown,}){
final _that = this;
switch (_that) {
case NetworkFailure() when network != null:
return network(_that);case ApiFailure() when api != null:
return api(_that);case ParsingFailure() when parsing != null:
return parsing(_that);case EmptyFailure() when empty != null:
return empty(_that);case UnknownFailure() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int? statusCode,  String? message)?  network,TResult Function( int? statusCode,  String? message)?  api,TResult Function( String? message)?  parsing,TResult Function()?  empty,TResult Function( Object? error,  StackTrace? stackTrace)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NetworkFailure() when network != null:
return network(_that.statusCode,_that.message);case ApiFailure() when api != null:
return api(_that.statusCode,_that.message);case ParsingFailure() when parsing != null:
return parsing(_that.message);case EmptyFailure() when empty != null:
return empty();case UnknownFailure() when unknown != null:
return unknown(_that.error,_that.stackTrace);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int? statusCode,  String? message)  network,required TResult Function( int? statusCode,  String? message)  api,required TResult Function( String? message)  parsing,required TResult Function()  empty,required TResult Function( Object? error,  StackTrace? stackTrace)  unknown,}) {final _that = this;
switch (_that) {
case NetworkFailure():
return network(_that.statusCode,_that.message);case ApiFailure():
return api(_that.statusCode,_that.message);case ParsingFailure():
return parsing(_that.message);case EmptyFailure():
return empty();case UnknownFailure():
return unknown(_that.error,_that.stackTrace);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int? statusCode,  String? message)?  network,TResult? Function( int? statusCode,  String? message)?  api,TResult? Function( String? message)?  parsing,TResult? Function()?  empty,TResult? Function( Object? error,  StackTrace? stackTrace)?  unknown,}) {final _that = this;
switch (_that) {
case NetworkFailure() when network != null:
return network(_that.statusCode,_that.message);case ApiFailure() when api != null:
return api(_that.statusCode,_that.message);case ParsingFailure() when parsing != null:
return parsing(_that.message);case EmptyFailure() when empty != null:
return empty();case UnknownFailure() when unknown != null:
return unknown(_that.error,_that.stackTrace);case _:
  return null;

}
}

}

/// @nodoc


class NetworkFailure implements Failure {
  const NetworkFailure({this.statusCode, this.message});
  

 final  int? statusCode;
 final  String? message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkFailureCopyWith<NetworkFailure> get copyWith => _$NetworkFailureCopyWithImpl<NetworkFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkFailure&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,statusCode,message);

@override
String toString() {
  return 'Failure.network(statusCode: $statusCode, message: $message)';
}


}

/// @nodoc
abstract mixin class $NetworkFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $NetworkFailureCopyWith(NetworkFailure value, $Res Function(NetworkFailure) _then) = _$NetworkFailureCopyWithImpl;
@useResult
$Res call({
 int? statusCode, String? message
});




}
/// @nodoc
class _$NetworkFailureCopyWithImpl<$Res>
    implements $NetworkFailureCopyWith<$Res> {
  _$NetworkFailureCopyWithImpl(this._self, this._then);

  final NetworkFailure _self;
  final $Res Function(NetworkFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? statusCode = freezed,Object? message = freezed,}) {
  return _then(NetworkFailure(
statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ApiFailure implements Failure {
  const ApiFailure({this.statusCode, this.message});
  

 final  int? statusCode;
 final  String? message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiFailureCopyWith<ApiFailure> get copyWith => _$ApiFailureCopyWithImpl<ApiFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiFailure&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,statusCode,message);

@override
String toString() {
  return 'Failure.api(statusCode: $statusCode, message: $message)';
}


}

/// @nodoc
abstract mixin class $ApiFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ApiFailureCopyWith(ApiFailure value, $Res Function(ApiFailure) _then) = _$ApiFailureCopyWithImpl;
@useResult
$Res call({
 int? statusCode, String? message
});




}
/// @nodoc
class _$ApiFailureCopyWithImpl<$Res>
    implements $ApiFailureCopyWith<$Res> {
  _$ApiFailureCopyWithImpl(this._self, this._then);

  final ApiFailure _self;
  final $Res Function(ApiFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? statusCode = freezed,Object? message = freezed,}) {
  return _then(ApiFailure(
statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ParsingFailure implements Failure {
  const ParsingFailure({this.message});
  

 final  String? message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParsingFailureCopyWith<ParsingFailure> get copyWith => _$ParsingFailureCopyWithImpl<ParsingFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParsingFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure.parsing(message: $message)';
}


}

/// @nodoc
abstract mixin class $ParsingFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ParsingFailureCopyWith(ParsingFailure value, $Res Function(ParsingFailure) _then) = _$ParsingFailureCopyWithImpl;
@useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$ParsingFailureCopyWithImpl<$Res>
    implements $ParsingFailureCopyWith<$Res> {
  _$ParsingFailureCopyWithImpl(this._self, this._then);

  final ParsingFailure _self;
  final $Res Function(ParsingFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(ParsingFailure(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class EmptyFailure implements Failure {
  const EmptyFailure();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmptyFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Failure.empty()';
}


}




/// @nodoc


class UnknownFailure implements Failure {
  const UnknownFailure({this.error, this.stackTrace});
  

 final  Object? error;
 final  StackTrace? stackTrace;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnknownFailureCopyWith<UnknownFailure> get copyWith => _$UnknownFailureCopyWithImpl<UnknownFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnknownFailure&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'Failure.unknown(error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class $UnknownFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $UnknownFailureCopyWith(UnknownFailure value, $Res Function(UnknownFailure) _then) = _$UnknownFailureCopyWithImpl;
@useResult
$Res call({
 Object? error, StackTrace? stackTrace
});




}
/// @nodoc
class _$UnknownFailureCopyWithImpl<$Res>
    implements $UnknownFailureCopyWith<$Res> {
  _$UnknownFailureCopyWithImpl(this._self, this._then);

  final UnknownFailure _self;
  final $Res Function(UnknownFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(UnknownFailure(
error: freezed == error ? _self.error : error ,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

// dart format on
