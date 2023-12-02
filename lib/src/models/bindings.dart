import 'package:client_data/client_data.dart';

class Bindings<T extends Model> {
  Bindings({
    required this.fromJson,
    required this.getDetailUrl,
    required this.getListUrl,
  });
  // Url creators.
  final ApiUrl Function(String id) getDetailUrl;
  final ApiUrl Function() getListUrl;

  // Builders.
  final T Function(Map<String, dynamic> data) fromJson;

  ApiUrl getCreateUrl() => getListUrl();
}
