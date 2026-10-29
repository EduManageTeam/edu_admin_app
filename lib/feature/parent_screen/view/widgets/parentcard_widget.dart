import 'package:edu_admin/feature/parent_screen/view/parentprofile_screen.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

Widget parentCard(
  BuildContext context,
  String name,
  String parentId,
  int children,
  String status,
) {
  bool isActive = status == "Active";
  final initial = name.trim().isEmpty ? "" : name.trim()[0].toUpperCase();

  return Card(
    color: ColorSystem.surface,
    elevation: 2,
    margin: const EdgeInsets.only(bottom: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: BorderSide(color: ColorSystem.border),
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      leading: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ColorSystem.light,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          initial,
          style: TextStyle(
            color: ColorSystem.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      title: Text(
        name,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: ColorSystem.lnk,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        "Parent #$parentId · ${children == 1 ? "1 child" : "$children children"}",
        style: TextStyle(fontSize: 11, color: ColorSystem.muted),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFFECFDF3)
                  : const Color(0xFFFEF3F2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isActive ? ColorSystem.success : ColorSystem.danger,
              ),
            ),
          ),
          SizedBox(width: 6),
          Icon(Icons.chevron_right, color: ColorSystem.muted, size: 20),
        ],
      ),
      onTap: () {
        // navigate to parent details screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ParentProfileScreen()),
        );
      },
    ),
  );
}
