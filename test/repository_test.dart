import 'package:client_data/client_data.dart';
import 'package:flutter_test/flutter_test.dart';

import 'sources/test_model.dart';

void main() {
  final sl = FakeSourceList<TestModel>();
  sl.addObj(const TestModel(id: 'does not matter'));
  final repo = Repository<TestModel>(sl);
  const TestModel obj = TestModel(id: 'also does not matter');

  group('Repository methods should pass through to SourceList', () {
    final emptyDetails = RequestDetails<TestModel>();
    test('including getById', () async {
      expect(
        await repo.getById('also does not matter', emptyDetails),
        isRight,
      );
    });
    test('including getById', () async {
      expect(
        await repo.getByIds({'also does not matter'}, emptyDetails),
        isRight,
      );
    });
    test('including getItems', () async {
      expect(
        await repo.getItems(emptyDetails),
        isRight,
      );
    });
    test('including setItem', () async {
      expect(
        await repo.setItem(obj, emptyDetails),
        isRight,
      );
    });
    test('including setItems', () async {
      expect(
        await repo.setItems([obj], emptyDetails),
        isRight,
      );
    });
  });
}
