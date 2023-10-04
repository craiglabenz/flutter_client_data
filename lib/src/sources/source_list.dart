import 'package:dartz/dartz.dart';
import 'package:client_data/client_data.dart';

/// Indicates whether a given [Source] produced data, which is used when we turn
/// around and locally cache objects fetched from the server.
class MatchedSource<T extends Model> {
  MatchedSource._({required this.source, required this.matched});
  factory MatchedSource.matched(Source<T> source) => MatchedSource._(
        source: source,
        matched: true,
      );
  factory MatchedSource.unmatched(Source<T> source) => MatchedSource._(
        source: source,
        matched: false,
      );

  final Source<T> source;
  final bool matched;
  bool get unmatched => !matched;

  @override
  String toString() => 'MatchedSource(matched=$matched, source=$source)';
}

/// Data component which iteratively asks individual sources for an object.
///
/// Sources that originally fail to yield and object have it cached if a
/// fallback source is able to yield it.
///
/// The [RequestType] parameter on [WriteDetails] and [GetDetails] can be used to
/// control which sources are asked, which is helpful when you want to refresh
/// data.
class SourceList<T extends Model> extends DataContract<T> {
  /// Default constructor which accepts a list of [Source] objects and the
  /// model's [Bindings] object.
  SourceList({required this.sources, required this.bindings});

  /// Testing-friendly constructor for wiring things up that don't actually
  /// require a functioning [SourceList].
  factory SourceList.empty(Bindings<T> bindings) =>
      SourceList(sources: [], bindings: bindings);

  final Bindings<T> bindings;
  final List<Source<T>> sources;

  Iterable<MatchedSource<T>> getSources({
    RequestType requestType = RequestType.global,
    bool reversed = false,
  }) sync* {
    final orderedSources = reversed ? sources.reversed : sources;
    for (final source in orderedSources) {
      if (requestType.includes(source.sourceType)) {
        yield MatchedSource.matched(source);
      }
      yield MatchedSource.unmatched(source);
    }
  }

  Future<void> _cacheItem(
    T item,
    List<Source> emptySources,
    WriteDetails details,
  ) async {
    for (final source in emptySources) {
      await source.setItem(item, details);
    }
  }

  Future<void> _cacheItems(
    List<T> items,
    List<Source> emptySources,
    WriteDetails details,
  ) async {
    for (final source in emptySources) {
      await source.setItems(items, details);
    }
  }

  @override
  Future<T?> getById(String id, ReadDetails details) async {
    final emptySources = <Source>[];
    for (final matchedSource in getSources(requestType: details.requestType)) {
      if (matchedSource.unmatched) {
        emptySources.add(matchedSource.source);
        continue;
      }
      final source = matchedSource.source;
      final maybeFoundItem = await source.getById(id, details);
      if (maybeFoundItem != null) {
        await _cacheItem(
          maybeFoundItem,
          emptySources,
          details.toWriteDetails(),
        );
        return maybeFoundItem;
      } else {
        emptySources.add(source);
      }
    }
    return null;
  }

  @override
  Future<ReadListResult<T>> getByIds(
    Set<String> ids,
    ReadDetails details,
  ) async {
    final items = <String, T>{};
    final pastSources = <Source>[];
    final backfillMap = <Source, Set<T>>{};

    // Copy the list of ids.
    // Called `missingIds` not because we've deemed these are all missing, but
    // because we're going to iteratively remove items that are locally known -
    // meaning at the end of the loop, remaining ids will be confirmed missing.
    Set<String> missingIds = Set<String>.from(ids);

    for (final matchedSource in getSources(requestType: details.requestType)) {
      if (missingIds.isEmpty) {
        break;
      }

      if (matchedSource.unmatched) {
        pastSources.add(matchedSource.source);
        continue;
      }
      final source = matchedSource.source;

      final maybeItemsById = await source.getByIds(missingIds, details);
      if (maybeItemsById.isRight()) {
        final foundItems = maybeItemsById.getOrRaise();
        items.addAll(foundItems.itemsMap);
        // Mark which Source needs which items
        for (final pastSource in pastSources) {
          backfillMap.putIfAbsent(pastSource, () => <T>{});
          backfillMap[pastSource]!.addAll(foundItems.items);
        }
      }

      // Remove any now-known Ids from `missingIds`
      missingIds = missingIds.where((id) => !items.containsKey(id)).toSet();

      // Note that we've already processed this Source, so if future Sources
      // produce any new items, we can backfill them to here.
      pastSources.add(source);
    }

    // Persist any items we found to local stores
    for (final pastSource in backfillMap.keys) {
      if (backfillMap[pastSource]!.isNotEmpty) {
        await pastSource.setItems(
          backfillMap[pastSource]!.toList(),
          WriteDetails(requestType: details.requestType),
        );
      }
    }

    return items.isNotEmpty
        ? Right(
            FoundItems<T>.fromMap(items, details, missingIds),
          )
        // ignore: prefer_const_constructors
        : Left(notFound);
  }

  @override
  Future<ReadListResult<T>> getItems(
    ReadDetails details, [
    List<ReadFilter<T>> filters = const [],
  ]) async {
    List<T> items;
    final emptySources = <Source>[];
    for (final matchedSource in getSources(requestType: details.requestType)) {
      if (matchedSource.unmatched) {
        emptySources.add(matchedSource.source);
        continue;
      }
      final source = matchedSource.source;

      final maybeItems = await source.getItems(details, filters);

      if (maybeItems.isRight() && maybeItems.getOrRaise().items.isNotEmpty) {
        items = maybeItems.getOrRaise().items;
        await _cacheItems(
          items,
          emptySources,
          details.toWriteDetails(),
        );
        return Right(FoundItems.fromList(items, details, {}));
      } else {
        emptySources.add(source);
      }
    }
    return const Left(NotFound());
  }

  @override
  Future<ReadListResult<T>> getSelected(ReadDetails details) {
    // TODO: implement getSelected
    throw UnimplementedError();
  }

  @override
  Future<WriteResult<T>> setItem(T item, WriteDetails details) async {
    // T _item = item;
    for (final ms in getSources(
      requestType: details.requestType,
      // Hit API first if item is new, so as to get an Id
      reversed: item.id == null,
    )) {
      if (ms.unmatched) continue;

      final result = await ms.source.setItem(item, details);
      if (result.isLeft()) {
        return Left(
          WriteFailure<T>.error('Failed to save $T with Id ${item.id}'),
        );
      }
      final successfulResult = result.getOrRaise();

      if (item.id == null) {
        if (successfulResult.item.id == null) {
          return Left(
            WriteFailure<T>.error('Failed to generate Id for new $T'),
          );
        }
        item = successfulResult.item;
      }
    }
    return Right(WriteSuccess<T>(item));
  }

  @override
  Future<WriteListResult<T>> setItems(
    List<T> items,
    WriteDetails details,
  ) async {
    for (final ms in getSources(requestType: details.requestType)) {
      if (ms.unmatched) continue;
      final result = await ms.source.setItems(items, details);
      if (result.isLeft()) {
        return Left(WriteFailure<T>.error('Failed to setItems for Type $T'));
      }
    }
    return Right(BulkWriteSuccess<T>(items));
  }

  @override
  Future<WriteResult<T>> setSelected(T item, WriteDetails details,
      {bool isSelected = true}) {
    // TODO: implement setSelected
    throw UnimplementedError();
  }
}
