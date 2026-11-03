import 'dart:async';
import 'dart:convert';

import 'package:edu_admin/feature/home_feature/config/api_config.dart';
import 'package:edu_admin/feature/school_screen/model/class_model.dart';
import 'package:edu_admin/feature/school_screen/model/subject_model.dart';
import 'package:edu_admin/feature/school_screen/service/exceptions/school_api_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class SchoolService {
  final String token;

  SchoolService({required this.token}) {
    if (token.trim().isEmpty) {
      throw ArgumentError('Authentication token is required');
    }
  }

  String get _classesBaseUrl =>
      '${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/classes';
  String get _subjectsBaseUrl =>
      '${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/subjects';

  Map<String, String> get headers => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  Map<String, dynamic> _decodeJson(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    } catch (error) {
      debugPrint('SCHOOL API JSON DECODE ERROR: $error');
    }
    throw const SchoolApiException('Invalid response format from server.');
  }

  void _checkResponse(http.Response response) {
    final status = response.statusCode;

    if (status >= 200 && status < 300) {
      return;
    }

    switch (status) {
      case 401:
        throw const SchoolApiException(
          'Your session has expired. Please log in again.',
          statusCode: 401,
        );

      case 403:
        throw const SchoolApiException(
          'You do not have permission to view this resource.',
          statusCode: 403,
        );

      case 404:
        throw const SchoolApiException(
          'The requested endpoint was not found.',
          statusCode: 404,
        );

      case 422:
        Map<String, dynamic> body = {};
        try {
          final decoded = jsonDecode(response.body);
          if (decoded is Map) {
            body = Map<String, dynamic>.from(decoded);
          }
        } catch (_) {}

        final rawErrors = body['errors'];
        throw SchoolApiException(
          'Validation error.',
          statusCode: 422,
          errors: rawErrors is Map ? Map<String, dynamic>.from(rawErrors) : {},
        );

      case 429:
        throw const SchoolApiException(
          'Too many requests. Please try again later.',
          statusCode: 429,
        );

      default:
        throw SchoolApiException(
          status >= 500
              ? 'Server error. Please try again later.'
              : 'Request failed (status $status).',
          statusCode: status,
        );
    }
  }

  Future<http.Response> _request(
    Future<http.Response> Function() action,
  ) async {
    try {
      final response = await action().timeout(ApiConfig.timeout);
      _checkResponse(response);
      return response;
    } on SchoolApiException {
      rethrow;
    } on TimeoutException {
      throw const SchoolApiException(
        'Connection timed out. Please try again.',
      );
    } on http.ClientException {
      throw const SchoolApiException('Unable to connect to the server.');
    } catch (e) {
      throw SchoolApiException('Unexpected network error: $e');
    }
  }

  /// Fetches a single page of classes using the secure HTTPS base URL.
  Future<ClassesResponse> getClassesPage({int page = 1}) async {
    final uri = Uri.parse('$_classesBaseUrl?page=$page');

    final response = await _request(() => http.get(uri, headers: headers));
    final json = _decodeJson(response.body);

    try {
      return ClassesResponse.fromJson(json);
    } catch (error, stackTrace) {
      debugPrint('CLASSES PARSING ERROR: $error');
      debugPrintStack(stackTrace: stackTrace);
      throw const SchoolApiException('Unable to read classes data.');
    }
  }

  /// Fetches classes. By default, reads meta.last_page and aggregates
  /// subsequent pages using the secure HTTPS base URL (never following HTTP links).
  Future<ClassesResponse> getClasses({bool fetchAllPages = true}) async {
    final firstPage = await getClassesPage(page: 1);

    if (!fetchAllPages || firstPage.meta.lastPage <= 1) {
      return firstPage;
    }

    final allItems = List<ClassModel>.from(firstPage.data);

    // Safely iterate through remaining pages up to lastPage (capped at 25 for safety)
    final maxPages = firstPage.meta.lastPage.clamp(1, 25);
    for (int p = 2; p <= maxPages; p++) {
      try {
        final nextPage = await getClassesPage(page: p);
        allItems.addAll(nextPage.data);
      } catch (e) {
        debugPrint('Error fetching classes page $p: $e');
        break; // Return what has been fetched so far
      }
    }

    return ClassesResponse(
      data: allItems,
      meta: firstPage.meta,
    );
  }

  /// Fetches a single page of subjects using the secure HTTPS base URL.
  Future<SubjectsResponse> getSubjectsPage({int page = 1}) async {
    final uri = Uri.parse('$_subjectsBaseUrl?page=$page');

    final response = await _request(() => http.get(uri, headers: headers));
    final json = _decodeJson(response.body);

    try {
      return SubjectsResponse.fromJson(json);
    } catch (error, stackTrace) {
      debugPrint('SUBJECTS PARSING ERROR: $error');
      debugPrintStack(stackTrace: stackTrace);
      throw const SchoolApiException('Unable to read subjects data.');
    }
  }

  /// Fetches subjects. By default, reads meta.last_page and aggregates
  /// subsequent pages using the secure HTTPS base URL.
  Future<SubjectsResponse> getSubjects({bool fetchAllPages = true}) async {
    final firstPage = await getSubjectsPage(page: 1);

    if (!fetchAllPages || firstPage.meta.lastPage <= 1) {
      return firstPage;
    }

    final allItems = List<SubjectModel>.from(firstPage.data);
    final maxPages = firstPage.meta.lastPage.clamp(1, 25);

    for (int p = 2; p <= maxPages; p++) {
      try {
        final nextPage = await getSubjectsPage(page: p);
        allItems.addAll(nextPage.data);
      } catch (e) {
        debugPrint('Error fetching subjects page $p: $e');
        break;
      }
    }

    return SubjectsResponse(
      data: allItems,
      meta: firstPage.meta,
    );
  }
}

