import 'package:edu_admin/feature/parent_screen/view/widgets/statusbadge_widget.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

Widget buildProfileCard() {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: ColorSystem.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: ColorSystem.border),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 23,
          backgroundColor: ColorSystem.light,
          child: Text(
            "CH",
            style: TextStyle(
              color: ColorSystem.primary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Chan Sophea",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: ColorSystem.lnk,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2),
              Text(
                "Parent · #P003",
                style: TextStyle(fontSize: 12, color: ColorSystem.muted),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        buildStatusBadge("Active"),
      ],
    ),
  );
}
