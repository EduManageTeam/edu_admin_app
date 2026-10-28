/// One student who is absent today (shown in the details screen).
class AbsentRecord {
  final String name;
  final String className;
  final String note;

  const AbsentRecord({
    required this.name,
    required this.className,
    required this.note,
  });
}

/// The numbers shown on the dashboard.
class DashboardStats {
  final int students;
  final int teachers;
  final int parents;
  final int classes;

  // Today's attendance
  final int present;
  final int absent;
  final int late;
  final int permission;

  // Who is absent today
  final List<AbsentRecord> absentList;

  const DashboardStats({
    required this.students,
    required this.teachers,
    required this.parents,
    required this.classes,
    required this.present,
    required this.absent,
    required this.late,
    required this.permission,
    required this.absentList,
  });

  int get attendanceTotal => present + absent + late + permission;

  /// 0.0 to 1.0
  double get presentRatio =>
      attendanceTotal == 0 ? 0 : present / attendanceTotal;
}
