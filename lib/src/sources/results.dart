import 'dart:io';

import 'package:client_data/client_data.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'results.freezed.dart';

//////////////////
/// WRITE RESULTS
//////////////////

@Freezed()
class WriteSuccess<T extends Model> with _$WriteSuccess<T> {
  const factory WriteSuccess(T item, {required WriteDetails details}) =
      _WriteSuccess;
}

@Freezed()
class BulkWriteSuccess<T extends Model> with _$BulkWriteSuccess<T> {
  const factory BulkWriteSuccess(
    List<T> items, {
    required WriteDetails details,
  }) = _BulkWriteSuccess;
}

/// Represents a failure with the write, resulting from either an unexpected
/// problem on the server or the server rejecting the client's request.
/// The `message` property should be suitable for showing the user.
@Freezed()
class WriteFailure<T extends Model> with _$WriteFailure<T> {
  const WriteFailure._();
  const factory WriteFailure.serverError(String message) = _WriteServerError;
  const factory WriteFailure.badRequest(String message) = _WriteClientError;

  factory WriteFailure.fromApiError(ApiError e) {
    if (e.statusCode >= HttpStatus.badRequest &&
        e.statusCode < HttpStatus.internalServerError) {
      return WriteFailure.badRequest(e.error.plain);
    } else if (e.statusCode >= HttpStatus.internalServerError) {
      return WriteFailure.serverError(e.error.plain);
    }
    // TODO(craiglabenz): Log `e.errorString`
    return WriteFailure.serverError(
      'Unexpected error: ${e.statusCode} ${e.error.plain}',
    );
  }
}

typedef WriteResult<T extends Model> = Either<WriteFailure<T>, WriteSuccess<T>>;
typedef WriteListResult<T extends Model> = //
    Either<WriteFailure<T>, BulkWriteSuccess<T>>;

/////////////////
/// READ RESULTS
/////////////////

@Freezed()
class ReadSuccess<T extends Model> with _$ReadSuccess<T> {
  const factory ReadSuccess(
    T? item, {
    required ReadDetails details,
  }) = _ReadSuccess;
}

@Freezed()
class ReadListSuccess<T extends Model> with _$ReadListSuccess<T> {
  const ReadListSuccess._();
  const factory ReadListSuccess({
    required List<T> items,
    required Map<String, T> itemsMap,
    required Set<String> missingItemIds,
    required ReadDetails details,
  }) = _ReadListSuccess;

  /// Map-friendly constructor.
  factory ReadListSuccess.fromMap(
    Map<String, T> map,
    ReadDetails details,
    Set<String> missingItemIds,
  ) =>
      ReadListSuccess(
        items: map.values.toList(),
        itemsMap: map,
        missingItemIds: missingItemIds,
        details: details,
      );

  /// List-friendly constructor.
  factory ReadListSuccess.fromList(
    List<T> items,
    ReadDetails details,
    Set<String> missingItemIds,
  ) {
    final map = <String, T>{};
    for (final item in items) {
      map[item.id!] = item;
    }
    return ReadListSuccess(
      items: items,
      itemsMap: map,
      details: details,
      missingItemIds: missingItemIds,
    );
  }
}

/// Represents a failure with the read, resulting from either an unexpected
/// problem on the server or the server rejecting the client's request.
/// The `message` property should be suitable for showing the user.
@Freezed()
class ReadFailure<T> with _$ReadFailure<T> {
  const factory ReadFailure.serverError(String message) = _ReadServerError;
  const factory ReadFailure.badRequest(String message) = _ReadClientError;

  factory ReadFailure.fromApiError(ApiError e) {
    if (e.statusCode >= HttpStatus.badRequest &&
        e.statusCode < HttpStatus.internalServerError) {
      return ReadFailure.badRequest(e.error.plain);
    } else if (e.statusCode >= HttpStatus.internalServerError) {
      return ReadFailure.serverError(e.error.plain);
    }
    // TODO(craiglabenz): Log `e.errorString`
    return ReadFailure.serverError(
      'Unexpected error: ${e.statusCode} ${e.error.plain}',
    );
  }
}

typedef ReadResult<T extends Model> = Either<ReadFailure<T>, ReadSuccess<T>>;
typedef ReadListResult<T extends Model> = //
    Either<ReadFailure<T>, ReadListSuccess<T>>;
