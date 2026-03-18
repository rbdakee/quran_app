import 'package:freezed_annotation/freezed_annotation.dart';

part 'engagement_summary.freezed.dart';
part 'engagement_summary.g.dart';

@freezed
abstract class EngagementSummary with _$EngagementSummary {
  const factory EngagementSummary({
    @JsonKey(name: 'current_streak_days') required int currentStreakDays,
    @JsonKey(name: 'best_streak_days') required int bestStreakDays,
    @JsonKey(name: 'lessons_completed_total')
    required int lessonsCompletedTotal,
    @JsonKey(name: 'days_active_30d') required int daysActive30d,
    @JsonKey(name: 'last_active_at') String? lastActiveAt,
  }) = _EngagementSummary;

  factory EngagementSummary.fromJson(Map<String, dynamic> json) =>
      _$EngagementSummaryFromJson(json);
}
