import 'package:edu_admin/feature/teacher_screen/view/widgets/edit_teacher_card_style.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/teacher_profile_icon_box.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/teacher_profile_section_title.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

class EditTeacherPersonalForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController addressController;
  final String gender;
  final String status;
  final String? joined;
  final ValueChanged<String> onGenderChanged;
  final ValueChanged<String> onStatusChanged;

  const EditTeacherPersonalForm({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.addressController,
    required this.gender,
    required this.status,
    required this.onGenderChanged,
    required this.onStatusChanged,
    this.joined,
  });

  Widget _field({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 19),
            child: TeacherProfileIconBox(icon: icon),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: ColorSystem.muted, fontSize: 11),
                ),
                SizedBox(height: 6),
                TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  maxLines: maxLines,
                  validator: validator,
                  style: TextStyle(color: ColorSystem.lnk, fontSize: 13),
                  decoration: editTeacherInputDecoration(label),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdown({
    required String label,
    required IconData icon,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 19),
            child: TeacherProfileIconBox(icon: icon),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: ColorSystem.muted, fontSize: 11),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: value,
                  isExpanded: true,
                  decoration: editTeacherInputDecoration(label),
                  items: items,
                  onChanged: (value) {
                    if (value != null) {
                      onChanged(value);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: editTeacherCardDecoration(),
      child: Column(
        children: [
          TeacherProfileSectionTitle(
            title: 'Personal Information',
            icon: Icons.person_rounded,
          ),
          SizedBox(height: 16),
          _field(
            label: 'Full Name',
            icon: Icons.person_outline,
            controller: nameController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Name is required';
              }
              return null;
            },
          ),
          _dropdown(
            label: 'Gender',
            icon: Icons.wc_rounded,
            value: gender,
            items: const [
              DropdownMenuItem(value: 'male', child: Text('Male')),
              DropdownMenuItem(value: 'female', child: Text('Female')),
              DropdownMenuItem(value: 'other', child: Text('Other')),
            ],
            onChanged: onGenderChanged,
          ),
          _field(
            label: 'Phone',
            icon: Icons.phone_outlined,
            controller: phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Phone is required';
              }
              return null;
            },
          ),
          _field(
            label: 'Email',
            icon: Icons.email_outlined,
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value != null &&
                  value.trim().isNotEmpty &&
                  !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                      .hasMatch(value.trim())) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          _field(
            label: 'Address',
            icon: Icons.location_on_outlined,
            controller: addressController,
            maxLines: 2,
          ),
          _dropdown(
            label: 'Status',
            icon: Icons.verified_user_outlined,
            value: status,
            items: const [
              DropdownMenuItem(
                value: 'active',
                child: Text('Active - On Duty'),
              ),
              DropdownMenuItem(
                value: 'inactive',
                child: Text('Inactive - On Leave'),
              ),
            ],
            onChanged: onStatusChanged,
          ),
          if (joined != null)
            Row(
              children: [
                TeacherProfileIconBox(icon: Icons.calendar_month_outlined),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Joined: $joined',
                    style: TextStyle(color: ColorSystem.muted, fontSize: 12),
                  ),
                ),
                Icon(Icons.lock_outline, color: ColorSystem.muted, size: 16),
              ],
            ),
        ],
      ),
    );
  }
}
