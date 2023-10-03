import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:client_data/client_data.dart';
import 'package:get_it/get_it.dart';

class ApiSource<T extends Model> extends Source<T> {
  ApiSource({
    required this.bindings,
    ITimer? timer,
    RestApi? restApi,
  })  : api = restApi ?? GetIt.I<RestApi>(),
        idsCurrentlyBeingFetched = <String>{},
        loadedItems = {},
        timer = timer ?? BatchTimer(),
        queuedIds = <String>{};

  final Bindings<T> bindings;
  final RestApi api;
  final ITimer timer;
  Set<String> queuedIds;
  Set<String> idsCurrentlyBeingFetched;
  final Map<String, Completer<T?>> loadedItems;
  DateTime? lastUpdatedAt;

  static const updatedSinceQueryParam = 'updatedSince';

  // ignore: avoid_print
  void _print(String msg) => ApiSource._shouldPrint ? print(msg) : null;

  static const bool _shouldPrint = false;

  @override
  SourceType get sourceType => SourceType.remote;

  @override
  Future<T?> getById(String id, ReadDetails details) async {
    if (!loadedItems.containsKey(id) || !loadedItems[id]!.isCompleted) {
      _print('Maybe queuing Id $id');
      queueId(id);
    }
    return await loadedItems[id]!.future;
  }

  @override
  Future<ReadListResult<T>> getItems(ReadDetails details) async {
    final Params params = <String, String>{};

    final bool shouldRefresh =
        details.requestType == RequestType.refresh && lastUpdatedAt != null;
    if (shouldRefresh) {
      params[updatedSinceQueryParam] = lastUpdatedAt!.toUtc().toIso8601String();
    }
    lastUpdatedAt = DateTime.now();
    final result = await fetchItems(params);
    return Right(FoundItems.fromList(hydrateListResponse(result), details, {}));
  }

  @override
  Future<ReadListResult<T>> getByIds(
    Set<String> ids,
    ReadDetails details,
  ) async {
    if (ids.isEmpty) {
      return Right(FoundItems<T>.fromList([], details, {}));
    }
    final Params params = <String, String>{
      'id__in': ids.join(','),
    };

    final ApiResult result = await fetchItems(params);
    final List<T> items = hydrateListResponse(result);
    final itemsById = <String, T>{};
    for (final T item in items) {
      // Objects from the server must always have an Id set.
      itemsById[item.id!] = item;
    }

    final missingItemIds = <String>{};
    for (String id in ids) {
      if (!itemsById.containsKey(id)) {
        missingItemIds.add(id);
      }
    }

    return Right(FoundItems<T>.fromMap(itemsById, details, missingItemIds));
  }

  @override
  Future<ReadListResult<T>> getSelected(ReadDetails details) {
    // TODO: implement getSelected
    throw UnimplementedError();
  }

  void queueId(String id) {
    if (!queuedIds.contains(id) && !idsCurrentlyBeingFetched.contains(id)) {
      _print('Id $id not yet queued - adding to queue now');
      loadedItems[id] = Completer<T?>();
      queuedIds.add(id);
      timer
        ..cancel()
        ..start(const Duration(milliseconds: 1), loadDeferredIds);
    }
  }

  Future<void> loadDeferredIds() async {
    _print('Starting to load deferred ids: $queuedIds');
    queuedIds.forEach(idsCurrentlyBeingFetched.add);
    final Set<String> ids = Set<String>.from(queuedIds);
    queuedIds.clear();
    final byIds =
        await getByIds(ids, const ReadDetails(requestType: RequestType.global));
    byIds.fold(
      (l) {
        for (final id in ids) {
          loadedItems[id]!.complete(null);
        }
      },
      (r) {
        for (final id in r.itemsMap.keys) {
          if (!loadedItems.containsKey(id)) {
            continue;
          }
          if (!loadedItems[id]!.isCompleted) {
            idsCurrentlyBeingFetched.remove(id);
            loadedItems[id]!.complete(r.itemsMap[id]);
            loadedItems.remove(id);
          }
        }
      },
    );
  }

  Future<ApiResult> fetchItems(Params? params) async {
    final request = ReadApiRequest(
      url: bindings.getListUrl(),
      params: params,
    );
    return api.get(request);
  }

  @override
  Future<WriteResult<T>> setItem(
    T item,
    WriteDetails details,
  ) async {
    final request = WriteApiRequest(
      url: item.id == null
          ? bindings.getCreateUrl()
          : bindings.getDetailUrl(item.id!),
      body: item.toJson(),
    );
    return createdItemOr(
      hydrateItemResponse(
        await (item.id == null ? api.post(request) : api.update(request)),
      ),
    );
  }

  @override
  Future<WriteListResult<T>> setItems(
    List<T> items,
    WriteDetails details,
  ) =>
      throw Exception('Should never call ApiSource.setItems');

  T? hydrateItemResponse(ApiResult result) => result.map(
        success: (ApiSuccess success) {
          return success.body.map(
            html: (HtmlApiResultBody body) => null,
            json: (JsonApiResultBody body) {
              if (body.data.containsKey('results')) {
                // TODO: log that this is unexpected for [result.url]
                if ((body.data['results'] as List).length != 1) {
                  // TODO: log that this is even more unexpected
                }
                final List<T> items =
                    (body.data['results'] as List<Map<String, dynamic>>)
                        .map<T>(bindings.fromJson)
                        .toList();
                return items.first;
              } else {
                return bindings.fromJson(body.data);
              }
            },
            plainText: (PlainTextApiResultBody body) => null,
          );
        },
        error: (ApiError error) {
          // TODO: log this
          return null;
        },
      );

  List<T> hydrateListResponse(ApiResult result) => result.map(
        success: (ApiSuccess success) {
          return success.body.map(
            html: (HtmlApiResultBody body) => <T>[],
            json: (JsonApiResultBody body) {
              if (body.data.containsKey('results')) {
                final List<Map<String, dynamic>> results =
                    (body.data['results'] as List).cast<Map<String, dynamic>>();
                final List<T> items =
                    results.map<T>(bindings.fromJson).toList();
                return items;
              } else {
                return [bindings.fromJson(body.data)];
              }
            },
            plainText: (PlainTextApiResultBody body) => <T>[],
          );
        },
        error: (ApiError error) {
          // TODO: log this
          return <T>[];
        },
      );

  @override
  Future<WriteResult<T>> setSelected(T item, WriteDetails details,
      {bool isSelected = true}) {
    // TODO: implement setSelected
    throw UnimplementedError();
  }
}
