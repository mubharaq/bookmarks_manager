//we want to catch unexpected errors from the backend
//and return them as AppException
// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bookmarks_manager/data/services/api/api_client.dart';
import 'package:bookmarks_manager/data/services/api/api_client_provider.dart';
import 'package:bookmarks_manager/domain/error/app_exception.dart';
import 'package:bookmarks_manager/domain/models/bookmark/bookmark.dart';
import 'package:bookmarks_manager/domain/models/category/category.dart';
import 'package:bookmarks_manager/domain/result/result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bookmarks_repository.g.dart';

class BookmarksRepository {
  const BookmarksRepository({required ApiClient apiClient})
    : _apiClient = apiClient;
  final ApiClient _apiClient;

  Logger get _log => Logger('BookmarksRepository');

  Future<Result<List<Bookmark>>> bookmarks({
    required int page,
    int limit = 10,
    String? categoryId,
  }) async {
    final result = await _apiClient.get(
      '/bookmarks',
      queryParameters: {
        'page': page,
        'limit': limit,
        'categoryId': ?categoryId,
      },
    );
    return result.fold(
      onOk: (data) {
        try {
          _log.info('bookmarks fetched');
          final responseData = (data as Map<String, dynamic>)['data'] as List;
          final bookmarks = responseData
              .map(
                (item) => Bookmark.fromJson(item as Map<String, dynamic>),
              )
              .toList();
          return Result.ok(bookmarks);
        } on CheckedFromJsonException catch (_) {
          _log.warning('Error formatting notifications');
          return Result.error(
            AppException.parse(
              'Error formatting bookmarks',
              StackTrace.current,
            ),
          );
        }
      },
      onError: (error) {
        _log.warning('Error fetching notifications');
        return Result.error(error);
      },
    );
  }

  Future<Result<Bookmark>> addBookmark({
    required String title,
    required String url,
    required String categoryId,
    String? description,
    bool isFavorite = false,
    List<String>? tags,
  }) async {
    final dataMap = {
      'title': title,
      'url': url,
      'categoryId': categoryId,
      'description': ?description,
      'is_favorite': isFavorite,
      'tags': ?tags,
    };
    final result = await _apiClient.post('/bookmarks', data: dataMap);
    return result.fold(
      onOk: (data) {
        _log.info('bookmark added');
        final bookmark = Bookmark.fromJson(data as Map<String, dynamic>);
        return Result.ok(bookmark);
      },
      onError: (error) {
        _log.warning('Error adding bookmark');
        return Result.error(error);
      },
    );
  }

  Future<Result<Category>> addCategory({
    required String name,
    String? icon,
    String? color,
  }) async {
    final result = await _apiClient.post(
      '/categories',
      data: {
        'name': name,
        'icon': ?icon,
        'color': ?color,
      },
    );
    return result.fold(
      onOk: (data) {
        try {
          _log.info('category added');
          final category = Category.fromJson(data as Map<String, dynamic>);
          return Result.ok(category);
        } catch (_) {
          _log.warning('Error formatting category');
          return Result.error(
            AppException.parse(
              'Error formatting category',
              StackTrace.current,
            ),
          );
        }
      },
      onError: (error) {
        _log.warning('Error adding category');
        return Result.error(error);
      },
    );
  }

  Future<Result<List<Category>>> categories() async {
    final result = await _apiClient.get(
      '/categories',
    );
    return result.fold(
      onOk: (data) {
        _log.info('categories fetched');
        final categoryData = data as Map<String, dynamic>;
        final categories = (categoryData['data'] as List)
            .map(
              (item) => Category.fromJson(item as Map<String, dynamic>),
            )
            .toList();
        return Result.ok(categories);
      },
      onError: (error) {
        _log.warning('Error fetching categories');
        return Result.error(error);
      },
    );
  }

  Future<Result<void>> updateBookmark({
    required String id,
    required String title,
    required String url,
    String? categoryId,
    String? description,
    bool isFavorite = false,
    List<String>? tags,
  }) async {
    final dataMap = {
      'title': title,
      'url': url,
      'category_id': categoryId,
      'description': ?description,
      'is_favorite': isFavorite,
      'tags': ?tags,
    };
    final result = await _apiClient.patch('/bookmarks/$id', data: dataMap);
    return result.fold(
      onOk: (data) {
        _log.info('bookmark updated');
        return const Result.ok(null);
      },
      onError: (error) {
        _log.warning('Error updating bookmark');
        return Result.error(error);
      },
    );
  }

  Future<Result<void>> updateCategory({
    required String id,
    required String name,
    String? icon,
    String? color,
  }) async {
    final result = await _apiClient.patch(
      '/categories/$id',
      data: {
        'name': name,
        'icon': ?icon,
        'color': ?color,
      },
    );
    return result.fold(
      onOk: (data) {
        _log.info('category updated');
        return const Result.ok(null);
      },
      onError: (error) {
        _log.warning('Error updating category');
        return Result.error(error);
      },
    );
  }

  Future<Result<void>> deleteBookmark({
    required String id,
  }) async {
    final result = await _apiClient.delete(
      '/bookmarks/$id',
    );
    return result.fold(
      onOk: (data) {
        _log.info('bookmark deleted');
        return const Result.ok(null);
      },
      onError: (error) {
        _log.warning('Error deleting bookmark');
        return Result.error(error);
      },
    );
  }

  Future<Result<void>> deleteCategory({
    required String id,
  }) async {
    final result = await _apiClient.delete(
      '/categories/$id',
    );
    return result.fold(
      onOk: (data) {
        _log.info('category deleted');
        return const Result.ok(null);
      },
      onError: (error) {
        _log.warning('Error deleting category');
        return Result.error(error);
      },
    );
  }
}

@riverpod
BookmarksRepository bookmarksRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return BookmarksRepository(apiClient: apiClient);
}
