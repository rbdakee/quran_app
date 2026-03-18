import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../today/data/lesson_repository.dart';
import 'lessons_timeline_state.dart';

final lessonsTimelineNotifierProvider =
    NotifierProvider<LessonsTimelineNotifier, LessonsTimelineState>(
      LessonsTimelineNotifier.new,
    );

class LessonsTimelineNotifier extends Notifier<LessonsTimelineState> {
  late final LessonRepository _repo;

  @override
  LessonsTimelineState build() {
    _repo = ref.watch(lessonRepositoryProvider);
    Future.microtask(loadTimeline);
    return const LessonsTimelineState();
  }

  Future<void> loadTimeline() async {
    state = state.copyWith(
      phase: LessonsTimelinePhase.loading,
      errorMessage: () => null,
    );
    try {
      final timeline = await _repo.getTimeline();
      state = state.copyWith(
        phase: timeline.items.isEmpty
            ? LessonsTimelinePhase.empty
            : LessonsTimelinePhase.ready,
        timeline: timeline,
      );
    } catch (e) {
      state = state.copyWith(
        phase: LessonsTimelinePhase.error,
        errorMessage: () => _errorMsg(e),
      );
    }
  }

  Future<String> createOrOpenNextLesson() async {
    state = state.copyWith(phase: LessonsTimelinePhase.openingNext);
    try {
      final lessonId = await _repo.createNextLesson();
      await loadTimeline();
      return lessonId;
    } catch (e) {
      state = state.copyWith(
        phase: LessonsTimelinePhase.error,
        errorMessage: () => _errorMsg(e),
      );
      rethrow;
    }
  }

  String _errorMsg(Object e) {
    if (e is DioException && e.error is ApiException) {
      return (e.error as ApiException).message;
    }
    if (e is DioException) {
      return 'Ошибка сети. Проверьте подключение.';
    }
    return 'Не удалось загрузить уроки';
  }
}
