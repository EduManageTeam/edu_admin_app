import 'package:edu_admin/feature/people_screen/provider/people_provider.dart';
import 'package:edu_admin/feature/teacher_screen/view/teacher_screen.dart';
import 'package:edu_admin/feature/parent_screen/view/parent_screen.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PeopleScreen extends ConsumerWidget {
  const PeopleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(peopleTabProvider);

    return Scaffold(
      backgroundColor: ColorSystem.appBG,
      body: SafeArea(
        child: Column(
          children: [
            // Teacher and Parent switcher
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: ColorSystem.surface,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: ColorSystem.border),
                ),
                child: Row(
                  children: [
                    _buildTab(
                      label: 'Teachers',
                      icon: Icons.school_outlined,
                      isSelected: selectedTab == 0,
                      onTap: () {
                        ref.read(peopleTabProvider.notifier).state = 0;
                      },
                    ),
                    _buildTab(
                      label: 'Parents',
                      icon: Icons.family_restroom_outlined,
                      isSelected: selectedTab == 1,
                      onTap: () {
                        ref.read(peopleTabProvider.notifier).state = 1;
                      },
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: selectedTab == 0
                  ? const TeacherScreen()
                  : const ParentScreen(),
            ),
          ],
        ),
      ),
    );
  }

  // Tab button
  Widget _buildTab({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? ColorSystem.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : ColorSystem.muted,
              ),
              SizedBox(width: 7),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : ColorSystem.lnk,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
