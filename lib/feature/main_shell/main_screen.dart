import 'package:edu_admin/feature/profile_screen/view/profile_screen.dart';
import 'package:edu_admin/feature/school_screen/view/school_screen.dart';
import 'package:edu_admin/feature/student_screen/view/student_screen.dart';
import 'package:edu_admin/feature/teacher_screen/view/teacher_screen.dart';
import 'package:flutter/material.dart';

import '../../model/color_system.dart';
import '../../widget/app_bottom_nav.dart';
import '../home_feature/view/dashboard_screen.dart';

/// The screen that holds the bottom navigation bar.
/// Each tab shows one page. Tapping a tab switches the page.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  // One page per tab, in the same order as the bar.
  // Teammates: replace your placeholder with your real screen.
  final List<Widget> _pages = const [
    DashboardScreen(), // Home
    StudentScreen(), // Students
    TeacherScreen(), // People
    SchoolScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps each page alive when you switch tabs
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}

// Temporary page until a teammate's screen is ready
// class _ComingSoon extends StatelessWidget {
//   final String title;

//   const _ComingSoon(this.title);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorSystem.appBG,
//       body: Center(
//         child: Text(
//           '$title (coming soon)',
//           style: TextStyle(color: ColorSystem.muted),
//         ),
//       ),
//     );
//   }
// }
