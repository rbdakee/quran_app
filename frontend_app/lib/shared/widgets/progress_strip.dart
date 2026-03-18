import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

class ProgressStrip extends StatelessWidget {
  final int current;
  final int total;

  const ProgressStrip({super.key, required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? current / total : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePaddingX),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Шаг $current из $total',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.s2),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
            child: AnimatedContainer(
              duration: AppDurations.normal,
              height: AppSpacing.progressHeight,
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.surfaceMuted,
                valueColor: const AlwaysStoppedAnimation(
                  AppColors.accentPrimary,
                ),
                minHeight: AppSpacing.progressHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
