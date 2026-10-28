import 'dart:convert';
import 'package:edu_admin/feature/home_feature/config/api_config.dart';
import 'package:edu_admin/feature/home_feature/service/auth_service.dart';
import 'package:edu_admin/feature/student_screen/model/student_model.dart';
import 'package:http/http.dart' as http;

class StudentService {
  static Future<List<StudentModel>> fetchStudents() async {
    final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/students');
    final token = await AuthService.getToken();

    final headers = <String, String>{
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http.get(url, headers: headers).timeout(ApiConfig.timeout);

    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      throw Exception('Invalid response from server');
    }

    if (response.statusCode == 401) {
      throw Exception('Unauthorized. Please login again.');
    }
    if (response.statusCode == 403) {
      throw Exception('Forbidden. You do not have permission to view students.');
    }
    if (response.statusCode != 200) {
      final message = decoded is Map ? decoded['message']?.toString() : null;
      throw Exception(message ?? 'Failed to fetch students (${response.statusCode})');
    }

    if (decoded is! Map || decoded['data'] == null) {
      return [];
    }

    final data = decoded['data'];
    if (data is! List) {
      return [];
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map((json) => StudentModel.fromJson(json))
        .toList();
  }

  static Future<StudentModel> createStudent(Map<String, dynamic> body) async {
    final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/students');
    final token = await AuthService.getToken();

    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http
        .post(url, headers: headers, body: jsonEncode(body))
        .timeout(ApiConfig.timeout);

    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      throw Exception('Invalid response from server');
    }

    if (response.statusCode == 401) {
      throw Exception('Unauthorized. Please login again.');
    }
    if (response.statusCode == 403) {
      throw Exception('Forbidden. You do not have permission to add students.');
    }
    if (response.statusCode == 422) {
      if (decoded is Map) {
        if (decoded['errors'] != null) {
          throw Exception(decoded['errors'].toString());
        }
        if (decoded['message'] != null) {
          throw Exception(decoded['message'].toString());
        }
      }
      throw Exception('Validation failed (${response.statusCode})');
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      final message = decoded is Map ? decoded['message']?.toString() : null;
      throw Exception(message ?? 'Failed to add student (${response.statusCode})');
    }

    if (decoded is Map && decoded['data'] is Map<String, dynamic>) {
      try {
        return StudentModel.fromJson(decoded['data'] as Map<String, dynamic>);
      } catch (_) {}
    }
    if (decoded is Map<String, dynamic>) {
      if (decoded.containsKey('id') && decoded.containsKey('name')) {
        try {
          return StudentModel.fromJson(decoded);
        } catch (_) {}
      }
      if (decoded['student'] is Map<String, dynamic>) {
        try {
          return StudentModel.fromJson(decoded['student'] as Map<String, dynamic>);
        } catch (_) {}
      }
    }

    final message = decoded is Map ? decoded['message']?.toString() : null;
    throw Exception(message ?? 'Student created (unexpected response format)');
  }

  static Future<StudentModel> updateStudent(int id, Map<String, dynamic> body) async {
    final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/students/$id');
    final token = await AuthService.getToken();

    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http
        .put(url, headers: headers, body: jsonEncode(body))
        .timeout(ApiConfig.timeout);

    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {}

    if (response.statusCode == 401) {
      throw Exception('Unauthorized. Please login again.');
    }
    if (response.statusCode == 403) {
      throw Exception('Forbidden. You do not have permission to update students.');
    }
    if (response.statusCode == 422) {
      if (decoded is Map) {
        if (decoded['errors'] != null) {
          throw Exception(decoded['errors'].toString());
        }
        if (decoded['message'] != null) {
          throw Exception(decoded['message'].toString());
        }
      }
      throw Exception('Validation failed (${response.statusCode})');
    }
    if (response.statusCode != 200) {
      final message = decoded is Map ? decoded['message']?.toString() : null;
      throw Exception(message ?? 'Failed to update student (${response.statusCode})');
    }

    if (decoded is Map && decoded['data'] is Map<String, dynamic>) {
      return StudentModel.fromJson(decoded['data'] as Map<String, dynamic>);
    }
    if (decoded is Map<String, dynamic>) {
      if (decoded.containsKey('id') && decoded.containsKey('name')) {
        return StudentModel.fromJson(decoded);
      }
      if (decoded['student'] is Map<String, dynamic>) {
        return StudentModel.fromJson(decoded['student'] as Map<String, dynamic>);
      }
    }

    throw Exception('Unexpected response while updating student');
  }

  static Future<void> deleteStudent(int id) async {
    final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/students/$id');
    final token = await AuthService.getToken();

    final headers = <String, String>{
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http.delete(url, headers: headers).timeout(ApiConfig.timeout);

    if (response.statusCode == 401) {
      throw Exception('Unauthorized. Please login again.');
    }
    if (response.statusCode == 403) {
      throw Exception('Forbidden. You do not have permission to delete students.');
    }
    if (response.statusCode != 200 && response.statusCode != 204) {
      dynamic decoded;
      try {
        decoded = jsonDecode(response.body);
      } catch (_) {}
      final message = decoded is Map ? decoded['message']?.toString() : null;
      throw Exception(message ?? 'Failed to delete student (${response.statusCode})');
    }
  }
}
