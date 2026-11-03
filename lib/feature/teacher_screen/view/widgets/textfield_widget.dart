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
      // Field label
      Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: ColorSystem.lnk,
        ),
      ),
       SizedBox(height: 7),
      // Text input
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        validator: validator,
        cursorColor: ColorSystem.primary,
        cursorWidth: 2,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: ColorSystem.lnk,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: ColorSystem.muted,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),

          filled: true,
          fillColor: ColorSystem.surface,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),

          // Normal border
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: ColorSystem.border, width: 1),
          ),

          // Pink border when clicked
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: ColorSystem.primary, width: 2),
          ),

          // Read-only border
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: ColorSystem.border),
          ),

          // Error border
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: ColorSystem.danger, width: 1.2),
          ),

          // Focused error border
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: ColorSystem.danger, width: 2),
          ),

          errorStyle: TextStyle(color: ColorSystem.danger, fontSize: 11),

          // Focus color
          focusColor: ColorSystem.primary,
          hoverColor: ColorSystem.primary.withValues(alpha: 0.04),
        ),
      ),
    ],
  );
}
