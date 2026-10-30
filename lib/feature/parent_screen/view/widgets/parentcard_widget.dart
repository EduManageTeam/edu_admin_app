import 'package:edu_admin/feature/parent_screen/model/parent_model.dart';
import 'package:edu_admin/feature/parent_screen/view/parentprofile_screen.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/profile_widget.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

Widget parentCard(BuildContext context, ParentModel parent) {
  final String name = parent.name;
  final String phone = parent.phone;
  final int childrenCount = parent.childrenCount;

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
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           SizedBox(height: 5),
          Text(
            phone.trim().isEmpty ? 'No phone number' : phone,
            style: TextStyle(fontSize: 13, color: ColorSystem.muted),
          ),
           SizedBox(height: 8),
          Text(
            '$childrenCount ${childrenCount == 1 ? 'Child' : 'Children'}',
            style: TextStyle(fontSize: 11, color: ColorSystem.primary),
          ),
        ],
      ),

      // Children count badge
      trailing: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 9),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: childrenCount > 0
              ? const Color(0xFFECFDF3)
              : const Color(0xFFFFF7E6),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          childrenCount > 0 ? 'Assigned' : 'Unassigned',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: childrenCount > 0
                ? ColorSystem.success
                : ColorSystem.warning,
          ),
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
