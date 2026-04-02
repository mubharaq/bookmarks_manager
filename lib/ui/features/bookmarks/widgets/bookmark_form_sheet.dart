import 'package:bookmarks_manager/domain/models/bookmark/bookmark.dart';
import 'package:bookmarks_manager/extensions/ref_extension.dart';
import 'package:bookmarks_manager/ui/core/theme/colors.dart';
import 'package:bookmarks_manager/ui/core/theme/typography.dart';
import 'package:bookmarks_manager/ui/core/widgets/app_button.dart';
import 'package:bookmarks_manager/ui/core/widgets/form/app_text_field.dart';
import 'package:bookmarks_manager/ui/features/bookmarks/view_model/bookmarks_viewmodel.dart';
import 'package:bookmarks_manager/ui/features/shared/collections_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookmarkFormSheet extends ConsumerStatefulWidget {
  const BookmarkFormSheet({
    this.bookmark,
    super.key,
  });

  final Bookmark? bookmark;

  static Future<void> show(
    BuildContext context, {
    Bookmark? bookmark,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BookmarkFormSheet(
        bookmark: bookmark,
      ),
    );
  }

  @override
  ConsumerState<BookmarkFormSheet> createState() => _BookmarkFormSheetState();
}

class _BookmarkFormSheetState extends ConsumerState<BookmarkFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _isFormValid = ValueNotifier<bool>(false);
  late final _titleController = TextEditingController(
    text: widget.bookmark?.title,
  );
  late final _urlController = TextEditingController(text: widget.bookmark?.url);
  late final _descriptionController = TextEditingController(
    text: widget.bookmark?.description,
  );
  late final _tagsController = TextEditingController(
    text: widget.bookmark?.tags.join(', '),
  );
  late String? _selectedCategoryId = widget.bookmark?.categoryId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isFormValid.value = _formKey.currentState?.validate() ?? false;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    _isFormValid.dispose();
    super.dispose();
  }

  List<String> get _parsedTags => _tagsController.text
      .split(',')
      .map((t) => t.trim())
      .where((t) => t.isNotEmpty)
      .toList();

  Future<void> _add() async {
    if (!(_formKey.currentState?.validate() ?? false) ||
        _selectedCategoryId == null) {
      return;
    }
    await addBookmarkMutation.run(ref, (tsx) {
      return tsx
          .get(bookmarksViewModelProvider.notifier)
          .addBookmark(
            title: _titleController.text,
            url: _urlController.text,
            categoryId: _selectedCategoryId!,
            description: _descriptionController.text.isEmpty
                ? null
                : _descriptionController.text,
            tags: _parsedTags,
          );
    }).suppress();
    if (!mounted) return;
    if (!ref.read(addBookmarkMutation).hasError) Navigator.pop(context);
  }

  Future<void> _update() async {
    if (!(_formKey.currentState?.validate() ?? false) ||
        widget.bookmark == null) {
      return;
    }
    await editBookmarkMutation.run(ref, (tsx) {
      return tsx
          .get(bookmarksViewModelProvider.notifier)
          .updateBookmark(
            id: widget.bookmark!.id,
            title: _titleController.text,
            url: _urlController.text,
            categoryId: _selectedCategoryId,
            description: _descriptionController.text,
            isFavorite: widget.bookmark!.isFavorite,
            tags: _parsedTags,
          );
    }).suppress();
    if (!mounted) return;
    if (!ref.read(editBookmarkMutation).hasError) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final collections = ref.watch(collectionsProvider);
    final isEditing = widget.bookmark != null;
    final isLoading =
        ref.watch(addBookmarkMutation).isPending ||
        ref.watch(editBookmarkMutation).isPending;

    return PopScope(
      canPop: !isLoading,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 0).copyWith(
          bottom: MediaQuery.viewInsetsOf(context).bottom + 32.h,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            onChanged: () =>
                _isFormValid.value = _formKey.currentState?.validate() ?? false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Edit Bookmark' : 'Add Bookmark',
                  style: AppTextStyles.text.xl.bold,
                ),
                20.verticalSpace,
                AppTextField(
                  hintText: 'Title',
                  controller: _titleController,
                  inputAction: TextInputAction.next,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Title is required' : null,
                ),
                12.verticalSpace,
                AppTextField(
                  hintText: 'URL',
                  controller: _urlController,
                  keyboardType: TextInputType.url,
                  inputAction: TextInputAction.next,
                  autoCorrect: false,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'URL is required' : null,
                ),
                12.verticalSpace,
                AppTextField(
                  hintText: 'Description (optional)',
                  controller: _descriptionController,
                  inputAction: TextInputAction.next,
                  maxLines: 3,
                ),
                16.verticalSpace,
                Text(
                  'Category',
                  style: AppTextStyles.text.sm.semibold,
                ),
                8.verticalSpace,
                if (collections.value case final categories?) ...[
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: categories.map((category) {
                      final isSelected = _selectedCategoryId == category.id;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedCategoryId = category.id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.green.shade700
                                : colorScheme.tertiaryContainer,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.green.shade700
                                  : colorScheme.outlineVariant,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                category.icon,
                                style: TextStyle(fontSize: 14.sp),
                              ),
                              6.horizontalSpace,
                              Text(
                                category.name,
                                style: AppTextStyles.text.sm.medium.copyWith(
                                  color: isSelected
                                      ? Colors.white
                                      : colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
                16.verticalSpace,
                AppTextField(
                  hintText: 'Tags (comma separated)',
                  controller: _tagsController,
                  inputAction: TextInputAction.done,
                ),
                24.verticalSpace,
                ValueListenableBuilder(
                  valueListenable: _isFormValid,
                  builder: (context, isValid, _) {
                    return AppButton(
                      isLoading: isLoading,
                      label: isEditing ? 'Update Bookmark' : 'Save Bookmark',
                      isDisabled: !isValid || _selectedCategoryId == null,
                      onPressed: () async {
                        if (isEditing) {
                          await _update();
                        } else {
                          await _add();
                        }
                      },
                    );
                  },
                ),
                12.verticalSpace,
                AppButton(
                  label: 'Cancel',
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  variant: ButtonVariant.neutral,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
