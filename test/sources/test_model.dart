import 'package:client_data/client_data.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';

class TestModel extends Model {
  const TestModel({required super.id, this.msg = 'default'});
  final String msg;

  @override
  Map<String, dynamic> toJson() => {'id': this.id, 'msg': msg};

  static TestModel fromJson(Map<String, dynamic> json) => TestModel(
        id: json['id']!,
        msg: json['msg']!,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestModel &&
          runtimeType == other.runtimeType &&
          this.id == other.id &&
          msg == other.msg;

  @override
  int get hashCode => Object.hashAll([this.id, msg]);

  @override
  String toString() => 'TestModel(id: ${this.id}, msg: $msg)';

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

  @override
  List<Object?> get props => [value];
}

class FakeSourceList<T extends Model> extends Fake implements SourceList<T> {
  List<T> objs = <T>[];

  addObj(T obj) => objs.add(obj);

  @override
  Future<ReadResult<T>> getById(
    String id,
    RequestDetails<T> details,
  ) =>
      Future.value(
        Right(ReadSuccess<T>(objs.first, details: details)),
      );

  @override
  Future<ReadListResult<T>> getByIds(
    Set<String> ids,
    RequestDetails<T> details,
  ) =>
      Future.value(
        Right(
          ReadListSuccess<T>.fromList([objs.first], details, {}),
        ),
      );

  @override
  Future<ReadListResult<T>> getItems(RequestDetails<T> details) => Future.value(
        Right(
          ReadListSuccess<T>.fromList([objs.first], details, {}),
        ),
      );

  @override
  Future<ReadListResult<T>> getSelected(RequestDetails<T> details) =>
      Future.value(
        Future.value(
          Right(
            ReadListSuccess<T>.fromList([objs.first], details, {}),
          ),
        ),
      );

  @override
  Future<WriteResult<T>> setItem(T item, RequestDetails<T> details) =>
      Future.value(
        Right(
          WriteSuccess<T>(objs.first, details: details),
        ),
      );

  @override
  Future<WriteListResult<T>> setItems(
    List<T> items,
    RequestDetails<T> details,
  ) =>
      Future.value(
        Right(
          BulkWriteSuccess<T>([objs.first], details: details),
        ),
      );

  @override
  Future<WriteResult<T>> setSelected(
    T item,
    RequestDetails<T> details, {
    bool isSelected = true,
  }) =>
      Future.value(
        Right(
          WriteSuccess<T>(objs.first, details: details),
        ),
      );
}

/// Checks whether a model's given field name equals the given value.
///
/// Not the most performant class, as this re-serializes the model. Best used
/// only for tests.
class FieldEquals<T extends Model> extends ReadFilter<T> {
  const FieldEquals(this.fieldName, this.value);
  final String fieldName;
  final String value;

  @override
  bool predicate(T obj) => obj.toJson()[fieldName] == value;

  @override
  List<Object?> get props => [fieldName, value, T.runtimeType];

  @override
  Map<String, String> toParams() => <String, String>{fieldName: value};
}
