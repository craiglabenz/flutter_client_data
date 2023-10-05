// import 'package:dartz/dartz.dart';
import 'package:client_data/client_data.dart';

abstract class Source<T extends Model> extends DataContract<T> {
  SourceType get sourceType;

  // Either<WriteFailure<T>, WriteSuccess<T>> createdItemOr(T? item) =>
  //     item?.id == null
  //         // ignore: prefer_const_constructors
  //         ? Left(WriteFailure<T>.error('Failed to save item'))
  //         : Right(WriteSuccess<T>(item!));

  // Either<NotFound, FoundItem<T>> itemOr(T? item) {
  //   if (item == null) {
  //     return const Left(notFound);
  //   }
  //   return Right(FoundItem(item));
  // }

  // Either<NotFound, FoundItems<T>> listOr(
  //   List<T>? items,
  //   ReadDetails details, {
  //   Set<String> missingItemIds = const {},
  // }) =>
  //     Right(
  //       FoundItems.fromList(items ?? [],
  //           setName: details.setName, missingItemIds: missingItemIds),
  //     );
  // items == null || items.isEmpty
  //     // ignore: prefer_const_constructors
  //     ? Left(notFound)
  //     : Right(FoundItems.fromList(items,
  //         setName: details.setName, missingItemIds: missingItemIds));

  // Either<NotFound, FoundItems<T>> mapOr(
  //   Map<String, T>? items,
  //   ReadDetails details, {
  //   Set<String> missingItemIds = const {},
  // }) =>
  //     items == null || items.isEmpty
  //         // ignore: prefer_const_constructors
  //         ? Left(notFound)
  //         : Right(FoundItems.fromMap(items,
  //             setName: details.setName, missingItemIds: missingItemIds));

  @override
  String toString() => '${runtimeType.toString()}()';
}
