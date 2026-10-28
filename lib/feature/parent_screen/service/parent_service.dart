// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:edu_admin/feature/parent_screen/model/parent_model.dart';
import 'package:http/http.dart' as http;

class ParentService {
  String baseUrl = "https://edu-api-7c7t.onrender.com/api/parents";

  // get all
  Future<List<ParentModel>> getAllParents() async {
    try {
      var response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body) as Map<String, dynamic>;
        var data = json['data'] as List? ?? [];
        return data.map((e) => ParentModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  // add
  Future<ParentModel?> addParent(ParentModel parent) async {
    try {
      var response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(parent.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var json = jsonDecode(response.body) as Map<String, dynamic>;
        return ParentModel.fromJson(json['data'] ?? json);
      }
      return null;
    } catch (e) {
      print('Error adding parent: $e');
      return null;
    }
  }

  // update
  Future<ParentModel?> updateParent(
    int id,
    Map<String, dynamic> updateFields,
  ) async {
    try {
      var response = await http.patch(
        Uri.parse("$baseUrl/$id"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(updateFields),
      );

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body) as Map<String, dynamic>;
        return ParentModel.fromJson(json['data'] ?? json);
      } else if (response.statusCode == 404) {
        print("Parent not found. The ID might be incorrect");
        return null;
      } else if (response.statusCode == 422 || response.statusCode == 400) {
        print("Invalid data. Please check the fields and try again.");
        return null;
      } else {
        print(
          "Failed to update. Server responded with status: ${response.statusCode}",
        );
        return null;
      }
    } catch (e) {
      print("Network or update error: $e");
      return null;
    }
  }

  // delete
  Future<bool> deleteParent(int id) async {
    try {
      var response = await http.delete(
        Uri.parse("$baseUrl/$id"),
        headers: {"Accept": "application/json"},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else if (response.statusCode == 404) {
        // ignore: duplicate_ignore
        // ignore: avoid_print
        print("Parent not found. They may have already been deleted.");
        return false;
      } else {
        print("Failed to delete parent. Status: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Network or deletion error: $e");
      return false;
    }
  }
}
