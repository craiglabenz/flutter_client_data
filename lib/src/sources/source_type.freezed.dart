// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'source_type.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SourceType {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() localSource,
    required TResult Function() remoteSource,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? localSource,
    TResult? Function()? remoteSource,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? localSource,
    TResult Function()? remoteSource,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LocalSource value) localSource,
    required TResult Function(RemoteSource value) remoteSource,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LocalSource value)? localSource,
    TResult? Function(RemoteSource value)? remoteSource,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LocalSource value)? localSource,
    TResult Function(RemoteSource value)? remoteSource,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SourceTypeCopyWith<$Res> {
  factory $SourceTypeCopyWith(
          SourceType value, $Res Function(SourceType) then) =
      _$SourceTypeCopyWithImpl<$Res, SourceType>;
}

/// @nodoc
class _$SourceTypeCopyWithImpl<$Res, $Val extends SourceType>
    implements $SourceTypeCopyWith<$Res> {
  _$SourceTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$LocalSourceImplCopyWith<$Res> {
  factory _$$LocalSourceImplCopyWith(
          _$LocalSourceImpl value, $Res Function(_$LocalSourceImpl) then) =
      __$$LocalSourceImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LocalSourceImplCopyWithImpl<$Res>
    extends _$SourceTypeCopyWithImpl<$Res, _$LocalSourceImpl>
    implements _$$LocalSourceImplCopyWith<$Res> {
  __$$LocalSourceImplCopyWithImpl(
      _$LocalSourceImpl _value, $Res Function(_$LocalSourceImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LocalSourceImpl extends LocalSource {
  const _$LocalSourceImpl() : super._();

  @override
  String toString() {
    return 'SourceType.localSource()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LocalSourceImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() localSource,
    required TResult Function() remoteSource,
  }) {
    return localSource();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? localSource,
    TResult? Function()? remoteSource,
  }) {
    return localSource?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? localSource,
    TResult Function()? remoteSource,
    required TResult orElse(),
  }) {
    if (localSource != null) {
      return localSource();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LocalSource value) localSource,
    required TResult Function(RemoteSource value) remoteSource,
  }) {
    return localSource(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LocalSource value)? localSource,
    TResult? Function(RemoteSource value)? remoteSource,
  }) {
    return localSource?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LocalSource value)? localSource,
    TResult Function(RemoteSource value)? remoteSource,
    required TResult orElse(),
  }) {
    if (localSource != null) {
      return localSource(this);
    }
    return orElse();
  }
}

abstract class LocalSource extends SourceType {
  const factory LocalSource() = _$LocalSourceImpl;
  const LocalSource._() : super._();
}

/// @nodoc
abstract class _$$RemoteSourceImplCopyWith<$Res> {
  factory _$$RemoteSourceImplCopyWith(
          _$RemoteSourceImpl value, $Res Function(_$RemoteSourceImpl) then) =
      __$$RemoteSourceImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RemoteSourceImplCopyWithImpl<$Res>
    extends _$SourceTypeCopyWithImpl<$Res, _$RemoteSourceImpl>
    implements _$$RemoteSourceImplCopyWith<$Res> {
  __$$RemoteSourceImplCopyWithImpl(
      _$RemoteSourceImpl _value, $Res Function(_$RemoteSourceImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$RemoteSourceImpl extends RemoteSource {
  const _$RemoteSourceImpl() : super._();

  @override
  String toString() {
    return 'SourceType.remoteSource()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$RemoteSourceImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() localSource,
    required TResult Function() remoteSource,
  }) {
    return remoteSource();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? localSource,
    TResult? Function()? remoteSource,
  }) {
    return remoteSource?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? localSource,
    TResult Function()? remoteSource,
    required TResult orElse(),
  }) {
    if (remoteSource != null) {
      return remoteSource();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LocalSource value) localSource,
    required TResult Function(RemoteSource value) remoteSource,
  }) {
    return remoteSource(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LocalSource value)? localSource,
    TResult? Function(RemoteSource value)? remoteSource,
  }) {
    return remoteSource?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LocalSource value)? localSource,
    TResult Function(RemoteSource value)? remoteSource,
    required TResult orElse(),
  }) {
    if (remoteSource != null) {
      return remoteSource(this);
    }
    return orElse();
  }
}

abstract class RemoteSource extends SourceType {
  const factory RemoteSource() = _$RemoteSourceImpl;
  const RemoteSource._() : super._();
}
