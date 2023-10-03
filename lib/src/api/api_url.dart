const Map<String, dynamic> _empty = <String, dynamic>{};

/// Container for locating resources on the server.
///
/// Usage:
/// ```dart
///  class LoginUrl extends ApiUrl {
///    const LoginUrl() : super(path: 'users/login/');
///  }
///
///  class DynamicUrl extends ApiUrl {
///    const DynamicUrl(this.token) : super(path: 'users/{{token}}/');
///  }
///
///  class RegisterUrl extends ApiUrl {
///    const RegisterUrl() : super(path: 'users/register/');
///  }
///
///  class LogoutUrl extends ApiUrl {
///    const LogoutUrl() : super(path: 'users/logout/');
///  }
/// ```
class ApiUrl {
  const ApiUrl({
    required this.path,
    this.context = _empty,
    this.params = _empty,
  });

  static const String v1 = 'api/v1';

  /// Chunk of the URL between the host and a possible querystring. May contain
  /// placeholders of the form {{placeholder}} that are hydrated by [context].
  ///
  /// Combined with baseUrl in the RestApi.
  ///
  /// Usage:
  /// ```dart
  ///   final url = MyApiUrl.someType(uri="a/{{value}}/", context=<String, String>{"value": "url"})
  ///   url.value  # api/v1/a/url/
  /// ```
  final String path;

  /// Map of values used to fill placeholders in [uri].
  final Map<String, dynamic> context;

  /// Map of values to be coerced into a querystring for GET requests.
  final Map<String, dynamic> params;

  String get value {
    var url = '${ApiUrl.v1}/$path$queryString';
    for (final key in context.keys) {
      if (url.contains('{{$key}}')) {
        url = url.replaceAll('{{$key}}', context[key] as String);
      }
    }
    return url;
  }

  Uri get uri => Uri.parse(value);

  String get queryString {
    if (params.isEmpty) return '';

    final stringData = <String, String>{};
    params.forEach((key, dynamic value) {
      stringData[key] = value.toString();
    });
    final uri = Uri(queryParameters: stringData);
    return '?${uri.query}';
  }
}

/// Useful for tests.
class StubUrl extends ApiUrl {
  const StubUrl() : super(path: '/');
}
