import 'package:edu_admin/feature/school_screen/model/class_model.dart';

class SubjectModel {
  final int id;
  final String name;
  final String? description;
  final String? createdAt;
  final String? updatedAt;

  const SubjectModel({
    required this.id,
    required this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: int.tryParse('${json['id']}') ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class SubjectsResponse {
  final List<SubjectModel> data;
  final PaginatedMeta meta;

  const SubjectsResponse({
    required this.data,
    required this.meta,
  });

  factory SubjectsResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final rawMeta = json['meta'];
    final list = <SubjectModel>[];

    if (rawData is List) {
      for (final item in rawData) {
        if (item is Map) {
          list.add(SubjectModel.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }

    return SubjectsResponse(
      data: list,
      meta: PaginatedMeta.fromJson(
        rawMeta is Map ? Map<String, dynamic>.from(rawMeta) : null,
      ),
    );
  }
}

