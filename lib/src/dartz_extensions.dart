import 'package:dartz/dartz.dart';
import 'package:matcher/matcher.dart';

extension DartzX<L, R> on Either<L, R> {
  R getOrRaise() => getOrElse(() => throw Exception('Unexpected Left: $this'));
  L leftOrRaise() =>
      fold((l) => l, (r) => throw Exception('Unexpected Right: $this'));
}

const Matcher isLeft = _IsLeft();

class _IsLeft extends Matcher {
  const _IsLeft();
  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) =>
      (item as Either?)!.isLeft();

  @override
  Description describe(Description description) => description.add('is-left');
}

const Matcher isRight = _IsRight();

class _IsRight extends Matcher {
  const _IsRight();
  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) =>
      (item as Either?)!.isRight();

  @override
  Description describe(Description description) => description.add('is-right');
}
