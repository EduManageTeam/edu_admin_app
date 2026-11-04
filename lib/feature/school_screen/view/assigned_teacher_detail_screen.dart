import 'package:edu_admin/feature/school_screen/model/class_model.dart';
import 'package:edu_admin/feature/school_screen/model/info_item.dart';
import 'package:edu_admin/feature/school_screen/widget/info_tile.dart';
import 'package:edu_admin/feature/school_screen/widget/screen_header.dart';
import 'package:edu_admin/feature/school_screen/widget/status_chip.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

class AssignedTeacherDetailScreen extends StatelessWidget {
  final ClassTeacherModel? teacher;
  final String className;

  const AssignedTeacherDetailScreen({
    super.key,
    required this.teacher,
    required this.className,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSystem.appBG,
      body: Column(
        children: [
          ScreenHeader(
            title: 'Assigned Teacher',
            subtitle: className,
            showBack: true,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              children: [
                if (teacher != null) ...[
                  _buildTeacherCard(teacher!),
                  const SizedBox(height: 24),
                  Text(
                    'Assignment Details',
                    style: TextStyle(
                      color: ColorSystem.lnk,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  InfoTile(
                    item: InfoItem(
                      title: 'Class Assignment',
                      subtitle: className,
                    ),
                  ),
                  InfoTile(
                    item: InfoItem(
                      title: 'Teacher ID',
                      subtitle: '#${teacher!.id}',
                    ),
                  ),
                  InfoTile(
                    item: InfoItem(
                      title: 'Teacher Status',
                      subtitle: teacher!.isInactive
                          ? 'Inactive (Account flagged)'
                          : 'Active in system',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: ColorSystem.light.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: ColorSystem.border),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 18,
                          color: ColorSystem.muted,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Note: Contact credentials, full address, and teaching schedule are managed in the Teachers directory.',
                            style: TextStyle(
                              color: ColorSystem.muted,
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  _buildUnassignedState(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherCard(ClassTeacherModel t) {
    final initial = t.name.trim().isNotEmpty
        ? t.name.trim()[0].toUpperCase()
        : 'T';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorSystem.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorSystem.border),
        boxShadow: [
          BoxShadow(
            color: ColorSystem.lnk.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: ColorSystem.light,
            child: Text(
              initial,
              style: TextStyle(
                color: ColorSystem.primary,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            t.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorSystem.lnk,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          StatusChip(
            label: t.isInactive ? 'Inactive' : 'Active',
            color: t.isInactive ? ColorSystem.warning : ColorSystem.success,
          ),
        ],
      ),
    );
  }

  Widget _buildUnassignedState() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.person_off_outlined,
            size: 56,
            color: ColorSystem.muted,
          ),
          const SizedBox(height: 16),
          Text(
            'No Teacher Assigned',
            style: TextStyle(
              color: ColorSystem.lnk,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'There is currently no teacher assigned to $className in the system.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorSystem.muted,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

