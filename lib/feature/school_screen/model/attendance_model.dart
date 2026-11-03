// Data model and pure calculation functions for Attendance records.
//
// The API returns all attendance records without server-side date filtering.
// Date comparison uses the first 10 characters of the ISO-8601 date string
// (YYYY-MM-DD) to avoid timezone shifting issues.

class AttendanceRecord {
  final int id;
  final int studentId;
  final int classId;
  final String date;
  final String status;
  final String? remark;

  const AttendanceRecord({
    required this.id,
    required this.studentId,
    required this.classId,
    required this.date,
    required this.status,
    this.remark,
  });

  /// Returns the first 10 characters of the ISO-8601 date (YYYY-MM-DD).
  String get datePrefix => date.length >= 10 ? date.substring(0, 10) : date;

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: int.tryParse('${json['id']}') ?? 0,
      studentId: int.tryParse('${json['student_id']}') ?? 0,
      classId: int.tryParse('${json['class_id']}') ?? 0,
      date: json['date']?.toString() ?? '',
      status: json['status']?.toString().toLowerCase().trim() ?? '',
      remark: json['remark']?.toString(),
    );
  }
}

class AttendanceResponse {
  final List<AttendanceRecord> data;
  final int total;

  const AttendanceResponse({
    required this.data,
    required this.total,
  });

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('data')) {
      throw const FormatException(
        'Attendance response missing required "data" field.',
      );
    }

    final rawData = json['data'];
    if (rawData is! List) {
      throw const FormatException(
        'Attendance response "data" must be a list.',
      );
    }

    final list = <AttendanceRecord>[];
    for (final item in rawData) {
      if (item is Map) {
        list.add(
          AttendanceRecord.fromJson(Map<String, dynamic>.from(item)),
        );
      } else {
        throw const FormatException(
          'Attendance record must be an object.',
        );
      }
    }

    // Accept 'total' at top level or nested under 'meta'
    int total = list.length;
    if (json['total'] is int) {
      total = json['total'] as int;
    } else if (json['meta'] is Map) {
      final meta = json['meta'] as Map;
      if (meta['total'] is int) {
        total = meta['total'] as int;
      }
    }

    return AttendanceResponse(data: list, total: total);
  }
}

/// Summary of attendance counts for a specific date.
class AttendanceSummary {
  final String datePrefix;
  final int present;
  final int absent;
  final int late;
  final int permission;
  final int unknown;
  final int distinctStudents;

  const AttendanceSummary({
    required this.datePrefix,
    required this.present,
    required this.absent,
    required this.late,
    required this.permission,
    required this.unknown,
    required this.distinctStudents,
  });

  /// Total of all recorded statuses (present + absent + late + permission + unknown).
  int get recordedTotal => present + absent + late + permission + unknown;

  /// Present-among-recorded rate as a percentage.
  /// Returns null when there are no recorded entries (safe zero-division).
  double? get presentRate {
    final total = recordedTotal;
    if (total == 0) return null;
    return (present / total) * 100;
  }

  /// Formatted present rate string. Returns '—' when rate is null.
  String get presentRateText {
    final rate = presentRate;
    if (rate == null) return '—';
    // Show integer if whole number, otherwise one decimal place
    return rate == rate.roundToDouble()
        ? '${rate.toInt()}%'
        : '${rate.toStringAsFixed(1)}%';
  }

  /// Creates an empty summary for the given date.
  const AttendanceSummary.empty({required this.datePrefix})
      : present = 0,
        absent = 0,
        late = 0,
        permission = 0,
        unknown = 0,
        distinctStudents = 0;
}

// ── Pure calculation functions ──────────────────────────────────────────

/// Filters attendance records by date prefix (first 10 characters of ISO-8601).
List<AttendanceRecord> filterByDate(
  List<AttendanceRecord> records,
  String datePrefix,
) {
  return records.where((r) => r.datePrefix == datePrefix).toList();
}

/// Counts statuses from a list of attendance records.
/// Unknown statuses are tracked separately and never silently dropped.
AttendanceSummary computeSummary(
  List<AttendanceRecord> records,
  String datePrefix,
) {
  int present = 0;
  int absent = 0;
  int late = 0;
  int permission = 0;
  int unknown = 0;
  final studentIds = <int>{};

  for (final record in records) {
    studentIds.add(record.studentId);

    switch (record.status) {
      case 'present':
        present++;
      case 'absent':
        absent++;
      case 'late':
        late++;
      case 'permission':
        permission++;
      default:
        unknown++;
    }
  }

  return AttendanceSummary(
    datePrefix: datePrefix,
    present: present,
    absent: absent,
    late: late,
    permission: permission,
    unknown: unknown,
    distinctStudents: studentIds.length,
  );
}

/// Returns a formatted date string for display (e.g. "2 Nov 2026").
/// Falls back to the raw prefix if parsing fails.
String formatDateForDisplay(String datePrefix) {
  try {
    final date = DateTime.parse(datePrefix);
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  } catch (_) {
    return datePrefix;
  }
}

/// Returns all distinct date prefixes, ensuring [todayPrefix] (if provided)
/// is included in the list along with all distinct dates from [records].
/// Result is sorted descending (newest first) without duplicates.
List<String> availableDates(
  List<AttendanceRecord> records, {
  String? todayPrefix,
}) {
  final set = records.map((r) => r.datePrefix).toSet();
  if (todayPrefix != null && todayPrefix.trim().isNotEmpty) {
    set.add(todayPrefix.trim());
  }
  final dates = set.toList();
  dates.sort((a, b) => b.compareTo(a)); // newest first
  return dates;
}
