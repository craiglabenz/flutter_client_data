void main() {}

// import 'dart:convert';
// import 'package:dartz/dartz.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:http/http.dart' as http;
// import 'package:washday/data/data.dart';

// import '../dependency_intestion.dart';

// @immutable
// class FakeClass extends WDO {
//   const FakeClass({required this.name, String? id}) : super(id: id);

//   factory FakeClass.fromJson(Map<String, dynamic> data) =>
//       FakeClass(name: data['name'] as String, id: data['id'] as String);

//   final String name;

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is FakeClass &&
//           runtimeType == other.runtimeType &&
//           name == other.name &&
//           this.id == other.id;

//   @override
//   int get hashCode => name.hashCode ^ id.hashCode;

//   @override
//   Map<String, dynamic> toJson() =>
//       <String, dynamic>{'name': name, 'id': this.id};

//   static Bindings<FakeClass> get bindings => Bindings<FakeClass>(
//         fromJson: FakeClass.fromJson,
//         getDetailUrl: (String id) => ApiUrl(path: 'fakeclasses/$id'),
//         getSelectedItemsUrl: () => const ApiUrl(path: 'users/me/fakeclasses'),
//         getListUrl: () => const ApiUrl(path: 'fakeclasses'),
//       );

//   @override
//   String toString() => 'FakeClass(id=${this.id}, name=$name)';
// }

// const _id = 'uuid';
// const _id2 = 'uuid2';
// const detailResponseBody = '{"id": "$_id", "name": "Fred"}';
// const detailResponseBody2 = '{"id": "$_id2", "name": "Flintstone"}';
// const listResponseBody = '{"results": [$detailResponseBody]}';
// const twoElementResponseBody =
//     '{"results": [$detailResponseBody, $detailResponseBody2]}';
// const returnHeaders = <String, String>{
//   'content-type': 'application/json',
// };
// const errorBody = '{"error": "not found"}';

// RequestDelegate getRequestDelegate(String body, [int statusCode = 200]) =>
//     RequestDelegate.fake(
//       getHandler: (uri, {headers}) {
//         // Because of pooling, all requests to ApiSource are turned into
//         // list responses.
//         return Future.value(
//           http.Response(body, statusCode, headers: returnHeaders),
//         );
//       },
//     );

// final delegate200 = getRequestDelegate(listResponseBody);
// final delegate404 = getRequestDelegate(listResponseBody, 404);

// SourceList<FakeClass> getSourceList(RequestDelegate delegate) =>
//     SourceList<FakeClass>(
//       sources: <Source<FakeClass>>[
//         LocalMemorySource<FakeClass>(),
//         LocalMemorySource<FakeClass>(),
//         ApiSource<FakeClass>(
//           bindings: FakeClass.bindings,
//           restApi: RestApi(delegate: delegate),
//           timer: TestFriendlyTimer(),
//         ),
//       ],
//       bindings: FakeClass.bindings,
//     );

// void main() {
//   group('SourceList should', () {
//     setUp(() async {
//       await setUpTestingDI();
//     });

//     test('get and cache items by Id', () async {
//       final sl = getSourceList(delegate200);
//       final obj = await sl.getById(_id);
//       expect(obj, isA<Right>());
//       expect(
//         obj.getOrRaise().item,
//         equals(
//           FakeClass.fromJson(
//             jsonDecode(detailResponseBody) as Map<String, dynamic>,
//           ),
//         ),
//       );
//       expect(
//         (sl.sources[0] as LocalMemorySource).itemIds,
//         contains('uuid'),
//       );
//       expect(
//         (sl.sources[1] as LocalMemorySource).itemIds,
//         contains('uuid'),
//       );
//     });

//     test('return Left when the item is not found', () async {
//       final sl = getSourceList(delegate404);
//       final obj = await sl.getById(_id);
//       expect(obj, isA<Left>());
//       expect(
//         (sl.sources[0] as LocalMemorySource).itemIds,
//         isEmpty,
//       );
//       expect(
//         (sl.sources[1] as LocalMemorySource).itemIds,
//         isEmpty,
//       );
//     });

//     test('get and cache items by Ids', () async {
//       final sl = getSourceList(getRequestDelegate(twoElementResponseBody));
//       final objs = await sl.getByIds([_id, _id2]);
//       expect(objs, isA<Right>());
//       expect(
//         objs.getOrRaise().items,
//         equals([
//           FakeClass.fromJson(
//             jsonDecode(detailResponseBody) as Map<String, dynamic>,
//           ),
//           FakeClass.fromJson(
//             jsonDecode(detailResponseBody2) as Map<String, dynamic>,
//           ),
//         ]),
//       );
//       expect(
//         (sl.sources[0] as LocalMemorySource).itemIds,
//         contains(_id),
//       );
//       expect(
//         (sl.sources[0] as LocalMemorySource).itemIds,
//         contains(_id2),
//       );
//       expect(
//         (sl.sources[1] as LocalMemorySource).itemIds,
//         contains(_id),
//       );
//       expect(
//         (sl.sources[1] as LocalMemorySource).itemIds,
//         contains(_id2),
//       );
//     });

//     test('get and cache items by Ids on partial returns', () async {
//       final sl = getSourceList(getRequestDelegate(listResponseBody));
//       final objs = await sl.getByIds([_id, _id2]);
//       expect(objs, isA<Right>());
//       expect(
//         objs.getOrRaise().items,
//         equals([
//           FakeClass.fromJson(
//             jsonDecode(detailResponseBody) as Map<String, dynamic>,
//           ),
//         ]),
//       );
//       expect(
//         (sl.sources[0] as LocalMemorySource).itemIds,
//         contains(_id),
//       );
//       expect(
//         (sl.sources[0] as LocalMemorySource).items[_id2],
//         isNull,
//       );
//       expect(
//         (sl.sources[1] as LocalMemorySource).itemIds,
//         contains(_id),
//       );
//       expect(
//         (sl.sources[1] as LocalMemorySource).items[_id2],
//         isNull,
//       );
//     });
//   });
// }
