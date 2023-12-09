import 'dart:convert';
import 'dart:io';
import 'package:client_data/client_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'test_model.dart';

const respHeaders = <String, String>{
  HttpHeaders.contentTypeHeader: 'application/json',
};

ApiSource<TestModel> getSrc({
  ReadHandler? readHandler,
  WriteRequestHandler? postHandler,
  ITimer? timer,
}) =>
    ApiSource<TestModel>(
      bindings: TestModel.bindings,
      restApi: RestApi(
        apiBaseUrl: 'https://fake.com/',
        delegate: RequestDelegate.fake(
          readHandler: readHandler,
          postHandler: postHandler,
        ),
        headersBuilder: () => <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
        },
      ),
      timer: timer ?? TestFriendlyTimer(),
    );

void main() {
  group('ApiSource.getById should', () {
    test('make a GET request and process its response', () async {
      final ApiSource<TestModel> src = getSrc(
        readHandler: (url, {headers}) async {
          return http.Response(
            jsonEncode({'id': 'abc', 'msg': 'amazing'}),
            HttpStatus.ok,
            headers: respHeaders,
          );
        },
      );
      final result = await src.getById('abc', RequestDetails());
      expect(result, isRight);
      expect(
        result.getOrRaise().item,
        const TestModel(id: 'abc', msg: 'amazing'),
      );
    });

    test('work with a real timer', () async {
      final ApiSource<TestModel> src = getSrc(
        readHandler: (url, {headers}) async {
          return http.Response(
            jsonEncode({'id': 'abc', 'msg': 'amazing'}),
            HttpStatus.ok,
            headers: respHeaders,
          );
        },
        timer: BatchTimer(),
      );
      final result = await src.getById('abc', RequestDetails());
      expect(result, isRight);
      expect(
        result.getOrRaise().item,
        const TestModel(id: 'abc', msg: 'amazing'),
      );
    });

    test(
      'return null from a 404',
      () async {
        final ApiSource<TestModel> src = getSrc(
          readHandler: (url, {headers}) async {
            return http.Response(
              'Not found',
              HttpStatus.notFound,
              headers: {HttpHeaders.contentTypeHeader: 'text/plain'},
            );
          },
        );
        final result = await src.getById('abc', RequestDetails());
        expect(result, isRight);
        expect(result.getOrRaise().item, null);
      },
      timeout: const Timeout(Duration(milliseconds: 50)),
    );
  });

  group('ApiSource.getByIds should', () {
    test('make a GET request and process its response', () async {
      final ApiSource<TestModel> src = getSrc(
        readHandler: (url, {headers}) async {
          return http.Response(
            jsonEncode(
              {
                'results': [
                  {'id': 'abc', 'msg': 'amazing'},
                  {'id': 'xyz', 'msg': 'pretty good'},
                ],
              },
            ),
            HttpStatus.ok,
            headers: respHeaders,
          );
        },
      );
      final result = await src.getByIds({'abc', 'xyz'}, RequestDetails());
      expect(result.isRight(), isTrue);
      final items = result.getOrRaise().items;
      expect(items.first, const TestModel(id: 'abc', msg: 'amazing'));
      expect(items.last, const TestModel(id: 'xyz', msg: 'pretty good'));
    });

    test('handle partial responses', () async {
      final ApiSource<TestModel> src = getSrc(
        readHandler: (url, {headers}) async {
          return http.Response(
            jsonEncode(
              {
                'results': [
                  {'id': 'abc', 'msg': 'amazing'},
                ],
              },
            ),
            HttpStatus.ok,
            headers: respHeaders,
          );
        },
      );
      final result = await src.getByIds({'abc', 'xyz'}, RequestDetails());
      expect(result.isRight(), isTrue);
      final items = result.getOrRaise().items;
      expect(items.first, const TestModel(id: 'abc', msg: 'amazing'));
      expect(result.getOrRaise().missingItemIds.contains('xyz'), isTrue);
    });

    test('handle zero hits', () async {
      final ApiSource<TestModel> src = getSrc(
        readHandler: (url, {headers}) async {
          return http.Response(
            jsonEncode({'results': <Object>[]}),
            HttpStatus.ok,
            headers: respHeaders,
          );
        },
      );
      final result = await src.getByIds({'abc', 'xyz'}, RequestDetails());
      expect(result.isRight(), isTrue);
      final items = result.getOrRaise().items;
      expect(items, isEmpty);
      expect(result.getOrRaise().missingItemIds.contains('abc'), isTrue);
      expect(result.getOrRaise().missingItemIds.contains('xyz'), isTrue);
    });

    test('handle a 404', () async {
      final ApiSource<TestModel> src = getSrc(
        readHandler: (url, {headers}) async {
          return http.Response(
            'Not found',
            HttpStatus.notFound,
            headers: {HttpHeaders.contentTypeHeader: 'text/plain'},
          );
        },
      );
      final result = await src.getByIds({'abc', 'xyz'}, RequestDetails());
      expect(result.isLeft(), isTrue);
    });
  });
}
