import 'package:edu_admin/feature/teacher_screen/model/teacher_model.dart';
import 'package:edu_admin/feature/teacher_screen/view/teacherprofile_screen.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/profile_widget.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

Widget teacherCard(BuildContext context, TeacherModel teacher) {
  final String name = teacher.name;
  final String phone = teacher.phone;
  final String teacherStatus = teacher.status.trim().toLowerCase();

  final bool isActive = teacherStatus == 'active';

  final String statusText = teacherStatus == 'active'
      ? 'On Duty'
      : teacherStatus == 'inactive'
      ? 'On Leave'
      : 'Unknown';

  return Card(
    color: ColorSystem.surface,
    elevation: 2,
    margin: const EdgeInsets.only(bottom: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: BorderSide(color: ColorSystem.border),
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

      // Avatar
      leading: ProfileAvatar(name: name, size: 46),

      // Teacher name
      title: Text(
        name,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: ColorSystem.lnk,
        ),
      ),

      // Phone and actions
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          Text(
            phone.trim().isEmpty ? 'No phone number' : phone,
            style: TextStyle(fontSize: 13, color: ColorSystem.muted),
          ),
          const SizedBox(height: 8),
          Text(
            'Schedule • Assign • Edit',
            style: TextStyle(fontSize: 11, color: ColorSystem.primary),
          ),
        ],
      ),

      // Status badge
      trailing: Container(
        width: 76,
        padding: const EdgeInsets.symmetric(vertical: 9),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFFECFDF3)
              : teacherStatus == 'inactive'
              ? const Color(0xFFFFF7E6)
              : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          statusText,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isActive
                ? ColorSystem.success
                : teacherStatus == 'inactive'
                ? ColorSystem.warning
                : ColorSystem.muted,
          ),
        ),
      ),

      // Navigate to teacher profile
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TeacherProfileScreen(teacher: teacher),
          ),
        );
      },
    ),
  );
}
