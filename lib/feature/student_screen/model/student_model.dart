class StudentModel {
  final int id;
  final String name;
  final String gender;
  final String dateOfBirth;
  final String phone;
  final String address;
  final String? photo;
  final int? classId;
  final int? parentId;
  final String status;

  const StudentModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.dateOfBirth,
    required this.phone,
    required this.address,
    this.photo,
    this.classId,
    this.parentId,
    required this.status,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: int.parse(json['id'].toString()),
      name: json['name']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      dateOfBirth: json['date_of_birth']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      photo: json['photo']?.toString(),
      classId: json['class_id'] == null
          ? null
          : int.parse(json['class_id'].toString()),
      parentId: json['parent_id'] == null
          ? null
          : int.parse(json['parent_id'].toString()),
      status: json['status']?.toString() ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'phone': phone,
      'address': address,
      'photo': photo,
      'class_id': classId,
      'parent_id': parentId,
      'status': status,
    };
  }
}
