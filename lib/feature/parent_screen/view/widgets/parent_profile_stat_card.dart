import 'package:edu_admin/feature/teacher_screen/view/widgets/profilecard_widget.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/teacher_profile_icon_box.dart';
import 'package:flutter/material.dart';

class ParentProfileStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const ParentProfileStatCard({
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
          ProfileIconBox(icon: icon, size: 38, iconSize: 19),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: ColorSystem.lnk,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  title,
                  style: TextStyle(fontSize: 15, color: ColorSystem.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
