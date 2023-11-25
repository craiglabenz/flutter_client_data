import 'package:client_data/client_data.dart';

class Repository<T extends Model> extends DataContract<T> {
  Repository(this.sourceList);

  final SourceList<T> sourceList;

  @override
  Future<ReadResult<T>> getById(String id, ReadDetails<T> details) =>
      sourceList.getById(id, details);

  @override
  Future<ReadListResult<T>> getByIds(Set<String> ids, ReadDetails<T> details) =>
      sourceList.getByIds(ids, details);

  @override
  Future<ReadListResult<T>> getItems(ReadDetails<T> details) =>
      getFilteredItems(details, const []);

  @override
  Future<ReadListResult<T>> getFilteredItems(
    ReadDetails<T> details,
    List<ReadFilter<T>> filters,
  ) =>
      sourceList.getFilteredItems(details, filters);

  @override
  Future<ReadListResult<T>> getSelected(ReadDetails<T> details) =>
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
