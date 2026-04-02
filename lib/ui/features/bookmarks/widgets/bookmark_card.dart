import 'package:bookmarks_manager/domain/models/bookmark/bookmark.dart';
import 'package:bookmarks_manager/ui/core/theme/colors.dart';
import 'package:bookmarks_manager/ui/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookmarkCard extends StatelessWidget {
  const BookmarkCard({
    required this.bookmark,
    required this.categoryName,
    required this.categoryColor,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final Bookmark bookmark;
  final String categoryName;
  final Color categoryColor;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Icon(
                Icons.language_outlined,
                size: 20.sp,
                color: colorScheme.onTertiaryContainer,
              ),
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  crossAxisAlignment: .start,
                  children: [
                    Expanded(
                      child: Text(
                        bookmark.title,
                        style: AppTextStyles.text.md.semibold,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    2.horizontalSpace,
                    PopupMenuButton<_CardAction>(
                      icon: Icon(
                        Icons.more_vert,
                        size: 18.sp,
                        color: colorScheme.outline,
                      ),
                      padding: const EdgeInsets.only(bottom: 10),
                      onSelected: (action) {
                        if (action == _CardAction.edit) onEdit();
                        if (action == _CardAction.delete) onDelete();
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                          value: _CardAction.edit,
                          child: _MenuRow(
                            icon: Icons.edit_outlined,
                            label: 'Edit',
                          ),
                        ),
                        PopupMenuItem(
                          value: _CardAction.delete,
                          child: _MenuRow(
                            icon: Icons.delete_outline,
                            label: 'Delete',
                            color: AppColors.error.shade300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                4.verticalSpace,
                Text(
                  bookmark.url,
                  style: AppTextStyles.text.xs.regular.copyWith(
                    color: colorScheme.outline,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                8.verticalSpace,
                Wrap(
                  spacing: 6.w,
                  runSpacing: 4.h,
                  children: [
                    _Chip(
                      label: categoryName,
                      backgroundColor: categoryColor.withValues(alpha: 0.12),
                      textColor: categoryColor,
                    ),
                    ...bookmark.tags.map(
                      (tag) => _Chip(
                        label: '#$tag',
                        backgroundColor: colorScheme.tertiaryContainer,
                        textColor: colorScheme.onTertiaryContainer,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _CardAction { edit, delete }

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.icon, required this.label, this.color});
  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.onSurface;
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: effectiveColor),
        8.horizontalSpace,
        Text(
          label,
          style: AppTextStyles.text.sm.regular.copyWith(color: effectiveColor),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });
  final String label;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        label,
        style: AppTextStyles.text.xs.medium.copyWith(color: textColor),
      ),
    );
  }
}
