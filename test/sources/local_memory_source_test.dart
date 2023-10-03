import 'package:flutter_test/flutter_test.dart';
import 'package:client_data/client_data.dart';

class TestModel extends Model {
  const TestModel({required super.id, this.msg = 'default'});
  final String msg;
  @override
  Map<String, dynamic> toJson() => {};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          msg == other.msg;

  @override
  int get hashCode => Object.hashAll([id, msg]);

  @override
  String toString() => 'TestModel(id: $id, msg: $msg)';
}

const readDetails = ReadDetails();
const abcReadDetails = ReadDetails(setName: 'abc');
const writeDetails = WriteDetails();
const abcWriteDetails = WriteDetails(setName: 'abc');

void main() {
  late LocalMemorySource<TestModel> mem;

  group('LocalMemorySource.setItem should', () {
    setUp(() {
      mem = LocalMemorySource<TestModel>();
    });

    test('save items', () {
      const item = TestModel(id: 'item 1');
      mem.setItem(item, writeDetails);
      fullyContains(mem, item);

      const item2 = TestModel(id: 'item 2');
      mem.setItem(item2, const WriteDetails(setName: 'abc'));
      fullyContains(mem, item2, setNames: ['abc']);
    });

    test('accept items twice', () {
      const item = TestModel(id: 'item 1');
      mem.setItem(item, writeDetails);
      fullyContains(mem, item);

      mem.setItem(item, writeDetails);
      fullyContains(mem, item);

      expect(mem.itemIds.length, equals(1));
    });

    test('overwrite', () {
      const item = TestModel(id: 'item 1');
      mem.setItem(item, writeDetails);
      fullyContains(mem, item);

      const itemTake2 = TestModel(id: 'item 1', msg: 'different');
      mem.setItem(itemTake2, writeDetails);
      fullyContains(mem, itemTake2);
      expect(mem.itemIds.length, equals(1));
    });

    test('honor overwrite=False', () {
      const item = TestModel(id: 'item 1');
      mem.setItem(item, writeDetails);
      fullyContains(mem, item);

      const itemTake2 = TestModel(id: 'item 1', msg: 'different');
      mem.setItem(itemTake2, const WriteDetails(shouldOverwrite: false));
      fullyContains(mem, item);
      expect(mem.itemIds.length, equals(1));
    });
  });

  group('LocalMemorySource.setItems should', () {
    setUp(() {
      mem = LocalMemorySource<TestModel>();
    });

    test('set items', () {
      const item = TestModel(id: 'item 1');
      const item2 = TestModel(id: 'item 2');
      mem.setItems([item, item2], writeDetails);
      fullyContains(mem, item);
      fullyContains(mem, item2);

      const item3 = TestModel(id: 'item 3');
      mem.setItems([item2, item3], writeDetails);
      fullyContains(mem, item);
      fullyContains(mem, item2);
      fullyContains(mem, item3);
      expect(mem.itemIds.length, 3);
    });

    test('set items with set name', () {
      const item = TestModel(id: 'item 1');
      const item2 = TestModel(id: 'item 2');
      mem.setItems([item, item2], writeDetails);
      fullyContains(mem, item);
      fullyContains(mem, item2);

      const item3 = TestModel(id: 'item 3');
      mem.setItems([item2, item3], const WriteDetails(setName: 'abc'));
      fullyContains(mem, item);
      fullyContains(mem, item2, setNames: ['abc']);
      fullyContains(mem, item3, setNames: ['abc']);
      expect(mem.itemIds.length, 3);
    });
  });

  group('LocalMemorySource.setSelectedItem should', () {
    setUp(() {
      mem = LocalMemorySource<TestModel>();
    });

    test('set new items', () {
      const item = TestModel(id: 'item 1');
      mem.setSelected(item, writeDetails);
      fullyContains(mem, item, isSelected: true);
    });

    test('set known items', () {
      const item = TestModel(id: 'item 1');
      mem.setItem(item, writeDetails);
      fullyContains(mem, item);
      mem.setSelected(item, writeDetails);
      fullyContains(mem, item, isSelected: true);
    });

    test('set new items with set name', () {
      const item = TestModel(id: 'item 1');
      mem.setSelected(item, const WriteDetails(setName: 'abc'));
      fullyContains(mem, item, setNames: ['abc'], isSelected: true);
    });

    test('set known items with set name', () {
      const item = TestModel(id: 'item 1');
      mem.setItem(item, writeDetails);
      fullyContains(mem, item);
      mem.setSelected(item, const WriteDetails(setName: 'abc'));
      fullyContains(mem, item, setNames: ['abc'], isSelected: true);
    });

    test('set known items with set name but no overwrite', () {
      const item = TestModel(id: 'item 1');
      mem.setItem(item, writeDetails);
      fullyContains(mem, item);
      mem.setSelected(
        item,
        const WriteDetails(setName: 'abc', shouldOverwrite: false),
      );
      fullyContains(mem, item, setNames: ['abc'], isSelected: true);
    });

    test('set known items with new values and set name but no overwrite', () {
      const item = TestModel(id: 'item 1');
      mem.setItem(item, writeDetails);
      fullyContains(mem, item);

      const itemTake2 = TestModel(id: 'item 1', msg: 'different');
      mem.setSelected(
        itemTake2,
        const WriteDetails(setName: 'abc', shouldOverwrite: false),
      );
      fullyContains(mem, item, setNames: ['abc'], isSelected: true);
    });

    test('set known items with new values and set name', () {
      const item = TestModel(id: 'item 1');
      mem.setItem(item, writeDetails);
      fullyContains(mem, item);

      const itemTake2 = TestModel(id: 'item 1', msg: 'different');
      mem.setSelected(itemTake2, const WriteDetails(setName: 'abc'));
      fullyContains(mem, itemTake2, setNames: ['abc'], isSelected: true);
    });

    test('set new item with first selected value as false', () {
      const item = TestModel(id: 'item 1');
      mem.setSelected(item, writeDetails, isSelected: false);
      fullyContains(mem, item);
    });

    test('set known item with changes', () {
      const item = TestModel(id: 'item 1');
      mem.setItem(item, writeDetails);
      const itemTake2 = TestModel(id: 'item 1', msg: 'different');
      mem.setSelected(itemTake2, writeDetails, isSelected: false);
      fullyContains(mem, itemTake2);

      mem.setSelected(itemTake2, writeDetails, isSelected: true);
      fullyContains(mem, itemTake2, isSelected: true);
    });

    test('remove set items', () {
      const item = TestModel(id: 'item 1');
      mem.setSelected(item, writeDetails, isSelected: true);
      fullyContains(mem, item, isSelected: true);
      mem.setSelected(item, writeDetails, isSelected: false);
      fullyContains(mem, item);
    });
  });

  group('LocalMemorySource.getItem should', () {
    setUp(() {
      mem = LocalMemorySource<TestModel>();
    });

    test('return known items', () async {
      const item = TestModel(id: 'item 1');
      mem.setItem(item, writeDetails);
      final maybeResult = await mem.getById(item.id!, readDetails);
      expect(maybeResult, isNotNull);
      expect(maybeResult, equals(item));
    });

    test('return NotFound for unknown items', () async {
      const item = TestModel(id: 'item 1');
      mem.setItem(item, writeDetails);

      const item2 = TestModel(id: 'item 2');

      final retrievedItem = await mem.getById(item2.id!, readDetails);
      expect(retrievedItem, isNull);
    });

    test('honor setName', () async {
      const item = TestModel(id: 'item 1');
      mem.setItem(item, writeDetails);
      final retrievedItem = await mem.getById(
        item.id!,
        const ReadDetails(setName: 'abc'),
      );
      expect(retrievedItem, isNull);

      mem.setItem(item, const WriteDetails(setName: 'abc'));
      final retrievedItem2 = await mem.getById(
        item.id!,
        const ReadDetails(setName: 'abc'),
      );
      expect(retrievedItem2, isNotNull);
      expect(retrievedItem2, item);
    });
  });

  group('LocalMemorySource.getByIds should', () {
    const item = TestModel(id: 'item 1');
    const item2 = TestModel(id: 'item 2');
    setUp(() {
      mem = LocalMemorySource<TestModel>();
    });

    test('return items', () async {
      mem.setItems([item, item2], writeDetails);
      final maybeResult = await mem.getByIds(
        {item.id!, item2.id!},
        readDetails,
      );
      expect(maybeResult.isRight(), true);
      final result = maybeResult.getOrRaise();
      expect(
        result,
        FoundItems<TestModel>.fromList([item, item2], readDetails, {}),
      );
    });

    test('return items for partial hits', () async {
      const item3 = TestModel(id: 'item 3');
      mem.setItems([item, item2], writeDetails);
      final maybeResult = await mem.getByIds(
        {item.id!, item2.id!, item3.id!},
        readDetails,
      );
      expect(maybeResult.isRight(), true);
      final result = maybeResult.getOrRaise();
      expect(
        result,
        FoundItems<TestModel>.fromList(
          [item, item2],
          readDetails,
          {item3.id!},
        ),
      );
    });
  });

  group('LocalMemorySource.getItems should', () {
    const item = TestModel(id: 'item 1');
    const item2 = TestModel(id: 'item 2');
    setUp(() {
      mem = LocalMemorySource<TestModel>();
    });
    test('return items', () async {
      mem.setItems([item, item2], writeDetails);
      final maybeResult = await mem.getItems(readDetails);
      final result = maybeResult.getOrRaise();
      expect(
        result,
        FoundItems<TestModel>.fromList([item, item2], readDetails, {}),
      );
    });

    test('return no items from setName if empty', () async {
      mem.setItems([item, item2], const WriteDetails(setName: 'abc'));

      final maybeResult = await mem.getItems(const ReadDetails(setName: 'xyz'));
      expect(maybeResult.isLeft(), true);
      // final result = maybeResult.getOrRaise();
      // expect(
      //   result,
      //   FoundItems<TestModel>.fromList(
      //     [],
      //     setName: globalSetName,
      //   ),
      // );

      // But globalSetName still returns
      final maybeResult2 = await mem.getItems(readDetails);
      final result2 = maybeResult2.getOrRaise();
      expect(
        result2,
        FoundItems<TestModel>.fromList([item, item2], readDetails, {}),
      );
    });

    test('return NotFound from custom setName if empty', () async {
      mem.setItems([item, item2], writeDetails);
      final maybeResult = await mem.getItems(const ReadDetails(setName: 'abc'));
      expect(maybeResult.isLeft(), true);
      // final result = maybeResult.getOrRaise();
      // expect(
      //   result,
      //   FoundItems<TestModel>.fromList(
      //     [],
      //     setName: globalSetName,
      //   ),
      // );
    });

    test('return only items from set name', () async {
      mem.setItems([item, item2], writeDetails);

      const item3 = TestModel(id: 'item 3');
      mem.setItems([item2, item3], abcWriteDetails);

      final maybeResult = await mem.getItems(abcReadDetails);
      final result = maybeResult.getOrRaise();
      expect(
        result,
        FoundItems<TestModel>.fromList([item2, item3], abcReadDetails, {}),
      );
    });
  });

  group('LocalMemorySource.getSelectedItems should', () {
    const item = TestModel(id: 'item 1');
    const item2 = TestModel(id: 'item 2');
    setUp(() {
      mem = LocalMemorySource<TestModel>();
    });

    test('return selected items', () async {
      mem.setItem(item, writeDetails);
      mem.setSelected(item2, writeDetails);
      final maybeResult = await mem.getSelected(readDetails);
      final result = maybeResult.getOrRaise();
      expect(
        result,
        FoundItems<TestModel>.fromList([item2], readDetails, {}),
      );
    });

    test('return selected items from setName', () async {
      mem.setItem(item, writeDetails);
      mem.setSelected(item2, writeDetails);

      const item3 = TestModel(id: 'item 3');
      mem.setSelected(item3, const WriteDetails(setName: 'setName'));

      const localReadDetails = ReadDetails(setName: 'setName');
      final maybeResult = await mem.getSelected(
        localReadDetails,
      );
      final result = maybeResult.getOrRaise();
      expect(
        result,
        FoundItems<TestModel>.fromList([item3], localReadDetails, {}),
      );
    });
  });
}

void fullyContains(
  LocalMemorySource<TestModel> mem,
  TestModel item, {
  List<String> setNames = const [],
  bool isSelected = false,
}) {
  expect(mem.itemIds.contains(item.id!), true);
  expect(mem.items.containsKey(item.id!), true);
  expect(mem.itemSets.containsKey(globalSetName), true);
  expect(mem.itemSets[globalSetName]!.contains(item.id), true);
  for (String setName in setNames) {
    expect(mem.itemSets.containsKey(setName), true);
    expect(mem.itemSets[setName]!.contains(item.id), true);
  }
  expect(mem.items[item.id!]!.msg, item.msg);
  expect(mem.selectedIds.contains(item.id!), isSelected);
}
