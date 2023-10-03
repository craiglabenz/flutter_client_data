import 'package:client_data/client_data.dart';

abstract class ReadFilter<T extends Model> {
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
}