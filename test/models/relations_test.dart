import 'package:client_data/client_data.dart';
import 'package:flutter_test/flutter_test.dart';

class Nested extends Model {
  Nested({required super.id, required this.body});

  final String body;

  // Doesn't matter
  @override
  Map<String, dynamic> toJson() => {};
}

class WithNestedDetail extends Model {
  WithNestedDetail({
    required super.id,
    required this.comment,
  });

  final RelatedModel<Nested> comment;

  // Doesn't matter
  @override
  Map<String, dynamic> toJson() => {};
}

class WithNestedList extends Model {
  WithNestedList({
    required super.id,
    required this.comments,
  });

  final RelatedModelList<Nested> comments;

  // Doesn't matter
  @override
  Map<String, dynamic> toJson() => {};
}

void main() {
  final nestedSourceList = SourceList(
    sources: [
      LocalMemorySource<Nested>(),
    ],
    bindings: Bindings<Nested>(
      getDetailUrl: (String id) => ApiUrl(path: '/nested/$id'),
      fromJson: (Map<String, dynamic> data) => Nested(
        id: data['id'] as String?,
        body: data['body'] as String,
      ),
      getListUrl: () => const ApiUrl(path: '/nested'),
    ),
  );

  group('RelatedModel should', () {
    late Repository<Nested> nestedRepository;

    setUpAll(() {
      nestedRepository = Repository<Nested>(nestedSourceList)
        ..setItem(
          Nested(id: 'abc', body: 'message here'),
          RequestDetails.write(),
        );
    });

    test('seamlessly load obj', () async {
      final obj = WithNestedDetail(
        id: 'xyz',
        comment: RelatedModel<Nested>(id: 'abc', repository: nestedRepository),
      );
      expect((await obj.comment.obj)!.body, 'message here');
    });

    test('return null for unknown id', () async {
      final obj = WithNestedDetail(
        id: 'xyz',
        comment:
            RelatedModel<Nested>(id: 'unknown', repository: nestedRepository),
      );
      expect(await obj.comment.obj, isNull);
    });

    group('RelatedModelList should', () {
      late Repository<Nested> nestedRepository;

      setUpAll(() {
        nestedRepository = Repository<Nested>(nestedSourceList)
          ..setItems(
            [
              Nested(id: 'abc', body: 'message here'),
              Nested(id: 'def', body: 'second message here'),
            ],
            RequestDetails.write(requestType: RequestType.local),
          );
      });

      test('seamlessly load objs', () async {
        final obj = WithNestedList(
          id: 'xyz',
          comments: RelatedModelList<Nested>(
            ids: const {'abc', 'def'},
            repository: nestedRepository,
          ),
        );
        final items = await obj.comments.objs;
        final itemsMap = <String, Nested>{};
        // ignore: avoid_function_literals_in_foreach_calls
        items.forEach((item) => itemsMap[item.id!] = item);
        expect(itemsMap['abc']!.body, 'message here');
        expect(itemsMap['def']!.body, 'second message here');
      });

      test('return empty for unknown id', () async {
        final obj = WithNestedList(
          id: 'xyz',
          comments: RelatedModelList<Nested>(
            ids: const {'unknown'},
            repository: nestedRepository,
          ),
        );
        expect(await obj.comments.objs, isEmpty);
      });
    });
  });
}
