import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/theme.dart';
import '../../../../shared/models/models.dart';
import '../../../../shared/widgets/widgets.dart';
import '../providers/lessons_timeline_notifier.dart';
import '../providers/lessons_timeline_state.dart';

class LessonsScreen extends ConsumerWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(lessonsTimelineNotifierProvider);
    final notifier = ref.read(lessonsTimelineNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Уроки')),
      body: switch (state.phase) {
        LessonsTimelinePhase.loading ||
        LessonsTimelinePhase.openingNext => const Center(
          child: CircularProgressIndicator(color: AppColors.accentPrimary),
        ),
        LessonsTimelinePhase.error => ErrorStateBlock(
          message: state.errorMessage ?? 'Не удалось загрузить уроки',
          onRetry: notifier.loadTimeline,
        ),
        LessonsTimelinePhase.empty ||
        LessonsTimelinePhase.ready => _LessonsTimelineBody(
          state: state,
          onRefresh: notifier.loadTimeline,
          onLessonTap: (lessonId) => context.push('/lesson/$lessonId'),
          onNextTap: () async {
            final lessonId = await notifier.createOrOpenNextLesson();
            if (context.mounted) {
              context.push('/lesson/$lessonId');
            }
          },
        ),
      },
    );
  }
}

class _LessonsTimelineBody extends StatelessWidget {
  final LessonsTimelineState state;
  final VoidCallback onRefresh;
  final ValueChanged<String> onLessonTap;
  final Future<void> Function() onNextTap;

  const _LessonsTimelineBody({
    required this.state,
    required this.onRefresh,
    required this.onLessonTap,
    required this.onNextTap,
  });

  @override
  Widget build(BuildContext context) {
    final timeline = state.timeline;
    final items = timeline?.items ?? const <LessonTimelineItem>[];
    final nextLesson = timeline?.nextLesson;

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          Text('Ваш путь', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'Предыдущие уроки и следующий шаг.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text('Уроков пока нет. Нажмите «Следующий урок».'),
            ),
          ...List.generate(items.length, (index) {
            final item = items[index];
            return _TimelineNode(
              key: ValueKey('lesson-node-${item.lessonId}'),
              title: 'Урок ${items.length - index}',
              subtitle: _lessonSubtitle(item),
              statusText: _lessonStatus(item),
              color: _lessonColor(item),
              icon: item.isCompleted
                  ? Icons.check
                  : item.isInProgress
                  ? Icons.play_arrow
                  : Icons.menu_book_outlined,
              showConnector: true,
              onTap: () => onLessonTap(item.lessonId),
            );
          }),
          _TimelineNode(
            key: const ValueKey('next-lesson-node'),
            title: nextLesson?.hasActiveLesson == true
                ? 'Продолжить текущий урок'
                : 'Следующий урок',
            subtitle: nextLesson?.hasActiveLesson == true
                ? 'Возобновит уже активный урок без создания дубля'
                : 'Создать и открыть следующий урок в основном пути',
            statusText: nextLesson?.hasActiveLesson == true
                ? 'Продолжить'
                : 'Открыть',
            color: AppColors.accentPrimary,
            icon: Icons.auto_stories,
            showConnector: false,
            onTap: () {
              onNextTap();
            },
            emphasized: true,
          ),
        ],
      ),
    );
  }

  static String _lessonSubtitle(LessonTimelineItem item) {
    final parts = <String>[
      if (item.totalSteps > 0) '${item.stepsAnswered}/${item.totalSteps} шагов',
      if (item.newWordsCount > 0) '${item.newWordsCount} новых',
      if (item.reviewWordsCount > 0) '${item.reviewWordsCount} повтор.',
    ];
    return parts.isEmpty ? item.lessonId : parts.join(' • ');
  }

  static String _lessonStatus(LessonTimelineItem item) {
    if (item.isCompleted) return 'Завершён';
    if (item.isInProgress) return 'В процессе';
    if (item.isInvalidated) return 'Неактуален';
    return 'Открыть';
  }

  static Color _lessonColor(LessonTimelineItem item) {
    if (item.isCompleted) return Colors.green;
    if (item.isInProgress) return Colors.orange;
    return AppColors.textTertiary;
  }
}

class _TimelineNode extends StatelessWidget {
  final String title;
  final String subtitle;
  final String statusText;
  final Color color;
  final IconData icon;
  final bool showConnector;
  final bool emphasized;
  final VoidCallback? onTap;

  const _TimelineNode({
    super.key,
    required this.title,
    required this.subtitle,
    required this.statusText,
    required this.color,
    required this.icon,
    required this.showConnector,
    this.emphasized = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap == null ? null : () => onTap!(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 72,
              child: Column(
                children: [
                  Container(
                    width: emphasized ? 56 : 50,
                    height: emphasized ? 56 : 50,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      boxShadow: emphasized
                          ? [
                              BoxShadow(
                                color: color.withValues(alpha: 0.25),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(icon, color: Colors.white),
                  ),
                  if (showConnector)
                    Container(
                      width: 4,
                      height: 56,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.dividerDefault,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Card(
                elevation: 0,
                color: emphasized
                    ? AppColors.accentPrimary.withValues(alpha: 0.08)
                    : AppColors.bgPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: emphasized
                        ? AppColors.accentPrimary
                        : AppColors.dividerDefault,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        statusText,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
