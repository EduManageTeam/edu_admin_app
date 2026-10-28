import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/cupertino.dart';

Widget buildStatusBadge(String status) {
  bool isActive = status == "Active";
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: isActive ? const Color(0xFFECFDF3) : const Color(0xFFFEF3F2),
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
  );
}
