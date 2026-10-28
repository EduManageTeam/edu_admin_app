import 'package:edu_admin/feature/teacher_screen/view/widgets/teacher_card.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:edu_admin/feature/teacher_screen/view/addteacher_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeacherScreen extends ConsumerWidget {
  const TeacherScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: ColorSystem.light,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'EDUSCHOOL • ADMIN',
                    style: TextStyle(
                      color: ColorSystem.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  CircleAvatar(
                    backgroundColor: const Color.fromARGB(49, 180, 179, 179),
                    child: Text(
                      'A',
                      style: TextStyle(color: ColorSystem.primary),
                    ),
                  ),
                ],
              ),

              Text(
                'Teacher',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              Text(
                'Faculty roster & contact',
                style: TextStyle(color: ColorSystem.muted),
              ),

              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: "Search teacher, ID or subject",
                  hintStyle: TextStyle(color: ColorSystem.muted, fontSize: 13),
                  prefixIcon: Icon(
                    Icons.search,
                    color: ColorSystem.muted,
                    size: 20,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.menu, color: ColorSystem.muted, size: 20),
                    onPressed: () {
                      // Open filter menu
                    },
                  ),
                  filled: true,
                  fillColor: ColorSystem.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: BorderSide(color: ColorSystem.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: BorderSide(color: ColorSystem.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: BorderSide(
                      color: ColorSystem.primary,
                      width: 1.5,
                    ),
                  ),
                ),
                onChanged: (value) {
                  // Search teachers
                },
              ),

              SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 100,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: ColorSystem.surface,
                    borderRadius: BorderRadius.circular(18),

                    // Soft border
                    border: Border.all(color: ColorSystem.border, width: 1),

                    // Soft shadow
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 14,
                        spreadRadius: 1,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Assigned
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Assigned",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "31",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: ColorSystem.lnk,
                            ),
                          ),
                        ],
                      ),

                      // On duty
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "On duty",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "30",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: ColorSystem.success,
                            ),
                          ),
                        ],
                      ),

                      // On leave
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "On leave",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "1",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: ColorSystem.danger,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 15),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 2,
                    vertical: 4,
                  ),

                  children: [
                    teacherCard(
                      context,
                      "Sarah Johnson",
                      "Mathematics • Grade 1A",
                      "Active",
                    ),

                    teacherCard(
                      context,
                      "Michael Brown",
                      "PE • Grade 3B",
                      "On leave",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: ColorSystem.primary.withValues(alpha: 0.25),
                blurRadius: 14,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: FloatingActionButton(
            backgroundColor: ColorSystem.primary,
            foregroundColor: ColorSystem.surface,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(Icons.add_rounded, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTeacherScreen()),
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
