import 'package:edu_admin/feature/profile_screen/view/student_profile_screen.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';
import 'package:edu_admin/feature/profile_screen/model/student_model.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<StudentModel> students = const [
    StudentModel(
      id: 1,
      name: 'Sopheak Van',
      gender: 'Male',
      dateOfBirth: '2009-11-02',
      phone: '0687561555',
      address: 'Street 6, Phnom Penh, Cambodia',
      classId: 2,
      parentId: 8,
      status: 'active',
    ),
    StudentModel(
      id: 2,
      name: 'Dara Sok',
      gender: 'Male',
      dateOfBirth: '2010-03-15',
      phone: '012345678',
      address: 'Phnom Penh, Cambodia',
      classId: 1,
      parentId: 9,
      status: 'active',
    ),
    StudentModel(
      id: 3,
      name: 'Sreyneang Kim',
      gender: 'Female',
      dateOfBirth: '2011-06-20',
      phone: '098765432',
      address: 'Phnom Penh, Cambodia',
      classId: 3,
      parentId: 10,
      status: 'inactive',
    ),
  ];

  String searchText = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<StudentModel> filterStudents(int? classId) {
    return students.where((student) {
      final matchesClass = classId == null || student.classId == classId;

      final query = searchText.toLowerCase().trim();

      final matchesSearch =
          student.name.toLowerCase().contains(query) ||
          student.id.toString().contains(query) ||
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
                  height: 50,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: ColorSystem.dark,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey.shade700,
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
                  child: TabBarView(
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

        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Add Student screen is not implemented yet.'),
              ),
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ColorSystem.dark, ColorSystem.dark.withOpacity(0.6)],
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Add Student',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
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

    return ListView.separated(
      padding: const EdgeInsets.only(top: 8, bottom: 90),
      itemCount: data.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final student = data[index];
        final isActive = student.status.toLowerCase() == 'active';

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
                  child: Text(
                    student.name.isEmpty ? '?' : student.name[0].toUpperCase(),
                    style: TextStyle(
                      color: ColorSystem.dark,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFFE6F7ED)
                            : const Color(0xFFFFE9E9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        student.status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isActive
                              ? const Color(0xFF16834A)
                              : Colors.red.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: Colors.grey.shade500,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
