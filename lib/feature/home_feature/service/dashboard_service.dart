import 'dart:convert';
import 'package:edu_admin/feature/home_feature/config/api_config.dart';
import 'package:edu_admin/feature/home_feature/config/app_clock.dart';
import 'package:http/http.dart' as http;

import '../model/attendance_summary.dart';
import '../model/dashboard_stats.dart';
import 'auth_service.dart';

class DashboardService {
  /// GET one endpoint with the saved token and return the decoded JSON.
  /// Throws a clear error if the server reports a problem.
  static Future<dynamic> _get(String path, String token) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}$path'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(ApiConfig.timeout);

    // Learn the real time from the server (used by the clock and "today")
    AppClock.syncFromHeader(response.headers['date']);

    if (response.statusCode == 401) {
      throw Exception('Session expired. Please sign in again.');
    }
    if (response.statusCode != 200) {
      throw Exception('Failed to load $path (status ${response.statusCode})');
    }

    final body = jsonDecode(response.body);

    // Some Laravel controllers send HTTP 200 but put the real status
    // inside the JSON, e.g. {"message": "...", "status": 500}
    if (body is Map && body['status'] is int && body['status'] != 200) {
      throw Exception(
        '$path: ${body['message'] ?? 'error ${body['status']}'}',
      );
    }
    return body;
  }

  /// The list of items in a response: either [..] or {"data": [..]}.
  /// Throws (instead of silently returning 0 items) if the shape is wrong.
  static List _list(String path, dynamic body) {
    if (body is List) return body;
    if (body is Map && body['data'] is List) return body['data'] as List;

    final text = body.toString();
    final preview = text.length > 100 ? text.substring(0, 100) : text;
    throw Exception('Unexpected response from $path: $preview');
  }

  /// Total count: uses "total" / "meta.total" when the API sends it
  /// (paginated lists), otherwise counts the items.
  static int _count(String path, dynamic body) {
    if (body is Map) {
      if (body['total'] is int) return body['total'] as int;
      final meta = body['meta'];
      if (meta is Map && meta['total'] is int) return meta['total'] as int;
    }
    return _list(path, body).length;
  }

  /// 0 = present, 1 = absent, 2 = late, 3 = permission, null = unknown
  static int? _classify(dynamic status) {
    final s = (status ?? '').toString().toLowerCase();
    if (s.contains('present')) return 0;
    if (s.contains('absent')) return 1;
    if (s.contains('late')) return 2;
    if (s.contains('permission') || s == 'excused') return 3;
    return null;
  }

  static String _two(int n) => n.toString().padLeft(2, '0');

  /// "2026-10-30"
  static String _dateKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${_two(d.month)}-${_two(d.day)}';

  static Future<DashboardStats> fetchStats() async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Not signed in. Please sign in again.');
    }

    // One after another (not at the same time) - safer for a small server
    final students = await _get('/students', token);
    final teachers = await _get('/teachers', token);
    final parents = await _get('/parents', token);
    final classes = await _get('/classes', token);
    final attendance = await _get('/attendance', token);

    // ---- Attendance ----
    final records = _list('/attendance', attendance);

    // "Today" in Cambodia, from the server's real time
    final today = _dateKey(AppClock.now());
    final hasDate = records.any((e) => e is Map && e['date'] != null);

    // Index: 0 present, 1 absent, 2 late, 3 permission
    final todayCount = [0, 0, 0, 0];
    final allCount = [0, 0, 0, 0];
    final perDay = <String, List<int>>{};
    final absentList = <AbsentRecord>[];

    for (final r in records) {
      if (r is! Map) continue;
      final kind = _classify(r['status']);
      if (kind == null) continue;

      final raw = r['date']?.toString();
      final key =
          (raw != null && raw.length >= 10) ? raw.substring(0, 10) : null;

      // All days
      allCount[kind]++;
      if (key != null) {
        perDay.putIfAbsent(key, () => [0, 0, 0, 0])[kind]++;
      }

      // Today only (if the records have no date, count everything)
      final isToday = !hasDate || key == today;
      if (isToday) {
        todayCount[kind]++;
        if (kind == 1) absentList.add(_toAbsentRecord(r));
      }
    }

    // One entry per day, oldest first
    final keys = perDay.keys.toList()..sort();
    final daily = <DailyAttendance>[];
    for (final k in keys) {
      final date = DateTime.tryParse(k);
      if (date == null) continue;
      final c = perDay[k]!;
      daily.add(DailyAttendance(
        date: date,
        present: c[0],
        absent: c[1],
        late: c[2],
        permission: c[3],
      ));
    }

    return DashboardStats(
      students: _count('/students', students),
      teachers: _count('/teachers', teachers),
      parents: _count('/parents', parents),
      classes: _count('/classes', classes),
      present: todayCount[0],
      absent: todayCount[1],
      late: todayCount[2],
      permission: todayCount[3],
      absentList: absentList,
      allAttendance: AttendanceSummary(
        present: allCount[0],
        absent: allCount[1],
        late: allCount[2],
        permission: allCount[3],
        daily: daily,
      ),
    );
  }

  static String _text(dynamic v) => v == null ? '' : v.toString();

  /// Turns one attendance record into a name / class / note.
  /// The API loads the student and class inside each record.
  static AbsentRecord _toAbsentRecord(Map r) {
    final student = r['student'];
    final schoolClass = r['school_class'] ?? r['schoolClass'] ?? r['class'];

    final name = student is Map ? _text(student['name']) : '';
    final className = schoolClass is Map ? _text(schoolClass['name']) : '';
    final note =
        _text(r['reason'] ?? r['note'] ?? r['remark'] ?? r['remarks']);

    return AbsentRecord(
      name: name.isEmpty ? 'Student #${_text(r['student_id'])}' : name,
      className: className,
      note: note,
    );
  }
}
