import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

// Reusable search bar. UI only, it does not filter yet.
class SearchField extends StatelessWidget {
  final String hint;
  final IconData trailingIcon;

  const SearchField({
    super.key,
    required this.hint,
    this.trailingIcon = Icons.tune,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: ColorSystem.muted, fontSize: 14),
        prefixIcon: Icon(Icons.search, color: ColorSystem.muted),
        suffixIcon: Icon(trailingIcon, color: ColorSystem.muted),
        filled: true,
        fillColor: ColorSystem.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: ColorSystem.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: ColorSystem.primary),
        ),
      ),
    );
  }
}
