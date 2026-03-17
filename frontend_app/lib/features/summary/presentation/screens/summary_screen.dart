import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../today/presentation/providers/lesson_notifier.dart';


class SummaryScreen extends ConsumerWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(lessonNotifierProvider);
    final summary = state.completeSummary?.summary;

    return Scaffold(
      appBar: AppBar(title: const Text('Итоги урока')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pagePaddingX),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.s8),

            // Hero
            const Icon(Icons.check_circle_outline, size: 64, color: AppColors.successDefault),
            const SizedBox(height: AppSpacing.s4),
            const Text('Урок завершён', style: AppTypography.titleLg),
            const SizedBox(height: AppSpacing.s2),
            Text(
              'Вы завершили урок и укрепили словарную базу.',
              style: AppTypography.bodyMd.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s8),

            // Metrics grid
            if (summary != null) ...[
              _MetricsGrid(summary: summary),
              const SizedBox(height: AppSpacing.s6),

              // Streak info
              if (state.completeSummary?.engagement?.streakUpdated == true)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.successBg,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.local_fire_department, color: AppColors.successDefault, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Серия обновлена!',
                        style: AppTypography.labelMd.copyWith(color: AppColors.successDefault),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: AppSpacing.s8),
            ] else ...[
              const SizedBox(height: AppSpacing.s4),
              Text(
                'Детали урока недоступны',
                style: AppTypography.bodyMd.copyWith(color: AppColors.textTertiary),
              ),
              const SizedBox(height: AppSpacing.s8),
            ],

            // Actions
            PrimaryButton(
              label: 'К прогрессу',
              onPressed: () => context.go('/progress'),
            ),
            const SizedBox(height: AppSpacing.s3),
            SecondaryButton(
              label: 'К повторениям',
              onPressed: () => context.go('/reviews'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  final dynamic summary;
  const _MetricsGrid({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _metric('${summary.stepsDone}', 'Шагов', Icons.check),
        _metric('${(summary.accuracy * 100).round()}%', 'Точность', Icons.gps_fixed),
        _metric('${summary.newConceptsLearned}', 'Новые слова', Icons.add_circle_outline),
        _metric('${summary.reviewsDone}', 'Повторений', Icons.replay),
        if (summary.ayahTasksDone > 0)
          _metric('${summary.ayahTasksDone}', 'Ayah задач', Icons.format_list_numbered),
      ],
    );
  }

  Widget _metric(String value, String label, IconData icon) {
    return SizedBox(
      width: 155,
      child: MetricCard(value: value, label: label, icon: icon),
    );
  }
}
