import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:client_data/client_data.dart';

import 'test_model.dart';

const _id = 'uuid';
const _id2 = 'uuid2';
const detailResponseBody = '{"id": "$_id", "msg": "Fred"}';
const detailResponseBody2 = '{"id": "$_id2", "msg": "Flintstone"}';
const listResponseBody = '{"results": [$detailResponseBody]}';
const twoElementResponseBody =
    '{"results": [$detailResponseBody, $detailResponseBody2]}';
const emptyResponseBody = '{"results": []}';
final returnHeaders = <String, String>{
  HttpHeaders.contentTypeHeader: 'application/json',
};
final requestHeaders = <String, String>{
  HttpHeaders.contentTypeHeader: 'application/json',
  HttpHeaders.acceptHeader: 'application/json',
};
const errorBody = '{"error": "not found"}';

final obj = TestModel.fromJson(jsonDecode(detailResponseBody));
final obj2 = TestModel.fromJson(jsonDecode(detailResponseBody2));

const rd = ReadDetails();
const localRd = ReadDetails(requestType: RequestType.local);
const remoteRd = ReadDetails(requestType: RequestType.refresh);
const rdAbc = ReadDetails(setName: 'abc');

const wrtAbc = WriteDetails(setName: 'abc');

RequestDelegate getRequestDelegate(
  List<String> bodies, {
  int statusCode = 200,
  bool canCreate = false,
  bool canUpdate = false,
}) {
  int count = 0;
  final WriteRequestHandler? postHandler = canCreate //
      ? (url, {headers, body, encoding}) {
          count++;
          return Future.value(http.Response(bodies[count - 1], statusCode,
              headers: returnHeaders));
        }
      : null;
  final WriteRequestHandler? updateHandler = canUpdate //
      ? (url, {headers, body, encoding}) {
          count++;
          return Future.value(http.Response(bodies[count - 1], statusCode,
              headers: returnHeaders));
        }
      : null;

  return RequestDelegate.fake(
    readHandler: (uri, {headers}) {
      count++;
      // Because of pooling, all requests to ApiSource are turned into
      // list responses.
      return Future.value(
        http.Response(bodies[count - 1], statusCode, headers: returnHeaders),
      );
    },
    postHandler: postHandler,
    putHandler: updateHandler,
  );
}

final delegate200 = getRequestDelegate([listResponseBody]);
final twoItemdelegate200 = getRequestDelegate([twoElementResponseBody]);
final twoItemdelegate200x2 =
    getRequestDelegate([twoElementResponseBody, twoElementResponseBody]);
final delegate404 = getRequestDelegate(
  [errorBody],
  statusCode: HttpStatus.notFound,
);
final delegate404x2 = getRequestDelegate(
  [errorBody, errorBody],
  statusCode: HttpStatus.notFound,
);
final emptyDelegate = getRequestDelegate([emptyResponseBody]);

final creatableDelegate =
    getRequestDelegate([listResponseBody], canCreate: true);
final updateableDelegate =
    getRequestDelegate([listResponseBody], canUpdate: true);

SourceList<TestModel> getSourceList(RequestDelegate delegate) =>
    SourceList<TestModel>(
      sources: <Source<TestModel>>[
        LocalMemorySource<TestModel>(),
        LocalMemorySource<TestModel>(),
        ApiSource<TestModel>(
          bindings: TestModel.bindings,
          restApi: RestApi(
            apiBaseUrl: 'https://fake.com',
            headersBuilder: () => requestHeaders,
            delegate: delegate,
          ),
          timer: TestFriendlyTimer(),
        ),
      ],
      bindings: TestModel.bindings,
    );

