
import 'dart:convert';

import 'package:edu_admin/feature/home_feature/config/api_config.dart';
import 'package:edu_admin/feature/home_feature/service/auth_service.dart';
import 'package:edu_admin/feature/student_screen/model/student_model.dart';
import 'package:http/http.dart' as http;

class StudentService {
  static const String _endpoint = '/students';

  static Uri _buildUrl([String? path]) {
    final baseUrl = ApiConfig.baseUrl;
    final prefix = ApiConfig.apiPrefix;

    return Uri.parse('$baseUrl$prefix$_endpoint${path ?? ''}');
  }

  static Future<Map<String, String>> _getHeaders({
    bool withBody = false,
  }) async {
    final token = await AuthService.getToken();

    final headers = <String, String>{
      'Accept': 'application/json',
    };

    if (withBody) {
      headers['Content-Type'] = 'application/json';
    }

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  /// Decode JSON response safely.
  static dynamic _decodeResponse(http.Response response) {
    if (response.body.isEmpty) {
      return null;
    }

    try {
      return jsonDecode(response.body);
    } catch (_) {
      return null;
    }
  }

  /// Handle common HTTP errors.
  static void _handleError(
    http.Response response,
    dynamic decoded, {
    required String action,
  }) {
    final statusCode = response.statusCode;

    if (statusCode == 401) {
      throw Exception('Unauthorized. Please login again.');
    }

    if (statusCode == 403) {
      throw Exception('Forbidden. You do not have permission to $action.');
    }

    if (statusCode == 404) {
      throw Exception('Student not found.');
    }

    if (statusCode == 422) {
      if (decoded is Map) {
        final errors = decoded['errors'];

        if (errors is Map) {
          final messages = errors.values
              .expand((value) => value is List ? value : [value])
              .map((value) => value.toString())
              .join('\n');

          throw Exception(messages);
        }

        if (decoded['message'] != null) {
          throw Exception(decoded['message'].toString());
        }
      }

      throw Exception('Validation failed.');
    }

    if (statusCode >= 500) {
      throw Exception('Server error. Please try again later.');
    }

    if (statusCode < 200 || statusCode >= 300) {
      final message = decoded is Map
          ? decoded['message']?.toString()
          : null;

      throw Exception(
        message ?? 'Failed to $action. Status: $statusCode',
      );
    }
  }

  /// Extract a student object from common Laravel response formats.
  static StudentModel _parseStudent(dynamic decoded) {
    dynamic data;

    if (decoded is Map) {
      data = decoded['data'] ?? decoded['student'] ?? decoded;
    }

    if (data is! Map) {
      throw Exception('Invalid student response from server.');
    }

    try {
      return StudentModel.fromJson(
        Map<String, dynamic>.from(data),
      );
    } catch (e) {
      throw Exception('Failed to parse student data: $e');
    }
  }

  /// Encode request body as JSON.
  static String _encodeBody(Map<String, dynamic> body) {
    return jsonEncode(body);
  }

  // ==============================
  // GET: Fetch All Students
  // ==============================

  static Future<List<StudentModel>> fetchStudents() async {
    final url = _buildUrl();
    final headers = await _getHeaders();

    final response = await http
        .get(url, headers: headers)
        .timeout(ApiConfig.timeout);

    final decoded = _decodeResponse(response);

    _handleError(
      response,
      decoded,
      action: 'view students',
    );

    if (decoded is! Map) {
      throw Exception('Invalid response from server.');
    }

    final data = decoded['data'];

    if (data is! List) {
      return [];
    }

    return data
        .whereType<Map>()
        .map(
          (json) => StudentModel.fromJson(
            Map<String, dynamic>.from(json),
          ),
        )
        .toList();
  }

  // ==============================
  // POST: Create Student
  // ==============================

  static Future<StudentModel> createStudent(
    Map<String, dynamic> body,
  ) async {
    final url = _buildUrl();
    final headers = await _getHeaders(withBody: true);

    final response = await http
        .post(
          url,
          headers: headers,
          body: _encodeBody(body),
        )
        .timeout(ApiConfig.timeout);

    final decoded = _decodeResponse(response);

    _handleError(
      response,
      decoded,
      action: 'add students',
    );

    if (response.statusCode != 200 &&
        response.statusCode != 201) {
      throw Exception('Unexpected response while creating student.');
    }

    return _parseStudent(decoded);
  }

  // ==============================
  // PUT: Update Student
  // ==============================

  static Future<StudentModel> updateStudent(
    int id,
    Map<String, dynamic> body,
  ) async {
    final url = _buildUrl('/$id');
    final headers = await _getHeaders(withBody: true);

    final response = await http
        .put(
          url,
          headers: headers,
          body: _encodeBody(body),
        )
        .timeout(ApiConfig.timeout);

    final decoded = _decodeResponse(response);

    _handleError(
      response,
      decoded,
      action: 'update students',
    );

    if (response.statusCode != 200) {
      throw Exception('Unexpected response while updating student.');
    }

    return _parseStudent(decoded);
  }

  // ==============================
  // DELETE: Delete Student
  // ==============================

  static Future<void> deleteStudent(int id) async {
    final url = _buildUrl('/$id');
    final headers = await _getHeaders();

    final response = await http
        .delete(url, headers: headers)
        .timeout(ApiConfig.timeout);

    // A 204 response normally has no response body.
    if (response.statusCode == 204) {
      return;
    }

    final decoded = _decodeResponse(response);

    _handleError(
      response,
      decoded,
      action: 'delete students',
    );

    if (response.statusCode != 200) {
      throw Exception('Unexpected response while deleting student.');
    }
  }
}
