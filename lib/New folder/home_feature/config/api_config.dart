/// The ONE place to switch between your local API and the teacher's Render API.
class ApiConfig {
  // true  = teacher's server on Render
  // false = your own Laravel on this PC (php artisan serve)
  static const bool useRender = true;

  // Local addresses:
  //  - Android emulator:  http://10.0.2.2:8000
  //  - Real phone:        http://<your-PC-IP>:8000  (php artisan serve --host=0.0.0.0)
  //  - Windows / web:     http://localhost:8000
  static const String baseUrl =
      useRender ? 'https://edu-api-7c7t.onrender.com' : 'http://10.0.2.2:8000';

  // Both local and Render use /api/login (confirmed in Postman).
  static const String apiPrefix = '/api';

  // Render free servers can take about a minute to wake up
  static const Duration timeout =
      useRender ? Duration(seconds: 60) : Duration(seconds: 15);
}
