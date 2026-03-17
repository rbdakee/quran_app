import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/today/presentation/providers/lesson_notifier.dart';
import '../../features/today/presentation/providers/lesson_state.dart';
import '../../features/today/presentation/widgets/step_renderer.dart';
import '../../core/theme/theme.dart';
import '../widgets/widgets.dart';

/// Reusable lesson screen for both /today and /reviews-words lessons.
class LessonScreen extends ConsumerStatefulWidget {
  final String lessonId;

  const LessonScreen({
    required this.lessonId,
    super.key,
  });

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  @override
  void initState() {
    super.initState();
    // Load lesson on screen open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Note: LessonNotifier loads /lessons/today by default
      // For review lessons, would need to pass lesson_id explicitly
      ref.read(lessonNotifierProvider.notifier).loadLessonById(widget.lessonId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(lessonNotifierProvider);
    final notifier = ref.read(lessonNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Урок'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/today');
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
      context.go('/today/summary');
    });
  }

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator(color: AppColors.accentPrimary));
}

class _LessonBody extends StatelessWidget {
  final LessonState state;
  final LessonNotifier notifier;

  const _LessonBody({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final step = state.currentStep;
    if (step == null) return const SizedBox.shrink();

    final isSubmitting = state.phase == LessonPhase.submitting;
    final isInFeedback = state.phase == LessonPhase.feedback;
    final isLastStep = state.isLastStep;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress indicator
          Text(
            'Шаг ${state.currentStepIndex + 1} / ${state.lesson?.steps.length ?? '?'}',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Step renderer
          StepRenderer(
            step: step,
            lessonState: state,
          ),
          const SizedBox(height: 24),
          // CTA buttons
          if (isSubmitting)
            const Center(
              child: CircularProgressIndicator(color: AppColors.accentPrimary),
            )
          else if (isInFeedback)
            ElevatedButton(
              onPressed: () => notifier.nextStep(),
              child: Text(isLastStep ? 'Завершить' : 'Далее'),
            )
          else
            ElevatedButton(
              onPressed: () => notifier.submitAnswer(),
              child: const Text('Ответить'),
            ),
        ],
      ),
    );
  }
}
