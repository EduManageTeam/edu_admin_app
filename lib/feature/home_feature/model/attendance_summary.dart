/// Attendance of ONE day.
class DailyAttendance {
  final DateTime date;
  final int present;
  final int absent;
  final int late;
  final int permission;

  const DailyAttendance({
    required this.date,
    required this.present,
    required this.absent,
    required this.late,
    required this.permission,
  });

  int get total => present + absent + late + permission;

  double get presentRatio => total == 0 ? 0 : present / total;
}

/// Attendance of ALL days together.
class AttendanceSummary {
  final int present;
  final int absent;
  final int late;
  final int permission;

  /// One entry per day, oldest first.
  final List<DailyAttendance> daily;

  const AttendanceSummary({
    required this.present,
    required this.absent,
    required this.late,
    required this.permission,
    required this.daily,
  });

  int get total => present + absent + late + permission;

  /// 0.0 to 1.0
  double ratioOf(int value) => total == 0 ? 0 : value / total;

  double get presentRatio => ratioOf(present);
}
