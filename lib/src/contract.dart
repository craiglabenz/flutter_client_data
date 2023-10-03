import 'package:client_data/client_data.dart';

class ReadDetails {
  const ReadDetails({
    this.setName = globalSetName,
    this.requestType = RequestType.global,
  });
  final RequestType requestType;
  final String setName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReadDetails &&
          runtimeType == other.runtimeType &&
          setName == other.setName &&
          requestType == other.requestType;

  @override
  int get hashCode => Object.hashAll([setName, requestType]);

  /// Convert results from a READ into a WRITE for the purposes of local caching.
  WriteDetails toWriteDetails([bool? shouldOverwrite]) => WriteDetails(
        requestType: RequestType.local,
        setName: setName,
        shouldOverwrite: shouldOverwrite ?? WriteDetails.defaultShouldOverwrite,
      );

  @override
  String toString() =>
      'ReadDetails(setName: $setName, requestType: $requestType)';
}

class WriteDetails {
  const WriteDetails({
    this.requestType = RequestType.global,
    this.setName = globalSetName,
    this.shouldOverwrite = defaultShouldOverwrite,
  });
  final RequestType requestType;
  final String setName;
  final bool shouldOverwrite;

  static const defaultShouldOverwrite = true;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WriteDetails &&
          runtimeType == other.runtimeType &&
          setName == other.setName &&
          requestType == other.requestType &&
          shouldOverwrite == other.shouldOverwrite;

  @override
  int get hashCode => Object.hashAll([setName, requestType, shouldOverwrite]);

  /// Convert results from a WRITE into a READ.
  ReadDetails toReadDetails() =>
      ReadDetails(requestType: RequestType.local, setName: setName);

  @override
  String toString() =>
      'WriteDetails(setName: $setName, requestType: $requestType, '
      'shouldOverwrite: $shouldOverwrite)';
}

abstract class DataContract<T extends Model> {
  // Getters.
  Future<T?> getById(
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
