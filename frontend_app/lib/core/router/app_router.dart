import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/shell/presentation/app_shell.dart';
import '../../features/today/presentation/screens/today_screen.dart';
import '../../features/progress/presentation/screens/progress_screen.dart';
import '../../features/reviews/presentation/screens/reviews_screen.dart';
import '../../features/summary/presentation/screens/summary_screen.dart';
import '../../shared/screens/lesson_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/today',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/today',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: TodayScreen(),
          ),
        ),
        GoRoute(
          path: '/progress',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProgressScreen(),
          ),
        ),
        GoRoute(
          path: '/reviews',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ReviewsScreen(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/today/summary',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SummaryScreen(),
    ),
    GoRoute(
      path: '/lesson/:lessonId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final lessonId = state.pathParameters['lessonId'] ?? '';
        return LessonScreen(lessonId: lessonId);
      },
    ),
  ],
);
