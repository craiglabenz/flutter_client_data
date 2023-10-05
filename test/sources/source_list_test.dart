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
const returnHeaders = <String, String>{
  HttpHeaders.contentTypeHeader: 'application/json',
};
const requestHeaders = <String, String>{
  HttpHeaders.contentTypeHeader: 'application/json',
  HttpHeaders.acceptHeader: 'application/json',
};
const errorBody = '{"error": "not found"}';

const rd = ReadDetails();
const localRd = ReadDetails(requestType: RequestType.local);
const rdAbc = ReadDetails(setName: 'abc');

RequestDelegate getRequestDelegate(String body, [int statusCode = 200]) =>
    RequestDelegate.fake(
      readHandler: (uri, {headers}) {
        // Because of pooling, all requests to ApiSource are turned into
        // list responses.
        return Future.value(
          http.Response(body, statusCode, headers: returnHeaders),
        );
      },
    );

final delegate200 = getRequestDelegate(listResponseBody);
final delegate404 = getRequestDelegate(listResponseBody, 404);

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
  group('SourceList should', () {
//     setUp(() async {
//       await setUpTestingDI();
//     });

    test('get and cache items by Id', () async {
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
      expect(
        (sl.sources[0] as LocalMemorySource).itemIds,
        contains('uuid'),
      );
      expect(
        (sl.sources[1] as LocalMemorySource).itemIds,
        contains('uuid'),
      );
      expect((await sl.getById(_id, localRd)).getOrRaise().item, obj);
    });

    test('return Left when the item is not found', () async {
      final sl = getSourceList(delegate404);
      final readResult = await sl.getById(_id, rd);
      expect(readResult, isRight);
      expect(
        (sl.sources[0] as LocalMemorySource).itemIds,
        isEmpty,
      );
      expect(
        (sl.sources[1] as LocalMemorySource).itemIds,
        isEmpty,
      );
      expect(readResult.getOrRaise().item, isNull);
    });

    test('get and cache items by Ids', () async {
      final sl = getSourceList(getRequestDelegate(twoElementResponseBody));
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
      expect(
        (sl.sources[0] as LocalMemorySource).itemIds,
        containsAll([_id, _id2]),
      );
      expect(
        (sl.sources[1] as LocalMemorySource).itemIds,
        containsAll([_id, _id2]),
      );
    });

    test('get and cache items by Ids on partial returns', () async {
      final sl = getSourceList(getRequestDelegate(listResponseBody));
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
      expect(
        (sl.sources[0] as LocalMemorySource).itemIds,
        contains(_id),
      );
      expect(
        (sl.sources[0] as LocalMemorySource).items[_id2],
        isNull,
      );
      expect(
        (sl.sources[1] as LocalMemorySource).itemIds,
        contains(_id),
      );
      expect(
        (sl.sources[1] as LocalMemorySource).items[_id2],
        isNull,
      );
    });
  });
}
