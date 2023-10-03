import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'api.dart';

class UnexpectedRequest implements Exception {
  UnexpectedRequest(this.message);
  final String message;

  @override
  String toString() => 'UnexpectedRequest($message)';
}

/// GET typedef
/// Represents all requests that lack a `body` component.
typedef ReadHandler = Future<http.Response> Function(
  Uri url, {
  Map<String, String>? headers,
});

/// POST/PUT/PATCH/DELETE typedef
/// Represents all requests that have a `body` component.
typedef WriteRequestHandler = Future<http.Response> Function(
  Uri url, {
  Map<String, String>? headers,
  Object? body,
  Encoding? encoding,
});

typedef ResponseProcessor = ApiResult Function(DateTime, http.Response);

Future<http.Response> unexpectedGet(Uri url, {Map<String, String>? headers}) =>
    throw UnexpectedRequest('Unexpected GET ${url.toString()}');
Future<http.Response> unexpectedPost(
  Uri url, {
  Map<String, String>? headers,
  Object? body,
  Encoding? encoding,
}) =>
    throw UnexpectedRequest('Unexpected POST ${url.toString()}');
Future<http.Response> unexpectedPut(
  Uri url, {
  Map<String, String>? headers,
  Object? body,
  Encoding? encoding,
}) =>
    throw UnexpectedRequest('Unexpected PUT ${url.toString()}');
Future<http.Response> unexpectedPatch(
  Uri url, {
  Map<String, String>? headers,
  Object? body,
  Encoding? encoding,
}) =>
    throw UnexpectedRequest('Unexpected PATCH ${url.toString()}');
Future<http.Response> unexpectedDelete(
  Uri url, {
  Map<String, String>? headers,
  Object? body,
  Encoding? encoding,
}) =>
    throw UnexpectedRequest('Unexpected DELETE ${url.toString()}');

/// Interface for something that can get data out onto the network.
class RequestDelegate {
  const RequestDelegate._({
    required this.readHandler,
    required this.postHandler,
    required this.putHandler,
    required this.patchHandler,
    required this.deleteHandler,
    required this.responseProcessor,
  });

  factory RequestDelegate.live() => const RequestDelegate._(
        readHandler: http.get,
        postHandler: http.post,
        putHandler: http.put,
        patchHandler: http.patch,
        deleteHandler: http.delete,
        responseProcessor: RequestDelegate.processResponse,
      );

  factory RequestDelegate.fake({
    ReadHandler? readHandler,
    WriteRequestHandler? postHandler,
    WriteRequestHandler? putHandler,
    WriteRequestHandler? patchHandler,
    WriteRequestHandler? deleteHandler,
    ResponseProcessor? responseProcessor,
  }) =>
      RequestDelegate._(
        readHandler: readHandler ?? unexpectedGet,
        postHandler: postHandler ?? unexpectedPost,
        putHandler: putHandler ?? unexpectedPut,
        patchHandler: patchHandler ?? unexpectedPatch,
        deleteHandler: deleteHandler ?? unexpectedDelete,
        responseProcessor: responseProcessor ?? RequestDelegate.processResponse,
      );

  final ReadHandler readHandler;
  final WriteRequestHandler postHandler;
  final WriteRequestHandler putHandler;
  final WriteRequestHandler patchHandler;
  final WriteRequestHandler deleteHandler;
  final ResponseProcessor responseProcessor;

  Future<ApiResult> get(
    String url, {
    required Map<String, String> headers,
  }) async =>
      responseProcessor(
        DateTime.now(),
        await readHandler(Uri.parse(url), headers: headers),
      );

  Future<ApiResult> delete(
    String url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async =>
      responseProcessor(
        DateTime.now(),
        await deleteHandler(
          Uri.parse(url),
          headers: headers,
          body: body,
          encoding: encoding,
        ),
      );

  Future<ApiResult> patch(
    String url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async =>
      responseProcessor(
        DateTime.now(),
        await patchHandler(
          Uri.parse(url),
          headers: headers,
          body: body,
          encoding: encoding,
        ),
      );

  Future<ApiResult> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    return responseProcessor(
      DateTime.now(),
      await postHandler(
        Uri.parse(url),
        headers: headers,
        body: body,
        encoding: encoding,
      ),
    );
  }

  Future<ApiResult> put(
    String url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async =>
      responseProcessor(
        DateTime.now(),
        await putHandler(
          Uri.parse(url),
          headers: headers,
          body: body,
          encoding: encoding,
        ),
      );

  static bool shouldPrint = false;

  static void _print(String msg) {
    if (!RequestDelegate.shouldPrint) return;
    // ignore: avoid_print
    print(msg);
  }

  @visibleForTesting
  static ApiResult processResponse(
    DateTime sentAt,
    http.Response resp,
  ) {
    final responseTime = DateTime.now().difference(sentAt);
    final statusCode = resp.statusCode;
    final is200 = (statusCode - 300) < 0;
    final is300 = !is200 && ((statusCode - 400) < 0);
    final is400 = !is200 && !is300 && (statusCode - 500) < 0;
    final is500 = !is200 && !is300 && !is400 && (statusCode - 500) >= 0;

    final rawResponseBody = utf8.decoder.convert(resp.bodyBytes);
    final contentType =
        resp.headers['content-type'] ?? resp.headers['Content-Type'];
    assert(contentType != null, 'contentType must have a value');

    ApiResultBody? body;

    if (rawResponseBody.isNotEmpty) {
      if (contentType != null) {
        if (contentType.contains('json')) {
          if (rawResponseBody.startsWith('{') ||
              rawResponseBody.startsWith('[')) {
            body = ApiResultBody.json(
              jsonDecode(rawResponseBody) as Map<String, dynamic>,
            );
          } else {
            body = ApiResultBody.plainText(rawResponseBody);
          }
        } else if (contentType.contains('html')) {
          body = ApiResultBody.html(rawResponseBody);
        } else if (contentType.contains('text')) {
          try {
            body = ApiResultBody.json(
              jsonDecode(rawResponseBody) as Map<String, dynamic>,
            );
          } catch (e) {
            body = ApiResultBody.plainText(rawResponseBody);
          }
        }
      }
    } else {
      // Empty response?
      body = !is200
          ? ApiResultBody.json(<String, dynamic>{
              'error': 'Unknown $statusCode Error',
            })
          : const ApiResultBody.json(<String, dynamic>{});
    }

    assert(body != null, 'body must not be null');

    if (is500) {
      _print('500!');
      _print(resp.body);
    }

    if (is200) {
      return ApiResult.success(
        body: body!,
        responseTime: responseTime,
        statusCode: resp.statusCode,
        url: resp.request?.url.toString() ?? '',
      );
    }

    // Error time!
    final errorMessage = body!.map(
      html: (HtmlApiResultBody body) => ErrorMessage.fromString(body.html),
      json: (JsonApiResultBody body) => ErrorMessage.fromMap(body.data),
      plainText: (PlainTextApiResultBody body) =>
          ErrorMessage.fromString(body.text),
    );
    // Application.shared.logEvent(
    //   '${resp.statusCode} API Error to ${resp.request.url}: ${error.plain}',
    // );
    return ApiResult.error(
      error: errorMessage,
      responseTime: responseTime,
      statusCode: resp.statusCode,
      url: resp.request?.url.toString() ?? '',
    );
  }
}
