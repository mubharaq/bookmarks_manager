import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark.freezed.dart';
part 'bookmark.g.dart';

@freezed
abstract class Bookmark with _$Bookmark {
  const factory Bookmark({
    required String id,
    required String title,
    required String url,
    required String categoryId,
    required String description,
    required String favicon,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isFavorite,
    @Default([]) List<String> tags,
  }) = _Bookmark;

  factory Bookmark.fromJson(Map<String, Object?> json) =>
      _$BookmarkFromJson(json);
}
