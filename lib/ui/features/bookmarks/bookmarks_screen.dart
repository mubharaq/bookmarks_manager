import 'package:bookmarks_manager/domain/error/app_exception.dart';
import 'package:bookmarks_manager/domain/models/bookmark/bookmark.dart';
import 'package:bookmarks_manager/extensions/ref_extension.dart';
import 'package:bookmarks_manager/ui/core/extensions/toast_extension.dart';
import 'package:bookmarks_manager/ui/core/helper.dart';
import 'package:bookmarks_manager/ui/core/theme/colors.dart';
import 'package:bookmarks_manager/ui/core/theme/typography.dart';
import 'package:bookmarks_manager/ui/core/widgets/app_scaffold.dart';
import 'package:bookmarks_manager/ui/core/widgets/empty_state.dart';
import 'package:bookmarks_manager/ui/core/widgets/error_state.dart';
import 'package:bookmarks_manager/ui/features/bookmarks/view_model/bookmarks_viewmodel.dart';
import 'package:bookmarks_manager/ui/features/bookmarks/widgets/bookmark_card.dart';
import 'package:bookmarks_manager/ui/features/bookmarks/widgets/bookmark_form_sheet.dart';
import 'package:bookmarks_manager/ui/features/shared/collections_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';

class BookmarksScreen extends ConsumerStatefulWidget {
  const BookmarksScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BookmarksScreenState();
}

class _BookmarksScreenState extends ConsumerState<BookmarksScreen> {
  String? _selectedCategoryId;

  Future<void> _confirmDelete(Bookmark bookmark) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete bookmark?'),
        content: Text('"${bookmark.title}" will be permanently removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error.shade300,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (confirmed == true) {
      await deleteBookmarkMutation.run(ref, (tsx) {
        return tsx
            .get(bookmarksViewModelProvider.notifier)
            .deleteBookmark(id: bookmark.id);
      }).suppress();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bookmarkAsync = ref.watch(bookmarksProvider);
    final collections = ref.watch(collectionsProvider);
    for (final mutation in [
      deleteBookmarkMutation,
      editBookmarkMutation,
      addBookmarkMutation,
    ]) {
      ref.listen(mutation, (_, next) {
        if (next is MutationSuccess) {
          context.showSuccessToast('Bookmarks updated successfully');
        }
        if (next case MutationError(:final error)) {
          context.showErrorToast(error.asErrorMessage);
        }
      });
    }

    return AppScaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
              child: Row(
                children: [
                  Text('Bookmarks', style: AppTextStyles.display.xs.bold),
                  const Spacer(),
                  IconButton(
                    onPressed: () => BookmarkFormSheet.show(
                      context,
                    ),
                    icon: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: AppColors.green.shade700,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            16.verticalSpace,
            SizedBox(
              height: 36.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                children: [
                  _FilterChip(
                    label: 'All',
                    isSelected: _selectedCategoryId == null,
                    onTap: () => setState(() => _selectedCategoryId = null),
                  ),
                  if (collections.value case final categories?) ...[
                    ...categories.map(
                      (collection) => Padding(
                        padding: EdgeInsets.only(left: 8.w),
                        child: _FilterChip(
                          label: '${collection.icon} ${collection.name}',
                          isSelected: _selectedCategoryId == collection.id,
                          onTap: () => setState(
                            () => _selectedCategoryId =
                                _selectedCategoryId == collection.id
                                ? null
                                : collection.id,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            16.verticalSpace,
            Expanded(
              child: bookmarkAsync.when(
                data: (bookmarkState) {
                  return RefreshIndicator.adaptive(
                    onRefresh: () async {
                      ref.invalidate(bookmarksProvider);
                    },
                    child: InfiniteList(
                      itemCount: bookmarkState.bookmarks.length,
                      isLoading: bookmarkState.isFetchingMore,
                      hasReachedMax:
                          bookmarkState.status == PaginationStatus.fetchedAll,
                      onFetchData: () =>
                          ref.read(bookmarksProvider.notifier).loadMore(),
                      itemBuilder: (context, index) {
                        final bookmark = bookmarkState.bookmarks[index];
                        final category = collections.asData?.value
                            .where(
                              (category) => category.id == bookmark.categoryId,
                            )
                            .firstOrNull;
                        return BookmarkCard(
                          bookmark: bookmark,
                          categoryName: category?.name ?? 'Uncategorised',
                          categoryColor: category != null
                              ? hexToColor(category.color)
                              : colorScheme.outline,
                          onEdit: () => BookmarkFormSheet.show(
                            context,
                            bookmark: bookmark,
                          ),
                          onDelete: () => _confirmDelete(bookmark),
                        );
                      },
                      emptyBuilder: (context) => const EmptyState(
                        icon: Icons.bookmark,
                        title: 'No bookmarks yet',
                        subtitle: 'Tap + to save your first bookmark',
                      ),
                    ),
                  );
                },
                error: (error, stackTrace) => ErrorState(
                  onRetry: () => ref.invalidate(bookmarksProvider),
                  message: error.asErrorMessage,
                ),
                loading: () =>
                    const Center(child: CircularProgressIndicator.adaptive()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.green.shade700 : colorScheme.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? AppColors.green.shade700
                : colorScheme.outlineVariant,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.text.sm.medium.copyWith(
              color: isSelected ? Colors.white : colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
