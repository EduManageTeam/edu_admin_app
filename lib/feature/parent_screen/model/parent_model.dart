class ParentModel {
  final int id;
  final String name;
  final String gender;
  final String phone;
  final String? email;
  final String address;
  final String? photo;

  const ParentModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.phone,
    this.email,
    required this.address,
    this.photo,
  });

  factory ParentModel.fromJson(Map<String, dynamic> json) {
    return ParentModel(
      id: int.parse(json['id']),
      name: json['name']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      photo: json['photo']?.toString(),
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
    };
  }
}
