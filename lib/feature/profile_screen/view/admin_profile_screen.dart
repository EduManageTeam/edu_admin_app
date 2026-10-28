import 'package:edu_admin/model/color_system.dart';
import 'package:edu_admin/feature/profile_screen/model/student_model.dart';
import 'package:flutter/material.dart';

class StudentProfileScreen extends StatelessWidget {
  final StudentModel student;

  const StudentProfileScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final isActive = student.status.toLowerCase() == 'active';

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Student Profile',
          style: TextStyle(
            color: Color(0xFF202939),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF202939)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: ColorSystem.lnk.withOpacity(0.12),
                    backgroundImage:
                        student.photo != null && student.photo!.isNotEmpty
                        ? NetworkImage(student.photo!)
                        : null,
                    child: student.photo == null || student.photo!.isEmpty
                        ? Icon(Icons.person, size: 52, color: ColorSystem.lnk)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    student.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF202939),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Student ID: ${student.id}',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFFE5F8ED)
                          : const Color(0xFFFFE9E9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      student.status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isActive
                            ? const Color(0xFF16834A)
                            : Colors.red.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _sectionTitle('Personal Information'),
            const SizedBox(height: 12),
            _infoCard([
              _infoRow(Icons.person_outline, 'Full Name', student.name),
              _infoRow(Icons.wc_outlined, 'Gender', student.gender),
              _infoRow(
                Icons.cake_outlined,
                'Date of Birth',
                student.dateOfBirth,
                isLast: true,
              ),
            ]),

            const SizedBox(height: 24),

            _sectionTitle('Contact Information'),
            const SizedBox(height: 12),
            _infoCard([
              _infoRow(Icons.phone_outlined, 'Phone Number', student.phone),
              _infoRow(
                Icons.location_on_outlined,
                'Address',
                student.address,
                isLast: true,
              ),
            ]),

            const SizedBox(height: 24),

            _sectionTitle('Academic Information'),
            const SizedBox(height: 12),
            _infoCard([
              _infoRow(
                Icons.badge_outlined,
                'Student ID',
                student.id.toString(),
              ),
              _infoRow(
                Icons.class_outlined,
                'Class ID',
                student.classId?.toString() ?? 'Not assigned',
              ),
              _infoRow(
                Icons.family_restroom_outlined,
                'Parent ID',
                student.parentId?.toString() ?? 'Not assigned',
                isLast: true,
              ),
            ]),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF202939),
      ),
    );
  }

  Widget _infoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(children: children),
    );
  }

  Widget _infoRow(
    IconData icon,
    String label,
    String value, {
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: ColorSystem.lnk.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: ColorSystem.lnk),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      value.isEmpty ? 'Not provided' : value,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF202939),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!isLast) ...[
            const SizedBox(height: 14),
            Divider(height: 1, color: Colors.grey.shade200),
          ],
        ],
      ),
    );
  }
}
