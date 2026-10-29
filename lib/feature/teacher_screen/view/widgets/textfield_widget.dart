import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

Widget buildTextField({
  required String label,
  required String hint,
  TextEditingController? controller,
  TextInputType keyboardType = TextInputType.text,
  String? Function(String?)? validator,
  bool readOnly = false,
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
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          validator: validator,
          style: TextStyle(fontSize: 13, color: ColorSystem.lnk),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: ColorSystem.muted, fontSize: 13),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
        ),
      ),
    ],
  );
}
