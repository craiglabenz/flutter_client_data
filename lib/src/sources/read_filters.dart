import 'package:client_data/client_data.dart';
import 'package:equatable/equatable.dart';

abstract class ReadFilter<T extends Model> extends Equatable {
  const ReadFilter();
  bool predicate(T obj);
  Map<String, String> toParams();
}

class CreatedSinceFilter<T extends CreatedAtModel> extends ReadFilter<T> {
  const CreatedSinceFilter(this.createdCutoff);

  final DateTime createdCutoff;

  @override
  bool predicate(T obj) =>
      obj.createdAt.difference(createdCutoff) > Duration.zero;

  @override
  Map<String, String> toParams() =>
      {'createdSince': createdCutoff.toIso8601String()};

  @override
  List<Object?> get props => [createdCutoff.toIso8601String()];
}
