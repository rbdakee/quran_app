import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme.dart';
import '../../../../shared/models/models.dart';
import '../../../../shared/widgets/widgets.dart';
import '../providers/lesson_notifier.dart';
import '../providers/lesson_state.dart';

class AyahBuildStepView extends ConsumerWidget {
  final LessonStep step;
  final LessonState lessonState;

  const AyahBuildStepView({
    super.key,
    required this.step,
    required this.lessonState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(lessonNotifierProvider.notifier);
    final pool = step.pool ?? [];
    final placed = lessonState.orderedTokenIds;
    final isInFeedback = lessonState.phase == LessonPhase.feedback;
    final goldOrder = step.goldOrderTokenIds ?? [];
    final slotCount = goldOrder.isNotEmpty
        ? goldOrder.length
        : pool.where((t) => !t.isDistractor).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StepTypeBadge.fromStepType(step.type),
        const SizedBox(height: AppSpacing.s2),
        Text(
          _instructionFor(step.type),
          style: AppTypography.bodyMd.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.s4),

        // Prompt
        PromptCard(minHeight: 100, child: _buildPrompt()),
        const SizedBox(height: AppSpacing.s4),

        // Slots
        Text('Ваш ответ:', style: AppTypography.labelMd),
        const SizedBox(height: AppSpacing.s2),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          textDirection: _isArabicBuild()
              ? TextDirection.rtl
              : TextDirection.ltr,
          children: List.generate(slotCount, (i) {
            final hasToken = i < placed.length;
            final tokenId = hasToken ? placed[i] : null;
            final tokenText = hasToken
                ? pool.where((t) => t.tokenId == tokenId).firstOrNull?.text ??
                      '?'
                : null;

            Color borderColor = AppColors.borderDefault;
            if (isInFeedback && hasToken && i < goldOrder.length) {
              borderColor = goldOrder[i] == tokenId
                  ? AppColors.successDefault
                  : AppColors.errorDefault;
            }

            return GestureDetector(
              onTap: (!isInFeedback && hasToken && tokenId != null)
                  ? () => notifier.removeToken(tokenId)
                  : null,
              child: AnimatedContainer(
                duration: AppDurations.fast,
                constraints: const BoxConstraints(minWidth: 56, minHeight: 44),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: hasToken
                      ? AppColors.surfaceElevated
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: borderColor,
                    width: isInFeedback ? 1.5 : 1,
                  ),
                ),
                child: hasToken
                    ? Text(
                        tokenText!,
                        style: _isArabicBuild()
                            ? AppTypography.arabicInline
                            : AppTypography.bodyMd,
                        textDirection: _isArabicBuild()
                            ? TextDirection.rtl
                            : null,
                      )
                    : Text(
                        '${i + 1}',
                        style: AppTypography.labelSm.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
              ),
            );
          }),
        ),
        const SizedBox(height: AppSpacing.s4),

        // Pool
        Text('Доступные слова:', style: AppTypography.labelMd),
        const SizedBox(height: AppSpacing.s2),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          textDirection: _isArabicBuild()
              ? TextDirection.rtl
              : TextDirection.ltr,
          children: pool.map((token) {
            final isPlaced = placed.contains(token.tokenId);
            return AnimatedOpacity(
              duration: AppDurations.fast,
              opacity: isPlaced ? 0.3 : 1.0,
              child: GestureDetector(
                onTap: (isPlaced || isInFeedback)
                    ? null
                    : () => notifier.addToken(token.tokenId),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                    border: Border.all(color: AppColors.borderDefault),
                  ),
                  child: Text(
                    token.text,
                    style: _isArabicBuild()
                        ? AppTypography.arabicInline
                        : AppTypography.bodyMd,
                    textDirection: _isArabicBuild() ? TextDirection.rtl : null,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPrompt() {
    if (step.type == 'ayah_build_ar_from_translation') {
      return Text(
        (step.promptTranslationUnits ?? []).join(' '),
        textAlign: TextAlign.center,
        style: AppTypography.bodyLg,
      );
    }
    if (step.type == 'ayah_build_translation_from_ar') {
      return Text(
        (step.promptArTokens ?? []).join(' '),
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center,
        style: AppTypography.arabicSegment,
      );
    }
    final audioKeys = step.promptAudioKeys ?? [];
    final surah = step.surah ?? 1;
    return Column(
      children: [
        if (audioKeys.isNotEmpty)
          AudioPlayButton(audioKey: audioKeys.first, surah: surah, size: 64)
        else
          const Icon(
            Icons.headphones,
            size: 40,
            color: AppColors.accentPrimary,
          ),
        const SizedBox(height: 8),
        Text(
          'Прослушайте и соберите',
          style: AppTypography.bodyMd.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  bool _isArabicBuild() =>
      step.type == 'ayah_build_ar_from_translation' ||
      step.type == 'ayah_build_ar_from_audio';

  String _instructionFor(String type) {
    return switch (type) {
      'ayah_build_ar_from_translation' => 'Соберите арабскую фразу по переводу',
      'ayah_build_ar_from_audio' => 'Соберите по аудио',
      'ayah_build_translation_from_ar' => 'Соберите перевод',
      _ => 'Соберите в правильном порядке',
    };
  }
}
