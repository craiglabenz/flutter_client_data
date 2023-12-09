import 'package:client_data/client_data.dart';

abstract class Model {
  const Model({this.id});

  final String? id;
  Json toJson();
  Json serializeId() => {'id': id};
}

abstract class CreatedAtModel extends Model {
  const CreatedAtModel({required this.createdAt, super.id});
  final DateTime createdAt;
}
