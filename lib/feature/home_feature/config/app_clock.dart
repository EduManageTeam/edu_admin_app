import 'dart:io' show HttpDate;

/// The app's own clock: real Cambodia time (UTC+7), not the phone's time.
///
/// Every API response has a "Date" header with the server's real time.
/// We compare it with the phone's clock and remember the difference,
/// so a wrong phone clock or wrong time zone no longer matters.
class AppClock {
  // server time minus phone time
  static Duration _offset = Duration.zero;

  static const _cambodia = Duration(hours: 7);

  /// Call this with the "date" header of any API response.
  static void syncFromHeader(String? dateHeader) {
    if (dateHeader == null) return;
    try {
      final serverUtc = HttpDate.parse(dateHeader);
      _offset = serverUtc.difference(DateTime.now().toUtc());
    } catch (_) {
      // Bad header: keep the old offset
    }
  }

  /// Current time in Cambodia. The hour / day fields are Cambodia wall-clock.
  static DateTime now() {
    return DateTime.now().toUtc().add(_offset).add(_cambodia);
  }
}
