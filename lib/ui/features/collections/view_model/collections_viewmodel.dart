import 'package:bookmarks_manager/data/repositories/bookmarks/bookmarks_repository.dart';
import 'package:bookmarks_manager/domain/models/category/category.dart';
import 'package:bookmarks_manager/ui/features/shared/collections_provider.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'collections_viewmodel.g.dart';

final editCollectionMutation = Mutation<void>();
final deleteCollectionMutation = Mutation<void>();
final addCollectionMutation = Mutation<void>();

@riverpod
class CollectionsViewModel extends _$CollectionsViewModel {
  @override
  void build() {}

  Future<void> addCollection({
    required String name,
    required String icon,
    required String color,
  }) async {
    final repository = ref.read(bookmarksRepositoryProvider);
    final response = await repository.addCategory(
      name: name,
      icon: icon,
      color: color,
    );

    return await response.fold(
      onOk: (data) {
        ref.read(collectionsProvider.notifier).add(data);
      },
      onError: (error) {
        throw error;
      },
    );
  }

  Future<void> updateCollection({
    required String id,
    required String name,
    required String icon,
    required String color,
  }) async {
    ref
        .read(collectionsProvider.notifier)
        .edit(
          id: id,
          newCategory: Category(
            id: id,
            name: name,
            icon: icon,
            color: color,
          ),
        );
    final repository = ref.read(bookmarksRepositoryProvider);
    final response = await repository.updateCategory(
      id: id,
      name: name,
      icon: icon,
      color: color,
    );

    return await response.fold(
      onOk: (data) {},
      onError: (error) {
        ref.invalidate(collectionsProvider);
        throw error;
      },
    );
  }

  Future<void> deleteCollection({
    required String id,
  }) async {
    ref.read(collectionsProvider.notifier).remove(id);
    final repository = ref.read(bookmarksRepositoryProvider);
    final response = await repository.deleteCategory(id: id);

    return await response.fold(
      onOk: (data) {},
      onError: (error) {
        ref.invalidate(collectionsProvider);
        throw error;
      },
    );
  }
}
