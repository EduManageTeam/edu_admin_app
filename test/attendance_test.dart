import 'dart:async';
import 'dart:convert';

import 'package:edu_admin/feature/school_screen/model/attendance_model.dart';
import 'package:edu_admin/feature/school_screen/service/attendance_service.dart';
import 'package:edu_admin/feature/school_screen/service/exceptions/school_api_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('AttendanceModel - Pure Calculation Tests', () {
    final sampleRecords = [
      const AttendanceRecord(
        id: 1,
        studentId: 1,
        classId: 1,
        date: '2026-11-02T00:00:00.000000Z',
        status: 'present',
      ),
      const AttendanceRecord(
        id: 2,
        studentId: 2,
        classId: 1,
        date: '2026-11-02T00:00:00.000000Z',
        status: 'absent',
      ),
      const AttendanceRecord(
        id: 3,
        studentId: 3,
        classId: 1,
        date: '2026-11-02T00:00:00.000000Z',
        status: 'late',
      ),
      const AttendanceRecord(
        id: 4,
        studentId: 4,
        classId: 1,
        date: '2026-11-02T00:00:00.000000Z',
        status: 'permission',
      ),
      const AttendanceRecord(
        id: 5,
        studentId: 5,
        classId: 2,
        date: '2026-11-02T00:00:00.000000Z',
        status: 'present',
      ),
      // Different date
      const AttendanceRecord(
        id: 6,
        studentId: 1,
        classId: 1,
        date: '2026-10-23T00:00:00.000000Z',
        status: 'present',
      ),
      const AttendanceRecord(
        id: 7,
        studentId: 2,
        classId: 1,
        date: '2026-10-23T00:00:00.000000Z',
        status: 'absent',
      ),
    ];

    test('filterByDate returns only records matching the date prefix', () {
      final nov2 = filterByDate(sampleRecords, '2026-11-02');
      expect(nov2.length, 5);

      final oct23 = filterByDate(sampleRecords, '2026-10-23');
      expect(oct23.length, 2);

      final noMatch = filterByDate(sampleRecords, '2026-12-25');
      expect(noMatch, isEmpty);
    });

    test('computeSummary counts each status correctly', () {
      final filtered = filterByDate(sampleRecords, '2026-11-02');
      final summary = computeSummary(filtered, '2026-11-02');

      expect(summary.present, 2);
      expect(summary.absent, 1);
      expect(summary.late, 1);
      expect(summary.permission, 1);
      expect(summary.unknown, 0);
      expect(summary.recordedTotal, 5);
    });

    test('computeSummary tracks distinct student IDs', () {
      final filtered = filterByDate(sampleRecords, '2026-11-02');
      final summary = computeSummary(filtered, '2026-11-02');

      expect(summary.distinctStudents, 5); // students 1-5
    });

    test('Records from different dates are excluded from summary', () {
      final filtered = filterByDate(sampleRecords, '2026-10-23');
      final summary = computeSummary(filtered, '2026-10-23');

      expect(summary.present, 1);
      expect(summary.absent, 1);
      expect(summary.late, 0);
      expect(summary.permission, 0);
      expect(summary.recordedTotal, 2);
      expect(summary.distinctStudents, 2); // students 1, 2
    });

    test('ISO-8601 date prefix matching uses first 10 characters', () {
      const record = AttendanceRecord(
        id: 99,
        studentId: 1,
        classId: 1,
        date: '2026-11-02T00:00:00.000000Z',
        status: 'present',
      );
      expect(record.datePrefix, '2026-11-02');

      final noMatch = filterByDate([record], '2026-11-0');
      expect(noMatch, isEmpty);

      final exactMatch = filterByDate([record], '2026-11-02');
      expect(exactMatch.length, 1);
    });

    test('Empty records yield zero counts and null rate', () {
      final summary = computeSummary([], '2026-11-02');

      expect(summary.present, 0);
      expect(summary.absent, 0);
      expect(summary.late, 0);
      expect(summary.permission, 0);
      expect(summary.unknown, 0);
      expect(summary.recordedTotal, 0);
      expect(summary.distinctStudents, 0);
      expect(summary.presentRate, isNull);
      expect(summary.presentRateText, '—');
    });

    test('Unknown statuses are counted separately and not dropped', () {
      final records = [
        const AttendanceRecord(
          id: 1,
          studentId: 1,
          classId: 1,
          date: '2026-11-02T00:00:00Z',
          status: 'present',
        ),
        const AttendanceRecord(
          id: 2,
          studentId: 2,
          classId: 1,
          date: '2026-11-02T00:00:00Z',
          status: 'excused',
        ),
        const AttendanceRecord(
          id: 3,
          studentId: 3,
          classId: 1,
          date: '2026-11-02T00:00:00Z',
          status: 'sick',
        ),
      ];

      final summary = computeSummary(records, '2026-11-02');

      expect(summary.present, 1);
      expect(summary.unknown, 2);
      expect(summary.recordedTotal, 3);
    });

    test('presentRate calculates correctly with safe zero-division', () {
      final filtered = filterByDate(sampleRecords, '2026-11-02');
      final summary = computeSummary(filtered, '2026-11-02');

      expect(summary.presentRate, 40.0);
      expect(summary.presentRateText, '40%');
    });

    test('presentRateText shows one decimal for non-whole percentages', () {
      final records = [
        const AttendanceRecord(
          id: 1,
          studentId: 1,
          classId: 1,
          date: '2026-11-02T00:00:00Z',
          status: 'present',
        ),
        const AttendanceRecord(
          id: 2,
          studentId: 2,
          classId: 1,
          date: '2026-11-02T00:00:00Z',
          status: 'absent',
        ),
        const AttendanceRecord(
          id: 3,
          studentId: 3,
          classId: 1,
          date: '2026-11-02T00:00:00Z',
          status: 'absent',
        ),
      ];
      final summary = computeSummary(records, '2026-11-02');

      expect(summary.presentRate, closeTo(33.33, 0.01));
      expect(summary.presentRateText, '33.3%');
    });
  });

  group('Attendance Date Selector Consistency Tests', () {
    final historicalRecords = [
      const AttendanceRecord(
        id: 1,
        studentId: 1,
        classId: 1,
        date: '2026-10-23T00:00:00.000000Z',
        status: 'present',
      ),
      const AttendanceRecord(
        id: 2,
        studentId: 2,
        classId: 1,
        date: '2026-11-02T00:00:00.000000Z',
        status: 'present',
      ),
    ];

    test('availableDates includes today even when today has no records', () {
      const today = '2026-11-03';
      final dates = availableDates(historicalRecords, todayPrefix: today);

      expect(dates, contains(today));
      expect(dates, contains('2026-11-02'));
      expect(dates, contains('2026-10-23'));
      // Sorted descending: newest first
      expect(dates.first, today);
    });

    test('availableDates includes today when record list is completely empty', () {
      const today = '2026-11-03';
      final dates = availableDates([], todayPrefix: today);

      expect(dates, [today]);
    });

    test('Selected date and summary consistency: today has no records while older date does', () {
      const today = '2026-11-03';
      final dates = availableDates(historicalRecords, todayPrefix: today);
      expect(dates, contains(today));

      // 1. When today is selected: empty summary is computed
      final todaySummary = computeSummary(
        filterByDate(historicalRecords, today),
        today,
      );
      expect(todaySummary.datePrefix, today);
      expect(todaySummary.recordedTotal, 0);
      expect(todaySummary.presentRate, isNull);
      expect(todaySummary.presentRateText, '—');

      // 2. When historical date is selected: summary is derived exclusively from that date
      const historicalDate = '2026-11-02';
      final historicalSummary = computeSummary(
        filterByDate(historicalRecords, historicalDate),
        historicalDate,
      );
      expect(historicalSummary.datePrefix, historicalDate);
      expect(historicalSummary.recordedTotal, 1);
      expect(historicalSummary.present, 1);
      expect(historicalSummary.presentRate, 100.0);
      expect(historicalSummary.presentRateText, '100%');
    });

    test('Date prefix avoids timezone shift by preserving ISO-8601 calendar date', () {
      const record = AttendanceRecord(
        id: 10,
        studentId: 5,
        classId: 1,
        date: '2026-11-02T00:00:00.000000Z',
        status: 'present',
      );
      expect(record.datePrefix, '2026-11-02');
    });
  });

  group('AttendanceModel - Deserialization & Malformed Response Tests', () {
    test('AttendanceRecord.fromJson parses verified API payload', () {
      final json = {
        'id': 1,
        'student_id': 1,
        'class_id': 1,
        'date': '2026-11-02T00:00:00.000000Z',
        'status': 'present',
        'remark': null,
      };

      final record = AttendanceRecord.fromJson(json);

      expect(record.id, 1);
      expect(record.studentId, 1);
      expect(record.classId, 1);
      expect(record.date, '2026-11-02T00:00:00.000000Z');
      expect(record.status, 'present');
      expect(record.remark, isNull);
      expect(record.datePrefix, '2026-11-02');
    });

    test('AttendanceRecord.fromJson normalizes status to lowercase', () {
      final json = {
        'id': 2,
        'student_id': 2,
        'class_id': 1,
        'date': '2026-11-02T00:00:00.000000Z',
        'status': 'ABSENT',
      };

      final record = AttendanceRecord.fromJson(json);
      expect(record.status, 'absent');
    });

    test('AttendanceResponse.fromJson parses valid payload with records', () {
      final json = {
        'data': [
          {
            'id': 1,
            'student_id': 1,
            'class_id': 1,
            'date': '2026-11-02T00:00:00.000000Z',
            'status': 'present',
          },
          {
            'id': 2,
            'student_id': 2,
            'class_id': 1,
            'date': '2026-11-02T00:00:00.000000Z',
            'status': 'absent',
          },
        ],
        'total': 11,
      };

      final response = AttendanceResponse.fromJson(json);

      expect(response.data.length, 2);
      expect(response.total, 11);
      expect(response.data[0].status, 'present');
      expect(response.data[1].status, 'absent');
    });

    test('AttendanceResponse.fromJson preserves genuine empty list as valid empty state', () {
      final json = {'data': [], 'total': 0};

      final response = AttendanceResponse.fromJson(json);
      expect(response.data, isEmpty);
      expect(response.total, 0);
    });

    test('AttendanceResponse.fromJson throws FormatException when "data" is missing', () {
      final json = {'total': 0, 'message': 'Success'};

      expect(
        () => AttendanceResponse.fromJson(json),
        throwsA(isA<FormatException>()),
      );
    });

    test('AttendanceResponse.fromJson throws FormatException when "data" is not a list', () {
      final json = {'data': 'not a list', 'total': 0};

      expect(
        () => AttendanceResponse.fromJson(json),
        throwsA(isA<FormatException>()),
      );
    });

    test('AttendanceResponse.fromJson throws FormatException when record item is not an object', () {
      final json = {
        'data': ['invalid item'],
        'total': 1,
      };

      expect(
        () => AttendanceResponse.fromJson(json),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('AttendanceService - Real Injected HTTP Client Tests', () {
    const testToken = 'valid-test-bearer-token';

    test('AttendanceService constructor throws ArgumentError when token is empty', () {
      expect(
        () => AttendanceService(token: ''),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => AttendanceService(token: '   '),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('getAttendance successfully fetches and parses attendance records', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, contains('/attendance'));
        expect(request.headers['Authorization'], 'Bearer $testToken');
        expect(request.headers['Accept'], 'application/json');

        return http.Response(
          jsonEncode({
            'data': [
              {
                'id': 1,
                'student_id': 10,
                'class_id': 2,
                'date': '2026-11-02T00:00:00.000000Z',
                'status': 'present',
              },
            ],
            'total': 1,
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = AttendanceService(token: testToken, client: mockClient);
      final response = await service.getAttendance();

      expect(response.data.length, 1);
      expect(response.total, 1);
      expect(response.data.first.status, 'present');
      expect(response.data.first.studentId, 10);
    });

    test('getAttendance successfully parses empty data list as valid empty state', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({'data': [], 'total': 0}),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = AttendanceService(token: testToken, client: mockClient);
      final response = await service.getAttendance();

      expect(response.data, isEmpty);
      expect(response.total, 0);
    });

    test('getAttendance throws SchoolApiException when "data" is missing from 200 response', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({'error': 'Unexpected error', 'total': 0}),
          200,
        );
      });

      final service = AttendanceService(token: testToken, client: mockClient);
      expect(
        () => service.getAttendance(),
        throwsA(isA<SchoolApiException>()),
      );
    });

    test('getAttendance throws SchoolApiException when "data" is not a list in 200 response', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({'data': 'not-a-list', 'total': 0}),
          200,
        );
      });

      final service = AttendanceService(token: testToken, client: mockClient);
      expect(
        () => service.getAttendance(),
        throwsA(isA<SchoolApiException>()),
      );
    });

    test('getAttendance throws SchoolApiException on malformed non-JSON body', () async {
      final mockClient = MockClient((request) async {
        return http.Response('<html>502 Bad Gateway</html>', 200);
      });

      final service = AttendanceService(token: testToken, client: mockClient);
      expect(
        () => service.getAttendance(),
        throwsA(
          predicate<SchoolApiException>(
            (e) => e.message.contains('Invalid response format'),
          ),
        ),
      );
    });

    test('getAttendance throws SchoolApiException with 401 on unauthenticated response', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({'message': 'Unauthenticated'}),
          401,
        );
      });

      final service = AttendanceService(token: testToken, client: mockClient);
      expect(
        () => service.getAttendance(),
        throwsA(
          predicate<SchoolApiException>(
            (e) => e.statusCode == 401 && e.message.contains('session has expired'),
          ),
        ),
      );
    });

    test('getAttendance throws SchoolApiException with 403 on forbidden response', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({'message': 'Forbidden'}),
          403,
        );
      });

      final service = AttendanceService(token: testToken, client: mockClient);
      expect(
        () => service.getAttendance(),
        throwsA(
          predicate<SchoolApiException>(
            (e) => e.statusCode == 403 && e.message.contains('do not have permission'),
          ),
        ),
      );
    });

    test('getAttendance throws SchoolApiException with 429 on rate limit exceeded', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({'message': 'Too Many Requests'}),
          429,
        );
      });

      final service = AttendanceService(token: testToken, client: mockClient);
      expect(
        () => service.getAttendance(),
        throwsA(
          predicate<SchoolApiException>(
            (e) => e.statusCode == 429 && e.message.contains('Too many requests'),
          ),
        ),
      );
    });

    test('getAttendance throws SchoolApiException with 500 on server error', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({'message': 'Internal Server Error'}),
          500,
        );
      });

      final service = AttendanceService(token: testToken, client: mockClient);
      expect(
        () => service.getAttendance(),
        throwsA(
          predicate<SchoolApiException>(
            (e) => e.statusCode == 500 && e.message.contains('Server error'),
          ),
        ),
      );
    });

    test('getAttendance throws SchoolApiException on network connection failure', () async {
      final mockClient = MockClient((request) async {
        throw http.ClientException('Connection failed');
      });

      final service = AttendanceService(token: testToken, client: mockClient);
      expect(
        () => service.getAttendance(),
        throwsA(
          predicate<SchoolApiException>(
            (e) => e.message.contains('Unable to connect to the server'),
          ),
        ),
      );
    });

    test('getAttendance throws SchoolApiException on network timeout', () async {
      final mockClient = MockClient((request) async {
        throw TimeoutException('Request timed out');
      });

      final service = AttendanceService(token: testToken, client: mockClient);
      expect(
        () => service.getAttendance(),
        throwsA(
          predicate<SchoolApiException>(
            (e) => e.message.contains('Connection timed out'),
          ),
        ),
      );
    });
  });

  group('AttendanceModel - Utility Functions', () {
    test('formatDateForDisplay formats ISO date correctly', () {
      expect(formatDateForDisplay('2026-11-02'), '2 Nov 2026');
      expect(formatDateForDisplay('2026-01-15'), '15 Jan 2026');
      expect(formatDateForDisplay('2026-10-23'), '23 Oct 2026');
    });

    test('formatDateForDisplay falls back to raw string on bad input', () {
      expect(formatDateForDisplay('invalid'), 'invalid');
      expect(formatDateForDisplay(''), '');
    });

    test('AttendanceSummary.empty constructor produces zeroed summary', () {
      const summary = AttendanceSummary.empty(datePrefix: '2026-11-02');

      expect(summary.present, 0);
      expect(summary.absent, 0);
      expect(summary.late, 0);
      expect(summary.permission, 0);
      expect(summary.unknown, 0);
      expect(summary.recordedTotal, 0);
      expect(summary.presentRate, isNull);
      expect(summary.presentRateText, '—');
      expect(summary.distinctStudents, 0);
      expect(summary.datePrefix, '2026-11-02');
    });
  });
}
