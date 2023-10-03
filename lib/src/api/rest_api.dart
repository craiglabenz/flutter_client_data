import 'dart:convert';
import 'dart:io';

import 'api.dart';

typedef HeadersBuilder = Map<String, String> Function();

/// Handler for RESTful external communications.
class RestApi {
  RestApi({
    RequestDelegate? delegate,
    this.forceEndingSlash = false,
    required this.apiBaseUrl,
    required this.headersBuilder,
  }) : _delegate = delegate ?? RequestDelegate.live();

  final RequestDelegate _delegate;
  final HeadersBuilder headersBuilder;
  final String apiBaseUrl;
  final bool forceEndingSlash;

  final bool _shouldPrint = false;

  void _print(String msg) {
    if (!_shouldPrint) return;
    // ignore: avoid_print
    print(msg);
  }

  Map<String, String> getDefaultHeaders({
    String? contentType,
    String? accept,
  }) {
    // final headers = <String, String>{
    //   'Content-Type': contentType,
    //   // 'Accept': contentType,
    //   'App-Name': 'Wash Day',
    //   'App-Version': _appDetails.appVersion,
    //   'App-Build': '${_appDetails.buildNumber}',

    //   /// iOS/Android
    //   'App-OS': _appDetails.os.toString(),

    //   /// OS build number
    //   'App-OS-Version': _appDetails.osVersion,

    //   /// Dev/Prod/etc
    //   'App-Environment': _appDetails.environment.toString(),
    // };

    // if (apiKey != null && apiKey!.isNotEmpty) {
    //   headers[HttpHeaders.authorizationHeader] = 'Token $apiKey';
    // }
    final headers = headersBuilder();
    if (contentType != null) {
      headers[HttpHeaders.contentTypeHeader] = contentType;
    }
    if (accept != null) {
      headers[HttpHeaders.acceptHeader] = accept;
    }
    return headers;
  }

  String _finishUrl(ApiRequest request) {
    String url = '$apiBaseUrl/${request.url.value}';
    if (forceEndingSlash && !url.endsWith('/')) {
      url = '$url/';
    }
    if (request is ReadApiRequest &&
        request.params != null &&
        request.params!.isNotEmpty) {
      url = '$url${Uri(queryParameters: request.params).toString()}';
    }
    return url;
  }

  Future<ApiResult> delete(WriteApiRequest request) async {
    final headers = getDefaultHeaders();

    final result = await _delegate.delete(
      _finishUrl(request),
      headers: headers,
    );
    _print('  ${result.statusCode} (${result.responseTime}) :: $request');
    return result;
  }

  Future<ApiResult> get(ReadApiRequest request) async {
    final headers = getDefaultHeaders();

    final url = _finishUrl(request);
    final result = await _delegate.get(url, headers: headers);
    _print('  ${result.statusCode} (${result.responseTime}) :: $request');
    return result;
  }

  Future<ApiResult> post(WriteApiRequest request) async {
    final headers = getDefaultHeaders(
      contentType: request.contentType,
    );

    final result = await _delegate.post(
      _finishUrl(request),
      body: request.body is! String ? jsonEncode(request.body) : request.body,
      headers: headers,
    );
    _print('  ${result.statusCode} (${result.responseTime}) :: $request');
    return result;
  }

  Future<ApiResult> update(WriteApiRequest request) async {
    final headers = getDefaultHeaders();

    final result = await _delegate.put(
      _finishUrl(request),
      body: request.body,
      headers: headers,
    );
    _print('  ${result.statusCode} (${result.responseTime}) :: $request');
    return result;
  }
}
