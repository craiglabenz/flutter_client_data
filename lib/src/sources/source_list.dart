import 'package:dartz/dartz.dart';
import 'package:client_data/client_data.dart';

/// Data component which iteratively asks individual sources for an object.
///
/// Sources that originally fail to yield and object have it cached if a
/// fallback source is able to yield it.
///
/// The [RequestType] parameter on [RequestDetails<T>] and [GetDetails] can be used to
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
    RequestDetails<T> details,
  ) async {
    for (final source in emptySources) {
      await source.setItem(item, details);
    }
  }

  Future<void> _cacheItems(
    List<T> items,
    List<Source> emptySources,
    RequestDetails<T> details,
  ) async {
    for (final source in emptySources) {
      await source.setItems(items, details);
    }
  }

  @override
  Future<ReadResult<T>> getById(String id, RequestDetails<T> details) async {
    final emptySources = <Source<T>>[];
    for (final matchedSource in getSources(requestType: details.requestType)) {
      if (matchedSource.unmatched) {
        emptySources.add(matchedSource.source);
        continue;
      }
      final source = matchedSource.source;
      final sourceResult = await source.getById(id, details);

      if (sourceResult.isLeft()) {
        return sourceResult;
      }

      final maybeItem = sourceResult.getOrRaise().item;
      if (maybeItem != null) {
        await _cacheItem(maybeItem, emptySources, details);
        return sourceResult;
      }
      emptySources.add(source);
    }
    return Right(ReadSuccess(null, details: details));
  }

  @override
  Future<ReadListResult<T>> getByIds(
    Set<String> ids,
    RequestDetails<T> details,
  ) async {
    details.assertEmpty('getByIds');
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
      final sourceResult =
          await matchedSource.source.getByIds(missingIds, details);

      if (sourceResult.isLeft()) {
        return sourceResult;
      }

      final readSuccess = sourceResult.getOrRaise();
      items.addAll(readSuccess.itemsMap);
      // Mark which Source needs which items
      for (final pastSource in pastSources) {
        backfillMap.putIfAbsent(pastSource, () => <T>{});
        backfillMap[pastSource]!.addAll(readSuccess.items);
      }

      // Remove any now-known Ids from `missingIds`
      missingIds = missingIds.where((id) => !items.containsKey(id)).toSet();

      // Note that we've already processed this Source, so if future Sources
      // produce any new items, we can backfill them to here.
      pastSources.add(matchedSource.source);
    }

    // Persist any items we found to local stores
    for (final pastSource in backfillMap.keys) {
      if (backfillMap[pastSource]!.isNotEmpty) {
        await pastSource.setItems(
          backfillMap[pastSource]!.toList(),
          RequestDetails<T>(requestType: details.requestType),
        );
      }
    }

    return Right(ReadListSuccess<T>.fromMap(items, details, missingIds));
  }

  @override
  Future<ReadListResult<T>> getItems(RequestDetails<T> details) async {
    final emptySources = <Source>[];
    for (final matchedSource in getSources(requestType: details.requestType)) {
      if (matchedSource.unmatched) {
        emptySources.add(matchedSource.source);
        continue;
      }

      final sourceResult = await matchedSource.source.getItems(details);

      if (sourceResult.isLeft()) {
        return sourceResult;
      }

      List<T> items = sourceResult.getOrRaise().items;
      if (items.isNotEmpty) {
        await _cacheItems(items, emptySources, details);
        return Right(ReadListSuccess<T>.fromList(items, details, {}));
      } else {
        emptySources.add(matchedSource.source);
      }
    }
    return Right(ReadListSuccess<T>.fromList([], details, {}));
  }

  @override
  Future<WriteResult<T>> setItem(T item, RequestDetails<T> details) async {
    // T _item = item;
    for (final ms in getSources(
      requestType: details.requestType,
      // Hit API first if item is new, so as to get an Id
      reversed: item.id == null,
    )) {
      if (ms.unmatched) continue;

      final result = await ms.source.setItem(item, details);
      if (result.isLeft()) {
        return result;
      }

      final successfulResult = result.getOrRaise();

      if (item.id == null) {
        if (successfulResult.item.id == null) {
          return Left(
            WriteFailure<T>.serverError('Failed to generate Id for new $T'),
          );
        }
        item = successfulResult.item;
      }
    }
    return Right(WriteSuccess<T>(item, details: details));
  }

  @override
  Future<WriteListResult<T>> setItems(
    List<T> items,
    RequestDetails<T> details,
  ) async {
    assert(details.requestType == RequestType.local,
        'setItems is a local-only method');
    for (final ms in getSources(requestType: details.requestType)) {
      if (ms.unmatched) continue;
      final result = await ms.source.setItems(items, details);
      if (result.isLeft()) {
        return result;
      }
    }
    return Right(BulkWriteSuccess<T>(items, details: details));
  }
}

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
