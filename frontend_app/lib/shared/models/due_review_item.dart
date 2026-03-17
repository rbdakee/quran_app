import 'package:freezed_annotation/freezed_annotation.dart';

part 'due_review_item.freezed.dart';
part 'due_review_item.g.dart';

@freezed
abstract class DueReviewItem with _$DueReviewItem {
  const factory DueReviewItem({
    @JsonKey(name: 'token_id') required String tokenId,
    @JsonKey(name: 'concept_key') String? conceptKey,
    required String state,
    required double stability,
    @JsonKey(name: 'next_review_at') required String nextReviewAt,
    @JsonKey(name: 'due_score') required double dueScore,
  }) = _DueReviewItem;

  factory DueReviewItem.fromJson(Map<String, dynamic> json) =>
      _$DueReviewItemFromJson(json);
}
