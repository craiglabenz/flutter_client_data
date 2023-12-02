// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:client_data/client_data.dart';
import 'package:equatable/equatable.dart';

class RelatedModel<T extends Model> extends Equatable {
  RelatedModel({
    required this.id,
    required this.repository,
  });
  final String? id;
  final Repository<T> repository;

  Future<T?> get obj async {
    if (id == null) return null;
    final result = await repository.getById(id!, RequestDetails.read());
    if (result.isRight()) {
      return result.getOrRaise().item;
    }
    // TODO(craiglabenz): Log this
    return null;
  }

  @override
  String toString() => 'RelatedModel<$T>(id: $id, repository: $repository)';

  @override
  List<Object?> get props => [id, repository.sourceList.bindings.getListUrl()];
}

class RelatedModelList<T extends Model> extends Equatable {
  RelatedModelList({
    required this.ids,
    required this.repository,
  });

  final Set<String> ids;
  final Repository<T> repository;

  Future<List<T>> get objs async {
    if (ids.isEmpty) return <T>[];
    final result = await repository.getByIds(ids, RequestDetails.read());
    if (result.isRight()) {
      final success = result.getOrRaise();
      if (success.missingItemIds.isNotEmpty) {
        // TODO(craiglabenz): Log this
      }
      return success.items;
    }
    // TODO(craiglabenz): Log this
    return <T>[];
  }

  @override
  List<Object?> get props => [
        ...ids,
        repository.sourceList.bindings.getListUrl(),
      ];
}
