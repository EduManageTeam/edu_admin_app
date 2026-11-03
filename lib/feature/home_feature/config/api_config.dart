/// The one place for the API address.
///
/// The address is NOT a secret (every app must contain it). Do not put
/// passwords, tokens or database keys in this file.
class ApiConfig {
  // true  = use the Render server
  // false = use your own local Laravel (php artisan serve)
  static const bool useRender = true;

  static const String renderUrl = 'https://edu-api-7c7t.onrender.com';

  // Android emulator reaches your PC through 10.0.2.2
  static const String localUrl = 'http://10.0.2.2:8000';

  static String get baseUrl => useRender ? renderUrl : localUrl;

  static const String apiPrefix = '/api';

  // Render free servers can take about a minute to wake up
  static const Duration timeout = Duration(seconds: 60);
}
