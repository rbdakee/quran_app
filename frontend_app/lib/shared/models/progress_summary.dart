import 'package:freezed_annotation/freezed_annotation.dart';

part 'progress_summary.freezed.dart';
part 'progress_summary.g.dart';

@freezed
abstract class ProgressSummary with _$ProgressSummary {
  const factory ProgressSummary({
    @JsonKey(name: 'total_tokens') required int totalTokens,
    @JsonKey(name: 'by_state') required Map<String, int> byState,
    @JsonKey(name: 'due_count') required int dueCount,
    @JsonKey(name: 'weak_concepts') @Default([]) List<String> weakConcepts,
  }) = _ProgressSummary;

  factory ProgressSummary.fromJson(Map<String, dynamic> json) =>
      _$ProgressSummaryFromJson(json);
}
