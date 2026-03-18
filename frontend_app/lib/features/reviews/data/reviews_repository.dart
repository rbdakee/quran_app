import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/models/models.dart';

final reviewsRepositoryProvider = Provider<ReviewsRepository>((ref) {
  return ReviewsRepository(ref.watch(dioProvider));
});

class ReviewsRepository {
  final Dio _dio;

  const ReviewsRepository(this._dio);

  /// Get due review items
  Future<List<DueReviewItem>> getReviewsDue({
    String userId = ApiConstants.defaultUserId,
    int limit = 50,
  }) async {
    final response = await _dio.get(
      ApiConstants.reviewsDue,
      queryParameters: {'user_id': userId, 'limit': limit},
    );
    final data = _extractListData(response.data);
    return data.map((e) => DueReviewItem.fromJson(e)).toList();
  }

  /// Generate review-only lesson from known words
  Future<LessonResponse> generateReviewLesson({
    String userId = ApiConstants.defaultUserId,
    int? seed,
    int limit = 20,
  }) async {
    final queryParams = {'user_id': userId, 'limit': limit};
    if (seed != null) {
      queryParams['seed'] = seed;
    }

    final response = await _dio.get(
      ApiConstants.reviewsWords,
      queryParameters: queryParams,
    );
    final lessonJson = response.data['data'] as Map<String, dynamic>;
    return LessonResponse.fromJson(lessonJson);
  }

  List<Map<String, dynamic>> _extractListData(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      final data = responseData['data'];
      if (data is List) {
        return data.cast<Map<String, dynamic>>();
      }
    }
    if (responseData is List) {
      return responseData.cast<Map<String, dynamic>>();
    }
    throw FormatException('Unexpected response format: $responseData');
  }
}
