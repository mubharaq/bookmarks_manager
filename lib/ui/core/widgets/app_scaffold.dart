import 'package:bookmarks_manager/ui/core/widgets/custom_appbar.dart';
import 'package:bookmarks_manager/ui/core/widgets/loader.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.body,
    super.key,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.extendBody = false,
    this.resizeToAvoidBottomInset = true,
    this.showLoader = false,
    this.backgroundColor,
  });

  factory AppScaffold.withAppBar({
    String? title,
    VoidCallback? onTapLeading,
    bool hideLeading = false,
    Widget? body,
    List<Widget>? trailingWidgets,
    Widget? titleWidget,
    bool showLoader = false,
  }) {
    return AppScaffold(
      appBar: CustomAppBar(
        title: title,
        onTapLeading: onTapLeading,
        hideLeading: hideLeading,
        trailingWidgets: trailingWidgets,
        titleWidget: titleWidget,
      ),
      body: body ?? const SizedBox.shrink(),
      showLoader: showLoader,
    );
  }
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool extendBody;
  final bool resizeToAvoidBottomInset;
  final bool showLoader;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: appBar,
          body: body,
          backgroundColor: backgroundColor,
          bottomNavigationBar: bottomNavigationBar,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
          extendBody: extendBody,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        ),
        if (showLoader) ...[
          const Loader(),
        ],
      ],
    );
  }
}
