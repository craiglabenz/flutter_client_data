import 'package:dartz/dartz.dart';
import 'package:client_data/client_data.dart';

class LocalMemorySource<T extends Model> extends Source<T> {
  Map<String, T> items = {};
  Set<String> get itemIds => items.keys.toSet();
  Set<String> selectedIds = {};
  Set<int> knownEmptySets = {};
  Map<int, Set<String>> requestCache = {};

  @override
  SourceType get sourceType => SourceType.local;

  /// Returns the object with the given `id`, as long as the item is associated
  /// with the given setName in `details`.
  @override
  Future<ReadResult<T>> getById(String id, RequestDetails<T> details) {
    T? item;
    if (!requestCache.containsKey(details.cacheKey)) {
      item = null;
    } else if (!requestCache[details.cacheKey]!.contains(id)) {
      item = null;
    } else {
      item = items[id];
    }
    return Future.value(
      Right(ReadSuccess(item, details: details)),
    );
  }

  /// Used for bulk read methods that neither want inner futures nor
  /// ReadResults.
  T? _getByIdSync(String id, RequestDetails<T> details) {
    if (!requestCache.containsKey(details.cacheKey)) return null;
    if (!requestCache[details.cacheKey]!.contains(id)) return null;
    return items[id];
  }

  /// Returns all known items from the set of IDs.
  /// Able to return non-empty `missingItemIds`, because unlike setNames and
  /// selected items, we can encounter IDs to unknown objects.
  @override
  Future<ReadListResult<T>> getByIds(
    Set<String> ids,
    RequestDetails<T> details,
  ) async {
    details.assertEmpty('getByIds');
    final itemsById = <String, T>{};
    final missingItemIds = <String>{};
    for (final String id in ids) {
      final maybeItem = _getByIdSync(id, details);
      if (maybeItem != null) {
        itemsById[id] = maybeItem;
      } else {
        missingItemIds.add(id);
      }
    }
    return Right(
      ReadListSuccess<T>.fromMap(itemsById, details, missingItemIds),
    );
  }

  @override
  Future<ReadListResult<T>> getItems(RequestDetails<T> details) async {
    if (knownEmptySets.contains(details.cacheKey)) {
      // TODO(craiglabenz): log this behavior
      return Right(
        ReadListSuccess<T>(
          items: [],
          itemsMap: {},
          details: details,
          missingItemIds: {},
        ),
      );
    }
    if (!requestCache.containsKey(details.cacheKey)) {
      return _applyUnseenRequest(details);
    }

    // Assumes all IDs in `details.setName` have a matching object in `items`,
    // because that is the job of `setItem`.
    Iterable<T> itemsIter =
        requestCache[details.cacheKey]!.map<T>((String id) => items[id]!);

    Iterable<T> filteredItemsIter =
        itemsIter.where((T obj) => _passesAllFilters(
              obj,
              details.filters,
            ));

    return Right(
      ReadListSuccess<T>.fromList(filteredItemsIter.toList(), details, {}),
    );
  }

  bool _passesAllFilters(T obj, List<ReadFilter<T>> filters) {
    for (ReadFilter<T> filter in filters) {
      if (!filter.predicate(obj)) return false;
    }
    return true;
  }

  ReadListResult<T> _applyUnseenRequest(RequestDetails<T> details) {
    // TODO(craiglabenz): return empty result if pagination is not empty

    Set<String> satisfyingIds = itemIds;
    for (T item in items.values) {
      for (ReadFilter<T> filter in details.filters) {
        if (!filter.predicate(item)) {
          satisfyingIds.remove(item.id);
        }
      }
    }

    final satisfyingItems = <T>[];
    for (String id in satisfyingIds) {
      satisfyingItems.add(items[id]!);
    }
    return Right(
      ReadListSuccess.fromList(satisfyingItems, details, <String>{}),
    );
  }

  /// Returns all SelectedItems that are locally available.
  @override
  Future<ReadListResult<T>> getSelected(RequestDetails<T> details) async {
    final items = <T>[];
    final missingItemIds = <String>{};
    for (String id in selectedIds) {
      final item = _getByIdSync(id, details);
      if (item != null) {
        items.add(item);
      } else {
        // Add this `id` as a missingItemId only if it is in the requested set,
        // and thus should have been found by `_getByIdSync`.
        if ((requestCache[details.cacheKey] ?? <String>{}).contains(id)) {
          missingItemIds.add(id);
        }
      }
    }

    return Right(ReadListSuccess<T>.fromList(items, details, missingItemIds));
  }

  @override
  Future<WriteResult<T>> setItem(T item, RequestDetails<T> details) async {
    assert(
      item.id != null,
      'LocalMemorySource can only persist items with an Id',
    );

    if (details.shouldOverwrite ||
        (item.id != null && !items.containsKey(item.id))) {
      items[item.id!] = item;
    }
    if (!requestCache.containsKey(details.cacheKey)) {
      requestCache[details.cacheKey] = <String>{};
    }
    if (!requestCache.containsKey(details.empty.cacheKey)) {
      requestCache[details.empty.cacheKey] = <String>{};
    }
    requestCache[details.cacheKey]!.add(item.id!);
    if (!details.isEmpty) {
      requestCache[details.empty.cacheKey]!.add(item.id!);
    }
    return Right(WriteSuccess<T>(item, details: details));
  }

  @override
  Future<WriteListResult<T>> setItems(
    List<T> items,
    RequestDetails<T> details,
  ) {
    for (T item in items) {
      setItem(item, details);
    }
    return Future.value(Right(BulkWriteSuccess<T>(items, details: details)));
  }

  @override
  Future<WriteResult<T>> setSelected(
    T item,
    RequestDetails<T> details, {
    bool isSelected = true,
  }) async {
    setItem(item, details);
    isSelected ? selectedIds.add(item.id!) : selectedIds.remove(item.id);
    return Right(WriteSuccess(item, details: details));
  }
}
