import 'dart:convert';

import 'package:edu_admin/feature/student_screen/view/add_student_screen.dart';
import 'package:edu_admin/feature/student_screen/view/student_profile_screen.dart';
import 'package:edu_admin/widget/gradient_action_button.dart';
import 'package:flutter/material.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:edu_admin/feature/student_screen/model/student_model.dart';
import 'package:edu_admin/feature/student_screen/service/student_service.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final TextEditingController searchController = TextEditingController();

  List<StudentModel> students = [];
  bool isLoading = false;
  String? errorMessage;

  String searchText = '';

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final fetched = await StudentService.fetchStudents();
      if (!mounted) return;
      setState(() {
        students = fetched;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = e.toString().replaceFirst('Exception: ', '');
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<StudentModel> filterStudents(int? classId) {
    final query = searchText.trim().toLowerCase();

    return students.where((student) {
      final matchesClass = classId == null || student.classId == classId;

      final matchesSearch =
          student.name.toLowerCase().contains(query) ||
          student.id.toString().contains(query) ||
          (student.phone).toLowerCase().contains(query) ||
          (student.classId?.toString() ?? '').contains(query) ||
          (student.parentId?.toString() ?? '').contains(query);

      return matchesClass && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Students',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text('Directory & enrollment'),
                      ],
                    ),
                    CircleAvatar(
                      backgroundColor: ColorSystem.light,
                      child: Text(
                        'A',
                        style: TextStyle(color: ColorSystem.dark),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search name, ID, class or parent',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  height: 48,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: ColorSystem.dark,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: ColorSystem.dark.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey.shade700,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                    tabs: const [
                      Tab(text: 'All'),
                      Tab(text: 'Grade 1'),
                      Tab(text: 'Grade 2'),
                      Tab(text: 'Grade 3'),
                      Tab(text: 'Grade 4'),
                      Tab(text: 'Grade 5'),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : errorMessage != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: Colors.red.shade400,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: _fetchStudents,
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Retry'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorSystem.dark,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : TabBarView(
                          children: [
                            _buildStudentList(filterStudents(null)),
                            _buildStudentList(filterStudents(1)),
                            _buildStudentList(filterStudents(2)),
                            _buildStudentList(filterStudents(3)),
                            _buildStudentList(filterStudents(4)),
                            _buildStudentList(filterStudents(5)),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),

        floatingActionButton: GradientActionButton(
          title: 'Add Student',
          icon: Icons.person_add_alt_1_rounded,
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddStudentScreen()),
            );

            if (result == true && mounted) {
              _fetchStudents();
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  Widget _buildStudentList(List<StudentModel> data) {
    if (data.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.school_outlined, size: 55, color: ColorSystem.warning),
            const SizedBox(height: 12),
            Text(
              'No students found',
              style: TextStyle(color: ColorSystem.warning),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchStudents,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 8, bottom: 90),
        itemCount: data.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final student = data[index];

          return InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentProfileScreen(student: student),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 27,
                    backgroundColor: ColorSystem.light,
                    backgroundImage: studentAvatarImage(student),
                    child: student.photo == null || student.photo!.isEmpty
                        ? Icon(
                            Icons.person_rounded,
                            size: 30,
                            color: ColorSystem.primary,
                          )
                        : null,
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Student ID: ${student.id} | '
                          'Class ID: ${student.classId ?? '-'}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          student.phone,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.more_vert,
                      size: 18,
                      color: Colors.grey.shade600,
                    ),
                    onSelected: (value) async {
                      if (value == 'update') {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AddStudentScreen(studentToEdit: student),
                          ),
                        );
                        if (result == true && mounted) {
                          _fetchStudents();
                        }
                      } else if (value == 'delete') {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Student'),
                            content: Text('Delete ${student.name}?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true && mounted) {
                          try {
                            await StudentService.deleteStudent(student.id);
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Student deleted')),
                            );
                            _fetchStudents();
                          } catch (e) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  e.toString().replaceFirst('Exception: ', ''),
                                ),
                              ),
                            );
                          }
                        }
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'update',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('Update'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  ImageProvider? studentAvatarImage(StudentModel student) {
    final photo = student.photo;

    if (photo == null || photo.isEmpty) {
      return null;
    }

    try {
      final base64String = photo.contains(',') ? photo.split(',').last : photo;

      return MemoryImage(base64Decode(base64String));
    } catch (e) {
      debugPrint('Invalid student photo: $e');
      return null;
    }
  }
}
