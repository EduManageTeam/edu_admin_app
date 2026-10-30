import 'dart:async';
import 'dart:convert';

import 'package:edu_admin/feature/home_feature/config/api_config.dart';
import 'package:edu_admin/feature/parent_screen/model/parent_model.dart';
import 'package:edu_admin/feature/parent_screen/model/parentresponse_model.dart';
import 'package:edu_admin/feature/parent_screen/service/exceptions/parent_api_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ParentService {
  final String token;

  ParentService({required this.token}) {
    if (token.trim().isEmpty) {
      throw ArgumentError('Authentication token is required');
    }
  }

  // API URL
  String get baseUrl => '${ApiConfig.baseUrl}${ApiConfig.apiPrefix}/parents';

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
      debugPrint('PARENT API JSON ERROR: $error');
    }

    throw const ParentApiException('Invalid response from server.');
  }

  // Check response
  void _checkResponse(http.Response response) {
    final status = response.statusCode;

    debugPrint('PARENT API HTTP: $status');

    if (status >= 200 && status < 300) {
      return;
    }

    switch (status) {
      case 401:
        throw const ParentApiException(
          'Your session has expired. Please log in again.',
          statusCode: 401,
        );

      case 403:
        throw const ParentApiException(
          'You do not have permission.',
          statusCode: 403,
        );

      case 404:
        throw const ParentApiException(
          'Parent endpoint not found or parent does not exist.',
          statusCode: 404,
        );

      case 409:
        throw const ParentApiException(
          'Cannot delete parent with linked students.',
          statusCode: 409,
        );

      case 422:
        Map<String, dynamic> body;

        try {
          body = _decodeJson(response.body);
        } on ParentApiException {
          body = {};
        }

        final rawErrors = body['errors'];

        throw ParentApiException(
          'Please check the entered information.',
          statusCode: 422,
          errors: rawErrors is Map ? Map<String, dynamic>.from(rawErrors) : {},
        );

      case 429:
        throw const ParentApiException(
          'Too many requests. Please try again later.',
          statusCode: 429,
        );

      default:
        throw ParentApiException(
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
    } on ParentApiException {
      rethrow;
    } on TimeoutException {
      throw const ParentApiException('Connection timed out. Please try again.');
    } on http.ClientException {
      throw const ParentApiException('Unable to connect to the server.');
    }
  }

  // Calculate statistics
  Map<String, int> _calculateStats(List<dynamic> data) {
    int linked = 0;
    int unlinked = 0;

    for (final item in data) {
      if (item is! Map) continue;

      final childrenCount =
          int.tryParse(
            (item['children_count'] ?? item['students_count'] ?? 0).toString(),
          ) ??
          0;

      if (childrenCount > 0) {
        linked++;
      } else {
        unlinked++;
      }
    }

    return {'total': data.length, 'linked': linked, 'unlinked': unlinked};
  }

  // Get parents with statistics, search and filter
  Future<ParentResponse> getParents({
    String search = '',
    String filter = 'all',
  }) async {
    final queryParameters = <String, String>{};

    if (search.trim().isNotEmpty) {
      queryParameters['search'] = search.trim();
    }

    if (filter == 'linked' || filter == 'unlinked') {
      queryParameters['filter'] = filter;
    }

    final uri = Uri.parse(baseUrl).replace(
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );

    debugPrint('PARENT API: ${ApiConfig.useRender ? "Render" : "Local"}');
    debugPrint('PARENT API GET: $uri');

    final response = await _request(() => http.get(uri, headers: headers));

    final json = _decodeJson(response.body);

    // Make sure data is a list
    final rawData = json['data'];

    if (rawData is! List) {
      debugPrint('PARENT API INVALID DATA: ${json.keys.toList()}');

      throw const ParentApiException('Server did not return a parent list.');
    }

    // Calculate statistics if API stats are missing
    final calculatedStats = _calculateStats(rawData);

    if (json['stats'] is Map) {
      debugPrint('PARENT API: Using API statistics');
    } else {
      json['stats'] = calculatedStats;

      debugPrint('PARENT API: Using calculated statistics');
    }

    debugPrint('PARENT API: Loaded ${rawData.length} parents');

    try {
      return ParentResponse.fromJson(json);
    } catch (error, stackTrace) {
      debugPrint('PARENT PARSING ERROR: $error');
      debugPrintStack(stackTrace: stackTrace);

      throw const ParentApiException('Unable to read parent information.');
    }
  }

  // Get all parent details in one API request
  Future<List<ParentDetailModel>> getAllParentDetails() async {
    final response = await _request(
      () => http.get(Uri.parse(baseUrl), headers: headers),
    );

    final json = _decodeJson(response.body);

    // Laravel returns parents inside "data"
    final data = json['data'];

    if (data is! List) {
      throw const ParentApiException('Invalid parent list response.');
    }

    try {
      return data.map((item) {
        return ParentDetailModel.fromJson(
          Map<String, dynamic>.from(item as Map),
        );
      }).toList();
    } catch (error, stackTrace) {
      debugPrint('PARENT DETAILS ERROR: $error');
      debugPrintStack(stackTrace: stackTrace);

      throw const ParentApiException('Unable to read parent details.');
    }
  }

  // Get parent list
  Future<List<ParentModel>> getAllParents() async {
    final response = await getParents();

    return response.parents;
  }

  // GET /api/parents/{id}
  // Get parent profile by ID
  Future<ParentDetailModel> getParentById(int id) async {
    if (id <= 0) {
      throw ArgumentError('Invalid parent ID');
    }

    final uri = Uri.parse('$baseUrl/$id');

    debugPrint('PARENT PROFILE GET: $uri');

    final response = await _request(() => http.get(uri, headers: headers));

    final json = _decodeJson(response.body);

    final rawData = json['data'];

    if (rawData is! Map) {
      throw const ParentApiException(
        'Server did not return parent profile information.',
      );
    }

    try {
      final parentDetail = ParentDetailModel.fromJson(
        Map<String, dynamic>.from(rawData),
      );

      debugPrint('PARENT PROFILE: Loaded parent ID $id');

      return parentDetail;
    } catch (error, stackTrace) {
      debugPrint('PARENT PROFILE PARSING ERROR: $error');
      debugPrintStack(stackTrace: stackTrace);

      throw const ParentApiException(
        'Unable to read parent profile information.',
      );
    }
  }

  // Create parent and user account
  Future<ParentModel> addParent(ParentModel parent) async {
    final response = await _request(
      () => http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: jsonEncode({
          'name': parent.name,
          'gender': parent.gender,
          'phone': parent.phone.trim().isEmpty ? null : parent.phone.trim(),
          'email': parent.email,
          'address': parent.address.trim().isEmpty
              ? null
              : parent.address.trim(),
          'photo': parent.photo,
        }),
      ),
    );

    debugPrint('ADD PARENT STATUS: ${response.statusCode}');

    final decoded = _decodeJson(response.body);
    final rawData = decoded['data'];

    if (rawData is! Map) {
      throw const ParentApiException(
        'Parent API returned an unexpected response.',
      );
    }

    try {
      final parentData = Map<String, dynamic>.from(rawData);

      // Laravel returns login ID separately
      if (decoded['login_id'] != null) {
        parentData['login_id'] = decoded['login_id'];
      }

      return ParentModel.fromJson(parentData);
    } catch (error, stackTrace) {
      debugPrint('PARENT MODEL ERROR: $error');
      debugPrintStack(stackTrace: stackTrace);

      throw const ParentApiException(
        'Parent may have been created, but the response is invalid.',
      );
    }
  }

  // Update parent information only
  Future<ParentModel> updateParent(
    int id,
    Map<String, dynamic> updateFields,
  ) async {
    if (id <= 0) {
      throw ArgumentError('Invalid parent ID');
    }

    // Only editable parent information
    const allowedFields = {
      'name',
      'gender',
      'phone',
      'email',
      'address',
      'photo',
    };

    final parentFields = Map<String, dynamic>.from(updateFields)
      ..removeWhere((key, value) => !allowedFields.contains(key));

    final response = await _request(
      () => http.patch(
        Uri.parse('$baseUrl/$id'),
        headers: headers,
        body: jsonEncode(parentFields),
      ),
    );

    final json = _decodeJson(response.body);

    try {
      return ParentModel.fromJson(
        Map<String, dynamic>.from(json['data'] as Map),
      );
    } catch (_) {
      throw const ParentApiException(
        'Parent may have been updated, but the response is invalid.',
      );
    }
  }

  // Admin resets parent password
  Future<void> resetParentPassword({
    required int parentId,
    required String password,
    required String confirmPassword,
  }) async {
    if (parentId <= 0) {
      throw ArgumentError('Invalid parent ID');
    }

    if (password.length < 8) {
      throw const ParentApiException('Password must be at least 8 characters.');
    }

    if (password != confirmPassword) {
      throw const ParentApiException('Passwords do not match.');
    }

    final uri = Uri.parse('$baseUrl/$parentId/reset-password');

    debugPrint('PARENT PASSWORD RESET: Parent ID $parentId');

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

    debugPrint('PARENT PASSWORD RESET: Successfully updated');
  }

  // Delete parent and linked user account
  Future<bool> deleteParent(int id) async {
    if (id <= 0) {
      throw ArgumentError('Invalid parent ID');
    }

    await _request(
      () => http.delete(Uri.parse('$baseUrl/$id'), headers: headers),
    );

    return true;
  }
}
