import 'package:edu_admin/feature/teacher_screen/view/widgets/edit_teacher_card_style.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/teacher_profile_icon_box.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/teacher_profile_section_title.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

class EditTeacherClasses extends StatelessWidget {
  final List<Map<String, dynamic>> classes;

  const EditTeacherClasses({super.key, required this.classes});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: editTeacherCardDecoration(),
      child: Column(
        children: [
          const ProfileSectionTitle(
            title: 'Assigned Classes',
            icon: Icons.school_outlined,
            trailing: 'View Only',
          ),
          const SizedBox(height: 14),
          if (classes.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                'No assigned classes available',
                style: TextStyle(color: ColorSystem.muted, fontSize: 12),
              ),
            ),
          ...classes.map((classroom) {
            final name = classroom['name']?.toString() ?? 'Class';
            final grade = classroom['grade']?.toString() ?? '-';
            final room = classroom['room']?.toString() ?? '-';
            final count = classroom['students_count'] ?? 0;

            return Container(
              margin: const EdgeInsets.only(bottom: 9),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ColorSystem.light,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: ColorSystem.border),
              ),
              child: Row(
                children: [
                  const ProfileIconBox(icon: Icons.menu_book_outlined),
                  SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            color: ColorSystem.lnk,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Grade $grade • Room $room',
                          style: TextStyle(
                            color: ColorSystem.muted,
                            fontSize: 11,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '$count students',
                          style: TextStyle(
                            color: ColorSystem.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.lock_outline_rounded,
                    color: ColorSystem.muted,
                    size: 17,
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: 7),
        ],
      ),
    );
  }
}
