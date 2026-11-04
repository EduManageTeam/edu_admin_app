import 'package:edu_admin/feature/school_screen/model/class_model.dart';
import 'package:edu_admin/feature/school_screen/model/info_item.dart';
import 'package:edu_admin/feature/school_screen/view/assigned_teacher_detail_screen.dart';
import 'package:edu_admin/feature/school_screen/view/attendance_overview_screen.dart';
import 'package:edu_admin/feature/school_screen/view/room_assignment_screen.dart';
import 'package:edu_admin/feature/school_screen/view/scores_overview_screen.dart';
import 'package:edu_admin/feature/school_screen/view/subjects_screen.dart';
import 'package:edu_admin/feature/school_screen/widget/info_tile.dart';
import 'package:edu_admin/feature/school_screen/widget/screen_header.dart';
import 'package:edu_admin/feature/school_screen/widget/status_chip.dart';
import 'package:edu_admin/feature/student_screen/view/class_students_screen.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

// This screen receives the class it should show.
// The School screen passes the tapped ClassModel here.
class ClassDetailScreen extends StatelessWidget {
  final ClassModel item;

  const ClassDetailScreen({super.key, required this.item});

  // NAVIGATION helper: open any screen on top of this one.
  void _open(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final teacher = item.teacher;
    final teacherName = teacher != null && teacher.name.trim().isNotEmpty
        ? teacher.name
        : 'No teacher assigned';
    final roomName = item.room != null && item.room!.trim().isNotEmpty
        ? item.room!
        : 'No room assigned';
    final gradeText = item.formattedGrade;

    return Scaffold(
      backgroundColor: ColorSystem.appBG,
      body: Column(
        children: [
          ScreenHeader(
            title: item.name,
            subtitle: 'Class overview',
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
                // 1. Student roster
                InfoTile(
                  item: InfoItem(
                    title: 'Student roster',
                    subtitle: '$gradeText roster',
                  ),
                  onTap: () => _open(
                    context,
                    ClassStudentsScreen(
                      classId: item.id,
                      className: item.name,
                      grade: item.grade,
                    ),
                  ),
                ),
                // 2. Subjects catalog
                InfoTile(
                  item: const InfoItem(
                    title: 'Subjects',
                    subtitle: 'School-wide subject catalog',
                  ),
                  onTap: () =>
                      _open(context, const SubjectsScreen(showBack: true)),
                ),
                // 3. Assigned Teacher
                InfoTile(
                  item: InfoItem(
                    title: 'Assigned Teacher',
                    subtitle: teacherName,
                  ),
                  onTap: () => _open(
                    context,
                    AssignedTeacherDetailScreen(
                      teacher: teacher,
                      className: item.name,
                    ),
                  ),
                ),
                // 4. Room Assignment
                InfoTile(
                  item: InfoItem(
                    title: 'Room Assignment',
                    subtitle: roomName,
                  ),
                  onTap: () => _open(
                    context,
                    RoomAssignmentScreen(
                      className: item.name,
                      room: item.room,
                    ),
                  ),
                ),
                // 5. Attendance Overview
                InfoTile(
                  item: const InfoItem(
                    title: 'Attendance',
                    subtitle: 'School-wide attendance overview',
                  ),
                  onTap: () => _open(
                    context,
                    const AttendanceOverviewScreen(showBack: true),
                  ),
                ),
                // 6. Scores Overview
                InfoTile(
                  item: const InfoItem(
                    title: 'Scores',
                    subtitle: 'School-wide academic performance',
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

  // Hero card with class name, grade badge, room, teacher and separate inactive status
  Widget _buildHeroCard() {
    final teacher = item.teacher;
    final teacherName = teacher != null && teacher.name.trim().isNotEmpty
        ? teacher.name
        : 'Unassigned';
    final isTeacherInactive = teacher?.isInactive ?? false;
    final gradeText = item.formattedGrade;

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
              // Grade badge always remains visible
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: ColorSystem.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ColorSystem.border),
                ),
                child: Text(
                  gradeText,
                  style: TextStyle(
                    color: ColorSystem.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          // Separate inactive teacher warning (does not replace grade badge)
          if (isTeacherInactive) ...[
            const SizedBox(height: 8),
            StatusChip(
              label: 'Teacher Inactive',
              color: ColorSystem.warning,
            ),
          ],
          const SizedBox(height: 10),
          Text(
            'Teacher: $teacherName',
            style: TextStyle(color: ColorSystem.muted, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            'Room: ${item.room != null && item.room!.trim().isNotEmpty ? item.room! : '—'}',
            style: TextStyle(color: ColorSystem.muted, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
