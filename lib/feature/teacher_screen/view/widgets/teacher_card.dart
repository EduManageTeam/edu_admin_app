import 'package:edu_admin/feature/teacher_screen/model/teacher_model.dart';
import 'package:edu_admin/feature/teacher_screen/provider/teacherimage_provider.dart';
import 'package:edu_admin/feature/teacher_screen/view/teacherprofile_screen.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/profile_widget.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

Widget teacherCard(BuildContext context, TeacherModel teacher) {
  final String phone = teacher.phone.trim();

  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: ColorSystem.surface,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: ColorSystem.border),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.035),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeacherProfileScreen(teacher: teacher),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Teacher Avatar
              ProfileAvatar(
                name: teacher.name,
                image: teacherAvatarProvider(teacher),
                size: 52,
              ),

              SizedBox(width: 12),

              // Teacher information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Teacher Name
                    Text(
                      teacher.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: ColorSystem.lnk,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    SizedBox(height: 6),

                    // Phone Number
                    Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 14,
                          color: ColorSystem.muted,
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            phone.isEmpty ? 'No phone number' : phone,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: ColorSystem.muted,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(width: 8),

              // Arrow Icon
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: ColorSystem.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: ColorSystem.primary,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
