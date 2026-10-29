// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:edu_admin/feature/teacher_screen/model/teacher_model.dart';
import 'package:http/http.dart' as http;

class TeacherService {
  String baseUrl = "https://edu-api-7c7t.onrender.com/api/teachers";

  // GET ALL TEACHERS
  Future<List<TeacherModel>> getAllTeacher() async {
    try {
      var response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body) as Map<String, dynamic>;
        var data = json['data'] as List? ?? [];
        return data.map((e) => TeacherModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  // ADD TEACHER
  Future<TeacherModel?> addTeacher(TeacherModel teacher) async {
    try {
      var response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(teacher.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var json = jsonDecode(response.body) as Map<String, dynamic>;
        return TeacherModel.fromJson(json['data'] ?? json);
      }
      return null;
    } catch (e) {
      print('Error adding teacher: $e');
      return null;
    }
  }

  // UPDATE TEACHER
  Future<TeacherModel?> updateTeacher(
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
        return TeacherModel.fromJson(json['data'] ?? json);
      } else if (response.statusCode == 404) {
        print("Teacher not found. The ID might be incorrect");
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

  // DELETE TEACHER
  Future<bool> deleteTeacher(int id) async {
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
        print("Teacher not found. They may have already been deleted.");
        return false;
      } else {
        print("Failed to delete teacher. Status: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Network or deletion error: $e");
      return false;
    }
  }
}
