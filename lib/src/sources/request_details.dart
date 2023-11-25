import 'package:client_data/client_data.dart';
import 'package:equatable/equatable.dart';
// ignore: implementation_imports
import 'package:equatable/src/equatable_utils.dart';

class ReadDetails<T extends Model> extends Equatable {
  const ReadDetails({
    this.setName = globalSetName,
    this.requestType = RequestType.global,
  });

  final RequestType requestType;
  final String setName;

  @override
  List<Object?> get props => [
        requestType,
        setName,
      ];

  /// Collapses this request into a key suitable for local memory caching.
  /// This key should incorporate everything about this request EXCEPT the
  /// requestType, as that would create false-positive variance.
  int get cacheCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([
        setName,
      ]);

  /// Convert details from a READ into a WRITE for the purposes of local caching.
  WriteDetails toWriteDetails([bool? shouldOverwrite]) => WriteDetails(
        requestType: RequestType.local,
        setName: setName,
        shouldOverwrite: shouldOverwrite ?? WriteDetails.defaultShouldOverwrite,
      );

  @override
  String toString() =>
      'ReadDetails(setName: $setName, requestType: $requestType)';
}

class WriteDetails extends Equatable {
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
  List<Object?> get props => [requestType, setName, shouldOverwrite];

  /// Convert details from a WRITE into a READ.
  ReadDetails<T> toReadDetails<T extends Model>() => ReadDetails<T>(
        requestType: RequestType.local,
        setName: setName,
      );

  @override
  String toString() =>
      'WriteDetails(setName: $setName, requestType: $requestType, '
      'shouldOverwrite: $shouldOverwrite)';
}
