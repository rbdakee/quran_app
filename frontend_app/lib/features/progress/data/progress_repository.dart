import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/models/models.dart';

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepository(ref.watch(dioProvider));
});

class ProgressRepository {
  final Dio _dio;

  const ProgressRepository(this._dio);

  /// Get progress summary
  Future<ProgressSummary> getSummary({
    String userId = ApiConstants.defaultUserId,
  }) async {
    final response = await _dio.get(
      ApiConstants.progressSummary,
      queryParameters: {'user_id': userId},
    );
    return ProgressSummary.fromJson(_extractData(response.data));
  }

  /// Get engagement stats
  Future<EngagementSummary> getEngagement({
    String userId = ApiConstants.defaultUserId,
  }) async {
    final response = await _dio.get(
      ApiConstants.engagement,
      queryParameters: {'user_id': userId},
    );
    return EngagementSummary.fromJson(_extractData(response.data));
  }

  Map<String, dynamic> _extractData(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      final data = responseData['data'];
      if (data is Map<String, dynamic>) return data;
      return responseData;
    }
    throw FormatException('Unexpected response format: $responseData');
  }
}
