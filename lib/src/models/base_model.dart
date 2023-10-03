abstract class Model {
  const Model({this.id});

  final String? id;
  Map<String, dynamic> toJson();
}

abstract class CreatedAtModel extends Model {
  const CreatedAtModel({super.id, required this.createdAt});
  final DateTime createdAt;
}
