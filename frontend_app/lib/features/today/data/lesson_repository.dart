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

  /// Load next lesson (Duolingo-like: no daily limit, invalidates any incomplete lesson)
  Future<LessonResponse> getNextLesson({
    String userId = ApiConstants.defaultUserId,
    int? seed,
  }) async {
    final response = await _dio.get(
      ApiConstants.lessonNext,
      queryParameters: {
        'user_id': userId,
        if (seed != null) 'seed': seed,
      },
    );
    final data = _extractData(response.data);
    return LessonResponse.fromJson(data);
  }

  /// Load lesson by ID (active lesson created by backend)
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
    final response = await _dio.post(
      ApiConstants.lessonComplete(lessonId),
      data: {
        if (completedAt != null) 'completed_at': completedAt,
      },
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
