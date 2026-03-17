import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/theme.dart';
import '../../../core/network/connectivity_provider.dart';
import '../../../shared/widgets/status_banner.dart';

class AppShell extends ConsumerWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  static int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/progress')) return 1;
    if (location.startsWith('/reviews')) return 2;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/today');
      case 1:
        context.go('/progress');
      case 2:
        context.go('/reviews');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = _currentIndex(context);
    final connectivity = ref.watch(connectivityProvider);
    final isOffline = connectivity.whenOrNull(data: (online) => !online) ?? false;

    return Scaffold(
      body: Column(
        children: [
          if (isOffline)
            const StatusBanner(type: StatusBannerType.offline),
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.dividerDefault, width: 1),
          ),
        ),
        child: NavigationBar(
          backgroundColor: AppColors.bgPrimary,
          indicatorColor: AppColors.accentPrimary.withValues(alpha: 0.15),
          selectedIndex: currentIndex,
          onDestinationSelected: (index) => _onTap(context, index),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          height: 64,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.auto_stories_outlined),
              selectedIcon: Icon(Icons.auto_stories),
              label: 'Урок',
            ),
            NavigationDestination(
              icon: Icon(Icons.insights_outlined),
              selectedIcon: Icon(Icons.insights),
              label: 'Прогресс',
            ),
            NavigationDestination(
              icon: Icon(Icons.replay_outlined),
              selectedIcon: Icon(Icons.replay),
              label: 'Повторения',
            ),
          ],
        ),
      ),
    );
  }
}
