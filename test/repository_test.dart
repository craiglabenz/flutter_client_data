import 'package:client_data/client_data.dart';
import 'package:flutter_test/flutter_test.dart';

import 'sources/test_model.dart';

void main() {
  final sl = FakeSourceList<TestModel>();
  sl.addObj(const TestModel(id: 'does not matter'));
  final repo = Repository<TestModel>(sl);
  const TestModel obj = TestModel(id: 'also does not matter');

  group('Repository methods should pass through to SourceList', () {
    // ignore: prefer_const_constructors
    final emptyReadDetails = ReadDetails<TestModel>();
    test('including getById', () async {
      expect(
        await repo.getById('also does not matter', emptyReadDetails),
        isRight,
      );
    });
    test('including getById', () async {
      expect(
        await repo.getByIds({'also does not matter'}, emptyReadDetails),
        isRight,
      );
    });
    test('including getItems', () async {
      expect(
        await repo.getItems(emptyReadDetails),
        isRight,
      );
    });
    test('including getSelected', () async {
      expect(
        await repo.getSelected(emptyReadDetails),
        isRight,
      );
    });
    test('including setItem', () async {
      expect(
        await repo.setItem(obj, const WriteDetails()),
        isRight,
      );
    });
    test('including setItems', () async {
      expect(
        await repo.setItems([obj], const WriteDetails()),
        isRight,
      );
    });
    test('including setSelected', () async {
      expect(
        await repo.setSelected(obj, const WriteDetails()),
        isRight,
      );
    });
  });
}
