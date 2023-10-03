import 'package:freezed_annotation/freezed_annotation.dart';
import 'api.dart';

part 'api_result.freezed.dart';

@Freezed()
class ApiResultBody with _$ApiResultBody {
  const factory ApiResultBody.html(String html) = HtmlApiResultBody;
  const factory ApiResultBody.json(Json data) = JsonApiResultBody;
  const factory ApiResultBody.plainText(String text) = PlainTextApiResultBody;
}

@Freezed()
class ApiResult with _$ApiResult {
  const ApiResult._();
  const factory ApiResult.success({
    required ApiResultBody body,
    required int statusCode,
    required Duration responseTime,
    required String url,
  }) = ApiSuccess;

  const factory ApiResult.error({
    required ErrorMessage error,
    required int statusCode,
    required Duration responseTime,
    required String url,
  }) = ApiError;

  factory ApiResult.fake({
    Map<String, dynamic>? body,
    int? statusCode,
    Duration? responseTime,
    String? url,
  }) =>
      ApiResult.success(
        body: ApiResultBody.json(body ?? <String, dynamic>{}),
        statusCode: statusCode ?? 200,
        url: url ?? 'https://fake.com',
        responseTime: responseTime ?? const Duration(milliseconds: 1),
      );

  bool get isSuccess => this is ApiSuccess;

  Map<String, dynamic> get jsonOrRaise => map(
        success: (ApiSuccess resp) => resp.body.map(
          html: (HtmlApiResultBody body) =>
              throw Exception('Received HTML, expected JSON for ${resp.url}'),
          json: (JsonApiResultBody body) => body.data,
          plainText: (PlainTextApiResultBody body) =>
              throw Exception('Received text, expected JSON for ${resp.url}'),
        ),
        error: (ApiError resp) =>
            throw Exception('Error response for ${resp.url}'),
      );

  String get errorString => map(
        success: (ApiSuccess res) =>
            throw Exception('No error string for successful response'),
        error: (ApiError res) =>
            '${res.statusCode} ${res.url} :: ${res.error.plain}',
      );
}

@freezed
class ErrorMessage with _$ErrorMessage {
  const ErrorMessage._();
  const factory ErrorMessage.fromString(String message) = ErrorString;
  const factory ErrorMessage.fromMap(Map<String, dynamic> message) = ErrorMap;

  String get plain => when<String>(
        fromString: (message) => message,
        fromMap: (msg) =>
            '${msg.keys.first}: ${msg[msg.keys.first].toString()}',
      );
}
