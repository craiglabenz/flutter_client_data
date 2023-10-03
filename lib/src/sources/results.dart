import 'package:client_data/client_data.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'results.freezed.dart';

@freezed
class WriteSuccess<T> with _$WriteSuccess<T> {
  const factory WriteSuccess(T item) = _WriteSuccess;
}

@freezed
class BulkWriteSuccess<T> with _$BulkWriteSuccess<T> {
  const factory BulkWriteSuccess(List<T> items) = _BulkWriteSuccess;
}

@freezed
class WriteFailure<T> with _$WriteFailure<T> {
  const factory WriteFailure.conflict() = _WriteFailureConfict;
  const factory WriteFailure.error(String message) = _WriteFailureError;
  const factory WriteFailure.notFound(String id) = _WriteFailureItemNotFound;
}

typedef WriteResult<T extends Model> = Either<WriteFailure<T>, WriteSuccess<T>>;
typedef WriteListResult<T extends Model> = //
    Either<WriteFailure<T>, BulkWriteSuccess<T>>;

/// Sentinel for a failed attempt to retrieve an item.
///
/// This is not itself an error; the item was simply missing.
class NotFound {
  const NotFound();
}

const notFound = NotFound();

class FoundItem<T extends Model> {
  FoundItem(this.item, [this.setName = globalSetName]);
  final T item;
  final String? setName;
}

class FoundItems<T extends Model> {
  /// Generative constructor.
  FoundItems._(this.items, this.itemsMap, this.details, this.missingItemIds);

  /// Map-friendly constructor.
  factory FoundItems.fromMap(
    Map<String, T> map,
    ReadDetails details,
    Set<String> missingItemIds,
  ) =>
      FoundItems._(map.values.toList(), map, details, missingItemIds);

  /// List-friendly constructor.
  factory FoundItems.fromList(
    List<T> items,
    ReadDetails details,
    Set<String> missingItemIds,
  ) {
    final map = <String, T>{};
    for (final item in items) {
      map[item.id!] = item;
    }
    return FoundItems._(items, map, details, missingItemIds);
  }

  final List<T> items;
  final Map<String, T> itemsMap;
  final Set<String> missingItemIds;
  final ReadDetails details;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoundItems &&
          runtimeType == other.runtimeType &&
          // items == other.items &&
          FoundItems._sameItems(this, other) &&
          // itemsMap == other.itemsMap &&
          FoundItems._sameItemsMap(this, other) &&
          // missingItemIds == other.missingItemIds &&
          FoundItems._sameMissingItemIds(this, other) &&
          details == other.details;

  static bool _sameItems<T>(FoundItems a, FoundItems b) {
    if (a.items.length != b.items.length) return false;
    for (T item in a.items as List<T>) {
      if (!b.items.contains(item)) return false;
    }
    return true;
  }

  static bool _sameItemsMap<T>(FoundItems a, FoundItems b) {
    if (a.itemsMap.keys.length != b.itemsMap.keys.length) return false;
    for (String key in a.itemsMap.keys) {
      if (!b.itemsMap.containsKey(key)) return false;
      if (a.itemsMap[key] != b.itemsMap[key]) return false;
    }
    return true;
  }

  static bool _sameMissingItemIds(FoundItems a, FoundItems b) {
    if (a.missingItemIds.length != b.missingItemIds.length) return false;
    return a.missingItemIds.intersection(b.missingItemIds).length ==
        a.missingItemIds.length;
  }

  @override
  int get hashCode =>
      Object.hashAll([items, itemsMap, missingItemIds, details.hashCode]);

  @override
  String toString() => 'FoundItems<$T>(items: $items, itemsMap: $itemsMap, '
      'missingItemIds: $missingItemIds, details: $details)';
}

// typedef ReadResult<T extends Model> = Either<NotFound, FoundItem<T>>;
typedef ReadListResult<T extends Model> = Either<NotFound, FoundItems<T>>;
