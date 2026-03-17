import 'package:flutter/material.dart';
import '../../../../shared/models/models.dart';
import '../providers/lesson_state.dart';
import 'intro_step_view.dart';
import 'mcq_step_view.dart';
import 'ayah_build_step_view.dart';

/// Routes to the correct step widget based on step.type
class StepRenderer extends StatelessWidget {
  final LessonStep step;
  final LessonState lessonState;

  const StepRenderer({
    super.key,
    required this.step,
    required this.lessonState,
  });

  @override
  Widget build(BuildContext context) {
    if (step.type == 'new_word_intro') {
      return IntroStepView(step: step);
    }

    if (step.type.startsWith('ayah_build')) {
      return AyahBuildStepView(step: step, lessonState: lessonState);
    }

    // MCQ: meaning_choice, review_card, reinforcement, audio_to_meaning, translation_to_word
    return McqStepView(step: step, lessonState: lessonState);
  }
}
