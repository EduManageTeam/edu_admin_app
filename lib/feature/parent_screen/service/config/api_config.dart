class ApiConfig {
  static const String localUrl =
      "http://10.0.2.2:8000/api";

  static const String hostedUrl =
      "https://edu-api-7c7t.onrender.com/api";

  // Change this while developing
  static const bool useLocal = true;

  static String get baseUrl =>
      useLocal ? localUrl : hostedUrl;
}
