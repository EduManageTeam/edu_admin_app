
import 'package:edu_admin/feature/teacher_screen/view/widgets/profile_widget.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';
// profile card widget
class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          ProfileAvatar(name: "Sarah Johnson", size: 46),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sarah Johnson",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: ColorSystem.lnk,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Mathematics • #T002",
                  style: TextStyle(fontSize: 12, color: ColorSystem.muted),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: ColorSystem.success.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Active",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: ColorSystem.success,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
