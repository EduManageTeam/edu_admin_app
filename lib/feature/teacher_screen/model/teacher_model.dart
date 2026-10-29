// teacher model
class TeacherModel {
  final int id;
  final String name;
  final String gender;
  final String phone;
  final String? email;
  final String address;
  final String? photo;
  final String status;

  TeacherModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.phone,
    this.email,
    required this.address,
    this.photo,
    required this.status,
  });

  // CONVERT API JSON TO TEACHER MODEL
  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: int.parse(json['id'].toString()),
      name: json['name']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString(),
      address: json['address']?.toString() ?? '',
      photo: json['photo']?.toString(),
      status: json['status']?.toString() ?? 'active',
    );
  }

  // CONVERT TEACHER MODEL TO JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'phone': phone,
      'email': email,
      'address': address,
      'photo': photo,
      'status': status,
    };
  }
}
// teacher detial model
class TeacherDetailModel {
  final TeacherModel teacher;
  final String? loginId;
  final DateTime? joinedAt;
  final int classesCount;
  final int studentsCount;
  final List<TeacherClassModel> classes;

  const TeacherDetailModel({
    required this.teacher,
    this.loginId,
    this.joinedAt,
    required this.classesCount,
    required this.studentsCount,
    required this.classes,
  });

  factory TeacherDetailModel.fromJson(Map<String, dynamic> json) {
    final rawClasses = json['classes'];

    return TeacherDetailModel(
      teacher: TeacherModel.fromJson(json),
      loginId: json['login_id']?.toString(),
      joinedAt: DateTime.tryParse(json['joined_at']?.toString() ?? ''),
      classesCount: int.tryParse('${json['classes_count']}') ?? 0,
      studentsCount: int.tryParse('${json['students_count']}') ?? 0,
      classes: rawClasses is List
          ? rawClasses
                .map(
                  (item) => TeacherClassModel.fromJson(
                    Map<String, dynamic>.from(item as Map),
                  ),
                )
                .toList()
          : [],
    );
  }
}

// Assigned class information
class TeacherClassModel {
  final int id;
  final String name;
  final String grade;
  final String room;
  final int studentsCount;

  const TeacherClassModel({
    required this.id,
    required this.name,
    required this.grade,
    required this.room,
    required this.studentsCount,
  });

  factory TeacherClassModel.fromJson(Map<String, dynamic> json) {
    return TeacherClassModel(
      id: int.tryParse('${json['id']}') ?? 0,
      name: json['name']?.toString() ?? '',
      grade: json['grade']?.toString() ?? '',
      room: json['room']?.toString() ?? '',
      studentsCount: int.tryParse('${json['students_count']}') ?? 0,
    );
  }
}
