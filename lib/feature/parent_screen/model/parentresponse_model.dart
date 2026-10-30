import 'package:edu_admin/feature/parent_screen/model/parent_model.dart';
import 'package:edu_admin/feature/parent_screen/model/parentstat_model.dart';

class ParentResponse {
  final List<ParentModel> parents;
  final ParentStats stats;

  const ParentResponse({required this.parents, required this.stats});

  factory ParentResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final rawStats = json['stats'];

    final parents = rawData is List
        ? rawData.map((item) {
            return ParentModel.fromJson(Map<String, dynamic>.from(item as Map));
          }).toList()
        : <ParentModel>[];

    // Count parents with linked children
    final linked = parents.where((e) => e.childrenCount > 0).length;

    return ParentResponse(
      parents: parents,
      stats: rawStats is Map
          ? ParentStats.fromJson(Map<String, dynamic>.from(rawStats))
          : ParentStats(
              total: parents.length,
              linked: linked,
              unlinked: parents.length - linked,
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': parents.map((parent) => parent.toJson()).toList(),
      'stats': stats.toJson(),
    };
  }
  
}
