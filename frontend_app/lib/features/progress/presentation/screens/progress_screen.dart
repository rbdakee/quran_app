import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/theme.dart';
import '../../../../shared/models/models.dart';
import '../../../../shared/widgets/widgets.dart';
import '../providers/progress_providers.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(progressSummaryProvider);
    final engagementAsync = ref.watch(engagementProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Прогресс')),
      body: RefreshIndicator(
        color: AppColors.accentPrimary,
        onRefresh: () async {
          ref.invalidate(progressSummaryProvider);
          ref.invalidate(engagementProvider);
        },
        child: summaryAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.accentPrimary),
          ),
          error: (e, _) => ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: ErrorStateBlock(
                  message: 'Не удалось загрузить прогресс',
                  onRetry: () => ref.invalidate(progressSummaryProvider),
                ),
              ),
            ],
          ),
          data: (summary) => _ProgressBody(
            summary: summary,
            engagementAsync: engagementAsync,
            onDueTap: () => context.go('/reviews'),
          ),
        ),
      ),
    );
  }
}

class _ProgressBody extends StatelessWidget {
  final ProgressSummary summary;
  final AsyncValue<EngagementSummary> engagementAsync;
  final VoidCallback onDueTap;

  const _ProgressBody({
    required this.summary,
    required this.engagementAsync,
    required this.onDueTap,
  });

  @override
  Widget build(BuildContext context) {
    final byState = summary.byState;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.pagePaddingX),
      children: [
        // ── Due card (actionable) ──
        GestureDetector(
          onTap: onDueTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.accentPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(
                color: AppColors.accentPrimary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.replay,
                  color: AppColors.accentPrimary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'К повторению сегодня',
                        style: AppTypography.labelMd.copyWith(
                          color: AppColors.accentPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${summary.dueCount} слов',
                        style: AppTypography.titleMd.copyWith(
                          color: AppColors.accentPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.accentPrimary),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),

        // ── Learning status cards ──
        Text('Статус обучения', style: AppTypography.titleSm),
        const SizedBox(height: AppSpacing.s3),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _card(
              '${byState['learning'] ?? 0}',
              'Изучается',
              Icons.school_outlined,
            ),
            _card(
              '${byState['reviewing'] ?? 0}',
              'Закреплено',
              Icons.autorenew,
            ),
            _card(
              '${byState['mastered'] ?? 0}',
              'Освоено',
              Icons.verified_outlined,
            ),
            _card(
              '${summary.totalTokens}',
              'Всего слов',
              Icons.library_books_outlined,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sectionGap),

        // ── Weak concepts ──
        if (summary.weakConcepts.isNotEmpty) ...[
          Text('Слабые места', style: AppTypography.titleSm),
          const SizedBox(height: AppSpacing.s3),
          ...summary.weakConcepts.map(
            (concept) => _WeakConceptRow(concept: concept),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
        ],

        // ── Engagement ──
        engagementAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
          data: (eng) => _EngagementSection(engagement: eng),
        ),

        const SizedBox(height: AppSpacing.s8),
      ],
    );
  }

  Widget _card(String value, String label, IconData icon) {
    return SizedBox(
      width: 155,
      child: MetricCard(value: value, label: label, icon: icon),
    );
  }
}

class _WeakConceptRow extends StatelessWidget {
  final String concept;
  const _WeakConceptRow({required this.concept});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceDefault,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_outlined,
            size: 18,
            color: AppColors.warningDefault,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              concept,
              style: AppTypography.bodyMd,
              textDirection: TextDirection.rtl,
            ),
          ),
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

class _EngagementSection extends StatelessWidget {
  final EngagementSummary engagement;
  const _EngagementSection({required this.engagement});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Активность', style: AppTypography.titleSm),
        const SizedBox(height: AppSpacing.s3),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: 155,
              child: MetricCard(
                value: '${engagement.currentStreakDays}',
                label: 'Серия дней',
                icon: Icons.local_fire_department,
              ),
            ),
            SizedBox(
              width: 155,
              child: MetricCard(
                value: '${engagement.bestStreakDays}',
                label: 'Лучшая серия',
                icon: Icons.emoji_events_outlined,
              ),
            ),
            SizedBox(
              width: 155,
              child: MetricCard(
                value: '${engagement.lessonsCompletedTotal}',
                label: 'Уроков всего',
                icon: Icons.menu_book_outlined,
              ),
            ),
            SizedBox(
              width: 155,
              child: MetricCard(
                value: '${engagement.daysActive30d}',
                label: 'Дней за 30д',
                icon: Icons.calendar_month_outlined,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
