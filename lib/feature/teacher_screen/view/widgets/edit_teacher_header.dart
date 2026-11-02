import 'dart:convert';

import 'package:edu_admin/feature/teacher_screen/model/teacher_model.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

class EditTeacherHeader extends StatelessWidget {
  final TeacherModel teacher;
  final String status;
  final String? photoBase64;
  final VoidCallback onEditPhoto;

  const EditTeacherHeader({
    super.key,
    required this.teacher,
    required this.status,
    required this.photoBase64,
    required this.onEditPhoto,
  });

  // Convert Base64 image to ImageProvider
  ImageProvider? _getPhoto() {
    final photo = photoBase64;

    if (photo == null || photo.trim().isEmpty) {
      return null;
    }

    try {
      // Support Base64 with or without data URI prefix
      final encoded = photo.contains(',') ? photo.split(',').last : photo;

      final bytes = base64Decode(base64.normalize(encoded.trim()));

      if (bytes.isEmpty) {
        return null;
      }

      return MemoryImage(bytes);
    } catch (error) {
      debugPrint('Invalid teacher photo: $error');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final photo = _getPhoto();

    final isActive = status.trim().toLowerCase() == 'active';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorSystem.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColorSystem.border),
      ),
      child: Row(
        children: [
          // Profile photo with camera button
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: ColorSystem.primary.withValues(alpha: 0.10),

                // Display teacher photo
                foregroundImage: photo,

                // Handle image loading errors
                onForegroundImageError: photo != null
                    ? (error, stackTrace) {
                        debugPrint('Teacher image error: $error');
                      }
                    : null,

                // Show person icon when no photo exists
                child: Icon(
                  Icons.person_rounded,
                  size: 28,
                  color: ColorSystem.primary,
                ),
              ),

              // Camera button on the photo
              Positioned(
                right: -3,
                bottom: -3,
                child: Material(
                  color: ColorSystem.primary,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: onEditPhoto,
                    customBorder: const CircleBorder(),
                    child: const Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 14),

          // Existing teacher information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Teacher name
                Text(
                  teacher.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: ColorSystem.lnk,
                  ),
                ),

                const SizedBox(height: 5),

                // Teacher ID
                Text(
                  'Teacher ID #${teacher.id}',
                  style: TextStyle(fontSize: 11, color: ColorSystem.muted),
                ),

                const SizedBox(height: 6),

                // Teacher status
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? ColorSystem.success.withValues(alpha: 0.12)
                        : ColorSystem.warning.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isActive ? 'On Duty' : 'On Leave',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isActive
                          ? ColorSystem.success
                          : ColorSystem.warning,
                    ),
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
