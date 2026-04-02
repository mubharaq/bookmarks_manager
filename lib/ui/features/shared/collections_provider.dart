import 'package:bookmarks_manager/data/repositories/bookmarks/bookmarks_repository.dart';
import 'package:bookmarks_manager/domain/models/category/category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'collections_provider.g.dart';

@Riverpod(keepAlive: true)
class Collections extends _$Collections {
  @override
  Future<List<Category>> build() async {
    return _fetchCollections();
  }

  Future<List<Category>> _fetchCollections() async {
    final repository = ref.read(bookmarksRepositoryProvider);

    final result = await repository.categories();

    return result.fold(
      onOk: (collections) {
        return collections;
      },
      onError: (error) => throw error,
    );
  }

  void edit({required String id, required Category newCategory}) {
    state = AsyncValue.data([
      for (final category in state.value!)
        if (category.id == id)
          category.copyWith(
            name: newCategory.name,
            icon: newCategory.icon,
            color: newCategory.color,
          )
        else
          category,
    ]);
  }

  void add(Category category) {
    state = AsyncValue.data([...?state.value, category]);
  }

  void remove(String id) {
    state = AsyncValue.data(
      state.value!.where((category) => category.id != id).toList(),
    );
  }
}
