import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/models.dart';
import '../../data/reviews_repository.dart';

final reviewsDueProvider = FutureProvider.autoDispose<List<DueReviewItem>>((
  ref,
) {
  return ref.watch(reviewsRepositoryProvider).getReviewsDue();
});

final reviewsWordsLessonProvider = FutureProvider.autoDispose<LessonResponse>((
  ref,
) {
  return ref.watch(reviewsRepositoryProvider).generateReviewLesson();
});
