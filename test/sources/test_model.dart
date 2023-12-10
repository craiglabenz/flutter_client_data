import 'dart:math';
import 'package:client_data/client_data.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_data/shared_data.dart';

@immutable
class TestModel extends Model {
  const TestModel({required super.id, this.msg = defaultMessage});

  factory TestModel.randomId([String msg = defaultMessage]) => TestModel(
        id: Random().nextDouble().toString(),
        msg: msg,
      );

  factory TestModel.fromJson(Map<String, dynamic> json) => TestModel(
        id: json['id'] as String?,
        msg: json['msg'] as String,
      );
  final String msg;

  static const defaultMessage = 'default';

  @override
  Map<String, dynamic> toJson() => {'id': this.id, 'msg': msg};

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

  void addObj(T obj) => objs.add(obj);

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
