import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

Widget buildDropdown({
  required String label,
  required String hint,
  required List<String> items,
  required String? value,
  required ValueChanged<String?> onChanged,
  String? Function(String?)? validator,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: ColorSystem.lnk,
        ),
      ),
      SizedBox(height: 6),
      Container(
        decoration: BoxDecoration(
          color: ColorSystem.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorSystem.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 14,
              spreadRadius: 1,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: DropdownButtonFormField<String>(
          initialValue: value,
          validator: validator,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: ColorSystem.muted, fontSize: 13),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
        ),
      ),
    ],
  );
}
