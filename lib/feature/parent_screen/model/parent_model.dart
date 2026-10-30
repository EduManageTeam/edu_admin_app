class ParentModel {
  final int id;
  final String name;
  final String gender;
  final String phone;
  final String? email;
  final String address;
  final String? photo;
  final int childrenCount;

  const ParentModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.phone,
    this.email,
    required this.address,
    this.photo,
    this.childrenCount = 0,
  });

  factory ParentModel.fromJson(Map<String, dynamic> json) {
    return ParentModel(
      id: int.tryParse('${json['id']}') ?? 0,
      name: json['name']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString(),
      address: json['address']?.toString() ?? '',
      photo: json['photo']?.toString(),
      childrenCount: int.tryParse('${json['children_count']}') ?? 0,
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
      'children_count': childrenCount,
    };
  }
}

// Parent detail model
class ParentDetailModel {
  final ParentModel parent;
  final String? loginId;
  final DateTime? joinedAt;
  final int childrenCount;
  final int classesCount;
  final List<ParentChildModel> children;

  const ParentDetailModel({
    required this.parent,
    this.loginId,
    this.joinedAt,
    required this.childrenCount,
    required this.classesCount,
    required this.children,
  });


  factory ParentDetailModel.fromJson(Map<String, dynamic> json) {
    final rawChildren = json['children'];

    return ParentDetailModel(
      parent: ParentModel.fromJson(json),
      loginId: json['login_id']?.toString(),
      joinedAt: DateTime.tryParse(json['joined_at']?.toString() ?? ''),
      childrenCount: int.tryParse('${json['children_count']}') ?? 0,
      classesCount: int.tryParse('${json['classes_count']}') ?? 0,
      children: rawChildren is List
          ? rawChildren.map((item) {
              return ParentChildModel.fromJson(
                Map<String, dynamic>.from(item as Map),
              );
            }).toList()
          : [],
    );
  }
}

// Linked child information
class ParentChildModel {
  final int id;
  final String name;
  final String gender;
  final String? photo;
  final String status;
  final ParentChildClassModel? studentClass;

  const ParentChildModel({
    required this.id,
    required this.name,
    required this.gender,
    this.photo,
    required this.status,
    this.studentClass,
  });


  factory ParentChildModel.fromJson(Map<String, dynamic> json) {
    final rawClass = json['class'];

    return ParentChildModel(
      id: int.tryParse('${json['id']}') ?? 0,
      name: json['name']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      photo: json['photo']?.toString(),
      status: json['status']?.toString() ?? '',
      studentClass: rawClass is Map
          ? ParentChildClassModel.fromJson(Map<String, dynamic>.from(rawClass))
          : null,
    );
  }
}

class ParentChildClassModel {
  final int id;
  final String name;
  final String grade;
  final String room;

  const ParentChildClassModel({
    required this.id,
    required this.name,
    required this.grade,
    required this.room,
  });

  factory ParentChildClassModel.fromJson(Map<String, dynamic> json) {
    return ParentChildClassModel(
      id: int.tryParse('${json['id']}') ?? 0,
      name: json['name']?.toString() ?? '',
      grade: json['grade']?.toString() ?? '',
      room: json['room']?.toString() ?? '',
    );
  }
}