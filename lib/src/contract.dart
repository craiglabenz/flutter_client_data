import 'package:client_data/client_data.dart';
import 'package:shared_data/shared_data.dart';

abstract class DataContract<T extends Model> {
  // Getters.
  Future<ReadResult<T>> getById(
    String id,
    RequestDetails<T> details,
  );
  Future<ReadListResult<T>> getByIds(
    Set<String> ids,
    RequestDetails<T> details,
  );
  Future<ReadListResult<T>> getItems(RequestDetails<T> details);

  // Setters.
  Future<WriteResult<T>> setItem(
    T item,
    RequestDetails<T> details,
  );
  Future<WriteListResult<T>> setItems(
    List<T> items,
    RequestDetails<T> details,
  );
}
