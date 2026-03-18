import 'package:flutter/foundation.dart';

import '../../../../shared/models/models.dart';

enum LessonsTimelinePhase { loading, ready, empty, error, openingNext }

@immutable
class LessonsTimelineState {
  final LessonsTimelinePhase phase;
  final LessonsTimelineResponse? timeline;
  final String? errorMessage;

  const LessonsTimelineState({
    this.phase = LessonsTimelinePhase.loading,
    this.timeline,
    this.errorMessage,
  });

  LessonsTimelineState copyWith({
    LessonsTimelinePhase? phase,
    LessonsTimelineResponse? timeline,
    String? Function()? errorMessage,
  }) {
    return LessonsTimelineState(
      phase: phase ?? this.phase,
      timeline: timeline ?? this.timeline,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
