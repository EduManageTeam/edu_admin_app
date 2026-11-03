import 'package:edu_admin/feature/profile_screen/view/profile_screen.dart';
import 'package:edu_admin/feature/school_screen/view/school_screen.dart';
import 'package:edu_admin/feature/student_screen/view/student_screen.dart';
import 'package:edu_admin/feature/people_screen/view/people_screen.dart';
import 'package:flutter/material.dart';
import 'package:edu_admin/feature/home_feature/config/app_tabs.dart';
import 'package:edu_admin/widget/app_bottom_nav.dart';
import 'package:edu_admin/feature/home_feature/view/dashboard_screen.dart';

/// The screen that holds the bottom navigation bar.
/// Each tab shows one page. Tapping a tab switches the page.
/// Any screen can also switch the tab with: AppTabs.goTo(AppTabs.students)
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // One page per tab, in the same order as the bar.
  final List<Widget> _pages = const [
    DashboardScreen(), // Home
    StudentScreen(), // Students
    PeopleScreen(), // People (Teachers / Parents switcher)
    SchoolScreen(), // School
    ProfileScreen(), // More
  ];

  @override
  void initState() {
    super.initState();
    AppTabs.goTo(AppTabs.home); // always start on Home after login
  }

  @override
  Widget build(BuildContext context) {
    // Rebuilds when AppTabs.current changes (bar tap or dashboard card tap)
    return ValueListenableBuilder<int>(
      valueListenable: AppTabs.current,
      builder: (context, index, _) {
        return Scaffold(
          // IndexedStack keeps each page alive when you switch tabs
          body: IndexedStack(index: index, children: _pages),
          bottomNavigationBar: AppBottomNav(
            currentIndex: index,
            onTap: AppTabs.goTo,
          ),
        );
      },
    );
  }
}
