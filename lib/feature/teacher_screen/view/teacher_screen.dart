import 'package:edu_admin/feature/teacher_screen/provider/teacher_proivder.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/teacher_card.dart';
import 'package:edu_admin/feature/teacher_screen/view/addteacher_screen.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/teacher_filter_widget.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeacherScreen extends ConsumerWidget {
  const TeacherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // refresh
    void refreshTeachers() {
      ref.invalidate(teacherAllProvider);
    }

    final teacherData = ref.watch(teacherProvider);
    final search = ref.watch(teacherSearchProvider);

    return Scaffold(

      body: SafeArea(
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
                  ref.read(teacherSearchProvider.notifier).state = value.trim();
                },
                decoration: InputDecoration(
                  hintText: 'Search teacher name, ID or phone',
                  counterText: '',
                  hintStyle: TextStyle(color: ColorSystem.muted, fontSize: 13),
                  prefixIcon: Icon(
                    Icons.search,
                    color: ColorSystem.muted,
                    size: 20,
                  ),

                  // Filter UI only
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
              Container(
                width: double.infinity,
                height: 100,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
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
                    // Assigned
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Assigned',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        SizedBox(height: 8),
                        teacherData.when(
                          data: (response) => Text(
                            response.stats.assigned.toString(),
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: ColorSystem.lnk,
                            ),
                          ),
                          loading: () => const Text('...'),
                          error: (_, _) => const Text('--'),
                        ),
                      ],
                    ),

                    // On duty
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'On duty',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        SizedBox(height: 8),
                        teacherData.when(
                          data: (response) => Text(
                            response.stats.onDuty.toString(),
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: ColorSystem.success,
                            ),
                          ),
                          loading: () => const Text('...'),
                          error: (_, _) => const Text('--'),
                        ),
                      ],
                    ),

                    // On leave
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'On leave',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        SizedBox(height: 8),
                        teacherData.when(
                          data: (response) => Text(
                            response.stats.onLeave.toString(),
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: ColorSystem.danger,
                            ),
                          ),
                          loading: () => const Text('...'),
                          error: (_, _) => const Text('--'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15),

              // Teacher list
              Expanded(
                child: teacherData.when(
                  // Loading
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),

                  // Error
                  error: (error, stackTrace) => Center(
                    child: SingleChildScrollView(
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
                  ),

                  // Success
                  data: (response) {
                    final teachers = response.teachers;

                    if (teachers.isEmpty) {
                      return Center(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Teacher icon
                                const Icon(
                                  Icons.co_present_outlined,
                                  color: Color(0xFFC45114),
                                  size: 48,
                                ),

                                const SizedBox(height: 12),

                                Text(
                                  'No teachers found',
                                  style: const TextStyle(
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

                                // Try again
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
                        ),
                      );
                    }

                    // Teacher cards
                    return RefreshIndicator(
                      color: ColorSystem.primary,
                      onRefresh: () async {
                        ref.invalidate(teacherAllProvider);
                        await ref.read(teacherAllProvider.future);
                      },
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
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
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // Add teacher
      floatingActionButton: Container(
        height: 54,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [ColorSystem.primary, const Color(0xFFD45468)],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: ColorSystem.primary.withValues(alpha: 0.28),
              blurRadius: 18,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddTeacherScreen(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.20),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_add_alt_1_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Add Teacher',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(width: 2),
                ],
              ),
            ),
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
