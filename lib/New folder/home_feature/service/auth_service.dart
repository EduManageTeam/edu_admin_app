import 'dart:convert';
import 'package:edu_admin/feature/home_feature/config/api_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'token';

  /// Logs in and saves the token. Throws an Exception with a message on failure.
  static Future<String> login(String userId, String password) async {
    final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/login');

    final response = await http
        .post(
          url,
          headers: {
            'Content-Type': 'application/json',
            // Makes Laravel return JSON errors instead of an HTML redirect
            'Accept': 'application/json',
          },
          // The API's login requires "u_id" (not email)
          body: jsonEncode({'u_id': userId, 'password': password}),
        )
        .timeout(ApiConfig.timeout);

    dynamic data;
    try {
      data = jsonDecode(response.body);
    } catch (_) {
      data = null;
    }

    if (response.statusCode != 200 && response.statusCode != 201) {
      final message = (data is Map ? data['message'] : null) ??
          'Login failed (status ${response.statusCode})';
      throw Exception(message);
    }

    final token = data is Map ? data['token'] : null;
    if (token == null) {
      // Show what the server really sent, to find the problem
      final preview = response.body.length > 150
          ? response.body.substring(0, 150)
          : response.body;
      throw Exception(
        'No token in response (status ${response.statusCode}): $preview',
      );
    }

    await _storage.write(key: _tokenKey, value: token.toString());
    return token.toString();
  }

  static Future<String?> getToken() => _storage.read(key: _tokenKey);

  static Future<void> logout() => _storage.delete(key: _tokenKey);
}
