import 'package:edu_admin/feature/teacher_screen/provider/teacher_proivder.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/teacher_card.dart';
import 'package:edu_admin/feature/teacher_screen/view/addteacher_screen.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/teacher_filter_widget.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:edu_admin/widget/gradient_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeacherScreen extends ConsumerWidget {
  const TeacherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Refresh teachers

    void refreshTeachers() {
      ref.invalidate(teacherAllProvider);
    }

    Future<void> refreshTeacherList() async {
      ref.invalidate(allTeacherDetailsProvider);
      await ref.read(allTeacherDetailsProvider.future);
    }

    final teacherData = ref.watch(teacherProvider);
    final search = ref.watch(teacherSearchProvider);
    final stats = teacherData.asData?.value.stats;

    return Scaffold(
      backgroundColor: ColorSystem.appBG,
      body: SafeArea(
        child: RefreshIndicator(
          color: ColorSystem.primary,
          onRefresh: refreshTeacherList,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Text(
                        'EDUSCHOOL • ADMIN',
                        style: TextStyle(
                          color: ColorSystem.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                        ),
                      ),
                      Spacer(),
                      CircleAvatar(
                        backgroundColor: const Color.fromARGB(
                          49,
                          180,
                          179,
                          179,
                        ),
                        child: Text(
                          'A',
                          style: TextStyle(color: ColorSystem.primary),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 5),

                  Text(
                    'Teacher',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),

                  Text(
                    'Faculty roster & contact',
                    style: TextStyle(color: ColorSystem.muted),
                  ),

                  SizedBox(height: 12),

                  // Search teachers
                  TextField(
                    maxLength: 100,
                    onChanged: (value) {
                      ref.read(teacherSearchProvider.notifier).state = value
                          .trim();
                    },
                    decoration: InputDecoration(
                      hintText: 'Search teacher name, ID or phone',
                      counterText: '',
                      hintStyle: TextStyle(
                        color: ColorSystem.muted,
                        fontSize: 12,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: ColorSystem.muted,
                        size: 20,
                      ),

                      // Filter teachers
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.tune_rounded,
                          color: ColorSystem.primary,
                          size: 21,
                        ),
                        tooltip: 'Filter teachers',
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: ColorSystem.surface,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(24),
                              ),
                            ),
                            builder: (context) => const TeacherFilterWidget(),
                          );
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
                  ),

                  SizedBox(height: 12),

                  // Teacher statistics
                  // Teacher statistics
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: ColorSystem.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: ColorSystem.border, width: 1),
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
                        _statItem(
                          label: 'Assigned',
                          value: '${stats?.assigned ?? 0}',
                          color: ColorSystem.lnk,
                        ),
                        _statItem(
                          label: 'On duty',
                          value: '${stats?.onDuty ?? 0}',
                          color: ColorSystem.success,
                        ),
                        _statItem(
                          label: 'On leave',
                          value: '${stats?.onLeave ?? 0}',
                          color: ColorSystem.danger,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 15),

                  // Teacher list
                  teacherData.when(
                    // Loading
                    loading: () => const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    ),

                    // Error
                    error: (error, stackTrace) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.co_present_outlined,
                              color: ColorSystem.danger,
                              size: 48,
                            ),

                            SizedBox(height: 12),

                            Text(
                              'Unable to load teachers',
                              style: TextStyle(
                                color: ColorSystem.danger,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            SizedBox(height: 8),

                            Text(
                              error.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: ColorSystem.muted,
                                fontSize: 12,
                              ),
                            ),

                            SizedBox(height: 15),

                            OutlinedButton.icon(
                              onPressed: refreshTeachers,
                              icon: const Icon(Icons.refresh, size: 18),
                              label: const Text('Try again'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: ColorSystem.primary,
                                side: BorderSide(color: ColorSystem.primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Success
                    data: (response) {
                      final teachers = response.teachers;

                      if (teachers.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.co_present_outlined,
                                  color: Color(0xFFC45114),
                                  size: 48,
                                ),

                                SizedBox(height: 12),

                                Text(
                                  'No teachers found',
                                  style: TextStyle(
                                    color: Color(0xFFC45114),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                SizedBox(height: 8),

                                Text(
                                  search.isNotEmpty
                                      ? 'Try another name, ID or phone'
                                      : 'No teachers have been added yet',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: ColorSystem.muted,
                                    fontSize: 12,
                                  ),
                                ),

                                SizedBox(height: 15),

                                OutlinedButton.icon(
                                  onPressed: refreshTeachers,
                                  icon: const Icon(Icons.refresh, size: 18),
                                  label: const Text('Try again'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: ColorSystem.primary,
                                    side: BorderSide(
                                      color: ColorSystem.primary,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      // Teacher cards
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(
                          left: 2,
                          right: 2,
                          top: 4,
                          bottom: 100,
                        ),
                        itemCount: teachers.length,
                        itemBuilder: (context, index) {
                          final teacher = teachers[index];

                          return teacherCard(context, teacher);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // Add teacher - unchanged
      floatingActionButton: GradientActionButton(
        title: 'Add Teacher',
        icon: Icons.person_add_alt_1_rounded,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTeacherScreen()),
          );
        },
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // Statistics
  Widget _statItem({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
