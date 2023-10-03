import 'api.dart';

abstract class ApiRequest {
  const ApiRequest({required this.url});

  /// Destination of this request.
  final ApiUrl url;

  String get contentType => 'application/json';
}

class ReadApiRequest extends ApiRequest {
  const ReadApiRequest({required super.url, this.params});

  /// GET/querystring-style payload of this request.
  final Params? params;
}

class WriteApiRequest extends ApiRequest {
  const WriteApiRequest({required super.url, this.body});

  /// POST-style payload of this request.
  final Body? body;
}
