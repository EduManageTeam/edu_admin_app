import 'dart:convert';

import 'package:edu_admin/feature/school_screen/model/class_model.dart';
import 'package:edu_admin/feature/school_screen/widget/screen_header.dart';
import 'package:edu_admin/feature/student_screen/model/student_model.dart';
import 'package:edu_admin/feature/student_screen/service/student_service.dart';
import 'package:edu_admin/feature/student_screen/view/student_profile_screen.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

class ClassStudentsScreen extends StatefulWidget {
  final int classId;
  final String className;
  final String? grade;

  const ClassStudentsScreen({
    super.key,
    required this.classId,
    required this.className,
    this.grade,
  });

  @override
  State<ClassStudentsScreen> createState() => _ClassStudentsScreenState();
}

class _ClassStudentsScreenState extends State<ClassStudentsScreen> {
  List<StudentModel> _students = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Fetch all students without server-side query params (Laravel endpoint does not support class_id query)
      final allStudents = await StudentService.fetchStudents();

      if (!mounted) return;

      // Filter locally for students matching this specific classId
      final classStudents =
          allStudents.where((s) => s.classId == widget.classId).toList();

      setState(() {
        _students = classStudents;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  ImageProvider? _studentAvatarImage(StudentModel student) {
    final photo = student.photo;
    if (photo == null || photo.isEmpty) return null;

    try {
      final base64String =
          photo.contains(',') ? photo.split(',').last : photo;
      return MemoryImage(base64Decode(base64String));
    } catch (e) {
      debugPrint('Invalid student photo: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final subtitleText = widget.grade != null && widget.grade!.trim().isNotEmpty
        ? '${formatGrade(widget.grade)} • Enrolled students'
        : 'Enrolled students';

    return Scaffold(
      backgroundColor: ColorSystem.appBG,
      body: Column(
        children: [
          ScreenHeader(
            title: '${widget.className} Roster',
            subtitle: subtitleText,
            showBack: true,
          ),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_off_rounded, size: 48, color: ColorSystem.danger),
              const SizedBox(height: 12),
              Text(
                'Unable to load student roster',
                style: TextStyle(
                  color: ColorSystem.lnk,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: ColorSystem.muted, fontSize: 13),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _fetchStudents,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Try Again'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: ColorSystem.primary,
                  side: BorderSide(color: ColorSystem.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: ColorSystem.primary,
      onRefresh: _fetchStudents,
      child: _students.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 40,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 52,
                            color: ColorSystem.muted,
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'No Students Enrolled',
                            style: TextStyle(
                              color: ColorSystem.lnk,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'No students are currently assigned to ${widget.className} (Class ID: ${widget.classId}).',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorSystem.muted,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              itemCount: _students.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final student = _students[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            StudentProfileScreen(student: student),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: ColorSystem.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: ColorSystem.border),
                      boxShadow: [
                        BoxShadow(
                          color: ColorSystem.lnk.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: ColorSystem.light,
                          backgroundImage: _studentAvatarImage(student),
                          child: student.photo == null ||
                                  student.photo!.isEmpty
                              ? Icon(
                                  Icons.person_rounded,
                                  size: 28,
                                  color: ColorSystem.primary,
                                )
                              : null,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                student.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: ColorSystem.lnk,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Student ID: ${student.id} | Class ID: ${student.classId ?? '-'}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: ColorSystem.muted,
                                ),
                              ),
                              if (student.phone.trim().isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  student.phone,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ColorSystem.muted,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: ColorSystem.muted,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

