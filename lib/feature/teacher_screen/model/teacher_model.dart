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

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: int.parse('id'),
      name: json['name']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      photo: json['photo']?.toString() ?? '',
      status: json['status']?.toString() ?? 'active',
    );
  }

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
