import 'package:bookmarks_manager/domain/error/app_exception.dart';
import 'package:bookmarks_manager/domain/models/category/category.dart';
import 'package:bookmarks_manager/ui/core/extensions/toast_extension.dart';
import 'package:bookmarks_manager/ui/core/theme/colors.dart';
import 'package:bookmarks_manager/ui/core/theme/typography.dart';
import 'package:bookmarks_manager/ui/core/widgets/app_scaffold.dart';
import 'package:bookmarks_manager/ui/core/widgets/empty_state.dart';
import 'package:bookmarks_manager/ui/core/widgets/error_state.dart';
import 'package:bookmarks_manager/ui/features/collections/view_model/collections_viewmodel.dart';
import 'package:bookmarks_manager/ui/features/collections/widgets/collection_card.dart';
import 'package:bookmarks_manager/ui/features/collections/widgets/collection_form_sheet.dart';
import 'package:bookmarks_manager/ui/features/shared/collections_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CollectionScreen extends ConsumerStatefulWidget {
  const CollectionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CollectionScreenState();
}

class _CollectionScreenState extends ConsumerState<CollectionScreen> {
  Future<bool> _confirmDelete(Category category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete collection?'),
        content: Text(
          '''"${category.name}" and all its bookmarks will be permanently removed.''',
        ),
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
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final collectionsAsync = ref.watch(collectionsProvider);
    ref
      ..listen(deleteCollectionMutation, (previous, next) {
        if (next case MutationSuccess()) {
          context.showSuccessToast('Collection deleted successfully');
        }
        if (next case MutationError(:final error)) {
          context.showErrorToast(error.asErrorMessage);
        }
      })
      ..listen(addCollectionMutation, (previous, next) {
        if (next case MutationSuccess()) {
          context.showSuccessToast('Collection added successfully');
        }
        if (next case MutationError(:final error)) {
          context.showErrorToast(error.asErrorMessage);
        }
      })
      ..listen(editCollectionMutation, (previous, next) {
        if (next case MutationSuccess()) {
          context.showSuccessToast('Collection updated successfully');
        }
        if (next case MutationError(:final error)) {
          context.showErrorToast(error.asErrorMessage);
        }
      });

    return AppScaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
              child: Row(
                children: [
                  Text('Collections', style: AppTextStyles.display.xs.bold),
                  const Spacer(),
                  IconButton(
                    onPressed: () => CollectionFormSheet.show(context),
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
            20.verticalSpace,
            Expanded(
              child: collectionsAsync.when(
                data: (collections) {
                  return collections.isEmpty
                      ? const EmptyState(
                          icon: Icons.grid_view_outlined,
                          title: 'No collections yet',
                          subtitle: 'Tap + to create your first collection',
                        )
                      : GridView.builder(
                          padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12.w,
                                mainAxisSpacing: 12.h,
                                childAspectRatio: 0.9,
                              ),
                          itemCount: collections.length,
                          itemBuilder: (_, index) {
                            final category = collections[index];
                            return CollectionCard(
                              category: category,
                              onEdit: () => CollectionFormSheet.show(
                                context,
                                category: category,
                              ),
                              onDelete: () async {
                                final confirmed = await _confirmDelete(
                                  category,
                                );
                                if (confirmed) {
                                  return deleteCollectionMutation.run(ref, (
                                    tsx,
                                  ) async {
                                    return tsx
                                        .get(
                                          collectionsViewModelProvider.notifier,
                                        )
                                        .deleteCollection(id: category.id);
                                  });
                                }
                              },
                            );
                          },
                        );
                },
                error: (error, stackTrace) => ErrorState(
                  message: error.asErrorMessage,
                  onRetry: () => ref.invalidate(collectionsProvider),
                  isRetrying: ref.watch(collectionsProvider).isRefreshing,
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
