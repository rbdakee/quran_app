import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/models/models.dart';
import '../../../../shared/widgets/widgets.dart';

class IntroStepView extends StatelessWidget {
  final LessonStep step;

  const IntroStepView({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    final token = step.token;
    if (token == null) return const SizedBox.shrink();

    final hasAudio = token.audioKey != null && token.audioKey!.isNotEmpty;

    return Column(
      children: [
        StepTypeBadge.fromStepType(step.type),
        const SizedBox(height: AppSpacing.s2),
        Text(
          'Запомните это слово',
          style: AppTypography.bodyMd.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.s4),
        PromptCard(
          minHeight: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Arabic word
              Text(
                token.ar,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: AppTypography.arabicWord,
              ),
              const SizedBox(height: AppSpacing.s4),
              // Translation
              Text(
                token.translationEn ?? '',
                textAlign: TextAlign.center,
                style: AppTypography.titleMd.copyWith(
                  color: AppColors.accentPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s3),
              // Location
              Text(
                'Сура ${token.surah}, аят ${token.ayah}',
                style: AppTypography.labelSm.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              // Audio button
              if (hasAudio) ...[
                const SizedBox(height: AppSpacing.s4),
                AudioPlayButton(
                  audioKey: token.audioKey!,
                  surah: token.surah,
                  size: 48,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
