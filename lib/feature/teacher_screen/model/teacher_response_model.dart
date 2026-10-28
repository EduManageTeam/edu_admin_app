import 'package:edu_admin/feature/teacher_screen/model/teacher_model.dart';
import 'package:edu_admin/feature/teacher_screen/model/teacherstats_model.dart';

class TeacherResponse {
  final List<TeacherModel> teachers;
  final TeacherStats stats;

  const TeacherResponse({required this.teachers, required this.stats});

  factory TeacherResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final statsData = json['stats'];

    if (data is! List || statsData is! Map) {
      throw const FormatException('Invalid teacher API response');
    }

    return TeacherResponse(
      teachers: data.map((item) {
        return TeacherModel.fromJson(Map<String, dynamic>.from(item as Map));
      }).toList(),

      stats: TeacherStats.fromJson(Map<String, dynamic>.from(statsData)),
    );
  }
}
