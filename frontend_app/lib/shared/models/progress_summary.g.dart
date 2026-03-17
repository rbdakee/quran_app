// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProgressSummary _$ProgressSummaryFromJson(Map<String, dynamic> json) =>
    _ProgressSummary(
      totalTokens: (json['total_tokens'] as num).toInt(),
      byState: Map<String, int>.from(json['by_state'] as Map),
      dueCount: (json['due_count'] as num).toInt(),
      weakConcepts:
          (json['weak_concepts'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ProgressSummaryToJson(_ProgressSummary instance) =>
    <String, dynamic>{
      'total_tokens': instance.totalTokens,
      'by_state': instance.byState,
      'due_count': instance.dueCount,
      'weak_concepts': instance.weakConcepts,
    };
