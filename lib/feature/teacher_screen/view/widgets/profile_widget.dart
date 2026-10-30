import 'package:edu_admin/feature/teacher_screen/view/util/string_util.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String name;
  final double size;
  const ProfileAvatar({super.key, required this.name, this.size = 46});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: ColorSystem.light,
      child: Text(
        getInitials(name),
        style: TextStyle(
          color: ColorSystem.primary,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.36,
        ),
      ),
    );
  }
}
