import 'dart:io';
import 'package:client_data/client_data.dart';

typedef Headers = Map<String, String>;

abstract class ApiRequest {
  const ApiRequest({required this.url, this.apiKey, Headers headers = const {}})
      : _headers = headers;

  /// Optional authentication token behind this request.
  final String? apiKey;

  /// Destination of this request.
  final ApiUrl url;

  /// Default content type header.
  String get contentType => 'application/json';

  /// Starter headers for this request. If [apiKey] is not null, it will
  /// be added as the authorization header.
  final Headers _headers;

  /// Returns complete map of HTTP headers for this request.
  Map<String, String> buildHeaders() {
    final Headers headers = Map<String, String>.from(_headers);
    headers['Content-Type'] = contentType;
    if (apiKey != null) {
      headers[HttpHeaders.authorizationHeader] = 'Token $apiKey';
    }
    return headers;
  }
}

class ReadApiRequest extends ApiRequest {
  const ReadApiRequest({
    required super.url,
    super.apiKey,
    super.headers,
    this.params,
  });

  /// GET/querystring-style payload of this request.
  final Params? params;
}

class WriteApiRequest extends ApiRequest {
  const WriteApiRequest({
    required super.url,
    super.apiKey,
    super.headers,
    this.body,
  });

  /// POST-style payload of this request.
  final Body? body;
}
