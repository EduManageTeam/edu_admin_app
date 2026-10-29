// Card decoration
import 'package:edu_admin/feature/teacher_screen/view/widgets/teacher_profile_icon_box.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

// Personal information row
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          TeacherProfileIconBox(icon: icon),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: ColorSystem.muted, fontSize: 11),
                ),
                SizedBox(height: 3),
                Text(
                  value,
                  style: TextStyle(
                    color: ColorSystem.lnk,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration cardDecoration() {
  return BoxDecoration(
    color: ColorSystem.surface,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: Colors.white.withValues(alpha: 0.85), width: 1.2),
    boxShadow: [
      BoxShadow(
        color: ColorSystem.primary.withValues(alpha: 0.10),
        blurRadius: 28,
        spreadRadius: 1,
        offset: const Offset(0, 10),
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.035),
        blurRadius: 14,
        offset: const Offset(0, 3),
      ),
    ],
  );
}

// Divider
Widget divider() {
  return Divider(
    color: ColorSystem.border,
    height: 1,
    thickness: 0.7,
    indent: 60,
    endIndent: 12,
  );
}
