import 'package:edu_admin/feature/teacher_screen/view/widgets/profilecard_widget.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/teacher_profile_icon_box.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/profile_widget.dart';
import 'package:flutter/material.dart';

class TeacherProfileStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const TeacherProfileStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: cardDecoration(),
      child: Row(
        children: [
          TeacherProfileIconBox(icon: icon, size: 38, iconSize: 19),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: ColorSystem.lnk,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  title,
                  style: TextStyle(fontSize: 11, color: ColorSystem.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
