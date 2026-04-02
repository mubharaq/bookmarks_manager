import 'package:bookmarks_manager/domain/models/category/category.dart';
import 'package:bookmarks_manager/ui/core/helper.dart';
import 'package:bookmarks_manager/ui/core/theme/app_theme.dart';
import 'package:bookmarks_manager/ui/core/theme/colors.dart';
import 'package:bookmarks_manager/ui/core/theme/typography.dart';
import 'package:bookmarks_manager/ui/core/widgets/touchable_opacity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CollectionCard extends StatelessWidget {
  const CollectionCard({
    required this.category,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final Category category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).isDarkMode;
    final colorScheme = Theme.of(context).colorScheme;
    final categoryColor = hexToColor(category.color);
    return TouchableOpacity(
      child: Container(
        decoration: BoxDecoration(
          color: categoryColor.withValues(alpha: isDarkMode ? .2 : .1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: Text(
                      category.icon,
                      style: TextStyle(fontSize: 20.sp),
                    ),
                  ),
                ),
                const Spacer(),
                PopupMenuButton<_CardAction>(
                  icon: Icon(
                    Icons.more_vert,
                    size: 18.sp,
                    color: colorScheme.outline,
                  ),
                  padding: EdgeInsets.zero,
                  elevation: 0,
                  borderRadius: BorderRadius.circular(12.r),
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
            12.verticalSpace,
            Text(
              category.name,
              style: AppTextStyles.text.md.semibold,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            4.verticalSpace,
            Text(
              '''${category.bookmarkCount} bookmark${category.bookmarkCount == 1 ? '' : 's'}''',
              style: AppTextStyles.text.xs.regular.copyWith(
                color: colorScheme.outline,
              ),
            ),
          ],
        ),
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
