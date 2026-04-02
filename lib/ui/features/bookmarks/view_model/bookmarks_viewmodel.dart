import 'dart:async';

import 'package:bookmarks_manager/data/repositories/bookmarks/bookmarks_repository.dart';
import 'package:bookmarks_manager/domain/models/bookmark/bookmark.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bookmarks_viewmodel.g.dart';
part 'bookmarks_viewmodel.freezed.dart';

final addBookmarkMutation = Mutation<void>();
final editBookmarkMutation = Mutation<void>();
final deleteBookmarkMutation = Mutation<void>();

enum PaginationStatus { idle, loadingMore, fetchedAll }

@freezed
abstract class BookmarksState with _$BookmarksState {
  const factory BookmarksState({
    @Default([]) List<Bookmark> bookmarks,
    @Default(2) int nextPage,
    @Default(PaginationStatus.idle) PaginationStatus status,
    String? paginationError,
  }) = _BookmarksState;

  const BookmarksState._();

  bool get isEmpty => bookmarks.isEmpty;
  bool get isFetchingMore => status == PaginationStatus.loadingMore;
  bool get hasMore => status != PaginationStatus.fetchedAll;
}

@Riverpod(keepAlive: true)
class Bookmarks extends _$Bookmarks {
  @override
  Future<BookmarksState> build() async {
    final repo = ref.read(bookmarksRepositoryProvider);
    final result = await repo.bookmarks(page: 1);

    return result.fold(
      onOk: (bookmarks) => BookmarksState(
        bookmarks: bookmarks,
        nextPage: bookmarks.isEmpty ? 1 : 2,
        status: bookmarks.isEmpty
            ? PaginationStatus.fetchedAll
            : PaginationStatus.idle,
      ),
      onError: (error) => throw error,
    );
  }

  Future<void> loadMore() async {
    final current = state.asData?.value;
    if (current == null || current.isFetchingMore || !current.hasMore) {
      return;
    }

    state = AsyncData(
      current.copyWith(
        status: PaginationStatus.loadingMore,
        paginationError: null,
      ),
    );

    final repo = ref.read(bookmarksRepositoryProvider);
    final result = await repo.bookmarks(page: current.nextPage);

    if (!ref.mounted) return;

    result.fold(
      onOk: (bookmarks) {
        state = AsyncData(
          current.copyWith(
            bookmarks: [...current.bookmarks, ...bookmarks],
            nextPage: bookmarks.isEmpty
                ? current.nextPage
                : current.nextPage + 1,
            status: bookmarks.isEmpty
                ? PaginationStatus.fetchedAll
                : PaginationStatus.idle,
            paginationError: null,
          ),
        );
      },
      onError: (error) {
        state = AsyncData(
          current.copyWith(
            status: PaginationStatus.idle,
            paginationError: error.toString(),
          ),
        );
      },
    );
  }

  void add(Bookmark bookmark) {
    final current = state.asData?.value;
    if (current == null) return;

    state = AsyncData(
      current.copyWith(
        bookmarks: [...current.bookmarks, bookmark],
      ),
    );
  }

  void edit({
    required String id,
    required String title,
    required String url,
    required bool isFavorite,
    String? description,
    List<String>? tags,
  }) {
    final current = state.asData?.value;
    if (current == null) return;

    state = AsyncData(
      current.copyWith(
        bookmarks: [
          for (final bookmark in current.bookmarks)
            if (bookmark.id == id)
              bookmark.copyWith(
                title: title,
                url: url,
                description: description ?? bookmark.description,
                isFavorite: isFavorite,
                tags: tags ?? bookmark.tags,
              )
            else
              bookmark,
        ],
      ),
    );
  }

  void remove(String id) {
    final current = state.asData?.value;
    if (current == null) return;

    state = AsyncData(
      current.copyWith(
        bookmarks: current.bookmarks
            .where((bookmark) => bookmark.id != id)
            .toList(),
      ),
    );
  }
}

@Riverpod(keepAlive: true)
class BookmarksViewModel extends _$BookmarksViewModel {
  @override
  void build() {}

  Future<void> addBookmark({
    required String title,
    required String url,
    required String categoryId,
    String? description,
    List<String>? tags,
  }) async {
    final response = await ref
        .read(bookmarksRepositoryProvider)
        .addBookmark(
          title: title,
          url: url,
          categoryId: categoryId,
          description: description,
          tags: tags,
        );
    return response.fold(
      onOk: (bookmark) {
        ref.read(bookmarksProvider.notifier).add(bookmark);
      },
      onError: (error) => throw error,
    );
  }

  Future<void> updateBookmark({
    required String id,
    required String title,
    required String url,
    String? categoryId,
    String? description,
    bool isFavorite = false,
    List<String>? tags,
  }) async {
    ref
        .read(bookmarksProvider.notifier)
        .edit(
          id: id,
          title: title,
          url: url,
          description: description,
          isFavorite: isFavorite,
          tags: tags,
        );
    final response = await ref
        .read(bookmarksRepositoryProvider)
        .updateBookmark(
          id: id,
          title: title,
          url: url,
          categoryId: categoryId,
          description: description,
          isFavorite: isFavorite,
          tags: tags,
        );
    return response.fold(
      onOk: (_) {},
      onError: (error) {
        ref.invalidate(bookmarksProvider);
        throw error;
      },
    );
  }

  Future<void> deleteBookmark({required String id}) async {
    ref.read(bookmarksProvider.notifier).remove(id);
    final response = await ref
        .read(bookmarksRepositoryProvider)
        .deleteBookmark(id: id);
    return response.fold(
      onOk: (_) {},
      onError: (error) {
        ref.invalidate(bookmarksProvider);
        throw error;
      },
    );
  }
}
