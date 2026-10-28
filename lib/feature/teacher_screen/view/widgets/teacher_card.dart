import 'package:edu_admin/feature/teacher_screen/view/teacherprofile_screen.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/profile_widget.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget teacherCard(
  BuildContext context,
  String name,
  String phone,
  String status,
) {
  bool isActive = status == "Active";

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

      // Teacher Name
      title: Text(
        name,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: ColorSystem.lnk,
        ),
      ),

      // Subject and Actions
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),
          Text(
            phone,
            style: TextStyle(fontSize: 11, color: ColorSystem.muted),
          ),
          SizedBox(height: 8),
          Text(
            "Schedule • Assign • Edit",
            style: TextStyle(fontSize: 11, color: ColorSystem.primary),
          ),
        ],
      ),

      // Status
      trailing: Container(
        width: 76,
        padding: const EdgeInsets.symmetric(vertical: 9),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFECFDF3) : const Color(0xFFFFF7E6),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          status,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isActive ? ColorSystem.success : ColorSystem.warning,
          ),
        ),
      ),

      // Navigate to Teacher Detail
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TeacherProfileScreen()),
        );
      },
    ),
  );
}
