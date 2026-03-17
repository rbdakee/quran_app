import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/models.dart';
import '../../data/progress_repository.dart';

final progressSummaryProvider = FutureProvider.autoDispose<ProgressSummary>((ref) {
  return ref.watch(progressRepositoryProvider).getSummary();
});

final engagementProvider = FutureProvider.autoDispose<EngagementSummary>((ref) {
  return ref.watch(progressRepositoryProvider).getEngagement();
});
