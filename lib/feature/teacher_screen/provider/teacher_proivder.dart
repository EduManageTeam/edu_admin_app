import 'package:edu_admin/feature/home_feature/service/auth_service.dart';
import 'package:edu_admin/feature/teacher_screen/model/teacher_model.dart';
import 'package:edu_admin/feature/teacher_screen/model/teacher_response_model.dart';
import 'package:edu_admin/feature/teacher_screen/model/teacherstats_model.dart';
import 'package:edu_admin/feature/teacher_screen/service/teacher_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Authentication token
final authTokenProvider = FutureProvider<String?>(
  (ref) => AuthService.getToken(),
);

// Teacher service
final teacherServiceProvider = FutureProvider<TeacherService>((ref) async {
  final token = await ref.watch(authTokenProvider.future);

  if (token == null || token.trim().isEmpty) {
    throw StateError('Admin is not logged in');
  }

  return TeacherService(token: token);
});

// Search teachers
final teacherSearchProvider = StateProvider<String>((ref) => '');

// Filter teachers
final teacherStatusProvider = StateProvider<String>((ref) => 'all');

// Get all teachers
final teacherAllProvider = FutureProvider<TeacherResponse>((ref) async {
  final teacherService = await ref.watch(teacherServiceProvider.future);

  return teacherService.getTeachers();
});

// Get teacher profile by ID
final teacherDetailProvider = FutureProvider.family<TeacherDetailModel, int>((
  ref,
  teacherId,
) async {
  final teacherService = await ref.watch(teacherServiceProvider.future);

  return teacherService.getTeacherById(teacherId);
});

// Teacher notifier
class TeacherNotifier extends AsyncNotifier<TeacherResponse> {
  Future<TeacherService> get service => ref.read(teacherServiceProvider.future);

  @override
  Future<TeacherResponse> build() async {
    final search = ref.watch(teacherSearchProvider);
    final status = ref.watch(teacherStatusProvider);

    final response = await ref.watch(teacherAllProvider.future);

    final keyword = search.trim().toLowerCase();

    // Filter teachers locally
    final teachers = response.teachers.where((teacher) {
      final matchesSearch =
          keyword.isEmpty ||
          teacher.name.toLowerCase().contains(keyword) ||
          teacher.phone.toLowerCase().contains(keyword) ||
          teacher.id.toString() == keyword;

      final matchesStatus =
          status == 'all' || teacher.status.trim().toLowerCase() == status;

      return matchesSearch && matchesStatus;
    }).toList();

    // Calculate filtered statistics
    final stats = TeacherStats(
      assigned: teachers.length,
      onDuty: teachers
          .where((teacher) => teacher.status.trim().toLowerCase() == 'active')
          .length,
      onLeave: teachers
          .where((teacher) => teacher.status.trim().toLowerCase() == 'inactive')
          .length,
    );

    return TeacherResponse(teachers: teachers, stats: stats);
  }

  // Refresh teacher list
  Future<void> loading() async {
    ref.invalidate(teacherAllProvider);
    ref.invalidateSelf();

    await future;
  }

  // Add teacher
  Future<void> addTeacher(TeacherModel teacher) async {
    final teacherService = await service;

    await teacherService.addTeacher(teacher);

    ref.invalidate(teacherAllProvider);
  }

  // Update teacher
  Future<void> updateTeacher(int id, TeacherModel teacher) async {
    final teacherService = await service;

    await teacherService.updateTeacher(id, {
      'name': teacher.name,
      'gender': teacher.gender,
      'phone': teacher.phone,
      'email': teacher.email,
      'address': teacher.address,
      'status': teacher.status,
    });

    ref.invalidate(teacherAllProvider);
    ref.invalidate(teacherDetailProvider(id));
  }

  // Delete teacher
  Future<void> deleteTeacher(int id) async {
    final teacherService = await service;

    await teacherService.deleteTeacher(id);

    ref.invalidate(teacherAllProvider);
    ref.invalidate(teacherDetailProvider(id));
  }

  // Reset teacher password
  Future<void> resetTeacherPassword({
    required int teacherId,
    required String password,
    required String confirmPassword,
  }) async {
    final teacherService = await service;

    await teacherService.resetTeacherPassword(
      teacherId: teacherId,
      password: password,
      confirmPassword: confirmPassword,
    );

    ref.invalidate(teacherDetailProvider(teacherId));
  }
}

// Teacher provider
final teacherProvider = AsyncNotifierProvider<TeacherNotifier, TeacherResponse>(
  TeacherNotifier.new,
);

// Add teacher form state
class AddTeacherFormState {
  final String? gender;
  final String status;
  final bool isCreating;

  const AddTeacherFormState({
    this.gender,
    this.status = 'Active',
    this.isCreating = false,
  });

  AddTeacherFormState copyWith({
    String? gender,
    String? status,
    bool? isCreating,
  }) {
    return AddTeacherFormState(
      gender: gender ?? this.gender,
      status: status ?? this.status,
      isCreating: isCreating ?? this.isCreating,
    );
  }
}

// Add teacher form notifier
class AddTeacherFormNotifier extends Notifier<AddTeacherFormState> {
  final formKey = GlobalKey<FormState>();

  final userIdController = TextEditingController(text: 'Auto assigned');

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  @override
  AddTeacherFormState build() {
    // Release form controllers when provider is disposed
    ref.onDispose(() {
      userIdController.dispose();
      nameController.dispose();
      phoneController.dispose();
      emailController.dispose();
      addressController.dispose();
    });

    return const AddTeacherFormState();
  }

  // Set gender
  void setGender(String? value) {
    state = state.copyWith(gender: value);
  }

  // Set status
  void setStatus(String? value) {
    state = state.copyWith(status: value ?? 'Active');
  }

  // Validate email
  bool isValidEmail(String value) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
  }

  // Validate phone
  bool isValidPhone(String value) {
    return RegExp(r'^[0-9+\s-]{8,15}$').hasMatch(value);
  }

  // Create teacher
  Future<void> createTeacher() async {
    if (state.isCreating) return;

    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    state = state.copyWith(isCreating: true);

    try {
      final teacher = TeacherModel(
        id: 0,
        name: nameController.text.trim(),
        gender: state.gender!.toLowerCase(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim().isEmpty
            ? null
            : emailController.text.trim(),
        address: addressController.text.trim(),
        photo: null,
        status: state.status.toLowerCase(),
      );

      await ref.read(teacherProvider.notifier).addTeacher(teacher);
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isCreating: false);
      }
    }
  }
}

// Add teacher form provider
final addTeacherFormProvider =
    NotifierProvider.autoDispose<AddTeacherFormNotifier, AddTeacherFormState>(
      AddTeacherFormNotifier.new,
    );
