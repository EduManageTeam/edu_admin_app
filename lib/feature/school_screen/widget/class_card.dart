import 'package:edu_admin/feature/school_screen/model/class_model.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

class ClassCard extends StatelessWidget {
  final ClassModel item;
  final VoidCallback? onTap;

  const ClassCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final roomDisplay = (item.room != null && item.room!.trim().isNotEmpty)
        ? item.room!
        : 'Room —';

    final teacher = item.teacher;
    final teacherName = teacher != null && teacher.name.trim().isNotEmpty
        ? teacher.name
        : 'No teacher assigned';
    final isTeacherInactive = teacher?.isInactive ?? false;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorSystem.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ColorSystem.border),
          boxShadow: [
            BoxShadow(
              color: ColorSystem.lnk.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Class name and Grade badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: ColorSystem.lnk,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: ColorSystem.light,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item.formattedGrade,
                    style: TextStyle(
                      color: ColorSystem.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Room and Teacher
            Row(
              children: [
                Icon(
                  Icons.meeting_room_outlined,
                  size: 14,
                  color: ColorSystem.muted,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    roomDisplay,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: ColorSystem.muted, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '•',
                  style: TextStyle(color: ColorSystem.border, fontSize: 12),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.person_outline,
                  size: 14,
                  color: ColorSystem.muted,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    teacherName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: ColorSystem.muted, fontSize: 12),
                  ),
                ),
              ],
            ),
            // Inactive teacher separate indication
            if (isTeacherInactive) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: ColorSystem.warning.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 13,
                      color: ColorSystem.warning,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Teacher inactive',
                      style: TextStyle(
                        color: ColorSystem.warning,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
