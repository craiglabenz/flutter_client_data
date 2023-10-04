abstract class Model {
  const Model({this.id});

  final String? id;
  Map<String, dynamic> toJson();
  Map<String, dynamic> serializeId() => {'id': id};
}

abstract class CreatedAtModel extends Model {
  const CreatedAtModel({super.id, required this.createdAt});
  final DateTime createdAt;
}
