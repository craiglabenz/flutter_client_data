import 'package:client_data/client_data.dart';

class Repository<T extends Model> extends DataContract<T> {
  Repository(this.sourceList);

  final SourceList<T> sourceList;

  @override
  Future<ReadResult<T>> getById(String id, ReadDetails details) =>
      sourceList.getById(id, details);

  @override
  Future<ReadListResult<T>> getByIds(Set<String> ids, ReadDetails details) =>
      sourceList.getByIds(ids, details);

  @override
  Future<ReadListResult<T>> getItems(
    ReadDetails details, [
    List<ReadFilter<T>> filters = const [],
  ]) =>
      sourceList.getItems(details, filters);

  @override
  Future<ReadListResult<T>> getSelected(ReadDetails details) =>
      sourceList.getSelected(details);

  @override
  Future<WriteResult<T>> setItem(T item, WriteDetails details) =>
      sourceList.setItem(item, details);

  @override
  Future<WriteListResult<T>> setItems(List<T> items, WriteDetails details) =>
      sourceList.setItems(items, details);

  @override
  Future<WriteResult<T>> setSelected(T item, WriteDetails details,
          {bool isSelected = true}) =>
      sourceList.setSelected(item, details, isSelected: isSelected);
}
