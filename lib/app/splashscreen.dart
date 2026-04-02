import 'package:bookmarks_manager/gen/assets.gen.dart';
import 'package:bookmarks_manager/ui/core/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Splashscreen extends ConsumerWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: AppImage(
          imageUrl: Assets.images.icon.path,
          height: 190,
        ),
      ),
    );
  }
}
