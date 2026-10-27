import 'dart:async';

import 'package:edu_admin/feature/teacher_screen/model/teacher_model.dart';
import 'package:edu_admin/feature/teacher_screen/service/teacher_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeacherNotifier extends AsyncNotifier<List<TeacherModel>> {
  final TeacherService service = TeacherService();

  @override
  Future<List<TeacherModel>> build() async {
    return await service.getAllTeacher();
  }

  // reload all teacher data
  Future<void> loading() async {
    state = AsyncLoading();
    // auto catches errors & turn it to AsynError state
    state = await AsyncValue.guard(() => service.getAllTeacher());
  }

  // add new teacher
  Future<void> addTeacher(TeacherModel teacher) async {
    state = const AsyncLoading();
    final newTeacher = await service.addTeacher(teacher);

    if (newTeacher != null) {
      // Success: Refresh the list from the database
      await loading();
    } else {
      await loading();
      throw Exception("Failed to add teacher. Please try again.");
    }
  }

  // update teacher
  Future<void> updateTeacher(int id, TeacherModel teacher) async {
    state = const AsyncLoading();
    final updatedTeacher = await service.updateTeacher(id, teacher.toJson());

    if (updatedTeacher != null) {
      await loading(); // Success
    } else {
      await loading();
      throw Exception("Failed to update teacher. Please try again."); // Failure
    }
  }

  // delete teacher
  Future<void> deleteTeacher(int id) async {
    state = const AsyncLoading();
    final success = await service.deleteTeacher(id);

    if (success) {
      await loading(); // Success
    } else {
      await loading();
      throw Exception(
        "Failed to delete teacher. They may have already been removed.",
      ); // Failure
    }
  }
}

final teacherProvider =
    AsyncNotifierProvider<TeacherNotifier, List<TeacherModel>>(
      TeacherNotifier.new,
    );
