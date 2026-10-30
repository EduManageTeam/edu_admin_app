import 'dart:async';
import 'dart:convert';

import 'package:edu_admin/feature/home_feature/config/api_config.dart';
import 'package:edu_admin/feature/teacher_screen/model/teacher_model.dart';
import 'package:edu_admin/feature/teacher_screen/model/teacher_response_model.dart';
import 'package:edu_admin/feature/teacher_screen/service/exceptions/teacher_api_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class TeacherService {
  final String token;

  TeacherService({required this.token}) {
    if (token.trim().isEmpty) {
      throw ArgumentError('Authentication token is required');
    }
  }

  // API URL
  String get baseUrl => '${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/teachers';

  // Headers
  Map<String, String> get headers => {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  // Decode JSON
  Map<String, dynamic> _decodeJson(String body) {
    try {
      final decoded = jsonDecode(body);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (error) {
      debugPrint('TEACHER API JSON ERROR: $error');
    }

    throw const TeacherApiException('Invalid response from server.');
  }

  // Check response
  void _checkResponse(http.Response response) {
    final status = response.statusCode;

    debugPrint('TEACHER API HTTP: $status');

    if (status >= 200 && status < 300) {
      return;
    }

    switch (status) {
      case 401:
        throw const TeacherApiException(
          'Your session has expired. Please log in again.',
          statusCode: 401,
        );

      case 403:
        throw const TeacherApiException(
          'You do not have permission.',
          statusCode: 403,
        );

      case 404:
        throw const TeacherApiException(
          'Teacher endpoint not found or teacher does not exist.',
          statusCode: 404,
        );

      case 422:
        Map<String, dynamic> body;

        try {
          body = _decodeJson(response.body);
        } on TeacherApiException {
          body = {};
        }

        final rawErrors = body['errors'];

        throw TeacherApiException(
          'Please check the entered information.',
          statusCode: 422,
          errors: rawErrors is Map ? Map<String, dynamic>.from(rawErrors) : {},
        );

      case 429:
        throw const TeacherApiException(
          'Too many requests. Please try again later.',
          statusCode: 429,
        );

      default:
        throw TeacherApiException(
          status >= 500
              ? 'Server error. Please try again later.'
              : 'Request failed. Please try again.',
          statusCode: status,
        );
    }
  }

  // Send request
  Future<http.Response> _request(
    Future<http.Response> Function() action,
  ) async {
    try {
      final response = await action().timeout(ApiConfig.timeout);

      _checkResponse(response);

      return response;
    } on TeacherApiException {
      rethrow;
    } on TimeoutException {
      throw const TeacherApiException(
        'Connection timed out. Please try again.',
      );
    } on http.ClientException {
      throw const TeacherApiException('Unable to connect to the server.');
    }
  }

  // Calculate statistics
  Map<String, dynamic> _calculateStats(List<dynamic> data) {
    int onDuty = 0;
    int onLeave = 0;

    for (final item in data) {
      if (item is! Map) continue;

      final status = item['status']?.toString().trim().toLowerCase() ?? '';

      if (status == 'active') {
        onDuty++;
      } else if (status == 'inactive') {
        onLeave++;
      }
    }

    return {'assigned': data.length, 'on_duty': onDuty, 'on_leave': onLeave};
  }

  // Get all teachers
  Future<TeacherResponse> getTeachers({
    String search = '',
    String status = 'all',
  }) async {
    final uri = Uri.parse(baseUrl);

    debugPrint('TEACHER API: ${ApiConfig.useRender ? "Render" : "Local"}');
    debugPrint('TEACHER API GET: $uri');

    final response = await _request(() => http.get(uri, headers: headers));

    final json = _decodeJson(response.body);

    // Make sure data is a list
    final rawData = json['data'];

    if (rawData is! List) {
      debugPrint('TEACHER API INVALID DATA: ${json.keys.toList()}');

      throw const TeacherApiException('Server did not return a teacher list.');
    }

    // Calculate statistics
    final calculatedStats = _calculateStats(rawData);

    // Use local API stats when available
    if (!ApiConfig.useRender && json['stats'] is Map) {
      debugPrint('TEACHER API: Using local statistics');
    } else {
      json['stats'] = calculatedStats;

      debugPrint('TEACHER API: Using calculated statistics');
    }

    debugPrint('TEACHER API: Loaded ${rawData.length} teachers');

    try {
      return TeacherResponse.fromJson(json);
    } catch (error, stackTrace) {
      debugPrint('TEACHER PARSING ERROR: $error');
      debugPrintStack(stackTrace: stackTrace);

      throw const TeacherApiException('Unable to read teacher information.');
    }
  }

  // get all teacher details info in on API request
  Future<List<TeacherDetailModel>> getAllTeacherDetails() async {
    final response = await _request(
      () => http.get(Uri.parse(baseUrl), headers: headers),
    );

    final json = _decodeJson(response.body);

    // Laravel returns teachers inside "data"
    final data = json['data'];

    if (data is! List) {
      throw const TeacherApiException('Invalid teacher list response');
    }

    // Convert all teachers into full detail models
    return data.map((item) {
      return TeacherDetailModel.fromJson(
        Map<String, dynamic>.from(item as Map),
      );
    }).toList();
  }

  // Get teacher list
  Future<List<TeacherModel>> getAllTeacher() async {
    final response = await getTeachers();

    return response.teachers;
  }

  // Get teacher profile by ID
  Future<TeacherDetailModel> getTeacherById(int id) async {
    if (id <= 0) {
      throw ArgumentError('Invalid teacher ID');
    }

    final uri = Uri.parse('$baseUrl/$id');

    debugPrint('TEACHER PROFILE GET: $uri');

    final response = await _request(() => http.get(uri, headers: headers));

    final json = _decodeJson(response.body);

    final rawData = json['data'];

    if (rawData is! Map) {
      throw const TeacherApiException(
        'Server did not return teacher profile information.',
      );
    }

    try {
      final teacherDetail = TeacherDetailModel.fromJson(
        Map<String, dynamic>.from(rawData),
      );

      debugPrint('TEACHER PROFILE: Loaded teacher ID $id');

      return teacherDetail;
    } catch (error, stackTrace) {
      debugPrint('TEACHER PROFILE PARSING ERROR: $error');
      debugPrintStack(stackTrace: stackTrace);

      throw const TeacherApiException(
        'Unable to read teacher profile information.',
      );
    }
  }

  // Add teacher

  // Add teacher
  Future<TeacherModel> addTeacher(TeacherModel teacher) async {
    final response = await _request(
      () => http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: jsonEncode({
          'name': teacher.name,
          'gender': teacher.gender,
          'phone': teacher.phone.trim().isEmpty ? null : teacher.phone.trim(),
          'email': teacher.email,
          'address': teacher.address.trim().isEmpty
              ? null
              : teacher.address.trim(),
          'photo': teacher.photo,
          'status': teacher.status,
        }),
      ),
    );

    // Debug Laravel response
    debugPrint('ADD TEACHER STATUS: ${response.statusCode}');
    debugPrint('ADD TEACHER BODY: ${response.body}');

    final decoded = _decodeJson(response.body);

    final teacherData = decoded['data'];

    if (teacherData is! Map) {
      throw TeacherApiException(
        'Teacher API returned an unexpected response: ${response.body}',
      );
    }

    try {
      return TeacherModel.fromJson(Map<String, dynamic>.from(teacherData));
    } catch (error, stackTrace) {
      debugPrint('TEACHER MODEL ERROR: $error');
      debugPrintStack(stackTrace: stackTrace);

      rethrow;
    }
  }

  // Update teacher
  Future<TeacherModel> updateTeacher(
    int id,
    Map<String, dynamic> updateFields,
  ) async {
    if (id <= 0) {
      throw ArgumentError('Invalid teacher ID');
    }

    final response = await _request(
      () => http.patch(
        Uri.parse('$baseUrl/$id'),
        headers: headers,
        body: jsonEncode(updateFields),
      ),
    );

    final json = _decodeJson(response.body);

    try {
      return TeacherModel.fromJson(
        Map<String, dynamic>.from(json['data'] ?? json),
      );
    } catch (_) {
      throw const TeacherApiException(
        'Teacher may have been updated, but the response is invalid.',
      );
    }
  }

  // Reset teacher password
  Future<void> resetTeacherPassword({
    required int teacherId,
    required String password,
    required String confirmPassword,
  }) async {
    if (teacherId <= 0) {
      throw ArgumentError('Invalid teacher ID');
    }

    if (password.length < 8) {
      throw const TeacherApiException(
        'Password must be at least 8 characters.',
      );
    }

    if (password != confirmPassword) {
      throw const TeacherApiException('Passwords do not match.');
    }

    final uri = Uri.parse('$baseUrl/$teacherId/reset-password');

    debugPrint('TEACHER PASSWORD RESET: Teacher ID $teacherId');

    await _request(
      () => http.patch(
        uri,
        headers: headers,
        body: jsonEncode({
          'password': password,
          'password_confirmation': confirmPassword,
        }),
      ),
    );

    debugPrint('TEACHER PASSWORD RESET: Successfully updated');
  }

  // Delete teacher
  Future<bool> deleteTeacher(int id) async {
    if (id <= 0) {
      throw ArgumentError('Invalid teacher ID');
    }

    await _request(
      () => http.delete(Uri.parse('$baseUrl/$id'), headers: headers),
    );

    return true;
  }
}
