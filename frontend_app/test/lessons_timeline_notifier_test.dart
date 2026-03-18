import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_app/features/lessons/presentation/providers/lessons_timeline_notifier.dart';
import 'package:quran_app/features/lessons/presentation/providers/lessons_timeline_state.dart';
import 'package:quran_app/features/today/data/lesson_repository.dart';
import 'package:quran_app/shared/models/models.dart';

void main() {
  test(
    'createOrOpenNextLesson returns lesson_id from create-next metadata response',
    () async {
      final container = ProviderContainer(
        overrides: [
          lessonRepositoryProvider.overrideWithValue(_FakeLessonRepository()),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(lessonsTimelineNotifierProvider.notifier);

      final lessonId = await notifier.createOrOpenNextLesson();
      final state = container.read(lessonsTimelineNotifierProvider);

      expect(lessonId, 'lesson-20260317-171843-3015');
      expect(state.phase, LessonsTimelinePhase.ready);
      expect(state.errorMessage, isNull);
    },
  );
}

class _FakeLessonRepository extends LessonRepository {
  _FakeLessonRepository() : super(Dio());

  @override
  Future<LessonsTimelineResponse> getTimeline({
    String userId = 'default_user',
    int limit = 20,
  }) async {
    return const LessonsTimelineResponse(
      items: [
        LessonTimelineItem(
          lessonId: 'lesson-existing',
          status: 'completed',
          readOnly: true,
          startedAt: '2026-03-17T10:00:00Z',
          completedAt: '2026-03-17T10:05:00Z',
          invalidatedAt: null,
          totalSteps: 10,
          stepsAnswered: 10,
          correctCount: 9,
          newWordsCount: 4,
          reviewWordsCount: 6,
          algorithmVersion: 'v3',
        ),
      ],
      nextLesson: NextLessonAction(
        kind: 'create_or_open',
        hasActiveLesson: false,
        activeLessonId: null,
      ),
    );
  }

  @override
  Future<String> createNextLesson({String userId = 'default_user'}) async {
    return 'lesson-20260317-171843-3015';
  }
}
