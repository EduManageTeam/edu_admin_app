import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

class TeacherProfileIconBox extends StatelessWidget {
  final IconData icon;
  final double size;
  final double iconSize;

  const TeacherProfileIconBox({
    super.key,
    required this.icon,
    this.size = 38,
    this.iconSize = 19,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ColorSystem.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: ColorSystem.primary, size: iconSize),
    );
  }
}
