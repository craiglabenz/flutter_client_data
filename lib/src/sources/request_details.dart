import 'package:client_data/client_data.dart';
import 'package:equatable/equatable.dart';
// ignore: implementation_imports
import 'package:equatable/src/equatable_utils.dart';
import 'package:shared_data/shared_data.dart';

class RequestDetails<T extends Model> extends Equatable {
  RequestDetails({
    this.filters = const [],
    this.requestType = defaultRequestType,
    this.pagination,
    this.shouldOverwrite = defaultShouldOverwrite,
  });

  factory RequestDetails.read({
    RequestType requestType = defaultRequestType,
    List<ReadFilter<T>> filters = const [],
    Pagination? pagination,
  }) =>
      RequestDetails(
        requestType: requestType,
        filters: filters,
        pagination: pagination,
      );

  factory RequestDetails.write({
    RequestType requestType = defaultRequestType,
    bool shouldOverwrite = defaultShouldOverwrite,
    Pagination? pagination,
  }) =>
      RequestDetails(
        requestType: requestType,
        shouldOverwrite: shouldOverwrite,
        pagination: pagination,
      );

  final RequestType requestType;
  final List<ReadFilter<T>> filters;
  final bool shouldOverwrite;
  final Pagination? pagination;

  final defaultPagination = Pagination.page(1);
  static const defaultRequestType = RequestType.global;
  static const defaultShouldOverwrite = true;

  @override
  List<Object?> get props => [
        requestType,
        shouldOverwrite,
        ...filters.map<int>((filter) => filter.hashCode),
        pagination,
      ];

  /// Collapses this request into a key suitable for local memory caching.
  /// This key should incorporate everything about this request EXCEPT the
  /// requestType, as that would create false-positive variance.
  late final int cacheKey = _getCacheKey();

  int _getCacheKey() =>
      runtimeType.hashCode ^
      mapPropsToHashCode([
        ...filters.map<int>((filter) => filter.hashCode),
        pagination,
      ]);

  /// Indicates whether the filters AND pagination are empty.
  bool get isEmpty => filters.isEmpty && pagination == null;

  /// Indicates whether the filters OR pagination are not empty.
  bool get isNotEmpty => !isEmpty;

  /// Copy of this RequestDetails without any filters, pagination, or other
  /// do-dads which would segment up a data set. This is used for saving the
  /// global list alongside any sliced / filtered lists.
  RequestDetails<T> get empty => RequestDetails<T>(requestType: requestType);

  @override
  String toString() => 'RequestDetails(requestType: $requestType, filters: '
      '${filters.map<String>((filter) => filter.toString()).toList()}, '
      'pagination: $pagination)';

  void assertEmpty(String functionName) {
    assert(isEmpty, 'Must not supply filters or pagination to $functionName');
  }
}

class Pagination extends Equatable {
  const Pagination({required this.pageSize, required this.page});
  factory Pagination.page(int page, {int pageSize = defaultPageSize}) =>
      Pagination(pageSize: pageSize, page: page);
  final int pageSize;
  final int page;

  static const defaultPageSize = 20;

  @override
  List<Object?> get props => [pageSize, page];

  @override
  String toString() => 'Pagination(pageSize: $pageSize, page: $page)';
}
