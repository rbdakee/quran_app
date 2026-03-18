import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/features/lessons/presentation/screens/lessons_screen.dart';
import 'package:quran_app/features/today/data/lesson_repository.dart';
import 'package:quran_app/shared/models/models.dart';

void main() {
  testWidgets('Lessons screen renders previous lessons and next CTA', (
    WidgetTester tester,
  ) async {
    final repo = _FakeLessonRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [lessonRepositoryProvider.overrideWithValue(repo)],
        child: const MaterialApp(home: LessonsScreen()),
      ),
    );

    await tester.pump();
    await tester.pump();

    expect(find.text('Ваш путь'), findsOneWidget);
    expect(find.byKey(const ValueKey('lesson-node-lesson-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('lesson-node-lesson-2')), findsOneWidget);
    expect(find.byKey(const ValueKey('next-lesson-node')), findsOneWidget);
    expect(find.text('Продолжить текущий урок'), findsOneWidget);
    expect(find.textContaining('без создания дубля'), findsOneWidget);
  });
}

class _FakeLessonRepository extends LessonRepository {
  _FakeLessonRepository() : super(Dio());

  @override
  Future<LessonsTimelineResponse> getTimeline({
    String userId = 'default_user',
    int limit = 20,
  }) async {
    return LessonsTimelineResponse(
      items: const [
        LessonTimelineItem(
          lessonId: 'lesson-1',
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
          algorithmVersion: 'v1',
        ),
        LessonTimelineItem(
          lessonId: 'lesson-2',
          status: 'in_progress',
          readOnly: false,
          startedAt: '2026-03-17T11:00:00Z',
          completedAt: null,
          invalidatedAt: null,
          totalSteps: 12,
          stepsAnswered: 3,
          correctCount: 3,
          newWordsCount: 5,
          reviewWordsCount: 7,
          algorithmVersion: 'v1',
        ),
      ],
      nextLesson: const NextLessonAction(
        kind: 'create_or_open',
        hasActiveLesson: true,
        activeLessonId: 'lesson-2',
      ),
    );
  }
}
