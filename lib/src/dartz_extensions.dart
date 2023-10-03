import 'package:dartz/dartz.dart';

extension DartzX<L, R> on Either<L, R> {
  R getOrRaise() => getOrElse(() => throw Exception('Unexpected Left: $this'));
  L leftOrRaise() =>
      fold((l) => l, (r) => throw Exception('Unexpected Right: $this'));
}
