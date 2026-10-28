import 'package:edu_admin/feature/home_feature/service/auth_service.dart';
import 'package:edu_admin/feature/teacher_screen/model/teacher_model.dart';
import 'package:edu_admin/feature/teacher_screen/model/teacher_response_model.dart';
import 'package:edu_admin/feature/teacher_screen/service/teacher_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Authentication token state
final authTokenProvider = FutureProvider<String?>((ref) async {
  return await AuthService.getToken();
});

// Teacher service provider
final teacherServiceProvider = FutureProvider<TeacherService>((ref) async {
  final token = await ref.watch(authTokenProvider.future);

  if (token == null || token.trim().isEmpty) {
    throw StateError('Admin is not logged in');
  }

  return TeacherService(token: token);
});

// Search state
final teacherSearchProvider = StateProvider<String>((ref) => '');

// Status filter state
final teacherStatusProvider = StateProvider<String>((ref) => 'all');

class TeacherNotifier extends AsyncNotifier<TeacherResponse> {
  Future<TeacherService> get service => ref.read(teacherServiceProvider.future);
  // get all, search, filter, statistic
  @override
  Future<TeacherResponse> build() async {
    final search = ref.watch(teacherSearchProvider);
    final status = ref.watch(teacherStatusProvider);

    final teacherService = await ref.watch(teacherServiceProvider.future);

    return teacherService.getTeachers(search: search, status: status);
  }

  // reload all teacher
  Future<void> loading() async {
    ref.invalidateSelf();
    await future;
  }

  // add 
  Future<void> addTeacher(TeacherModel teacher) async {
    final teacherService = await service;

    await teacherService.addTeacher(teacher);

    ref.invalidateSelf();
  }

  // update
  Future<void> updateTeacher(int id, TeacherModel teacher) async {
    final teacherService = await service;

    await teacherService.updateTeacher(id, teacher.toJson());

    ref.invalidateSelf();
  }

  // delete
  Future<void> deleteTeacher(int id) async {
    final teacherService = await service;

    await teacherService.deleteTeacher(id);

    ref.invalidateSelf();
  }
}


// Teacher state provider
final teacherProvider = AsyncNotifierProvider<TeacherNotifier, TeacherResponse>(
  TeacherNotifier.new,
);