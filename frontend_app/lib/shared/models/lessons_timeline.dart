class LessonsTimelineResponse {
  final List<LessonTimelineItem> items;
  final NextLessonAction nextLesson;

  const LessonsTimelineResponse({
    required this.items,
    required this.nextLesson,
  });

  factory LessonsTimelineResponse.fromJson(Map<String, dynamic> json) {
    final itemsJson = (json['items'] as List<dynamic>? ?? const []);
    return LessonsTimelineResponse(
      items: itemsJson
          .whereType<Map<String, dynamic>>()
          .map(LessonTimelineItem.fromJson)
          .toList(),
      nextLesson: NextLessonAction.fromJson(
        (json['next_lesson'] as Map<String, dynamic>?) ?? const {},
      ),
    );
  }
}

class LessonTimelineItem {
  final String lessonId;
  final String status;
  final bool readOnly;
  final String? startedAt;
  final String? completedAt;
  final String? invalidatedAt;
  final int totalSteps;
  final int stepsAnswered;
  final int correctCount;
  final int newWordsCount;
  final int reviewWordsCount;
  final String algorithmVersion;

  const LessonTimelineItem({
    required this.lessonId,
    required this.status,
    required this.readOnly,
    required this.startedAt,
    required this.completedAt,
    required this.invalidatedAt,
    required this.totalSteps,
    required this.stepsAnswered,
    required this.correctCount,
    required this.newWordsCount,
    required this.reviewWordsCount,
    required this.algorithmVersion,
  });

  bool get isCompleted => status == 'completed';
  bool get isInProgress => status == 'in_progress' || status == 'active';
  bool get isInvalidated => status == 'invalidated';

  factory LessonTimelineItem.fromJson(Map<String, dynamic> json) {
    return LessonTimelineItem(
      lessonId: json['lesson_id']?.toString() ?? '',
      status: json['status']?.toString() ?? 'unknown',
      readOnly: json['read_only'] == true,
      startedAt: json['started_at']?.toString(),
      completedAt: json['completed_at']?.toString(),
      invalidatedAt: json['invalidated_at']?.toString(),
      totalSteps: (json['total_steps'] as num?)?.toInt() ?? 0,
      stepsAnswered: (json['steps_answered'] as num?)?.toInt() ?? 0,
      correctCount: (json['correct_count'] as num?)?.toInt() ?? 0,
      newWordsCount: (json['new_words_count'] as num?)?.toInt() ?? 0,
      reviewWordsCount: (json['review_words_count'] as num?)?.toInt() ?? 0,
      algorithmVersion: json['algorithm_version']?.toString() ?? '',
    );
  }
}

class NextLessonAction {
  final String kind;
  final bool hasActiveLesson;
  final String? activeLessonId;

  const NextLessonAction({
    required this.kind,
    required this.hasActiveLesson,
    required this.activeLessonId,
  });

  factory NextLessonAction.fromJson(Map<String, dynamic> json) {
    return NextLessonAction(
      kind: json['kind']?.toString() ?? 'create_or_open',
      hasActiveLesson: json['has_active_lesson'] == true,
      activeLessonId: json['active_lesson_id']?.toString(),
    );
  }
}
