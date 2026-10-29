import 'package:edu_admin/feature/teacher_screen/model/teacher_model.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/edit_teacher_card_style.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

class EditTeacherHeader extends StatelessWidget {
  final TeacherModel teacher;
  final String status;

  const EditTeacherHeader({
    super.key,
    required this.teacher,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final name = teacher.name.trim();
    final initials = name.isEmpty
        ? 'T'
        : name
              .split(RegExp(r'\s+'))
              .take(2)
              .map((part) => part[0].toUpperCase())
              .join();

    final isActive = status == 'active';

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: editTeacherCardDecoration(),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: ColorSystem.primary.withValues(alpha: 0.10),
            child: Text(
              initials,
              style: TextStyle(
                color: ColorSystem.primary,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  teacher.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ColorSystem.lnk,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Teacher ID #${teacher.id}',
                  style: TextStyle(color: ColorSystem.muted, fontSize: 11),
                ),
                SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? ColorSystem.success.withValues(alpha: 0.1)
                        : ColorSystem.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isActive ? 'On Duty' : 'On Leave',
                    style: TextStyle(
                      color: isActive
                          ? ColorSystem.success
                          : ColorSystem.warning,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
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
