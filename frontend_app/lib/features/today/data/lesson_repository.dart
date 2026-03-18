import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/models/models.dart';

final lessonRepositoryProvider = Provider<LessonRepository>((ref) {
  return LessonRepository(ref.watch(dioProvider));
});

class LessonRepository {
  final Dio _dio;

  const LessonRepository(this._dio);

  Future<LessonsTimelineResponse> getTimeline({
    String userId = ApiConstants.defaultUserId,
    int limit = 20,
  }) async {
    final response = await _dio.get(
      ApiConstants.lessonsTimeline,
      queryParameters: {'user_id': userId, 'limit': limit},
    );
    final data = _extractData(response.data);
    return LessonsTimelineResponse.fromJson(data);
  }

  Future<String> createNextLesson({
    String userId = ApiConstants.defaultUserId,
  }) async {
    final response = await _dio.post(
      ApiConstants.lessonsCreateNext,
      queryParameters: {'user_id': userId},
    );
    final data = _extractData(response.data);
    final lessonId = data['lesson_id']?.toString();
    if (lessonId == null || lessonId.isEmpty) {
      throw const FormatException('Missing lesson_id in create-next response');
    }
    return lessonId;
  }

  /// Load lesson by ID (exact stored lesson instance)
  Future<LessonResponse> getLessonById({
    required String lessonId,
    String userId = ApiConstants.defaultUserId,
  }) async {
    final response = await _dio.get(
      ApiConstants.lessonById(lessonId),
      queryParameters: {'user_id': userId},
    );
    final data = _extractData(response.data);
    return LessonResponse.fromJson(data);
  }

  /// Submit answer for a step
  Future<AnswerResponse> submitAnswer({
    required String lessonId,
    required AnswerRequest request,
    String userId = ApiConstants.defaultUserId,
  }) async {
    final response = await _dio.post(
      ApiConstants.lessonAnswer(lessonId),
      data: request.toJson(),
      queryParameters: {'user_id': userId},
    );
    final data = _extractData(response.data);
    return AnswerResponse.fromJson(data);
  }

  /// Complete the lesson
  Future<LessonCompleteResponse> completeLesson({
    required String lessonId,
    String userId = ApiConstants.defaultUserId,
    String? completedAt,
  }) async {
    final payload = <String, dynamic>{};
    if (completedAt != null) {
      payload['completed_at'] = completedAt;
    }

    final response = await _dio.post(
      ApiConstants.lessonComplete(lessonId),
      data: payload,
      queryParameters: {'user_id': userId},
    );
    final data = _extractData(response.data);
    return LessonCompleteResponse.fromJson(data);
  }

  /// Extract `data` field from envelope `{ ok: true, data: {...} }`
  Map<String, dynamic> _extractData(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      final data = responseData['data'];
      if (data is Map<String, dynamic>) return data;
      return responseData;
    }
    throw FormatException('Unexpected response format: $responseData');
  }
}
