import 'package:edu_admin/feature/school_screen/model/class_item.dart';
import 'package:edu_admin/feature/school_screen/model/info_item.dart';
import 'package:edu_admin/feature/school_screen/view/attendance_overview_screen.dart';
import 'package:edu_admin/feature/school_screen/view/scores_overview_screen.dart';
import 'package:edu_admin/feature/school_screen/view/subjects_screen.dart';
import 'package:edu_admin/feature/school_screen/widget/info_tile.dart';
import 'package:edu_admin/feature/school_screen/widget/screen_header.dart';
import 'package:edu_admin/feature/school_screen/widget/status_chip.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

// This screen receives the class it should show.
// The School screen passes the tapped ClassItem here.
class ClassDetailScreen extends StatelessWidget {
  final ClassItem item;

  const ClassDetailScreen({super.key, required this.item});

  // NAVIGATION helper: open any screen on top of this one.
  void _open(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSystem.appBG,
      body: Column(
        children: [
          ScreenHeader(
            title: item.name,
            subtitle: 'Class & subject setup',
            showBack: true,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              children: [
                _buildHeroCard(),
                const SizedBox(height: 24),
                Text(
                  'Class setup',
                  style: TextStyle(
                    color: ColorSystem.lnk,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                // No onTap = tapping does nothing (no screen designed yet)
                InfoTile(
                  item: InfoItem(
                    title: 'Student roster',
                    subtitle: '${item.students} enrolled students',
                  ),
                ),
                // Opens the Subjects screen, with a back arrow
                InfoTile(
                  item: const InfoItem(
                    title: 'Subjects',
                    subtitle: '6 active subjects',
                  ),
                  onTap: () =>
                      _open(context, const SubjectsScreen(showBack: true)),
                ),
                const InfoTile(
                  item: InfoItem(
                    title: 'Teacher assignments',
                    subtitle: '4 assigned teachers',
                  ),
                ),
                const InfoTile(
                  item: InfoItem(
                    title: 'Schedule',
                    subtitle: 'Mon–Fri · 8:00–2:00',
                  ),
                ),
                // Opens the Attendance Overview screen, with a back arrow
                InfoTile(
                  item: const InfoItem(
                    title: 'Attendance',
                    subtitle: 'Today 96% present',
                  ),
                  onTap: () => _open(
                    context,
                    const AttendanceOverviewScreen(showBack: true),
                  ),
                ),
                // NEW: extra tile (not in the Figma design) so we can reach
                // the Scores Overview screen. Delete this block if the team
                // links Scores from somewhere else later.
                InfoTile(
                  item: const InfoItem(
                    title: 'Scores',
                    subtitle: 'Average 84.6',
                  ),
                  onTap: () => _open(
                    context,
                    const ScoresOverviewScreen(showBack: true),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Big pink card with the class name, status, teacher and student count
  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorSystem.light.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorSystem.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ColorSystem.lnk,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              StatusChip(label: 'Active', color: ColorSystem.success),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Homeroom · ${item.teacher}',
            style: TextStyle(color: ColorSystem.muted, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Text(
            '${item.students} enrolled students',
            style: TextStyle(color: ColorSystem.muted, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
