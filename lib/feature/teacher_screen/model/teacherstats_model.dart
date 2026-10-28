class TeacherStats {
  final int assigned;
  final int onDuty;
  final int onLeave;

  const TeacherStats({
    required this.assigned,
    required this.onDuty,
    required this.onLeave,
  });

  factory TeacherStats.fromJson(Map<String, dynamic> json) {
    return TeacherStats(
      assigned: (json['assigned'] as num).toInt(),
      onDuty: (json['on_duty'] as num).toInt(),
      onLeave: (json['on_leave'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'assigned': assigned, 'on_duty': onDuty, 'on_leave': onLeave};
  }
}
