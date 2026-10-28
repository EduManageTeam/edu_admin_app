import 'dart:convert';

import 'package:edu_admin/feature/home_feature/config/api_config.dart';
import 'package:http/http.dart' as http;
import '../model/dashboard_stats.dart';
import 'auth_service.dart';

class DashboardService {
  /// GET one endpoint with the saved token and return the decoded JSON.
  /// Throws a clear error if the server reports a problem.
  static Future<dynamic> _get(String path, String token) async {
    final response = await http
        .get(
          Uri.parse('${ApiConfig.baseUrl}${ApiConfig.apiPrefix}$path'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(ApiConfig.timeout);

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
      throw Exception('$path: ${body['message'] ?? 'error ${body['status']}'}');
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

    // ---- Attendance: count today's records by status ----
    final records = _list('/attendance', attendance);
    final today = DateTime.now().toIso8601String().substring(0, 10);

    // If the records have a "date" field, only use today's records.
    final hasDate = records.any((e) => e is Map && e['date'] != null);
    final todays = hasDate
        ? records
              .where((e) => e is Map && e['date'].toString().startsWith(today))
              .toList()
        : records;

    int present = 0, absent = 0, late = 0, permission = 0;
    final absentList = <AbsentRecord>[];
    for (final r in todays) {
      if (r is! Map) continue;
      final status = (r['status'] ?? '').toString().toLowerCase();
      if (status.contains('present')) {
        present++;
      } else if (status.contains('absent')) {
        absent++;
        absentList.add(_toAbsentRecord(r));
      } else if (status.contains('late')) {
        late++;
      } else if (status.contains('permission') || status.contains('excused')) {
        permission++;
      }
    }

    return DashboardStats(
      students: _count('/students', students),
      teachers: _count('/teachers', teachers),
      parents: _count('/parents', parents),
      classes: _count('/classes', classes),
      present: present,
      absent: absent,
      late: late,
      permission: permission,
      absentList: absentList,
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
    final note = _text(r['reason'] ?? r['note'] ?? r['remark'] ?? r['remarks']);

    return AbsentRecord(
      name: name.isEmpty ? 'Student #${_text(r['student_id'])}' : name,
      className: className,
      note: note,
    );
  }
}
