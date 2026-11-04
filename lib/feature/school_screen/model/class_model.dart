class ClassTeacherModel {
  final int id;
  final int userId;
  final String name;
  final String status;

  const ClassTeacherModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.status,
  });

  bool get isInactive => status.trim().toLowerCase() == 'inactive';

  factory ClassTeacherModel.fromJson(Map<String, dynamic> json) {
    return ClassTeacherModel(
      id: int.tryParse('${json['id']}') ?? 0,
      userId: int.tryParse('${json['user_id']}') ?? 0,
      name: json['name']?.toString() ?? '',
      status: json['status']?.toString() ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'status': status,
    };
  }
}

class PaginatedMeta {
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;

  const PaginatedMeta({
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
  });

  factory PaginatedMeta.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const PaginatedMeta(
        total: 0,
        currentPage: 1,
        lastPage: 1,
        perPage: 15,
      );
    }
    return PaginatedMeta(
      total: int.tryParse('${json['total']}') ?? 0,
      currentPage: int.tryParse('${json['current_page']}') ?? 1,
      lastPage: int.tryParse('${json['last_page']}') ?? 1,
      perPage: int.tryParse('${json['per_page']}') ?? 15,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
    };
  }
}

/// Formats a raw grade string consistently across the School module.
/// Trims whitespace, eliminates duplicate "Grade" prefixes case-insensitively,
/// and falls back to "Grade —" for null or empty values.
String formatGrade(String? grade) {
  if (grade == null) return 'Grade —';
  String trimmed = grade.trim();
  if (trimmed.isEmpty) return 'Grade —';
  while (trimmed.toLowerCase().startsWith('grade')) {
    trimmed = trimmed.substring(5).trim();
  }
  if (trimmed.isEmpty) return 'Grade —';
  return 'Grade $trimmed';
}

class ClassModel {
  final int id;
  final String name;
  final String grade;
  final String? room;
  final int? teacherId;
  final ClassTeacherModel? teacher;
  final String? createdAt;
  final String? updatedAt;

  const ClassModel({
    required this.id,
    required this.name,
    required this.grade,
    this.room,
    this.teacherId,
    this.teacher,
    this.createdAt,
    this.updatedAt,
  });

  /// Formatted grade with duplicate "Grade" prevention and safe fallback.
  String get formattedGrade => formatGrade(grade);

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    final rawTeacher = json['teacher'];
    ClassTeacherModel? parsedTeacher;
    if (rawTeacher is Map<String, dynamic>) {
      parsedTeacher = ClassTeacherModel.fromJson(rawTeacher);
    } else if (rawTeacher is Map) {
      parsedTeacher = ClassTeacherModel.fromJson(
        Map<String, dynamic>.from(rawTeacher),
      );
    }

    return ClassModel(
      id: int.tryParse('${json['id']}') ?? 0,
      name: json['name']?.toString() ?? '',
      grade: json['grade']?.toString() ?? '',
      room: json['room']?.toString(),
      teacherId: json['teacher_id'] == null
          ? null
          : int.tryParse('${json['teacher_id']}'),
      teacher: parsedTeacher,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'grade': grade,
      'room': room,
      'teacher_id': teacherId,
      'teacher': teacher?.toJson(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class ClassesResponse {
  final List<ClassModel> data;
  final PaginatedMeta meta;

  const ClassesResponse({
    required this.data,
    required this.meta,
  });

  factory ClassesResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final rawMeta = json['meta'];
    final list = <ClassModel>[];

    if (rawData is List) {
      for (final item in rawData) {
        if (item is Map) {
          list.add(ClassModel.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }

    return ClassesResponse(
      data: list,
      meta: PaginatedMeta.fromJson(
        rawMeta is Map ? Map<String, dynamic>.from(rawMeta) : null,
      ),
    );
  }
}

