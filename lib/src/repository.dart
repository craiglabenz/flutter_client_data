import 'package:client_data/client_data.dart';

class Repository<T extends Model> extends DataContract {
  @override
  Future<ReadResult<T>> getById(String id, ReadDetails details) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<ReadListResult<T>> getByIds(Set<String> ids, ReadDetails details) {
    // TODO: implement getByIds
    throw UnimplementedError();
  }

  @override
  Future<ReadListResult<T>> getItems(
    ReadDetails details, [
    // TODO: Why can't this be List<ReadFilter<T>> ??
    List<ReadFilter> filters = const [],
  ]) {
    // TODO: implement getItems
    throw UnimplementedError();
  }

  @override
  Future<ReadListResult<Model>> getSelected(ReadDetails details) {
    // TODO: implement getSelected
    throw UnimplementedError();
  }

  @override
  Future<WriteResult<T>> setItem(Model item, WriteDetails details) {
    // TODO: implement setItem
    throw UnimplementedError();
  }

  @override
  Future<WriteListResult<T>> setItems(List<Model> items, WriteDetails details) {
    // TODO: implement setItems
    throw UnimplementedError();
  }

  @override
  Future<WriteResult<Model>> setSelected(Model item, WriteDetails details,
      {bool isSelected = true}) {
    // TODO: implement setSelected
    throw UnimplementedError();
  }
}
