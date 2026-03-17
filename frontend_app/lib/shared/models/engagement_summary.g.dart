// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'engagement_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EngagementSummary _$EngagementSummaryFromJson(Map<String, dynamic> json) =>
    _EngagementSummary(
      currentStreakDays: (json['current_streak_days'] as num).toInt(),
      bestStreakDays: (json['best_streak_days'] as num).toInt(),
      lessonsCompletedTotal: (json['lessons_completed_total'] as num).toInt(),
      daysActive30d: (json['days_active_30d'] as num).toInt(),
      lastActiveAt: json['last_active_at'] as String?,
    );

Map<String, dynamic> _$EngagementSummaryToJson(_EngagementSummary instance) =>
    <String, dynamic>{
      'current_streak_days': instance.currentStreakDays,
      'best_streak_days': instance.bestStreakDays,
      'lessons_completed_total': instance.lessonsCompletedTotal,
      'days_active_30d': instance.daysActive30d,
      'last_active_at': instance.lastActiveAt,
    };
