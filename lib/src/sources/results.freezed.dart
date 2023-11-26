// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'results.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$WriteSuccess<T extends Model> {
  T get item => throw _privateConstructorUsedError;
  RequestDetails<T> get details => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WriteSuccessCopyWith<T, WriteSuccess<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WriteSuccessCopyWith<T extends Model, $Res> {
  factory $WriteSuccessCopyWith(
          WriteSuccess<T> value, $Res Function(WriteSuccess<T>) then) =
      _$WriteSuccessCopyWithImpl<T, $Res, WriteSuccess<T>>;
  @useResult
  $Res call({T item, RequestDetails<T> details});
}

/// @nodoc
class _$WriteSuccessCopyWithImpl<T extends Model, $Res,
    $Val extends WriteSuccess<T>> implements $WriteSuccessCopyWith<T, $Res> {
  _$WriteSuccessCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? item = null,
    Object? details = null,
  }) {
    return _then(_value.copyWith(
      item: null == item
          ? _value.item
          : item // ignore: cast_nullable_to_non_nullable
              as T,
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as RequestDetails<T>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WriteSuccessImplCopyWith<T extends Model, $Res>
    implements $WriteSuccessCopyWith<T, $Res> {
  factory _$$WriteSuccessImplCopyWith(_$WriteSuccessImpl<T> value,
          $Res Function(_$WriteSuccessImpl<T>) then) =
      __$$WriteSuccessImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({T item, RequestDetails<T> details});
}

/// @nodoc
class __$$WriteSuccessImplCopyWithImpl<T extends Model, $Res>
    extends _$WriteSuccessCopyWithImpl<T, $Res, _$WriteSuccessImpl<T>>
    implements _$$WriteSuccessImplCopyWith<T, $Res> {
  __$$WriteSuccessImplCopyWithImpl(
      _$WriteSuccessImpl<T> _value, $Res Function(_$WriteSuccessImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? item = null,
    Object? details = null,
  }) {
    return _then(_$WriteSuccessImpl<T>(
      null == item
          ? _value.item
          : item // ignore: cast_nullable_to_non_nullable
              as T,
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as RequestDetails<T>,
    ));
  }
}

/// @nodoc

class _$WriteSuccessImpl<T extends Model> implements _WriteSuccess<T> {
  const _$WriteSuccessImpl(this.item, {required this.details});

  @override
  final T item;
  @override
  final RequestDetails<T> details;

  @override
  String toString() {
    return 'WriteSuccess<$T>(item: $item, details: $details)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WriteSuccessImpl<T> &&
            const DeepCollectionEquality().equals(other.item, item) &&
            (identical(other.details, details) || other.details == details));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(item), details);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WriteSuccessImplCopyWith<T, _$WriteSuccessImpl<T>> get copyWith =>
      __$$WriteSuccessImplCopyWithImpl<T, _$WriteSuccessImpl<T>>(
          this, _$identity);
}

abstract class _WriteSuccess<T extends Model> implements WriteSuccess<T> {
  const factory _WriteSuccess(final T item,
      {required final RequestDetails<T> details}) = _$WriteSuccessImpl<T>;

  @override
  T get item;
  @override
  RequestDetails<T> get details;
  @override
  @JsonKey(ignore: true)
  _$$WriteSuccessImplCopyWith<T, _$WriteSuccessImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BulkWriteSuccess<T extends Model> {
  List<T> get items => throw _privateConstructorUsedError;
  RequestDetails<T> get details => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BulkWriteSuccessCopyWith<T, BulkWriteSuccess<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BulkWriteSuccessCopyWith<T extends Model, $Res> {
  factory $BulkWriteSuccessCopyWith(
          BulkWriteSuccess<T> value, $Res Function(BulkWriteSuccess<T>) then) =
      _$BulkWriteSuccessCopyWithImpl<T, $Res, BulkWriteSuccess<T>>;
  @useResult
  $Res call({List<T> items, RequestDetails<T> details});
}

/// @nodoc
class _$BulkWriteSuccessCopyWithImpl<T extends Model, $Res,
        $Val extends BulkWriteSuccess<T>>
    implements $BulkWriteSuccessCopyWith<T, $Res> {
  _$BulkWriteSuccessCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? details = null,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as RequestDetails<T>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BulkWriteSuccessImplCopyWith<T extends Model, $Res>
    implements $BulkWriteSuccessCopyWith<T, $Res> {
  factory _$$BulkWriteSuccessImplCopyWith(_$BulkWriteSuccessImpl<T> value,
          $Res Function(_$BulkWriteSuccessImpl<T>) then) =
      __$$BulkWriteSuccessImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({List<T> items, RequestDetails<T> details});
}

/// @nodoc
class __$$BulkWriteSuccessImplCopyWithImpl<T extends Model, $Res>
    extends _$BulkWriteSuccessCopyWithImpl<T, $Res, _$BulkWriteSuccessImpl<T>>
    implements _$$BulkWriteSuccessImplCopyWith<T, $Res> {
  __$$BulkWriteSuccessImplCopyWithImpl(_$BulkWriteSuccessImpl<T> _value,
      $Res Function(_$BulkWriteSuccessImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? details = null,
  }) {
    return _then(_$BulkWriteSuccessImpl<T>(
      null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as RequestDetails<T>,
    ));
  }
}

/// @nodoc

class _$BulkWriteSuccessImpl<T extends Model> implements _BulkWriteSuccess<T> {
  const _$BulkWriteSuccessImpl(final List<T> items, {required this.details})
      : _items = items;

  final List<T> _items;
  @override
  List<T> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final RequestDetails<T> details;

  @override
  String toString() {
    return 'BulkWriteSuccess<$T>(items: $items, details: $details)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BulkWriteSuccessImpl<T> &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.details, details) || other.details == details));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_items), details);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BulkWriteSuccessImplCopyWith<T, _$BulkWriteSuccessImpl<T>> get copyWith =>
      __$$BulkWriteSuccessImplCopyWithImpl<T, _$BulkWriteSuccessImpl<T>>(
          this, _$identity);
}

abstract class _BulkWriteSuccess<T extends Model>
    implements BulkWriteSuccess<T> {
  const factory _BulkWriteSuccess(final List<T> items,
      {required final RequestDetails<T> details}) = _$BulkWriteSuccessImpl<T>;

  @override
  List<T> get items;
  @override
  RequestDetails<T> get details;
  @override
  @JsonKey(ignore: true)
  _$$BulkWriteSuccessImplCopyWith<T, _$BulkWriteSuccessImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$WriteFailure<T extends Model> {
  String get message => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) serverError,
    required TResult Function(String message) badRequest,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? serverError,
    TResult? Function(String message)? badRequest,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? serverError,
    TResult Function(String message)? badRequest,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_WriteServerError<T> value) serverError,
    required TResult Function(_WriteClientError<T> value) badRequest,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_WriteServerError<T> value)? serverError,
    TResult? Function(_WriteClientError<T> value)? badRequest,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WriteServerError<T> value)? serverError,
    TResult Function(_WriteClientError<T> value)? badRequest,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WriteFailureCopyWith<T, WriteFailure<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WriteFailureCopyWith<T extends Model, $Res> {
  factory $WriteFailureCopyWith(
          WriteFailure<T> value, $Res Function(WriteFailure<T>) then) =
      _$WriteFailureCopyWithImpl<T, $Res, WriteFailure<T>>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$WriteFailureCopyWithImpl<T extends Model, $Res,
    $Val extends WriteFailure<T>> implements $WriteFailureCopyWith<T, $Res> {
  _$WriteFailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WriteServerErrorImplCopyWith<T extends Model, $Res>
    implements $WriteFailureCopyWith<T, $Res> {
  factory _$$WriteServerErrorImplCopyWith(_$WriteServerErrorImpl<T> value,
          $Res Function(_$WriteServerErrorImpl<T>) then) =
      __$$WriteServerErrorImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$WriteServerErrorImplCopyWithImpl<T extends Model, $Res>
    extends _$WriteFailureCopyWithImpl<T, $Res, _$WriteServerErrorImpl<T>>
    implements _$$WriteServerErrorImplCopyWith<T, $Res> {
  __$$WriteServerErrorImplCopyWithImpl(_$WriteServerErrorImpl<T> _value,
      $Res Function(_$WriteServerErrorImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$WriteServerErrorImpl<T>(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$WriteServerErrorImpl<T extends Model> extends _WriteServerError<T> {
  const _$WriteServerErrorImpl(this.message) : super._();

  @override
  final String message;

  @override
  String toString() {
    return 'WriteFailure<$T>.serverError(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WriteServerErrorImpl<T> &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WriteServerErrorImplCopyWith<T, _$WriteServerErrorImpl<T>> get copyWith =>
      __$$WriteServerErrorImplCopyWithImpl<T, _$WriteServerErrorImpl<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) serverError,
    required TResult Function(String message) badRequest,
  }) {
    return serverError(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? serverError,
    TResult? Function(String message)? badRequest,
  }) {
    return serverError?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? serverError,
    TResult Function(String message)? badRequest,
    required TResult orElse(),
  }) {
    if (serverError != null) {
      return serverError(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_WriteServerError<T> value) serverError,
    required TResult Function(_WriteClientError<T> value) badRequest,
  }) {
    return serverError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_WriteServerError<T> value)? serverError,
    TResult? Function(_WriteClientError<T> value)? badRequest,
  }) {
    return serverError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WriteServerError<T> value)? serverError,
    TResult Function(_WriteClientError<T> value)? badRequest,
    required TResult orElse(),
  }) {
    if (serverError != null) {
      return serverError(this);
    }
    return orElse();
  }
}

abstract class _WriteServerError<T extends Model> extends WriteFailure<T> {
  const factory _WriteServerError(final String message) =
      _$WriteServerErrorImpl<T>;
  const _WriteServerError._() : super._();

  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$WriteServerErrorImplCopyWith<T, _$WriteServerErrorImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WriteClientErrorImplCopyWith<T extends Model, $Res>
    implements $WriteFailureCopyWith<T, $Res> {
  factory _$$WriteClientErrorImplCopyWith(_$WriteClientErrorImpl<T> value,
          $Res Function(_$WriteClientErrorImpl<T>) then) =
      __$$WriteClientErrorImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$WriteClientErrorImplCopyWithImpl<T extends Model, $Res>
    extends _$WriteFailureCopyWithImpl<T, $Res, _$WriteClientErrorImpl<T>>
    implements _$$WriteClientErrorImplCopyWith<T, $Res> {
  __$$WriteClientErrorImplCopyWithImpl(_$WriteClientErrorImpl<T> _value,
      $Res Function(_$WriteClientErrorImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$WriteClientErrorImpl<T>(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$WriteClientErrorImpl<T extends Model> extends _WriteClientError<T> {
  const _$WriteClientErrorImpl(this.message) : super._();

  @override
  final String message;

  @override
  String toString() {
    return 'WriteFailure<$T>.badRequest(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WriteClientErrorImpl<T> &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WriteClientErrorImplCopyWith<T, _$WriteClientErrorImpl<T>> get copyWith =>
      __$$WriteClientErrorImplCopyWithImpl<T, _$WriteClientErrorImpl<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) serverError,
    required TResult Function(String message) badRequest,
  }) {
    return badRequest(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? serverError,
    TResult? Function(String message)? badRequest,
  }) {
    return badRequest?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? serverError,
    TResult Function(String message)? badRequest,
    required TResult orElse(),
  }) {
    if (badRequest != null) {
      return badRequest(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_WriteServerError<T> value) serverError,
    required TResult Function(_WriteClientError<T> value) badRequest,
  }) {
    return badRequest(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_WriteServerError<T> value)? serverError,
    TResult? Function(_WriteClientError<T> value)? badRequest,
  }) {
    return badRequest?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WriteServerError<T> value)? serverError,
    TResult Function(_WriteClientError<T> value)? badRequest,
    required TResult orElse(),
  }) {
    if (badRequest != null) {
      return badRequest(this);
    }
    return orElse();
  }
}

abstract class _WriteClientError<T extends Model> extends WriteFailure<T> {
  const factory _WriteClientError(final String message) =
      _$WriteClientErrorImpl<T>;
  const _WriteClientError._() : super._();

  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$WriteClientErrorImplCopyWith<T, _$WriteClientErrorImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ReadSuccess<T extends Model> {
  T? get item => throw _privateConstructorUsedError;
  RequestDetails<T> get details => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ReadSuccessCopyWith<T, ReadSuccess<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReadSuccessCopyWith<T extends Model, $Res> {
  factory $ReadSuccessCopyWith(
          ReadSuccess<T> value, $Res Function(ReadSuccess<T>) then) =
      _$ReadSuccessCopyWithImpl<T, $Res, ReadSuccess<T>>;
  @useResult
  $Res call({T? item, RequestDetails<T> details});
}

/// @nodoc
class _$ReadSuccessCopyWithImpl<T extends Model, $Res,
    $Val extends ReadSuccess<T>> implements $ReadSuccessCopyWith<T, $Res> {
  _$ReadSuccessCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? item = null,
    Object? details = null,
  }) {
    return _then(_value.copyWith(
      item: null == item
          ? _value.item
          : item // ignore: cast_nullable_to_non_nullable
              as T?,
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as RequestDetails<T>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReadSuccessImplCopyWith<T extends Model, $Res>
    implements $ReadSuccessCopyWith<T, $Res> {
  factory _$$ReadSuccessImplCopyWith(_$ReadSuccessImpl<T> value,
          $Res Function(_$ReadSuccessImpl<T>) then) =
      __$$ReadSuccessImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({T? item, RequestDetails<T> details});
}

/// @nodoc
class __$$ReadSuccessImplCopyWithImpl<T extends Model, $Res>
    extends _$ReadSuccessCopyWithImpl<T, $Res, _$ReadSuccessImpl<T>>
    implements _$$ReadSuccessImplCopyWith<T, $Res> {
  __$$ReadSuccessImplCopyWithImpl(
      _$ReadSuccessImpl<T> _value, $Res Function(_$ReadSuccessImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? item = null,
    Object? details = null,
  }) {
    return _then(_$ReadSuccessImpl<T>(
      null == item
          ? _value.item
          : item // ignore: cast_nullable_to_non_nullable
              as T?,
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as RequestDetails<T>,
    ));
  }
}

/// @nodoc

class _$ReadSuccessImpl<T extends Model> implements _ReadSuccess<T> {
  const _$ReadSuccessImpl(this.item, {required this.details});

  @override
  final T? item;
  @override
  final RequestDetails<T> details;

  @override
  String toString() {
    return 'ReadSuccess<$T>(item: $item, details: $details)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReadSuccessImpl<T> &&
            const DeepCollectionEquality().equals(other.item, item) &&
            (identical(other.details, details) || other.details == details));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(item), details);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReadSuccessImplCopyWith<T, _$ReadSuccessImpl<T>> get copyWith =>
      __$$ReadSuccessImplCopyWithImpl<T, _$ReadSuccessImpl<T>>(
          this, _$identity);
}

abstract class _ReadSuccess<T extends Model> implements ReadSuccess<T> {
  const factory _ReadSuccess(final T? item,
      {required final RequestDetails<T> details}) = _$ReadSuccessImpl<T>;

  @override
  T? get item;
  @override
  RequestDetails<T> get details;
  @override
  @JsonKey(ignore: true)
  _$$ReadSuccessImplCopyWith<T, _$ReadSuccessImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ReadListSuccess<T extends Model> {
  List<T> get items => throw _privateConstructorUsedError;
  Map<String, T> get itemsMap => throw _privateConstructorUsedError;
  Set<String> get missingItemIds => throw _privateConstructorUsedError;
  RequestDetails<T> get details => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ReadListSuccessCopyWith<T, ReadListSuccess<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReadListSuccessCopyWith<T extends Model, $Res> {
  factory $ReadListSuccessCopyWith(
          ReadListSuccess<T> value, $Res Function(ReadListSuccess<T>) then) =
      _$ReadListSuccessCopyWithImpl<T, $Res, ReadListSuccess<T>>;
  @useResult
  $Res call(
      {List<T> items,
      Map<String, T> itemsMap,
      Set<String> missingItemIds,
      RequestDetails<T> details});
}

/// @nodoc
class _$ReadListSuccessCopyWithImpl<T extends Model, $Res,
        $Val extends ReadListSuccess<T>>
    implements $ReadListSuccessCopyWith<T, $Res> {
  _$ReadListSuccessCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? itemsMap = null,
    Object? missingItemIds = null,
    Object? details = null,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      itemsMap: null == itemsMap
          ? _value.itemsMap
          : itemsMap // ignore: cast_nullable_to_non_nullable
              as Map<String, T>,
      missingItemIds: null == missingItemIds
          ? _value.missingItemIds
          : missingItemIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as RequestDetails<T>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReadListSuccessImplCopyWith<T extends Model, $Res>
    implements $ReadListSuccessCopyWith<T, $Res> {
  factory _$$ReadListSuccessImplCopyWith(_$ReadListSuccessImpl<T> value,
          $Res Function(_$ReadListSuccessImpl<T>) then) =
      __$$ReadListSuccessImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call(
      {List<T> items,
      Map<String, T> itemsMap,
      Set<String> missingItemIds,
      RequestDetails<T> details});
}

/// @nodoc
class __$$ReadListSuccessImplCopyWithImpl<T extends Model, $Res>
    extends _$ReadListSuccessCopyWithImpl<T, $Res, _$ReadListSuccessImpl<T>>
    implements _$$ReadListSuccessImplCopyWith<T, $Res> {
  __$$ReadListSuccessImplCopyWithImpl(_$ReadListSuccessImpl<T> _value,
      $Res Function(_$ReadListSuccessImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? itemsMap = null,
    Object? missingItemIds = null,
    Object? details = null,
  }) {
    return _then(_$ReadListSuccessImpl<T>(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      itemsMap: null == itemsMap
          ? _value._itemsMap
          : itemsMap // ignore: cast_nullable_to_non_nullable
              as Map<String, T>,
      missingItemIds: null == missingItemIds
          ? _value._missingItemIds
          : missingItemIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as RequestDetails<T>,
    ));
  }
}

/// @nodoc

class _$ReadListSuccessImpl<T extends Model> extends _ReadListSuccess<T> {
  const _$ReadListSuccessImpl(
      {required final List<T> items,
      required final Map<String, T> itemsMap,
      required final Set<String> missingItemIds,
      required this.details})
      : _items = items,
        _itemsMap = itemsMap,
        _missingItemIds = missingItemIds,
        super._();

  final List<T> _items;
  @override
  List<T> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final Map<String, T> _itemsMap;
  @override
  Map<String, T> get itemsMap {
    if (_itemsMap is EqualUnmodifiableMapView) return _itemsMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_itemsMap);
  }

  final Set<String> _missingItemIds;
  @override
  Set<String> get missingItemIds {
    if (_missingItemIds is EqualUnmodifiableSetView) return _missingItemIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_missingItemIds);
  }

  @override
  final RequestDetails<T> details;

  @override
  String toString() {
    return 'ReadListSuccess<$T>(items: $items, itemsMap: $itemsMap, missingItemIds: $missingItemIds, details: $details)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReadListSuccessImpl<T> &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality().equals(other._itemsMap, _itemsMap) &&
            const DeepCollectionEquality()
                .equals(other._missingItemIds, _missingItemIds) &&
            (identical(other.details, details) || other.details == details));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      const DeepCollectionEquality().hash(_itemsMap),
      const DeepCollectionEquality().hash(_missingItemIds),
      details);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReadListSuccessImplCopyWith<T, _$ReadListSuccessImpl<T>> get copyWith =>
      __$$ReadListSuccessImplCopyWithImpl<T, _$ReadListSuccessImpl<T>>(
          this, _$identity);
}

abstract class _ReadListSuccess<T extends Model> extends ReadListSuccess<T> {
  const factory _ReadListSuccess(
      {required final List<T> items,
      required final Map<String, T> itemsMap,
      required final Set<String> missingItemIds,
      required final RequestDetails<T> details}) = _$ReadListSuccessImpl<T>;
  const _ReadListSuccess._() : super._();

  @override
  List<T> get items;
  @override
  Map<String, T> get itemsMap;
  @override
  Set<String> get missingItemIds;
  @override
  RequestDetails<T> get details;
  @override
  @JsonKey(ignore: true)
  _$$ReadListSuccessImplCopyWith<T, _$ReadListSuccessImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ReadFailure<T> {
  String get message => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) serverError,
    required TResult Function(String message) badRequest,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? serverError,
    TResult? Function(String message)? badRequest,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? serverError,
    TResult Function(String message)? badRequest,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ReadServerError<T> value) serverError,
    required TResult Function(_ReadClientError<T> value) badRequest,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ReadServerError<T> value)? serverError,
    TResult? Function(_ReadClientError<T> value)? badRequest,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ReadServerError<T> value)? serverError,
    TResult Function(_ReadClientError<T> value)? badRequest,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ReadFailureCopyWith<T, ReadFailure<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReadFailureCopyWith<T, $Res> {
  factory $ReadFailureCopyWith(
          ReadFailure<T> value, $Res Function(ReadFailure<T>) then) =
      _$ReadFailureCopyWithImpl<T, $Res, ReadFailure<T>>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$ReadFailureCopyWithImpl<T, $Res, $Val extends ReadFailure<T>>
    implements $ReadFailureCopyWith<T, $Res> {
  _$ReadFailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReadServerErrorImplCopyWith<T, $Res>
    implements $ReadFailureCopyWith<T, $Res> {
  factory _$$ReadServerErrorImplCopyWith(_$ReadServerErrorImpl<T> value,
          $Res Function(_$ReadServerErrorImpl<T>) then) =
      __$$ReadServerErrorImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ReadServerErrorImplCopyWithImpl<T, $Res>
    extends _$ReadFailureCopyWithImpl<T, $Res, _$ReadServerErrorImpl<T>>
    implements _$$ReadServerErrorImplCopyWith<T, $Res> {
  __$$ReadServerErrorImplCopyWithImpl(_$ReadServerErrorImpl<T> _value,
      $Res Function(_$ReadServerErrorImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ReadServerErrorImpl<T>(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ReadServerErrorImpl<T> implements _ReadServerError<T> {
  const _$ReadServerErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'ReadFailure<$T>.serverError(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReadServerErrorImpl<T> &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReadServerErrorImplCopyWith<T, _$ReadServerErrorImpl<T>> get copyWith =>
      __$$ReadServerErrorImplCopyWithImpl<T, _$ReadServerErrorImpl<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) serverError,
    required TResult Function(String message) badRequest,
  }) {
    return serverError(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? serverError,
    TResult? Function(String message)? badRequest,
  }) {
    return serverError?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? serverError,
    TResult Function(String message)? badRequest,
    required TResult orElse(),
  }) {
    if (serverError != null) {
      return serverError(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ReadServerError<T> value) serverError,
    required TResult Function(_ReadClientError<T> value) badRequest,
  }) {
    return serverError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ReadServerError<T> value)? serverError,
    TResult? Function(_ReadClientError<T> value)? badRequest,
  }) {
    return serverError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ReadServerError<T> value)? serverError,
    TResult Function(_ReadClientError<T> value)? badRequest,
    required TResult orElse(),
  }) {
    if (serverError != null) {
      return serverError(this);
    }
    return orElse();
  }
}

abstract class _ReadServerError<T> implements ReadFailure<T> {
  const factory _ReadServerError(final String message) =
      _$ReadServerErrorImpl<T>;

  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$ReadServerErrorImplCopyWith<T, _$ReadServerErrorImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ReadClientErrorImplCopyWith<T, $Res>
    implements $ReadFailureCopyWith<T, $Res> {
  factory _$$ReadClientErrorImplCopyWith(_$ReadClientErrorImpl<T> value,
          $Res Function(_$ReadClientErrorImpl<T>) then) =
      __$$ReadClientErrorImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ReadClientErrorImplCopyWithImpl<T, $Res>
    extends _$ReadFailureCopyWithImpl<T, $Res, _$ReadClientErrorImpl<T>>
    implements _$$ReadClientErrorImplCopyWith<T, $Res> {
  __$$ReadClientErrorImplCopyWithImpl(_$ReadClientErrorImpl<T> _value,
      $Res Function(_$ReadClientErrorImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ReadClientErrorImpl<T>(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ReadClientErrorImpl<T> implements _ReadClientError<T> {
  const _$ReadClientErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'ReadFailure<$T>.badRequest(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReadClientErrorImpl<T> &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReadClientErrorImplCopyWith<T, _$ReadClientErrorImpl<T>> get copyWith =>
      __$$ReadClientErrorImplCopyWithImpl<T, _$ReadClientErrorImpl<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) serverError,
    required TResult Function(String message) badRequest,
  }) {
    return badRequest(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? serverError,
    TResult? Function(String message)? badRequest,
  }) {
    return badRequest?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? serverError,
    TResult Function(String message)? badRequest,
    required TResult orElse(),
  }) {
    if (badRequest != null) {
      return badRequest(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ReadServerError<T> value) serverError,
    required TResult Function(_ReadClientError<T> value) badRequest,
  }) {
    return badRequest(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ReadServerError<T> value)? serverError,
    TResult? Function(_ReadClientError<T> value)? badRequest,
  }) {
    return badRequest?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ReadServerError<T> value)? serverError,
    TResult Function(_ReadClientError<T> value)? badRequest,
    required TResult orElse(),
  }) {
    if (badRequest != null) {
      return badRequest(this);
    }
    return orElse();
  }
}

abstract class _ReadClientError<T> implements ReadFailure<T> {
  const factory _ReadClientError(final String message) =
      _$ReadClientErrorImpl<T>;

  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$ReadClientErrorImplCopyWith<T, _$ReadClientErrorImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
