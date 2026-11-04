import 'package:edu_admin/feature/parent_screen/model/parent_model.dart';
import 'package:edu_admin/feature/parent_screen/view/parentprofile_screen.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/profile_widget.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

Widget parentCard(BuildContext context, ParentModel parent) {
  final String name = parent.name;
  final String phone = parent.phone;
  return Card(
    color: ColorSystem.surface,
    elevation: 2,
    margin: const EdgeInsets.only(bottom: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: BorderSide(color: ColorSystem.border),
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

      // Avatar
      leading: ProfileAvatar(name: name, size: 46),

      // Parent name
      title: Text(
        name,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: ColorSystem.lnk,
        ),
      ),

      // Phone and children count
      subtitle: Row(
        children: [
          Icon(Icons.phone_outlined, size: 14, color: ColorSystem.muted),
          SizedBox(width: 5),
          Expanded(
            child: Text(
              phone.isEmpty ? 'No phone number' : phone,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: ColorSystem.muted, fontSize: 12),
            ),
          ),
        ],
      ),

      // Arrow icon
      trailing: Container(
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

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ParentProfileScreen(parent: parent),
          ),
        );
      },
    ),
  );
}
