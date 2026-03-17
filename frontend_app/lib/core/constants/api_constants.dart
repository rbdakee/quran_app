/// API configuration constants
abstract final class ApiConstants {
  static const String baseUrl = 'http://localhost:8000';
  static const String defaultUserId = 'default_user';

  // ── Endpoints ──
  static const String health = '/health';
  static const String lessonNext = '/lessons/next';
  @Deprecated('Use lessonNext instead')
  static const String lessonToday = '/lessons/today';
  static String lessonById(String lessonId) => '/lessons/$lessonId';
  static String lessonAnswer(String lessonId) => '/lessons/$lessonId/answer';
  static String lessonComplete(String lessonId) => '/lessons/$lessonId/complete';
  static const String progressSummary = '/progress/summary';
  static const String reviewsDue = '/progress/reviews-due';
  static const String reviewsWords = '/progress/reviews-words';
  static const String engagement = '/progress/engagement';

  // ── Audio ──
  static const String audioBaseUrl = 'https://audios.quranwbw.com/words';

  /// Build audio URL: `/{surah}/{audio_key}`
  /// Example: audioKey = "001_002_003.mp3", surah = 1
  ///   → https://audios.quranwbw.com/words/1/001_002_003.mp3
  static String audioUrl({required int surah, required String audioKey}) =>
      '$audioBaseUrl/$surah/$audioKey';

  // ── Timeouts ──
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
