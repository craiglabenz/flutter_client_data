import 'package:client_data/client_data.dart';
import 'package:json_annotation/json_annotation.dart';

class TestModel extends Model {
  const TestModel({required super.id, this.msg = 'default'});
  final String msg;

  @override
  Map<String, dynamic> toJson() => {'id': id, 'msg': msg};

  static TestModel fromJson(Map<String, dynamic> json) => TestModel(
        id: json['id']!,
        msg: json['msg']!,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          msg == other.msg;

  @override
  int get hashCode => Object.hashAll([id, msg]);

  @override
  String toString() => 'TestModel(id: $id, msg: $msg)';

  static Bindings<TestModel> bindings = Bindings<TestModel>(
    fromJson: TestModel.fromJson,
    getDetailUrl: (id) => ApiUrl(path: 'test/$id'),
    getListUrl: () => const ApiUrl(path: 'test/'),
    getSelectedItemsUrl: () => const ApiUrl(path: 'users/me/tests'),
  );
}

class MsgStartsWithFilter<T extends TestModel> extends ReadFilter<T> {
  const MsgStartsWithFilter(this.value);
  final String value;
  @override
  bool predicate(T obj) => obj.msg.startsWith(value);
  @override
  Map<String, String> toParams() => {'msg__startsWith': value};
}
