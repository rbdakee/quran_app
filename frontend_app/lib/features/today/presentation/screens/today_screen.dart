import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../providers/lesson_notifier.dart';
import '../providers/lesson_state.dart';
import '../widgets/step_renderer.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(lessonNotifierProvider);
    final notifier = ref.read(lessonNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Сегодня')),
      body: switch (state.phase) {
        LessonPhase.loading || LessonPhase.completing => const Center(
            child: CircularProgressIndicator(color: AppColors.accentPrimary),
          ),
        LessonPhase.error => ErrorStateBlock(
            message: state.errorMessage ?? 'Не удалось загрузить урок',
            onRetry: notifier.loadLesson,
          ),
        LessonPhase.empty => EmptyStateBlock(
            icon: Icons.auto_stories_outlined,
            title: 'На сегодня всё!',
            body: 'Вы прошли урок. Возвращайтесь завтра для нового.',
            ctaLabel: 'Открыть прогресс',
            onCta: () => context.go('/progress'),
          ),
        LessonPhase.completed => _CompletedRedirect(state: state),
        _ => _LessonBody(state: state, notifier: notifier),
      },
    );
  }
}

/// Auto-navigates to summary after lesson completes
class _CompletedRedirect extends StatefulWidget {
  final LessonState state;
  const _CompletedRedirect({required this.state});

  @override
  State<_CompletedRedirect> createState() => _CompletedRedirectState();
}

class _CompletedRedirectState extends State<_CompletedRedirect> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go('/today/summary');
    });
  }

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator(color: AppColors.accentPrimary));
}

/// Lesson in progress — shows step + CTA
class _LessonBody extends StatelessWidget {
  final LessonState state;
  final LessonNotifier notifier;

  const _LessonBody({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final step = state.currentStep;
    if (step == null) return const SizedBox.shrink();

    final isInFeedback = state.phase == LessonPhase.feedback;
    final isSubmitting = state.phase == LessonPhase.submitting;
    final answer = state.lastAnswer;

    return Column(
      children: [
        const SizedBox(height: AppSpacing.s2),
        ProgressStrip(current: state.currentStepIndex + 1, total: state.totalSteps),
        const SizedBox(height: AppSpacing.s4),

        // Step content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePaddingX),
            child: StepRenderer(step: step, lessonState: state),
          ),
        ),

        // Feedback
        if (isInFeedback && answer != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePaddingX),
            child: FeedbackBanner(
              type: answer.isCorrect ? FeedbackType.success : FeedbackType.error,
              message: answer.feedback?.message ??
                  (answer.isCorrect ? 'Правильно!' : 'Неправильно'),
            ),
          ),

        // CTA
        Padding(
          padding: const EdgeInsets.all(AppSpacing.pagePaddingX),
          child: PrimaryButton(
            label: _ctaLabel(),
            isLoading: isSubmitting,
            onPressed: _ctaAction(),
          ),
        ),
      ],
    );
  }

  String _ctaLabel() {
    if (state.phase == LessonPhase.feedback) return 'Далее';
    if (state.currentStep?.type == 'new_word_intro') return 'Далее';
    return 'Проверить';
  }

  VoidCallback? _ctaAction() {
    if (state.phase == LessonPhase.feedback) return notifier.nextStep;
    if (state.phase == LessonPhase.submitting) return null;
    if (!state.canSubmit) return null;
    return notifier.submitAnswer;
  }
}
