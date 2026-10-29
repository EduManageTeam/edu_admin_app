import 'package:edu_admin/feature/teacher_screen/view/widgets/profilecard_widget.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeacherProfileScreen extends ConsumerWidget {
  const TeacherProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: ColorSystem.appBG,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back_ios_new, size: 18),
                    color: ColorSystem.lnk,
                  ),
                  SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sarah Johnson",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ColorSystem.lnk,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        "Mathematics • #T002",
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
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Teacher Profile Card
                    ProfileCard(),

                    SizedBox(height: 16),
                    Text(
                      "Information",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: ColorSystem.lnk,
                      ),
                    ),
                    SizedBox(height: 10),
                    _InformationCard(
                      icon: "T",
                      label: "Teacher ID",
                      value: "#T002",
                    ),
                    SizedBox(height: 8),
                    _InformationCard(
                      icon: "P",
                      label: "Phone",
                      value: "097 656 768",
                    ),
                    SizedBox(height: 8),
                    _InformationCard(
                      icon: "E",
                      label: "Email",
                      value: "sarah@school.edu",
                    ),
                    SizedBox(height: 8),
                    _InformationCard(
                      icon: "C",
                      label: "Classes",
                      value: "Grade 1A, Grade 4A",
                    ),
                    SizedBox(height: 8),
                    _InformationCard(
                      icon: "S",
                      label: "Status",
                      value: "Active",
                    ),
                    SizedBox(height: 8),
                    _InformationCard(
                      icon: "J",
                      label: "Joined",
                      value: "12 Aug 2024",
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                // Edit
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorSystem.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.edit, size: 18),
                                  SizedBox(width: 8),
                                  Text("Edit"),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () {
                                // Delete teacher
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: ColorSystem.surface,
                                foregroundColor: ColorSystem.primary,
                                side: BorderSide(color: ColorSystem.border),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text("Delete"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InformationCard extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  const _InformationCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorSystem.surface,
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: ColorSystem.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ColorSystem.light,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            icon,
            style: TextStyle(
              color: ColorSystem.primary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: ColorSystem.lnk,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(fontSize: 12, color: ColorSystem.muted),
        ),
        trailing: Icon(Icons.chevron_right, color: ColorSystem.muted, size: 20),
        onTap: () {
          // Edit field
        },
      ),
    );
  }
}
