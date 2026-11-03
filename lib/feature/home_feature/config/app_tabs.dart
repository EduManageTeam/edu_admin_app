import 'package:flutter/foundation.dart';

/// Which tab of the bottom navigation bar is open.
/// Any screen can change the tab with:  AppTabs.goTo(AppTabs.students)
class AppTabs {
  // Same order as the bar: Home, Students, People, School, More
  static const int home = 0;
  static const int students = 1;
  static const int people = 2;
  static const int school = 3;
  static const int more = 4;

  /// The tab that is open now. MainScreen listens to this.
  static final ValueNotifier<int> current = ValueNotifier<int>(home);

  static void goTo(int tab) => current.value = tab;
}
