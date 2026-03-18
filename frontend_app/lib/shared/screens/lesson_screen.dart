import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/theme.dart';
import '../../features/today/presentation/providers/lesson_notifier.dart';
import '../../features/today/presentation/providers/lesson_state.dart';
import '../../features/today/presentation/widgets/step_renderer.dart';
import '../widgets/widgets.dart';

class LessonScreen extends ConsumerStatefulWidget {
  final String lessonId;

  const LessonScreen({required this.lessonId, super.key});

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(lessonNotifierProvider.notifier).loadLessonById(widget.lessonId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(lessonNotifierProvider);
    final notifier = ref.read(lessonNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          state.lesson?.readOnly == true ? 'Урок · Только чтение' : 'Урок',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/lessons');
            }
          },
        ),
      ),
      body: switch (state.phase) {
        LessonPhase.loading => const Center(
          child: CircularProgressIndicator(color: AppColors.accentPrimary),
        ),
        LessonPhase.error => ErrorStateBlock(
          message: state.errorMessage ?? 'Не удалось загрузить урок',
          onRetry: () => notifier.loadLessonById(widget.lessonId),
        ),
        LessonPhase.empty => EmptyStateBlock(
          icon: Icons.auto_stories_outlined,
          title: 'Урок пуст',
          body: 'Нет шагов для прохождения.',
          ctaLabel: 'Вернуться',
          onCta: () => context.pop(),
        ),
        LessonPhase.completed => _CompletedRedirect(context: context),
        _ => _LessonBody(state: state, notifier: notifier),
      },
    );
  }
}

class _CompletedRedirect extends StatefulWidget {
  final BuildContext context;
  const _CompletedRedirect({required this.context});

  @override
  State<_CompletedRedirect> createState() => _CompletedRedirectState();
}

class _CompletedRedirectState extends State<_CompletedRedirect> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go('/lessons/summary');
    });
  }

  @override
  Widget build(BuildContext context) => const Center(
    child: CircularProgressIndicator(color: AppColors.accentPrimary),
  );
}

class _LessonBody extends StatelessWidget {
  final LessonState state;
  final LessonNotifier notifier;

  const _LessonBody({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final step = state.currentStep;
    final lesson = state.lesson;
    if (step == null || lesson == null) return const SizedBox.shrink();

    final isReadOnly = lesson.readOnly;
    final isSubmitting = state.phase == LessonPhase.submitting;
    final isInFeedback = state.phase == LessonPhase.feedback;
    final isLastStep = state.isLastStep;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isReadOnly) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.orange.withValues(alpha: 0.35),
                ),
              ),
              child: const Text(
                'Этот урок открыт в режиме только чтения. Ответы изменить нельзя.',
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            'Шаг ${state.currentStepIndex + 1} / ${lesson.steps.length}',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          StepRenderer(step: step, lessonState: state),
          const SizedBox(height: 24),
          if (isSubmitting)
            const Center(
              child: CircularProgressIndicator(color: AppColors.accentPrimary),
            )
          else if (isReadOnly)
            PrimaryButton(
              label: isLastStep ? 'Закрыть' : 'Далее',
              onPressed: () {
                if (isLastStep) {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/lessons');
                  }
                } else {
                  notifier.advanceReadOnlyStep();
                }
              },
            )
          else if (isInFeedback)
            PrimaryButton(
              label: isLastStep ? 'Завершить' : 'Далее',
              onPressed: notifier.nextStep,
            )
          else
            PrimaryButton(
              label: 'Ответить',
              onPressed: state.canSubmit ? notifier.submitAnswer : null,
            ),
        ],
      ),
    );
  }
}
