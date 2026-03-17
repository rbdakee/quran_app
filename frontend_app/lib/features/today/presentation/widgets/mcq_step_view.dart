import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme.dart';
import '../../../../shared/models/models.dart';
import '../../../../shared/widgets/widgets.dart';
import '../providers/lesson_notifier.dart';
import '../providers/lesson_state.dart';

class McqStepView extends ConsumerWidget {
  final LessonStep step;
  final LessonState lessonState;

  const McqStepView({
    super.key,
    required this.step,
    required this.lessonState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(lessonNotifierProvider.notifier);
    final token = step.token;
    final options = step.options ?? [];
    final isInFeedback = lessonState.phase == LessonPhase.feedback;
    final answer = lessonState.lastAnswer;

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

        // Prompt card
        PromptCard(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (token != null) ...[
                if (_showArabicPrompt(step.type))
                  Text(
                    token.ar,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: AppTypography.arabicWord,
                  ),
                if (step.type == 'translation_to_word')
                  Text(
                    token.translationEn ?? '',
                    textAlign: TextAlign.center,
                    style: AppTypography.titleMd,
                  ),
                if (step.type == 'audio_to_meaning') ...[
                  if (token.audioKey != null && token.audioKey!.isNotEmpty)
                    AudioPlayButton(
                      audioKey: token.audioKey!,
                      surah: token.surah,
                      size: 64,
                    )
                  else
                    const Icon(Icons.headphones, size: 40, color: AppColors.accentPrimary),
                  const SizedBox(height: 8),
                  Text(
                    'Прослушайте и выберите ответ',
                    style: AppTypography.bodyMd.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s4),

        // Options
        ...options.map((option) {
          final optState = _optionState(
            option: option,
            selected: lessonState.selectedOption,
            isInFeedback: isInFeedback,
            isCorrect: answer?.isCorrect ?? false,
            correctAnswer: step.correct,
          );

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: OptionTile(
              text: option,
              state: optState,
              onTap: isInFeedback ? null : () => notifier.selectOption(option),
            ),
          );
        }),
      ],
    );
  }

  bool _showArabicPrompt(String type) =>
      type == 'meaning_choice' || type == 'review_card' || type == 'reinforcement';

  String _instructionFor(String type) {
    return switch (type) {
      'meaning_choice' => 'Выберите правильный перевод',
      'review_card' => 'Выберите правильный перевод',
      'reinforcement' => 'Закрепите знание слова',
      'audio_to_meaning' => 'Выберите значение по аудио',
      'translation_to_word' => 'Выберите арабское слово',
      _ => 'Выберите ответ',
    };
  }

  OptionState _optionState({
    required String option,
    required String? selected,
    required bool isInFeedback,
    required bool isCorrect,
    required String? correctAnswer,
  }) {
    if (!isInFeedback) {
      return option == selected ? OptionState.selected : OptionState.idle;
    }
    if (option == selected && isCorrect) return OptionState.correct;
    if (option == selected && !isCorrect) return OptionState.wrongSelected;
    if (option == correctAnswer && !isCorrect) return OptionState.correct;
    return OptionState.disabled;
  }
}
