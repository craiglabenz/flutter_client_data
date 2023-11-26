import 'package:client_data/client_data.dart';

class Repository<T extends Model> extends DataContract<T> {
  Repository(this.sourceList);

  final SourceList<T> sourceList;

  @override
  Future<ReadResult<T>> getById(String id, RequestDetails<T> details) =>
      sourceList.getById(id, details);

  @override
  Future<ReadListResult<T>> getByIds(
    Set<String> ids,
    RequestDetails<T> details,
  ) =>
      sourceList.getByIds(ids, details);

  @override
  Future<ReadListResult<T>> getItems(RequestDetails<T> details) =>
      sourceList.getItems(details);

  @override
  Future<ReadListResult<T>> getSelected(RequestDetails<T> details) =>
      sourceList.getSelected(details);

  @override
  Future<WriteResult<T>> setItem(T item, RequestDetails<T> details) =>
      sourceList.setItem(item, details);

  @override
  Future<WriteListResult<T>> setItems(
    List<T> items,
    RequestDetails<T> details,
  ) =>
      sourceList.setItems(items, details);

  @override
  Future<WriteResult<T>> setSelected(
    T item,
    RequestDetails<T> details, {
    bool isSelected = true,
  }) =>
      sourceList.setSelected(item, details, isSelected: isSelected);
}
