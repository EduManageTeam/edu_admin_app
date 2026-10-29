import 'package:edu_admin/feature/teacher_screen/model/teacher_model.dart';
import 'package:edu_admin/feature/teacher_screen/provider/teacher_proivder.dart';
import 'package:edu_admin/feature/teacher_screen/view/editteacher_screen.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/profilecard_widget.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/teacher_profile_class_row.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/teacher_profile_login_info.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/teacher_profile_section_title.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/teacher_profile_stat_card.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeacherProfileScreen extends ConsumerWidget {
  final TeacherModel teacher;

  const TeacherProfileScreen({super.key, required this.teacher});

  // Format joined date
  String _formatDate(DateTime? date) {
    if (date == null) return 'Not available';

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final local = date.toLocal();

    return '${local.day} ${months[local.month - 1]} ${local.year}';
  }

  // Teacher initials
  String _getInitials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2);

    final initials = parts.map((part) => part[0].toUpperCase()).join();

    return initials.isEmpty ? 'T' : initials;
  }

  // Profile header
  Widget _profileHeader(TeacherModel teacher) {
    final isActive = teacher.status.trim().toLowerCase() == 'active';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorSystem.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorSystem.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: ColorSystem.primary.withValues(alpha: 0.10),
                child: Text(
                  _getInitials(teacher.name),
                  style: TextStyle(
                    color: ColorSystem.primary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Positioned(
                right: 2,
                bottom: 2,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: isActive ? ColorSystem.success : ColorSystem.warning,
                    shape: BoxShape.circle,
                    border: Border.all(color: ColorSystem.surface, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  teacher.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ColorSystem.lnk,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Teacher ID #${teacher.id}',
                  style: TextStyle(color: ColorSystem.muted, fontSize: 11),
                ),
                const SizedBox(height: 9),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? ColorSystem.success.withValues(alpha: 0.10)
                        : ColorSystem.warning.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: isActive
                              ? ColorSystem.success
                              : ColorSystem.warning,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        isActive ? 'On Duty' : 'On Leave',
                        style: TextStyle(
                          color: isActive
                              ? ColorSystem.success
                              : ColorSystem.warning,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Personal information
  Widget _personalInformation(TeacherDetailModel detail) {
    final teacher = detail.teacher;

    return Column(
      children: [
        const TeacherProfileSectionTitle(
          title: 'Personal Information',
          icon: Icons.person_rounded,
        ),
        const SizedBox(height: 9),
        Container(
          decoration: cardDecoration(),
          child: Column(
            children: [
              InfoRow(
                icon: Icons.wc_rounded,
                label: 'Gender',
                value: teacher.gender,
              ),
              divider(),
              InfoRow(
                icon: Icons.phone_rounded,
                label: 'Phone',
                value: teacher.phone.isEmpty ? 'Not provided' : teacher.phone,
              ),
              divider(),
              InfoRow(
                icon: Icons.email_outlined,
                label: 'Email',
                value: teacher.email?.isNotEmpty == true
                    ? teacher.email!
                    : 'Not provided',
              ),
              divider(),
              InfoRow(
                icon: Icons.location_on_outlined,
                label: 'Address',
                value: teacher.address.isEmpty
                    ? 'Not provided'
                    : teacher.address,
              ),
              divider(),
              InfoRow(
                icon: Icons.calendar_month_outlined,
                label: 'Joined',
                value: _formatDate(detail.joinedAt),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Assigned classes
  Widget _assignedClasses(TeacherDetailModel detail) {
    final classes = detail.classes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TeacherProfileSectionTitle(
          title: 'Assigned Classes',
          icon: Icons.school_outlined,
          trailing: '${detail.classesCount} Classes',
        ),
        const SizedBox(height: 9),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: cardDecoration(),
          child: classes.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      'No assigned classes',
                      style: TextStyle(color: ColorSystem.muted, fontSize: 12),
                    ),
                  ),
                )
              : Column(
                  children: [
                    for (int index = 0; index < classes.length; index++) ...[
                      TeacherProfileClassRow(
                        name: classes[index].name,
                        detail:
                            'Grade ${classes[index].grade} • '
                            'Room ${classes[index].room}',
                        students: '${classes[index].studentsCount} students',
                      ),
                      if (index < classes.length - 1) divider(),
                    ],
                  ],
                ),
        ),
        const SizedBox(height: 12),
        Text(
          'Class assignments are managed separately in School Management.',
          style: TextStyle(color: ColorSystem.muted, fontSize: 11),
        ),
      ],
    );
  }

  // Edit teacher
  Future<void> _openEditTeacher(
    BuildContext context,
    WidgetRef ref,
    TeacherDetailModel detail,
  ) async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditTeacherScreen(
          teacher: detail.teacher,
          loginId: detail.loginId,
          joined: _formatDate(detail.joinedAt),
          assignedClasses: detail.classes.map((classroom) {
            return <String, dynamic>{
              'id': classroom.id,
              'name': classroom.name,
              'grade': classroom.grade,
              'room': classroom.room,
              'students_count': classroom.studentsCount,
            };
          }).toList(),
        ),
      ),
    );

    if (updated == true) {
      ref.invalidate(teacherDetailProvider(teacher.id));
      ref.invalidate(teacherAllProvider);
    }
  }

  // Delete teacher dialog
  Future<void> _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: ColorSystem.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          icon: Icon(
            Icons.delete_outline_rounded,
            color: ColorSystem.danger,
            size: 36,
          ),
          title: const Text('Delete Teacher?', textAlign: TextAlign.center),
          content: const Text(
            'Are you sure you want to delete this teacher? '
            'This action cannot be undone.',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorSystem.danger,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    try {
      // Delete teacher through provider
      await ref.read(teacherProvider.notifier).deleteTeacher(teacher.id);

      if (!context.mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Teacher deleted successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Return to teacher list
      Navigator.pop(context, true);
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to delete teacher: $error'),
          backgroundColor: ColorSystem.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get teacher detail from API
    final teacherDetailData = ref.watch(teacherDetailProvider(teacher.id));
    return Scaffold(
      backgroundColor: ColorSystem.appBG,
      appBar: AppBar(
        backgroundColor: ColorSystem.appBG,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ColorSystem.lnk,
            size: 19,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Teacher Profile',
          style: TextStyle(
            color: ColorSystem.lnk,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: ColorSystem.lnk),
            tooltip: 'More options',
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteDialog(context, ref);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline_rounded,
                      color: ColorSystem.danger,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Delete Teacher',
                      style: TextStyle(
                        color: ColorSystem.danger,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      // API state
      body: teacherDetailData.when(
        loading: () => Center(
          child: CircularProgressIndicator(color: ColorSystem.primary),
        ),

        error: (error, stackTrace) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: ColorSystem.danger,
                    size: 42,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Unable to load teacher profile',
                    style: TextStyle(
                      color: ColorSystem.lnk,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: ColorSystem.muted, fontSize: 12),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    onPressed: () {
                      ref.invalidate(teacherDetailProvider(teacher.id));
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          );
        },

        data: (detail) {
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 18),
                    children: [
                      // Profile header
                      _profileHeader(detail.teacher),

                      const SizedBox(height: 12),

                      // Teaching statistics
                      Row(
                        children: [
                          Expanded(
                            child: TeacherProfileStatCard(
                              title: 'Classes',
                              value: '${detail.classesCount}',
                              icon: Icons.groups_rounded,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TeacherProfileStatCard(
                              title: 'Students',
                              value: '${detail.studentsCount}',
                              icon: Icons.menu_book_rounded,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // Personal information
                      _personalInformation(detail),

                      const SizedBox(height: 18),

                      // Login information
                      TeacherProfileLoginInfo(loginId: detail.loginId),

                      const SizedBox(height: 18),

                      // Assigned classes
                      _assignedClasses(detail),
                    ],
                  ),
                ),

                // Bottom actions
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  decoration: BoxDecoration(
                    color: ColorSystem.appBG,
                    border: Border(top: BorderSide(color: ColorSystem.border)),
                  ),
                  child: Row(
                    children: [
                      // Contact
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            // Contact functionality not connected yet.
                          },
                          icon: const Icon(Icons.phone_outlined, size: 18),
                          label: const Text('Contact'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: ColorSystem.primary,
                            backgroundColor: ColorSystem.surface,
                            side: BorderSide(color: ColorSystem.primary),
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      // Edit teacher
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _openEditTeacher(context, ref, detail);
                          },
                          icon: const Icon(Icons.edit_rounded, size: 18),
                          label: const Text('Edit Teacher'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorSystem.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
