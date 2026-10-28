import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String name;
  final double size;
  const ProfileAvatar({super.key, required this.name, this.size = 46});

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return parts.isEmpty ? "" : parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: ColorSystem.light,
      child: Text(
        _initials,
        style: TextStyle(
          color: ColorSystem.primary,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.36,
        ),
      ),
    );
  }
}


