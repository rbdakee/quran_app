/// Structured API error
class ApiException implements Exception {
  final int statusCode;
  final String code;
  final String message;

  const ApiException({
    required this.statusCode,
    required this.code,
    required this.message,
  });

  bool get isNotFound => statusCode == 404 || code == 'NOT_FOUND';
  bool get isLessonExpired => code == 'LESSON_EXPIRED';
  bool get isValidationError => statusCode == 422 || code == 'VALIDATION_ERROR';

  @override
  String toString() => 'ApiException($statusCode, $code: $message)';
}
