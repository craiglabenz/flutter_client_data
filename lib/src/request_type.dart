import 'package:freezed_annotation/freezed_annotation.dart';
import 'sources/source_type.dart';

part 'request_type.freezed.dart';

@freezed
class RequestType with _$RequestType {
  const RequestType._();

  /// Request to a repository that limits reads to on-device sources. This
  /// includes active memory and any local filestore.
  const factory RequestType.localRequest() = LocalRequest;

  /// Request to a repository that limits reads to off-device sources. This is
  /// used when we believe our local data may be stale.
  const factory RequestType.refreshRequest() = RefreshRequest;

  /// Request to a repository that accepts data from the first source that has
  /// any records for us at all.
  const factory RequestType.globalRequest() = GlobalRequest;

  static const local = LocalRequest();
  static const refresh = RefreshRequest();
  static const global = GlobalRequest();

  bool includes(SourceType sourceType) {
    return sourceType.map(
      localSource: (SourceType sourceType) =>
          this == RequestType.local || this == RequestType.global,
      remoteSource: (SourceType sourceType) =>
          this == RequestType.refresh || this == RequestType.global,
    );
  }
}
