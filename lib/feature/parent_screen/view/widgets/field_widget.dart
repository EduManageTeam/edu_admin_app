import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

Widget field({
  required String label,
  required TextEditingController controller,
  TextInputType keyboardType = TextInputType.text,
  int maxLines = 1,
  bool requiredField = false,
  String? Function(String?)? validator,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: ColorSystem.lnk,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 6),
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        cursorColor: ColorSystem.primary,
        validator:
            validator ??
            (requiredField
                ? (value) => value == null || value.trim().isEmpty
                      ? '$label is required'
                      : null
                : null),
        style: TextStyle(color: ColorSystem.lnk, fontSize: 13),
        decoration: InputDecoration(
          filled: true,
          fillColor: ColorSystem.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide(color: ColorSystem.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide(color: ColorSystem.primary, width: 1.8),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide(color: ColorSystem.danger),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide(color: ColorSystem.danger, width: 1.8),
          ),
        ),
      ),
    ],
  );
}
