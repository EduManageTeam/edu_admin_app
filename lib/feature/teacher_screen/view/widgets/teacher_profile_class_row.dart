import 'package:edu_admin/feature/teacher_screen/view/widgets/teacher_profile_icon_box.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

class TeacherProfileClassRow extends StatelessWidget {
  final String name;
  final String detail;
  final String students;

  const TeacherProfileClassRow({
    super.key,
    required this.name,
    required this.detail,
    required this.students,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          const ProfileIconBox(icon: Icons.menu_book_rounded),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: ColorSystem.lnk,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  detail,
                  style: TextStyle(color: ColorSystem.muted, fontSize: 11),
                ),
                SizedBox(height: 4),
                Text(
                  students,
                  style: TextStyle(
                    color: ColorSystem.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
