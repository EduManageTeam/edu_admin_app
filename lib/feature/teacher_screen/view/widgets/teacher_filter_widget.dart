import 'package:edu_admin/feature/teacher_screen/provider/teacher_proivder.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeacherFilterWidget extends ConsumerWidget {
  const TeacherFilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStatus = ref.watch(teacherStatusProvider);

    final filters = [
      ('all', 'All Teachers', Icons.groups_outlined),
      ('active', 'On Duty', Icons.check_circle_outline),
      ('inactive', 'On Leave', Icons.event_busy_outlined),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.tune_rounded, color: ColorSystem.primary),
                const SizedBox(width: 10),
                const Text(
                  'Filter Teachers',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            SizedBox(height: 20),

            Text(
              'Teacher status',
              style: TextStyle(color: ColorSystem.muted, fontSize: 13),
            ),

            SizedBox(height: 12),

            // Filter options
            ...filters.map((filter) {
              final isSelected = selectedStatus == filter.$1;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () {
                    ref.read(teacherStatusProvider.notifier).state = filter.$1;

                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? ColorSystem.primary.withValues(alpha: 0.08)
                          : ColorSystem.light,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? ColorSystem.primary
                            : ColorSystem.border,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          filter.$3,
                          color: isSelected
                              ? ColorSystem.primary
                              : ColorSystem.muted,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          filter.$2,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? ColorSystem.primary
                                : ColorSystem.lnk,
                          ),
                        ),
                        const Spacer(),
                        if (isSelected)
                          Icon(Icons.check_circle, color: ColorSystem.primary),
                      ],
                    ),
                  ),
                ),
              );
            }),

            SizedBox(height: 10),

            // Reset filter
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  ref.read(teacherStatusProvider.notifier).state = 'all';

                  Navigator.pop(context);
                },
                child: const Text('Reset Filter'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
