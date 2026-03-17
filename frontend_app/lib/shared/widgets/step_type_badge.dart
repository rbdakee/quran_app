import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

enum BadgeVariant { neutral, accent, listening, newWord }

class StepTypeBadge extends StatelessWidget {
  final String label;
  final BadgeVariant variant;

  const StepTypeBadge({
    super.key,
    required this.label,
    this.variant = BadgeVariant.neutral,
  });

  factory StepTypeBadge.fromStepType(String stepType) {
    return switch (stepType) {
      'new_word_intro' => const StepTypeBadge(label: 'Новое слово', variant: BadgeVariant.newWord),
      'meaning_choice' => const StepTypeBadge(label: 'AR → EN', variant: BadgeVariant.accent),
      'review_card' => const StepTypeBadge(label: 'Повторение', variant: BadgeVariant.neutral),
      'reinforcement' => const StepTypeBadge(label: 'Закрепление', variant: BadgeVariant.neutral),
      'audio_to_meaning' => const StepTypeBadge(label: 'Аудирование', variant: BadgeVariant.listening),
      'translation_to_word' => const StepTypeBadge(label: 'EN → AR', variant: BadgeVariant.accent),
      String s when s.startsWith('ayah_build') => const StepTypeBadge(label: 'Ayah Build', variant: BadgeVariant.accent),
      _ => StepTypeBadge(label: stepType, variant: BadgeVariant.neutral),
    };
  }

  (Color bg, Color text) get _colors => switch (variant) {
    BadgeVariant.neutral => (AppColors.surfaceElevated, AppColors.textSecondary),
    BadgeVariant.accent => (AppColors.accentPrimary.withValues(alpha: 0.15), AppColors.accentPrimary),
    BadgeVariant.listening => (AppColors.infoBg, AppColors.infoDefault),
    BadgeVariant.newWord => (AppColors.successBg, AppColors.successDefault),
  };

  @override
  Widget build(BuildContext context) {
    final (bg, text) = _colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Text(
        label,
        style: AppTypography.labelSm.copyWith(color: text),
      ),
    );
  }
}
