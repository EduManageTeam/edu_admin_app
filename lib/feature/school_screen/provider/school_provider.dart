import 'package:edu_admin/feature/home_feature/service/auth_service.dart';
import 'package:edu_admin/feature/school_screen/model/class_model.dart';
import 'package:edu_admin/feature/school_screen/model/subject_model.dart';
import 'package:edu_admin/feature/school_screen/service/school_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Authentication token provider
final schoolAuthTokenProvider = FutureProvider<String?>(
  (ref) => AuthService.getToken(),
);

/// School API service provider
final schoolServiceProvider = FutureProvider<SchoolService>((ref) async {
  final token = await ref.watch(schoolAuthTokenProvider.future);

  if (token == null || token.trim().isEmpty) {
    throw StateError('Admin is not logged in');
  }

  return SchoolService(token: token);
});

/// Fetches and caches the full classes response from API
final classesResponseProvider = FutureProvider<ClassesResponse>((ref) async {
  final service = await ref.watch(schoolServiceProvider.future);
  return service.getClasses();
});

/// Fetches and caches the full subjects response from API
final subjectsResponseProvider = FutureProvider<SubjectsResponse>((ref) async {
  final service = await ref.watch(schoolServiceProvider.future);
  return service.getSubjects();
});

/// Class search query provider
final classSearchProvider = StateProvider<String>((ref) => '');

/// Locally filtered classes matching search by name, grade, room, or teacher
final filteredClassesProvider = Provider<AsyncValue<List<ClassModel>>>((ref) {
  final classesAsync = ref.watch(classesResponseProvider);
  final query = ref.watch(classSearchProvider).trim().toLowerCase();

  return classesAsync.whenData((response) {
    if (query.isEmpty) {
      return response.data;
    }
    return response.data.where((cls) {
      final matchesName = cls.name.toLowerCase().contains(query);
      final matchesGrade = cls.grade.toLowerCase().contains(query);
      final matchesRoom = (cls.room ?? '').toLowerCase().contains(query);
      final matchesTeacher =
          (cls.teacher?.name ?? '').toLowerCase().contains(query);

      return matchesName || matchesGrade || matchesRoom || matchesTeacher;
    }).toList();
  });
});

/// Locally filtered subjects matching search by name or description
final filteredSubjectsProvider =
    Provider<AsyncValue<List<SubjectModel>>>((ref) {
  final subjectsAsync = ref.watch(subjectsResponseProvider);
  final query = ref.watch(classSearchProvider).trim().toLowerCase();

  return subjectsAsync.whenData((response) {
    if (query.isEmpty) {
      return response.data;
    }
    return response.data.where((subject) {
      final matchesName = subject.name.toLowerCase().contains(query);
      final matchesDesc =
          (subject.description ?? '').toLowerCase().contains(query);
      return matchesName || matchesDesc;
    }).toList();
  });
});

