import 'dart:async';
import 'dart:convert';

import 'package:edu_admin/feature/home_feature/config/api_config.dart';
import 'package:edu_admin/feature/teacher_screen/model/teacher_model.dart';
import 'package:edu_admin/feature/teacher_screen/model/teacher_response_model.dart';
import 'package:edu_admin/feature/teacher_screen/service/exceptions/teacher_api_exception.dart';
import 'package:http/http.dart' as http;

class TeacherService {
  final String token;

  TeacherService({required this.token}) {
    if (token.trim().isEmpty) {
      throw ArgumentError('Authentication token is required');
    }
  }

  String get baseUrl => '${ApiConfig.baseUrl}/teachers';

  Map<String, String> get headers => {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  // DECODE JSON
  Map<String, dynamic> _decodeJson(String body) {
    try {
      final decoded = jsonDecode(body);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {
      // Handle
    }

    throw const TeacherApiException('Invalid response from server.');
  }

  // check api reponse
  void _checkResponse(http.Response response) {
    final status = response.statusCode;

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
        throw const TeacherApiException('Teacher not found.', statusCode: 404);

      case 422:
        final json = _decodeJson(response.body);
        final rawErrors = json['errors'];

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

  // send request
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

  // search, filter, statistic
  Future<TeacherResponse> getTeachers({
    String search = '',
    String status = 'all',
  }) async {
    final searchText = search.trim();

    // validate text
    if (searchText.length > 100) {
      throw ArgumentError('Search cannot exceed 100 characters');
    }

    // validate filter
    if (!['all', 'active', 'inactive'].contains(status)) {
      throw ArgumentError('Invalid teacher status');
    }

    // query parameter
    final query = <String, String>{};

    if (searchText.isNotEmpty) {
      query['search'] = searchText;
    }

    if (status != 'all') {
      query['status'] = status;
    }

    final uri = Uri.parse(baseUrl)
        .replace(queryParameters: query.isEmpty ? null : query);

    // send api request
    final response = await _request(() => http.get(uri, headers: headers));

    final json = _decodeJson(response.body);

    try {
      return TeacherResponse.fromJson(json);
    } catch (_) {
      throw const TeacherApiException('Unable to read teacher information.');
    }
  }

  // get all teachers
  Future<List<TeacherModel>> getAllTeacher() async {
    final response = await getTeachers();
    return response.teachers;
  }

  // add
  Future<TeacherModel> addTeacher(TeacherModel teacher) async {
    final response = await _request(
      () => http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: jsonEncode(teacher.toJson()),
      ),
    );

    final json = _decodeJson(response.body);

    try {
      return TeacherModel.fromJson(
        Map<String, dynamic>.from(json['data'] ?? json),
      );
    } catch (_) {
      throw const TeacherApiException(
        'Teacher may have been created, but the response is invalid.',
      );
    }
  }

  // update
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

  // delete
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
