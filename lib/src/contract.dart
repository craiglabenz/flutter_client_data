import 'package:client_data/client_data.dart';

abstract class DataContract<T extends Model> {
  // Getters.
  Future<ReadResult<T>> getById(
    String id,
    ReadDetails details,
  );
  Future<ReadListResult<T>> getByIds(
    Set<String> ids,
    ReadDetails details,
  );
  Future<ReadListResult<T>> getSelected(ReadDetails details);

  Future<ReadListResult<T>> getItems(
    ReadDetails details, [
    List<ReadFilter<T>> filters = const [],
  ]);

  // Setters.
  Future<WriteResult<T>> setItem(
    T item,
    WriteDetails details,
  );
  Future<WriteListResult<T>> setItems(
    List<T> items,
    WriteDetails details,
  );
  Future<WriteResult<T>> setSelected(
    T item,
    WriteDetails details, {
    bool isSelected = true,
  });
}
