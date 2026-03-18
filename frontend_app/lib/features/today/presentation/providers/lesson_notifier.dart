import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../shared/models/models.dart';
import '../../data/lesson_repository.dart';
import 'lesson_state.dart';

final lessonNotifierProvider = NotifierProvider<LessonNotifier, LessonState>(
  LessonNotifier.new,
);

class LessonNotifier extends Notifier<LessonState> {
  late final LessonRepository _repo;
  DateTime? _stepShownAt;

  @override
  LessonState build() {
    _repo = ref.watch(lessonRepositoryProvider);
    return const LessonState();
  }

  // ── Load ──

  /// Load lesson by ID from backend (exact lesson instance)
  Future<void> loadLessonById(String lessonId) async {
    state = state.copyWith(phase: LessonPhase.loading);
    try {
      final lesson = await _repo.getLessonById(lessonId: lessonId);
      if (lesson.steps.isEmpty) {
        state = state.copyWith(phase: LessonPhase.empty);
      } else {
        state = state.copyWith(
          phase: LessonPhase.ready,
          lesson: lesson,
          currentStepIndex: 0,
          selectedOption: () => null,
          orderedTokenIds: [],
          lastAnswer: () => null,
        );
        _stepShownAt = DateTime.now();
      }
    } catch (e) {
      state = state.copyWith(
        phase: LessonPhase.error,
        errorMessage: () => _errorMsg(e),
      );
    }
  }

  /// Kept for call-site compatibility; source of truth is backend cache now.
  void cacheLesson(String lessonId, LessonResponse lesson) {}

  // ── Select (MCQ) ──

  void selectOption(String option) {
    if (state.phase != LessonPhase.ready) return;
    state = state.copyWith(selectedOption: () => option);
  }

  // ── Ayah Build: add/remove token ──

  void addToken(String tokenId) {
    if (state.phase != LessonPhase.ready) return;
    if (state.orderedTokenIds.contains(tokenId)) return;
    state = state.copyWith(
      orderedTokenIds: [...state.orderedTokenIds, tokenId],
    );
  }

  void removeToken(String tokenId) {
    if (state.phase != LessonPhase.ready) return;
    state = state.copyWith(
      orderedTokenIds: state.orderedTokenIds
          .where((id) => id != tokenId)
          .toList(),
    );
  }

  // ── Submit ──

  Future<void> submitAnswer() async {
    final step = state.currentStep;
    final lesson = state.lesson;
    if (step == null || lesson == null || lesson.readOnly) return;
    if (state.phase == LessonPhase.submitting) return;

    state = state.copyWith(phase: LessonPhase.submitting);

    final latencyMs = _stepShownAt != null
        ? DateTime.now().difference(_stepShownAt!).inMilliseconds
        : null;

    final tokenId = step.token?.tokenId ?? '';

    AnswerBody answerBody;
    if (step.type == 'new_word_intro') {
      answerBody = const AnswerBody(acknowledged: true);
    } else if (step.type.startsWith('ayah_build')) {
      answerBody = AnswerBody(orderedTokenIds: state.orderedTokenIds);
    } else {
      answerBody = AnswerBody(selectedOption: state.selectedOption);
    }

    final request = AnswerRequest(
      stepIndex: step.stepIndex,
      stepType: step.type,
      tokenId: tokenId,
      answer: answerBody,
      telemetry: AnswerTelemetry(
        latencyMs: latencyMs,
        clientTs: DateTime.now().toUtc().toIso8601String(),
      ),
    );

    try {
      final response = await _repo.submitAnswer(
        lessonId: lesson.lessonId,
        request: request,
      );
      state = state.copyWith(
        phase: LessonPhase.feedback,
        lastAnswer: () => response,
      );
    } catch (e) {
      state = state.copyWith(
        phase: LessonPhase.error,
        errorMessage: () => _errorMsg(e),
      );
    }
  }

  // ── Next Step ──

  void nextStep() {
    if (state.lesson?.readOnly == true) {
      advanceReadOnlyStep();
      return;
    }
    if (state.isLastStep) {
      _completeLesson();
    } else {
      state = state.copyWith(
        phase: LessonPhase.ready,
        currentStepIndex: state.currentStepIndex + 1,
        selectedOption: () => null,
        orderedTokenIds: [],
        lastAnswer: () => null,
      );
      _stepShownAt = DateTime.now();
    }
  }

  void advanceReadOnlyStep() {
    if (state.lesson == null || state.phase == LessonPhase.loading) return;
    if (state.isLastStep) return;
    state = state.copyWith(
      phase: LessonPhase.ready,
      currentStepIndex: state.currentStepIndex + 1,
      selectedOption: () => null,
      orderedTokenIds: [],
      lastAnswer: () => null,
    );
  }

  // ── Complete ──

  Future<void> _completeLesson() async {
    final lesson = state.lesson;
    if (lesson == null) return;

    state = state.copyWith(phase: LessonPhase.completing);
    try {
      final result = await _repo.completeLesson(lessonId: lesson.lessonId);
      state = state.copyWith(
        phase: LessonPhase.completed,
        completeSummary: () => result,
      );
    } catch (_) {
      state = state.copyWith(
        phase: LessonPhase.completed,
        completeSummary: () => null,
      );
    }
  }

  // ── Helpers ──

  String _errorMsg(Object e) {
    if (e is DioException && e.error is ApiException) {
      return (e.error as ApiException).message;
    }
    if (e is DioException) {
      return 'Ошибка сети. Проверьте подключение.';
    }
    return 'Непредвиденная ошибка';
  }
}
