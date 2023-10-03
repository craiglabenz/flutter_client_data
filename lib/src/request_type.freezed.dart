// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_type.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$RequestType {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() localRequest,
    required TResult Function() refreshRequest,
    required TResult Function() globalRequest,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? localRequest,
    TResult? Function()? refreshRequest,
    TResult? Function()? globalRequest,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? localRequest,
    TResult Function()? refreshRequest,
    TResult Function()? globalRequest,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LocalRequest value) localRequest,
    required TResult Function(RefreshRequest value) refreshRequest,
    required TResult Function(GlobalRequest value) globalRequest,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LocalRequest value)? localRequest,
    TResult? Function(RefreshRequest value)? refreshRequest,
    TResult? Function(GlobalRequest value)? globalRequest,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LocalRequest value)? localRequest,
    TResult Function(RefreshRequest value)? refreshRequest,
    TResult Function(GlobalRequest value)? globalRequest,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequestTypeCopyWith<$Res> {
  factory $RequestTypeCopyWith(
          RequestType value, $Res Function(RequestType) then) =
      _$RequestTypeCopyWithImpl<$Res, RequestType>;
}

/// @nodoc
class _$RequestTypeCopyWithImpl<$Res, $Val extends RequestType>
    implements $RequestTypeCopyWith<$Res> {
  _$RequestTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$LocalRequestImplCopyWith<$Res> {
  factory _$$LocalRequestImplCopyWith(
          _$LocalRequestImpl value, $Res Function(_$LocalRequestImpl) then) =
      __$$LocalRequestImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LocalRequestImplCopyWithImpl<$Res>
    extends _$RequestTypeCopyWithImpl<$Res, _$LocalRequestImpl>
    implements _$$LocalRequestImplCopyWith<$Res> {
  __$$LocalRequestImplCopyWithImpl(
      _$LocalRequestImpl _value, $Res Function(_$LocalRequestImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LocalRequestImpl extends LocalRequest {
  const _$LocalRequestImpl() : super._();

  @override
  String toString() {
    return 'RequestType.localRequest()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LocalRequestImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() localRequest,
    required TResult Function() refreshRequest,
    required TResult Function() globalRequest,
  }) {
    return localRequest();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? localRequest,
    TResult? Function()? refreshRequest,
    TResult? Function()? globalRequest,
  }) {
    return localRequest?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? localRequest,
    TResult Function()? refreshRequest,
    TResult Function()? globalRequest,
    required TResult orElse(),
  }) {
    if (localRequest != null) {
      return localRequest();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LocalRequest value) localRequest,
    required TResult Function(RefreshRequest value) refreshRequest,
    required TResult Function(GlobalRequest value) globalRequest,
  }) {
    return localRequest(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LocalRequest value)? localRequest,
    TResult? Function(RefreshRequest value)? refreshRequest,
    TResult? Function(GlobalRequest value)? globalRequest,
  }) {
    return localRequest?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LocalRequest value)? localRequest,
    TResult Function(RefreshRequest value)? refreshRequest,
    TResult Function(GlobalRequest value)? globalRequest,
    required TResult orElse(),
  }) {
    if (localRequest != null) {
      return localRequest(this);
    }
    return orElse();
  }
}

abstract class LocalRequest extends RequestType {
  const factory LocalRequest() = _$LocalRequestImpl;
  const LocalRequest._() : super._();
}

/// @nodoc
abstract class _$$RefreshRequestImplCopyWith<$Res> {
  factory _$$RefreshRequestImplCopyWith(_$RefreshRequestImpl value,
          $Res Function(_$RefreshRequestImpl) then) =
      __$$RefreshRequestImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RefreshRequestImplCopyWithImpl<$Res>
    extends _$RequestTypeCopyWithImpl<$Res, _$RefreshRequestImpl>
    implements _$$RefreshRequestImplCopyWith<$Res> {
  __$$RefreshRequestImplCopyWithImpl(
      _$RefreshRequestImpl _value, $Res Function(_$RefreshRequestImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$RefreshRequestImpl extends RefreshRequest {
  const _$RefreshRequestImpl() : super._();

  @override
  String toString() {
    return 'RequestType.refreshRequest()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$RefreshRequestImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() localRequest,
    required TResult Function() refreshRequest,
    required TResult Function() globalRequest,
  }) {
    return refreshRequest();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? localRequest,
    TResult? Function()? refreshRequest,
    TResult? Function()? globalRequest,
  }) {
    return refreshRequest?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? localRequest,
    TResult Function()? refreshRequest,
    TResult Function()? globalRequest,
    required TResult orElse(),
  }) {
    if (refreshRequest != null) {
      return refreshRequest();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LocalRequest value) localRequest,
    required TResult Function(RefreshRequest value) refreshRequest,
    required TResult Function(GlobalRequest value) globalRequest,
  }) {
    return refreshRequest(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LocalRequest value)? localRequest,
    TResult? Function(RefreshRequest value)? refreshRequest,
    TResult? Function(GlobalRequest value)? globalRequest,
  }) {
    return refreshRequest?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LocalRequest value)? localRequest,
    TResult Function(RefreshRequest value)? refreshRequest,
    TResult Function(GlobalRequest value)? globalRequest,
    required TResult orElse(),
  }) {
    if (refreshRequest != null) {
      return refreshRequest(this);
    }
    return orElse();
  }
}

abstract class RefreshRequest extends RequestType {
  const factory RefreshRequest() = _$RefreshRequestImpl;
  const RefreshRequest._() : super._();
}

/// @nodoc
abstract class _$$GlobalRequestImplCopyWith<$Res> {
  factory _$$GlobalRequestImplCopyWith(
          _$GlobalRequestImpl value, $Res Function(_$GlobalRequestImpl) then) =
      __$$GlobalRequestImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GlobalRequestImplCopyWithImpl<$Res>
    extends _$RequestTypeCopyWithImpl<$Res, _$GlobalRequestImpl>
    implements _$$GlobalRequestImplCopyWith<$Res> {
  __$$GlobalRequestImplCopyWithImpl(
      _$GlobalRequestImpl _value, $Res Function(_$GlobalRequestImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$GlobalRequestImpl extends GlobalRequest {
  const _$GlobalRequestImpl() : super._();

  @override
  String toString() {
    return 'RequestType.globalRequest()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$GlobalRequestImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() localRequest,
    required TResult Function() refreshRequest,
    required TResult Function() globalRequest,
  }) {
    return globalRequest();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? localRequest,
    TResult? Function()? refreshRequest,
    TResult? Function()? globalRequest,
  }) {
    return globalRequest?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? localRequest,
    TResult Function()? refreshRequest,
    TResult Function()? globalRequest,
    required TResult orElse(),
  }) {
    if (globalRequest != null) {
      return globalRequest();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LocalRequest value) localRequest,
    required TResult Function(RefreshRequest value) refreshRequest,
    required TResult Function(GlobalRequest value) globalRequest,
  }) {
    return globalRequest(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LocalRequest value)? localRequest,
    TResult? Function(RefreshRequest value)? refreshRequest,
    TResult? Function(GlobalRequest value)? globalRequest,
  }) {
    return globalRequest?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LocalRequest value)? localRequest,
    TResult Function(RefreshRequest value)? refreshRequest,
    TResult Function(GlobalRequest value)? globalRequest,
    required TResult orElse(),
  }) {
    if (globalRequest != null) {
      return globalRequest(this);
    }
    return orElse();
  }
}

abstract class GlobalRequest extends RequestType {
  const factory GlobalRequest() = _$GlobalRequestImpl;
  const GlobalRequest._() : super._();
}
