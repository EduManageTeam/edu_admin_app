import 'package:edu_admin/feature/school_screen/model/attendance_model.dart';
import 'package:edu_admin/feature/school_screen/provider/school_provider.dart';
import 'package:edu_admin/feature/school_screen/service/attendance_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Returns today's date prefix (YYYY-MM-DD) based on local calendar date.
String getTodayDatePrefix() {
  return DateTime.now().toIso8601String().substring(0, 10);
}

/// Service provider for attendance API calls.
/// Reuses [schoolAuthTokenProvider] from the school provider.
final attendanceServiceProvider =
    FutureProvider<AttendanceService>((ref) async {
  final token = await ref.watch(schoolAuthTokenProvider.future);

  if (token == null || token.trim().isEmpty) {
    throw StateError('Admin is not logged in');
  }

  final service = AttendanceService(token: token);
  ref.onDispose(() => service.dispose());
  return service;
});

/// Fetches and caches all attendance records from the API.
final attendanceResponseProvider =
    FutureProvider<AttendanceResponse>((ref) async {
  final service = await ref.watch(attendanceServiceProvider.future);
  return service.getAttendance();
});

/// The currently selected date for the attendance view.
/// Defaults to today's date prefix (YYYY-MM-DD).
final selectedAttendanceDateProvider = StateProvider<String>(
  (ref) => getTodayDatePrefix(),
);

/// Computed attendance summary for the selected date.
///
/// Filters all records by the selected date prefix and computes
/// present / absent / late / permission / unknown counts.
final attendanceSummaryProvider = Provider<AsyncValue<AttendanceSummary>>(
  (ref) {
    final responseAsync = ref.watch(attendanceResponseProvider);
    final selectedDate = ref.watch(selectedAttendanceDateProvider);

    return responseAsync.whenData((response) {
      final filtered = filterByDate(response.data, selectedDate);
      return computeSummary(filtered, selectedDate);
    });
  },
);

/// All available dates from the API response, plus today's date,
/// sorted newest first.
final attendanceDatesProvider = Provider<AsyncValue<List<String>>>(
  (ref) {
    final responseAsync = ref.watch(attendanceResponseProvider);
    return responseAsync.whenData((response) {
      return availableDates(response.data, todayPrefix: getTodayDatePrefix());
    });
  },
);
