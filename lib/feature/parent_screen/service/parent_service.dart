import 'dart:async';
import 'dart:convert';

import 'package:edu_admin/feature/home_feature/config/api_config.dart';
import 'package:edu_admin/feature/parent_screen/model/parent_model.dart';
import 'package:edu_admin/feature/parent_screen/service/exceptions/parent_api_exception.dart';
import 'package:http/http.dart' as http;

class ParentService {
  final String token;

  ParentService({required this.token}) {
    if (token.trim().isEmpty) {
      throw ArgumentError('Authentication token is required');
    }
  }

  String get baseUrl => "${ApiConfig.baseUrl}/parents";

  Map<String, String> get headers => {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "Authorization": "Bearer $token",
  };

  // decode json
  Map<String, dynamic> _decodeJson(String body) {
    try {
      final decoded = jsonDecode(body);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {
      // return safe error
    }

    throw const ParentApiException("Invalid response from server.");
  }

  // api response error
  void _checkResponse(http.Response response) {
    final status = response.statusCode;

    if (status >= 200 && status < 300) {
      return;
    }

    switch (status) {
      case 401:
        throw const ParentApiException(
          "Your session has expired. Please log in again.",
          statusCode: 401,
        );

      case 403:
        throw const ParentApiException(
          "You do not have permission.",
          statusCode: 403,
        );

      case 404:
        throw const ParentApiException(
          "Parent record not found.",
          statusCode: 404,
        );

      case 422:
        final json = _decodeJson(response.body);
        final rawErrors = json['errors'];

        throw ParentApiException(
          "Please check the entered information.",
          statusCode: 422,
          errors: rawErrors is Map ? Map<String, dynamic>.from(rawErrors) : {},
        );

      case 429:
        throw const ParentApiException(
          "Too many requests. Please try again later.",
          statusCode: 429,
        );

      default:
        throw ParentApiException(
          status >= 500
              ? "Server error. Please try again later."
              : "Request failed. Please try again.",
          statusCode: status,
        );
    }
  }

  // send resquest
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
      throw const ParentApiException("Connection timed out. Please try again.");
    } on http.ClientException {
      throw const ParentApiException("Unable to connect to the server.");
    }
  }

  // get all
  Future<List<ParentModel>> getAllParents() async {
    final response = await _request(
      () => http.get(Uri.parse(baseUrl), headers: headers),
    );

    final json = _decodeJson(response.body);
    final data = json['data'];

    if (data is! List) {
      throw const ParentApiException("Invalid parent list response.");
    }

    try {
      return data.map((item) {
        return ParentModel.fromJson(Map<String, dynamic>.from(item as Map));
      }).toList();
    } catch (_) {
      throw const ParentApiException("Unable to read parent information.");
    }
  }

  // create or add
  Future<ParentModel> addParent(ParentModel parent) async {
    final response = await _request(
      () => http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: jsonEncode(parent.toJson()),
      ),
    );

    final json = _decodeJson(response.body);

    try {
      return ParentModel.fromJson(
        Map<String, dynamic>.from(json['data'] ?? json),
      );
    } catch (_) {
      throw const ParentApiException(
        "Parent may have been created, but the response is invalid.",
      );
    }
  }

  // update
  Future<ParentModel> updateParent(
    int id,
    Map<String, dynamic> updateFields,
  ) async {
    if (id <= 0) {
      throw ArgumentError("Invalid parent ID");
    }

    final response = await _request(
      () => http.patch(
        Uri.parse("$baseUrl/$id"),
        headers: headers,
        body: jsonEncode(updateFields),
      ),
    );

    final json = _decodeJson(response.body);

    try {
      return ParentModel.fromJson(
        Map<String, dynamic>.from(json['data'] ?? json),
      );
    } catch (_) {
      throw const ParentApiException(
        "Parent may have been updated, but the response is invalid.",
      );
    }
  }

  // delete
  Future<bool> deleteParent(int id) async {
    if (id <= 0) {
      throw ArgumentError("Invalid parent ID");
    }

    await _request(
      () => http.delete(Uri.parse("$baseUrl/$id"), headers: headers),
    );

    return true;
  }
}
