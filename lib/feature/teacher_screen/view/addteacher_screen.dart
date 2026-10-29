import 'package:edu_admin/feature/teacher_screen/view/widgets/dropdown_widget.dart';

import 'package:edu_admin/model/color_system.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';

class AddTeacherScreen extends StatefulWidget {
  const AddTeacherScreen({super.key});

  @override
  State<AddTeacherScreen> createState() => _AddTeacherScreenState();
}

class _AddTeacherScreenState extends State<AddTeacherScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController(text: "Auto assigned");
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  String? _gender;
  String _status = "Active";

  @override
  void dispose() {
    _userIdController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String v) => RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v);
  bool _isValidPhone(String v) => RegExp(r'^[0-9+\s-]{8,15}$').hasMatch(v);
  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Teacher form validated successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorSystem.appBG,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: ColorSystem.light,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    color: ColorSystem.lnk,
                  ),
                  SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Add Teacher",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ColorSystem.lnk,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Complete the required information",
                        style: TextStyle(
                          fontSize: 11,
                          color: ColorSystem.muted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildTextField(
                        label: "User ID",
                        hint: "Assigned user ID",
                        controller: _userIdController,
                        readOnly: true,
                      ),
                      SizedBox(height: 12),
                      buildTextField(
                        label: "Full name",
                        hint: "Teacher name",
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? "Required" : null,
                      ),
                      SizedBox(height: 12),
                      buildDropdown(
                        label: "Gender",
                        hint: "Select gender",
                        items: const ["Male", "Female", "Other"],
                        value: _gender,
                        onChanged: (v) => setState(() => _gender = v),
                        validator: (v) => v == null ? "Required" : null,
                      ),
                      SizedBox(height: 12),
                      buildTextField(
                        label: "Phone",
                        hint: "Phone number",
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return null;
                          return _isValidPhone(v) ? null : "Invalid phone";
                        },
                      ),
                      SizedBox(height: 12),
                      buildTextField(
                        label: "Email",
                        hint: "Email address",
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return null;
                          return _isValidEmail(v) ? null : "Invalid email";
                        },
                      ),
                      SizedBox(height: 12),
                      buildTextField(
                        label: "Address",
                        hint: "Home address",
                        controller: _addressController,
                        keyboardType: TextInputType.streetAddress,
                      ),
                      SizedBox(height: 12),
                      buildDropdown(
                        label: "Status",
                        hint: "Active",
                        items: const ["Active", "Inactive"],
                        value: _status,
                        onChanged: (v) =>
                            setState(() => _status = v ?? "Active"),
                      ),
                      SizedBox(height: 20),
                      _buildCreateButton(),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorSystem.primary,
          foregroundColor: ColorSystem.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          shadowColor: ColorSystem.primary.withValues(alpha: 0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Create teacher", style: TextStyle(fontSize: 15)),
            SizedBox(width: 8),
            Icon(Icons.person_add_alt_1, size: 20),
          ],
        ),
      ),
    );
  }
}
