import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

BoxDecoration editTeacherCardDecoration() {
  return BoxDecoration(
    color: ColorSystem.surface,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: ColorSystem.border.withValues(alpha: 0.7)),
    boxShadow: [
      BoxShadow(
        color: ColorSystem.primary.withValues(alpha: 0.09),
        blurRadius: 24,
        offset: const Offset(0, 8),
      ),
    ],
  );
}

InputDecoration editTeacherInputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    isDense: true,
    filled: true,
    fillColor: ColorSystem.surface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: ColorSystem.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: ColorSystem.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: ColorSystem.primary, width: 1.5),
    ),
  );
}
