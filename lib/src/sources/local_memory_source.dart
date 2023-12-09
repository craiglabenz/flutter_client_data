import 'package:client_data/client_data.dart';
import 'package:dartz/dartz.dart';

class LocalMemorySource<T extends Model> extends Source<T> {
  Map<String, T> items = {};
  Set<String> get itemIds => items.keys.toSet();
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

  /// Returns all known items from the set of IDs. Any id values not found
  /// appear in `missingItemIds`.
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
    final Iterable<T> itemsIter =
        requestCache[details.cacheKey]!.map<T>((String id) => items[id]!);

    final Iterable<T> filteredItemsIter = itemsIter.where(
      (T obj) => _passesAllFilters(obj, details.filters),
    );

    return Right(
      ReadListSuccess<T>.fromList(filteredItemsIter.toList(), details, {}),
    );
  }

  bool _passesAllFilters(T obj, List<ReadFilter<T>> filters) {
    for (final ReadFilter<T> filter in filters) {
      if (!filter.predicate(obj)) return false;
    }
    return true;
  }

  ReadListResult<T> _applyUnseenRequest(RequestDetails<T> details) {
    // Unseen requests with pagination cannot be fulfilled, as we cannot know we
    // have all the results for that page.
    if (details.pagination != null) {
      return Right(ReadListSuccess.fromList([], details, <String>{}));
    }

    final Set<String> satisfyingIds = itemIds;
    for (final T item in items.values) {
      for (final ReadFilter<T> filter in details.filters) {
        if (!filter.predicate(item)) {
          satisfyingIds.remove(item.id);
        }
      }
    }

    final satisfyingItems = <T>[];
    for (final String id in satisfyingIds) {
      satisfyingItems.add(items[id]!);
    }
    return Right(
      ReadListSuccess.fromList(satisfyingItems, details, <String>{}),
    );
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

    if (details.isNotEmpty) {
      requestCache[details.empty.cacheKey]!.add(item.id!);
    }
    return Right(WriteSuccess<T>(item, details: details));
  }

  @override
  Future<WriteListResult<T>> setItems(
    List<T> items,
    RequestDetails<T> details,
  ) {
    for (final T item in items) {
      setItem(item, details);
    }
    return Future.value(Right(BulkWriteSuccess<T>(items, details: details)));
  }
}
