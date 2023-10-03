import 'package:freezed_annotation/freezed_annotation.dart';

part 'source_type.freezed.dart';

@freezed
class SourceType with _$SourceType {
  const SourceType._();

  /// Gateway to entirely on-device persistence.
  const factory SourceType.localSource() = LocalSource;

  /// Gateway to off-device persistence. Network requests are required
  /// to load data.
  const factory SourceType.remoteSource() = RemoteSource;

  static const local = LocalSource();
  static const remote = RemoteSource();
}
