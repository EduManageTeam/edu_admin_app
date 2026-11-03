import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String name;
  final ImageProvider? image;
  final double size;

  const ProfileAvatar({
    super.key,
    required this.name,
    this.image,
    this.size = 46,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ColorSystem.primary.withValues(alpha: 0.10),
      ),
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: Colors.transparent,

        // Display teacher photo
        foregroundImage: image,

        // Handle image loading errors
        onForegroundImageError: image != null
            ? (error, stackTrace) {
                debugPrint('Unable to display teacher photo: $error');
              }
            : null,

        // Fallback person icon
        child: Icon(
          Icons.person_rounded,
          color: ColorSystem.primary,
          size: size * 0.48,
        ),
      ),
    );
  }
}
