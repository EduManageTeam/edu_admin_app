import 'dart:async';
import 'dart:convert';

import 'package:edu_admin/feature/home_feature/config/api_config.dart';
import 'package:edu_admin/feature/school_screen/model/attendance_model.dart';
import 'package:edu_admin/feature/school_screen/service/exceptions/school_api_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Fetches attendance records from the Laravel API.
///
/// Reuses the same auth / error-handling patterns as [SchoolService]:
/// - Bearer token from [AuthService.getToken()]
/// - [ApiConfig] for base URL and timeout
/// - [SchoolApiException] for domain-specific error mapping
/// - Injectable [http.Client] for isolated, authentic unit testing
class AttendanceService {
  final String token;
  final http.Client _client;
  final bool _closeClientOnDispose;

  AttendanceService({
    required this.token,
    http.Client? client,
  })  : _client = client ?? http.Client(),
        _closeClientOnDispose = client == null {
    if (token.trim().isEmpty) {
      throw ArgumentError('Authentication token is required');
    }
  }

  void dispose() {
    if (_closeClientOnDispose) {
      _client.close();
    }
  }

  String get _attendanceUrl =>
      '${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/attendance';

  Map<String, String> get headers => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  /// Fetches all attendance records from `GET /api/attendance`.
  ///
  /// The API does not support server-side date filtering or pagination
  /// for this endpoint; it returns all historical records in one response.
  Future<AttendanceResponse> getAttendance() async {
    final uri = Uri.parse(_attendanceUrl);

    try {
      final response = await _client
          .get(uri, headers: headers)
          .timeout(ApiConfig.timeout);

      _checkResponse(response);

      final json = _decodeJson(response.body);
      try {
        return AttendanceResponse.fromJson(json);
      } on FormatException catch (e) {
        throw SchoolApiException(e.message);
      } catch (e) {
        debugPrint('ATTENDANCE PARSING ERROR: $e');
        throw const SchoolApiException('Unable to read attendance data.');
      }
    } on SchoolApiException {
      rethrow;
    } on TimeoutException {
      throw const SchoolApiException(
        'Connection timed out. Please try again.',
      );
    } on http.ClientException {
      throw const SchoolApiException('Unable to connect to the server.');
    } catch (e) {
      if (e is SchoolApiException) rethrow;
      throw SchoolApiException('Unexpected network error: $e');
    }
  }

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
      debugPrint('ATTENDANCE API JSON DECODE ERROR: $error');
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
          'You do not have permission to view attendance records.',
          statusCode: 403,
        );

      case 404:
        throw const SchoolApiException(
          'The attendance endpoint was not found.',
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
          errors:
              rawErrors is Map ? Map<String, dynamic>.from(rawErrors) : {},
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
}
