import 'package:flutter/foundation.dart';
import '../../../../shared/models/models.dart';

enum LessonPhase {
  loading,
  ready,
  submitting,
  feedback,
  completing,
  completed,
  error,
  empty,
}

@immutable
class LessonState {
  final LessonPhase phase;
  final LessonResponse? lesson;
  final int currentStepIndex;
  final String? selectedOption;
  final List<String> orderedTokenIds; // for ayah build
  final AnswerResponse? lastAnswer;
  final LessonCompleteResponse? completeSummary;
  final String? errorMessage;

  const LessonState({
    this.phase = LessonPhase.loading,
    this.lesson,
    this.currentStepIndex = 0,
    this.selectedOption,
    this.orderedTokenIds = const [],
    this.lastAnswer,
    this.completeSummary,
    this.errorMessage,
  });

  LessonStep? get currentStep {
    final steps = lesson?.steps;
    if (steps == null || currentStepIndex >= steps.length) return null;
    return steps[currentStepIndex];
  }

  int get totalSteps => lesson?.steps.length ?? 0;
  bool get isLastStep => currentStepIndex >= totalSteps - 1;
  bool get canSubmit {
    if (lesson?.readOnly == true) return false;
    if (phase != LessonPhase.ready) return false;
    final step = currentStep;
    if (step == null) return false;
    if (step.type == 'new_word_intro') return true;
    if (step.type.startsWith('ayah_build')) return orderedTokenIds.isNotEmpty;
    return selectedOption != null;
  }

  LessonState copyWith({
    LessonPhase? phase,
    LessonResponse? lesson,
    int? currentStepIndex,
    String? Function()? selectedOption,
    List<String>? orderedTokenIds,
    AnswerResponse? Function()? lastAnswer,
    LessonCompleteResponse? Function()? completeSummary,
    String? Function()? errorMessage,
  }) {
    return LessonState(
      phase: phase ?? this.phase,
      lesson: lesson ?? this.lesson,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      selectedOption: selectedOption != null
          ? selectedOption()
          : this.selectedOption,
      orderedTokenIds: orderedTokenIds ?? this.orderedTokenIds,
      lastAnswer: lastAnswer != null ? lastAnswer() : this.lastAnswer,
      completeSummary: completeSummary != null
          ? completeSummary()
          : this.completeSummary,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
