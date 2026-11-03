import 'package:edu_admin/feature/teacher_screen/view/widgets/teacher_profile_icon_box.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

class ProfileSectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? trailing;

  const ProfileSectionTitle({
    super.key,
    required this.title,
    required this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileIconBox(icon: icon),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: ColorSystem.lnk,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: TextStyle(
              color: ColorSystem.primary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}
