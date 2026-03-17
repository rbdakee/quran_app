// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'due_review_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DueReviewItem _$DueReviewItemFromJson(Map<String, dynamic> json) =>
    _DueReviewItem(
      tokenId: json['token_id'] as String,
      conceptKey: json['concept_key'] as String?,
      state: json['state'] as String,
      stability: (json['stability'] as num).toDouble(),
      nextReviewAt: json['next_review_at'] as String,
      dueScore: (json['due_score'] as num).toDouble(),
    );

Map<String, dynamic> _$DueReviewItemToJson(_DueReviewItem instance) =>
    <String, dynamic>{
      'token_id': instance.tokenId,
      'concept_key': instance.conceptKey,
      'state': instance.state,
      'stability': instance.stability,
      'next_review_at': instance.nextReviewAt,
      'due_score': instance.dueScore,
    };
