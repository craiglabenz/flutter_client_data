import 'package:dartz/dartz.dart';
import 'package:client_data/client_data.dart';

class LocalMemorySource<T extends Model> extends Source<T> {
  Map<String, T> items = {};
  Map<String, Set<String>> itemSets = {globalSetName: <String>{}};
  List<String> get itemIds => items.keys.toList();
  Set<String> selectedIds = {};

  @override
  SourceType get sourceType => SourceType.local;

  /// Returns the object with the given `id`, as long as the item is associated
  /// with the given setName in `details`. By default, [ReadDetails] uses
  /// the [globalSetName], so that will match any item stored for any reason.
  @override
  Future<ReadResult<T>> getById(String id, ReadDetails details) {
    T? item;
    if (!itemSets.containsKey(details.setName)) {
      item = null;
    } else if (!itemSets[details.setName]!.contains(id)) {
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
  T? _getByIdSync(String id, String setName) {
    if (!itemSets.containsKey(setName)) return null;
    if (!itemSets[setName]!.contains(id)) return null;
    return items[id];
  }

  /// Returns all known items from the set of IDs.
  /// Able to return non-empty `missingItemIds`, because unlike setNames and
  /// selected items, we can encounter IDs to unknown objects.
  @override
  Future<ReadListResult<T>> getByIds(
    Set<String> ids,
    ReadDetails details,
  ) async {
    assert(
      details.setName == globalSetName,
      'Must not supply a setName to getByIds',
    );
    final itemsById = <String, T>{};
    final missingItemIds = <String>{};
    for (final String id in ids) {
      final maybeItem = _getByIdSync(id, details.setName);
      if (maybeItem != null) {
        itemsById[id] = maybeItem;
      } else {
        missingItemIds.add(id);
      }
    }
    // TODO(craiglabenz): Make sure SourceList or Repository does something with
    // non-empty `missingItemIds`.
    return Right(
      ReadListSuccess<T>.fromMap(itemsById, details, missingItemIds),
    );
  }

  @override
  Future<ReadListResult<T>> getItems(
    ReadDetails details, [
    List<ReadFilter<T>> filters = const [],
  ]) async {
    if (!itemSets.containsKey(details.setName)) {
      // TODO: This does not differentiate between known empty
      // sets and brand new sets we just don't have anything for.
      return Right(
        ReadListSuccess<T>(
          items: [],
          itemsMap: {},
          details: details,
          missingItemIds: {},
        ),
      );
    }

    // Assumes all IDs in `details.setName` have a matching object in `items`,
    // because that is the job of `setItem`.
    Iterable<T> itemsIter =
        itemSets[details.setName]!.map<T>((String id) => items[id]!);

    Iterable<T> filteredItemsIter =
        itemsIter.where((T obj) => _passesAllFilters(obj, filters));

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

  /// Returns all SelectedItems that are locally available.
  @override
  Future<ReadListResult<T>> getSelected(ReadDetails details) async {
    final items = <T>[];
    final missingItemIds = <String>{};
    for (String id in selectedIds) {
      final item = _getByIdSync(id, details.setName);
      if (item != null) {
        items.add(item);
      } else {
        // Add this `id` as a missingItemId only if it is in the requested set,
        // and thus should have been found by `_getByIdSync`.
        if ((itemSets[details.setName] ?? <String>{}).contains(id)) {
          missingItemIds.add(id);
        }
      }
    }

    return Right(ReadListSuccess<T>.fromList(items, details, missingItemIds));
  }

  @override
  Future<WriteResult<T>> setItem(T item, WriteDetails details) async {
    assert(
      item.id != null,
      'LocalMemorySource can only persist items with an Id',
    );

    if (details.shouldOverwrite ||
        (item.id != null && !items.containsKey(item.id))) {
      items[item.id!] = item;
    }
    if (!itemSets.containsKey(details.setName)) {
      itemSets[details.setName] = <String>{};
    }
    if (!itemSets[details.setName]!.contains(item.id)) {
      itemSets[details.setName]!.add(item.id!);
    }
    itemSets[globalSetName]!.add(item.id!);
    return Right(WriteSuccess<T>(item, details: details));
  }

  @override
  Future<WriteListResult<T>> setItems(List<T> items, WriteDetails details) {
    for (T item in items) {
      setItem(item, details);
    }
    return Future.value(Right(BulkWriteSuccess<T>(items, details: details)));
  }

  @override
  Future<WriteResult<T>> setSelected(T item, WriteDetails details,
      {bool isSelected = true}) async {
    setItem(item, details);
    isSelected ? selectedIds.add(item.id!) : selectedIds.remove(item.id);
    return Right(WriteSuccess(item, details: details));
  }
}
