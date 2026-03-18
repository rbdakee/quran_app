import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/theme.dart';
import '../../../../shared/models/models.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../today/presentation/providers/lesson_notifier.dart';
import '../providers/reviews_providers.dart';

class ReviewsScreen extends ConsumerWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(reviewsDueProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Повторения')),
      body: RefreshIndicator(
        color: AppColors.accentPrimary,
        onRefresh: () async => ref.invalidate(reviewsDueProvider),
        child: reviewsAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.accentPrimary),
          ),
          error: (e, _) => ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: ErrorStateBlock(
                  message: 'Не удалось загрузить повторения',
                  onRetry: () => ref.invalidate(reviewsDueProvider),
                ),
              ),
            ],
          ),
          data: (items) {
            if (items.isEmpty) {
              return ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: EmptyStateBlock(
                      icon: Icons.auto_awesome,
                      title: 'Срочных повторений нет',
                      body:
                          'Основной путь продолжается через «Следующий урок». Здесь доступна только дополнительная тренировка по уже изученным словам.',
                      ctaLabel: 'Доп. тренировка',
                      onCta: () => ref.startReviewLesson(context),
                    ),
                  ),
                ],
              );
            }
            return _ReviewsList(items: items);
          },
        ),
      ),
    );
  }
}

class _ReviewsList extends ConsumerWidget {
  final List<DueReviewItem> items;
  const _ReviewsList({required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.pagePaddingX),
      children: [
        _ReviewsListHeader(items: items),
        const SizedBox(height: AppSpacing.s4),

        // "Start Review Lesson" button
        ElevatedButton.icon(
          onPressed: () => ref.startReviewLesson(context),
          icon: const Icon(Icons.play_arrow),
          label: const Text('Пройти урок повторений'),
        ),
        const SizedBox(height: AppSpacing.s4),

        // List
        ...items.map((item) => _DueReviewRow(item: item)),

        const SizedBox(height: AppSpacing.s8),
      ],
    );
  }
}

class _DueReviewRow extends StatelessWidget {
  final DueReviewItem item;
  const _DueReviewRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final isUrgent = item.dueScore >= 80;
    final isWeak = item.state == 'lapsed';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceDefault,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Row(
        children: [
          // Token/concept
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.conceptKey ?? item.tokenId,
                  style: AppTypography.bodyLg,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      item.state,
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'score: ${item.dueScore.toStringAsFixed(0)}',
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Priority chips
          if (isUrgent)
            Flexible(
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.errorBg,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                ),
                child: Text(
                  'overdue',
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.errorDefault,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          if (isWeak)
            Flexible(
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.warningBg,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                ),
                child: Text(
                  'weak',
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.warningDefault,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

          const SizedBox(width: 4),
          const Icon(
            Icons.chevron_right,
            size: 18,
            color: AppColors.textTertiary,
          ),
        ],
      ),
    );
  }
}

class _ReviewsListHeader extends StatelessWidget {
  final List<DueReviewItem> items;
  const _ReviewsListHeader({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'К дополнительной тренировке доступно: ${items.length}',
          style: AppTypography.bodyMd.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.s3),
        Wrap(
          spacing: 8,
          children: [
            if (items.where((i) => i.dueScore >= 80).isNotEmpty)
              _badge(
                'Срочные: ${items.where((i) => i.dueScore >= 80).length}',
                AppColors.errorDefault,
                AppColors.errorBg,
              ),
            if (items
                .where((i) => i.dueScore >= 40 && i.dueScore < 80)
                .isNotEmpty)
              _badge(
                'Обычные: ${items.where((i) => i.dueScore >= 40 && i.dueScore < 80).length}',
                AppColors.warningDefault,
                AppColors.warningBg,
              ),
            if (items.where((i) => i.dueScore < 40).isNotEmpty)
              _badge(
                'Лёгкие: ${items.where((i) => i.dueScore < 40).length}',
                AppColors.successDefault,
                AppColors.successBg,
              ),
          ],
        ),
      ],
    );
  }

  static Widget _badge(String label, Color fg, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(label, style: AppTypography.labelSm.copyWith(color: fg)),
    );
  }
}

extension _ReviewLessonBuilder on WidgetRef {
  Future<void> startReviewLesson(BuildContext context) async {
    try {
      final lesson = await read(reviewsWordsLessonProvider.future);
      if (!context.mounted) return;

      // Cache lesson and navigate (push keeps back stack for AppBar back button)
      read(
        lessonNotifierProvider.notifier,
      ).cacheLesson(lesson.lessonId, lesson);
      context.push('/lesson/${lesson.lessonId}');
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
    }
  }
}
