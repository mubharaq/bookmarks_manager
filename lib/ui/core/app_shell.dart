import 'dart:async';

import 'package:bookmarks_manager/app/providers/push_notifications/push_notification_manager_provider.dart';
import 'package:bookmarks_manager/ui/core/notification_prompt_sheet.dart';
import 'package:bookmarks_manager/ui/core/widgets/lazy_indexed_stack.dart';
import 'package:bookmarks_manager/ui/features/bookmarks/bookmarks_screen.dart';
import 'package:bookmarks_manager/ui/features/collections/collection_screen.dart';
import 'package:bookmarks_manager/ui/features/profile/profile_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_initialize());
    });
  }

  Future<void> _initialize() async {
    await ref.read(pushNotificationManagerProvider.future);
    if (!mounted) return;

    final manager = ref.read(pushNotificationManagerProvider.notifier);

    final initialMessage = await manager.onAppReady();
    if (!mounted) return;

    if (initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _handleMessageNavigation(initialMessage);
      });
      return;
    }

    final shouldPrompt = await manager.shouldShowPermissionPrompt();
    if (!shouldPrompt || !mounted) return;

    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    await NotificationPromptSheet.show(context);
  }

  void _handleMessageNavigation(RemoteMessage message) {}

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: LazyIndexedStack(
        index: _currentIndex,
        children: const [
          BookmarksScreen(),
          CollectionScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withValues(alpha: 0.4),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            activeIcon: Icon(Icons.bookmark),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view),
            label: 'Collections',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
