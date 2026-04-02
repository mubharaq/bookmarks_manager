import 'package:bookmarks_manager/gen/assets.gen.dart';
import 'package:bookmarks_manager/ui/core/theme/colors.dart';
import 'package:bookmarks_manager/ui/core/theme/typography.dart';
import 'package:bookmarks_manager/ui/core/widgets/app_image.dart';
import 'package:bookmarks_manager/ui/core/widgets/touchable_opacity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.onTapLeading,
    this.title,
    this.hideLeading = false,
    this.centerTitle = true,
    this.backgroundColor,
    this.titleColor,
    this.titleWidget,
    this.iconColor,
    this.iconBgColor,
    this.iconSize,
    this.icon,
    this.leftPadding,
    this.trailingWidgets,
    this.borderColor,
    this.height = 50,
  });
  final VoidCallback? onTapLeading;
  final String? title;
  final bool hideLeading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? titleColor;
  final Widget? titleWidget;
  final Color? iconColor;
  final Color? iconBgColor;
  final Color? borderColor;
  final double? iconSize;
  final String? icon;
  final double? leftPadding;
  final List<Widget>? trailingWidgets;
  final double height;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: height,
      leadingWidth: height.h + 24.h,
      titleSpacing: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
      backgroundColor: backgroundColor ?? Colors.transparent,
      leading: hideLeading
          ? null
          : Align(
              alignment: AlignmentGeometry.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 24.h),
                child: TouchableOpacity(
                  onTap: onTapLeading,
                  child: AppImage(
                    imageUrl: icon ?? Assets.images.arrowLeft,
                    height: iconSize ?? 24.h,
                    fit: BoxFit.contain,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
      centerTitle: centerTitle,
      title: _buildTitle(),
      elevation: 0,
      actions: trailingWidgets,
    );
  }

  Widget? _buildTitle() {
    if (titleWidget != null) {
      return titleWidget;
    }

    if (title != null && title!.isNotEmpty) {
      return Text(
        title!,
        style: AppTextStyles.text.md.semibold.copyWith(
          color: AppColors.neutrals.shade900,
        ),
      );
    }

    return null;
  }
}
