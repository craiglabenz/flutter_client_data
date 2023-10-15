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
  Future<ReadResult<T>> getById(String id, ReadDetails details) async {
    if (!loadedItems.containsKey(id) || !loadedItems[id]!.isCompleted) {
      _print('Maybe queuing Id $id');
      queueId(id);
    }
    return Right(
      ReadSuccess(await loadedItems[id]!.future, details: details),
    );
  }

  @override
  Future<ReadListResult<T>> getItems(
    ReadDetails details, [
    List<ReadFilter<T>> filters = const [],
  ]) async {
    final Params params = <String, String>{};

    final bool shouldRefresh =
        details.requestType == RequestType.refresh && lastUpdatedAt != null;
    if (shouldRefresh) {
      params[updatedSinceQueryParam] = lastUpdatedAt!.toUtc().toIso8601String();
    }
    lastUpdatedAt = DateTime.now();
    final result = await fetchItems(params);

    return result.map(
      success: (s) => Right(
        ReadListSuccess.fromList(
          hydrateListResponse(s),
          details,
          {},
        ),
      ),
      error: (e) => Left(ReadFailure.fromApiError(e)),
    );
  }

  @override
  Future<ReadListResult<T>> getByIds(
    Set<String> ids,
    ReadDetails details,
  ) async {
    if (ids.isEmpty) {
      return Right(ReadListSuccess<T>.fromList([], details, {}));
    }
    final Params params = <String, String>{
      'id__in': ids.join(','),
    };

    final ApiResult result = await fetchItems(params);

    return result.map(
      success: (s) {
        final List<T> items = hydrateListResponse(result as ApiSuccess);
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

        return Right(
          ReadListSuccess<T>.fromMap(itemsById, details, missingItemIds),
        );
      },
      error: (e) => Left(ReadFailure.fromApiError(e)),
    );
  }

  @override
  Future<ReadListResult<T>> getSelected(ReadDetails details) async {
    final request = ReadApiRequest(url: bindings.getSelectedItemsUrl());
    final ApiResult result = await api.get(request);

    return result.map(
      success: (s) {
        final List<T> items = hydrateListResponse(result as ApiSuccess);
        final itemsById = <String, T>{};
        for (final T item in items) {
          // Objects from the server must always have an Id set.
          itemsById[item.id!] = item;
        }
        return Right(ReadListSuccess<T>.fromMap(itemsById, details, {}));
      },
      error: (e) => Left(ReadFailure.fromApiError(e)),
    );
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
      (ReadFailure<T> l) {
        for (final id in ids) {
          loadedItems[id]!.complete(null);
        }
      },
      (ReadListSuccess<T> r) {
        for (final id in r.missingItemIds) {
          loadedItems[id]!.complete(null);
        }
        for (final id in r.itemsMap.keys) {
          if (!loadedItems.containsKey(id)) {
            continue;
          }
          if (!loadedItems[id]!.isCompleted) {
            idsCurrentlyBeingFetched.remove(id);
            loadedItems[id]!.complete(r.itemsMap[id]!);
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

    final result = await (item.id == null //
            ? api.post(request)
            : api.update(request) //
        );

    return result.map(
      success: (s) {
        return Right(
          WriteSuccess(hydrateItemResponse(s)!, details: details),
        );
      },
      error: (e) => Left(WriteFailure.fromApiError(e)),
    );
  }

  @override
  Future<WriteListResult<T>> setItems(
    List<T> items,
    WriteDetails details,
  ) =>
      throw Exception('Should never call ApiSource.setItems');

  T? hydrateItemResponse(ApiSuccess success) => success.body.map(
        html: (HtmlApiResultBody body) => null,
        json: (JsonApiResultBody body) {
          if (body.data.containsKey('results')) {
            // TODO: log that this is unexpected for [result.url]
            if ((body.data['results'] as List).length != 1) {
              // TODO: log that this is even more unexpected
            }
            final List<T> items = (body.data['results'].cast<Json>())
                .map<T>(bindings.fromJson)
                .toList();
            return items.first;
          } else {
            return bindings.fromJson(body.data);
          }
        },
        plainText: (PlainTextApiResultBody body) => null,
      );

  List<T> hydrateListResponse(ApiSuccess success) => success.body.map(
        html: (HtmlApiResultBody body) => <T>[],
        json: (JsonApiResultBody body) {
          if (body.data.containsKey('results')) {
            final List<Map<String, dynamic>> results =
                (body.data['results'] as List).cast<Json>();
            final List<T> items = results.map<T>(bindings.fromJson).toList();
            return items;
          } else {
            return [bindings.fromJson(body.data)];
          }
        },
        plainText: (PlainTextApiResultBody body) => <T>[],
      );

  @override
  Future<WriteResult<T>> setSelected(
    T item,
    WriteDetails details, {
    bool isSelected = true,
  }) async {
    final request = WriteApiRequest(
      url: bindings.getSelectedItemsUrl(),
      body: item.serializeId(),
    );
    final ApiResult result =
        await (isSelected ? api.post(request) : api.delete(request));

    return result.map(
      success: (_) => Right(WriteSuccess(item, details: details)),
      error: (e) => Left(WriteFailure.fromApiError(e)),
    );
  }
}