void main() {
  group('SourceList.getById should', () {
    test('get and cache items', () async {
      final sl = getSourceList(delegate200);
      final readResult = await sl.getById(_id, rd);
      final obj = readResult.getOrRaise().item;
      expect(readResult, isRight);
      expect(
        readResult.getOrRaise().item,
        equals(
          TestModel.fromJson(
            jsonDecode(detailResponseBody) as Json,
          ),
        ),
      );
      expect((sl.sources[0] as LocalMemorySource).itemIds, contains('uuid'));
      expect((sl.sources[1] as LocalMemorySource).itemIds, contains('uuid'));
      expect((await sl.getById(_id, localRd)).getOrRaise().item, obj);
    });

    test('return Left when the item is not found', () async {
      final sl = getSourceList(delegate404);
      final readResult = await sl.getById(_id, rd);
      expect(readResult, isRight);
      expect((sl.sources[0] as LocalMemorySource).itemIds, isEmpty);
      expect((sl.sources[1] as LocalMemorySource).itemIds, isEmpty);
      expect(readResult.getOrRaise().item, isNull);
    });

    test('honor request types in getById', () async {
      final sl = getSourceList(delegate404x2);
      (sl.sources[0] as LocalMemorySource<TestModel>)
          .setItem(obj, const WriteDetails(requestType: RequestType.local));
      (sl.sources[1] as LocalMemorySource<TestModel>)
          .setItem(obj, const WriteDetails(requestType: RequestType.local));

      final readResult = await sl.getById(obj.id!, rd);
      expect(readResult.getOrRaise().item, obj);

      final localReadResult = await sl.getById(obj.id!, localRd);
      expect(localReadResult.getOrRaise().item, obj);

      final remoteReadResult = await sl.getById(obj.id!, remoteRd);
      expect(remoteReadResult.getOrRaise().item, isNull);
    });
  });

  group('SourceList.getByIds should', () {
    test('get and cache items', () async {
      final sl = getSourceList(getRequestDelegate([twoElementResponseBody]));
      final readResult = await sl.getByIds({_id, _id2}, rd);
      expect(readResult, isRight);
      expect(
        readResult.getOrRaise().items,
        equals([
          TestModel.fromJson(
            jsonDecode(detailResponseBody) as Json,
          ),
          TestModel.fromJson(
            jsonDecode(detailResponseBody2) as Json,
          ),
        ]),
      );
      expect((sl.sources[0] as LocalMemorySource).itemIds,
          containsAll([_id, _id2]));
      expect((sl.sources[1] as LocalMemorySource).itemIds,
          containsAll([_id, _id2]));
    });

    test('get and cache items on partial returns', () async {
      final sl = getSourceList(getRequestDelegate([listResponseBody]));
      final readResult = await sl.getByIds({_id, _id2}, rd);
      expect(readResult, isRight);
      expect(
        readResult.getOrRaise().items,
        equals([
          TestModel.fromJson(
            jsonDecode(detailResponseBody) as Json,
          ),
        ]),
      );
      expect((sl.sources[0] as LocalMemorySource).itemIds, contains(_id));
      expect((sl.sources[0] as LocalMemorySource).items[_id2], isNull);
      expect((sl.sources[1] as LocalMemorySource).itemIds, contains(_id));
      expect((sl.sources[1] as LocalMemorySource).items[_id2], isNull);
    });

    test('complete partially filled local hits', () async {
      final sl = getSourceList(twoItemdelegate200);
      (sl.sources[0] as LocalMemorySource<TestModel>)
          .setItem(obj, const WriteDetails(requestType: RequestType.local));
      (sl.sources[1] as LocalMemorySource<TestModel>)
          .setItem(obj, const WriteDetails(requestType: RequestType.local));

      final localReadResult = await sl.getByIds({obj.id!, obj2.id!}, localRd);
      expect(localReadResult.getOrRaise().items.length, 1);
      expect(localReadResult.getOrRaise().missingItemIds, {obj2.id!});

      final remoteReadResult = await sl.getByIds({obj.id!, obj2.id!}, remoteRd);
      expect(remoteReadResult.getOrRaise().items.length, 2);
    });

    test('honor request types', () async {
      final sl = getSourceList(emptyDelegate);
      (sl.sources[0] as LocalMemorySource<TestModel>).setItems(
          [obj, obj2], const WriteDetails(requestType: RequestType.local));
      (sl.sources[1] as LocalMemorySource<TestModel>).setItems(
          [obj, obj2], const WriteDetails(requestType: RequestType.local));

      final readResult = await sl.getByIds({obj.id!, obj2.id!}, rd);
      expect(readResult.getOrRaise().items.length, 2);

      final localReadResult = await sl.getByIds({obj.id!, obj2.id!}, localRd);
      expect(localReadResult.getOrRaise().items.length, 2);

      final remoteReadResult = await sl.getByIds({obj.id!, obj2.id!}, remoteRd);
      expect(remoteReadResult.getOrRaise().items.length, 0);
    });

    test('surface 404s', () async {
      final sl = getSourceList(delegate404x2);
      (sl.sources[0] as LocalMemorySource<TestModel>).setItems(
          [obj, obj2], const WriteDetails(requestType: RequestType.local));
      (sl.sources[1] as LocalMemorySource<TestModel>).setItems(
          [obj, obj2], const WriteDetails(requestType: RequestType.local));

      final readResult = await sl.getByIds({obj.id!, obj2.id!}, rd);
      expect(readResult.getOrRaise().items.length, 2);

      final localReadResult = await sl.getByIds({obj.id!, obj2.id!}, localRd);
      expect(localReadResult.getOrRaise().items.length, 2);

      final remoteReadResult = await sl.getByIds({obj.id!, obj2.id!}, remoteRd);
      expect(remoteReadResult, isLeft);
    });
  });

  group('SourceList.getItems should', () {
    test('load items', () async {
      final sl = getSourceList(twoItemdelegate200x2);
      (sl.sources[0] as LocalMemorySource<TestModel>).setItems(
          [obj, obj2], const WriteDetails(requestType: RequestType.local));

      final localReadResult = await sl.getItems(localRd);
      expect(localReadResult.getOrRaise().items.length, 2);

      final remoteReadResult = await sl.getItems(remoteRd);
      expect(remoteReadResult.getOrRaise().items.length, 2);
    });

    test('honor request types and cache items', () async {
      final sl = getSourceList(getRequestDelegate([twoElementResponseBody]));

      final localReadResult = await sl.getItems(localRd);
      expect(localReadResult.getOrRaise().items.length, 0);

      final remoteReadResult = await sl.getItems(remoteRd);
      expect(remoteReadResult.getOrRaise().items.length, 2);
      expect((sl.sources[0] as LocalMemorySource<TestModel>).items.length, 2);

      final localReadResult2 = await sl.getItems(localRd);
      expect(localReadResult2.getOrRaise().items.length, 2);
    });

    test('handle 404s', () async {
      final sl = getSourceList(getRequestDelegate(
        [errorBody],
        statusCode: HttpStatus.notFound,
      ));
      (sl.sources[0] as LocalMemorySource<TestModel>).setItems(
          [obj, obj2], const WriteDetails(requestType: RequestType.local));

      final remoteReadResult = await sl.getItems(remoteRd);
      expect(remoteReadResult, isLeft);

      final localReadResult = await sl.getItems(localRd);
      expect(localReadResult.getOrRaise().items.length, 2);
    });

    test('honor setNames', () async {
      final sl = getSourceList(getRequestDelegate([twoElementResponseBody]));

      final remoteReadResult = await sl.getItems(rd);
      expect(remoteReadResult.getOrRaise().items.length, 2);

      final localReadResult = await sl.getItems(
          const ReadDetails(setName: 'abc', requestType: RequestType.local));
      expect(localReadResult.getOrRaise().items.length, 0);

      final localReadResult2 =
          await sl.getItems(const ReadDetails(requestType: RequestType.local));
      expect(localReadResult2.getOrRaise().items.length, 2);
    });
  });

  group('SourceList.getSelected should', () {
    test('load and cache items', () async {
      final sl = getSourceList(
          getRequestDelegate([twoElementResponseBody, twoElementResponseBody]));
      final localReadResult = await sl.getSelected(localRd);
      expect(localReadResult.getOrRaise().items.length, 0);

      final remoteReadResult = await sl.getSelected(remoteRd);
      expect(remoteReadResult.getOrRaise().items.length, 2);
      expect((sl.sources[0] as LocalMemorySource<TestModel>).items.length, 2);

      final localReadResult2 = await sl.getSelected(localRd);
      expect(localReadResult2.getOrRaise().items.length, 2);
    });
  });

  group('SourceList.setItem should', () {
    test('persist an item to all layers', () async {
      const newObj = TestModel(id: null, msg: "new");
      final sl = getSourceList(creatableDelegate);
      final writeResult = await sl.setItem(newObj, const WriteDetails());
      expect(writeResult.getOrRaise().item, obj);

      final localReadResult = await sl.getItems(localRd);
      expect(localReadResult.getOrRaise().items.length, 1);
    });

    test('honor setNames', () async {
      const newObj = TestModel(id: null, msg: "new");
      final sl = getSourceList(
          getRequestDelegate([listResponseBody], canCreate: true));
      final writeResult = await sl.setItem(newObj, wrtAbc);
      final savedObj = writeResult.getOrRaise().item;
      expect(savedObj, obj);

      final localReadResult = await sl.getById(
        savedObj.id!,
        const ReadDetails(requestType: RequestType.local, setName: 'abc'),
      );
      expect(localReadResult.getOrRaise().item, savedObj);
    });
  });

  group('SourceList.setItems should', () {
    test('persist items to all local layers', () async {
      const newObj = TestModel(id: 'item 1', msg: 'new');
      const newObj2 = TestModel(id: 'item 2', msg: 'new 2');
      final sl = getSourceList(getRequestDelegate(
          [detailResponseBody, detailResponseBody2],
          canCreate: true));
      final writeResult = await sl.setItems(
        [newObj, newObj2],
        const WriteDetails(requestType: RequestType.local),
      );
      expect(writeResult.getOrRaise().items.length, 2);

      final localReadResult = await sl.getItems(localRd);
      expect(localReadResult.getOrRaise().items.length, 2);
    });

    test('throw for remote setItems', () async {
      const newObj = TestModel(id: 'item 1', msg: 'new');
      // Config of SourceList does not matter for this test
      final sl = getSourceList(getRequestDelegate(
          [detailResponseBody, detailResponseBody2],
          canCreate: true));
      expect(
        () => sl.setItems(
          [newObj],
          const WriteDetails(requestType: RequestType.refresh),
        ),
        throwsAssertionError,
      );
    });
  });

  group('SourceList.setSelected should', () {
    test('persist remotely', () async {
      const newObj = TestModel(id: 'item 1', msg: 'new');
      final sl = getSourceList(getRequestDelegate([detailResponseBody]));
      final writeResult = await sl.setSelected(
        newObj,
        const WriteDetails(requestType: RequestType.local),
      );
      expect(writeResult, isRight);
    });

    test('persist locally', () async {
      const newObj = TestModel(id: 'item 1', msg: 'new');
      final sl = getSourceList(getRequestDelegate([]));
      await sl.setSelected(
        newObj,
        const WriteDetails(requestType: RequestType.local),
      );
      expect(
        (sl.sources.first as LocalMemorySource).selectedIds,
        contains(newObj.id!),
      );
    });
  });
}
