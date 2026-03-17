import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/api_constants.dart';
import 'api_exception.dart';

/// Configured Dio instance
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (error, handler) {
        handler.next(error.toApiException());
      },
    ),
  );

  return dio;
});

extension _DioErrorMapper on DioException {
  DioException toApiException() {
    final data = response?.data;
    if (data is Map<String, dynamic>) {
      final detail = data['detail'];
      String? code;
      String? message;

      if (detail is Map<String, dynamic>) {
        code = detail['code'] as String?;
        message = detail['message'] as String?;
      } else if (detail is String) {
        message = detail;
      }

      if (code != null || message != null) {
        return DioException(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: ApiException(
            statusCode: response?.statusCode ?? 0,
            code: code ?? 'UNKNOWN',
            message: message ?? 'Unknown error',
          ),
        );
      }
    }
    return this;
  }
}
