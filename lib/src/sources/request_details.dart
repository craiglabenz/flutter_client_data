import 'package:client_data/client_data.dart';
import 'package:equatable/equatable.dart';
// ignore: implementation_imports
import 'package:equatable/src/equatable_utils.dart';

class RequestDetails<T extends Model> extends Equatable {
  RequestDetails({
    this.requestType = defaultRequestType,
    this.filters = const [],
    this.shouldOverwrite = defaultShouldOverwrite,
  });

  factory RequestDetails.read({
    RequestType requestType = defaultRequestType,
    List<ReadFilter<T>> filters = const [],
  }) =>
      RequestDetails(requestType: requestType, filters: filters);

  factory RequestDetails.write({
    RequestType requestType = defaultRequestType,
    bool shouldOverwrite = defaultShouldOverwrite,
  }) =>
      RequestDetails(
        requestType: requestType,
        shouldOverwrite: shouldOverwrite,
      );

  final RequestType requestType;
  final List<ReadFilter<T>> filters;
  final bool shouldOverwrite;

  static const defaultShouldOverwrite = true;
  static const defaultRequestType = RequestType.global;

  @override
  List<Object?> get props => [
        requestType,
        shouldOverwrite,
        ...filters.map<int>((filter) => filter.hashCode).toList(),
      ];

  /// Collapses this request into a key suitable for local memory caching.
  /// This key should incorporate everything about this request EXCEPT the
  /// requestType, as that would create false-positive variance.
  late final int cacheKey = _getCacheKey();

  int _getCacheKey() =>
      runtimeType.hashCode ^
      mapPropsToHashCode([
        ...filters.map<int>((filter) => filter.hashCode).toList(),
      ]);

  bool get isEmpty => filters.isEmpty;

  bool get isNotEmpty => !isEmpty;

  /// Copy of this RequestDetails without any filters, pagination, or other
  /// do-dads which would segment up a data set. This is used for saving the
  /// global list alongside any sliced / filtered lists.
  RequestDetails<T> get empty => RequestDetails<T>(requestType: requestType);

  @override
  String toString() => 'RequestDetails(requestType: $requestType, filters: '
      '${filters.map<String>((filter) => filter.toString()).toList()})';

  void assertEmpty(String functionName) {
    assert(isEmpty, 'Must not supply filters or pagination to $functionName');
  }
}
