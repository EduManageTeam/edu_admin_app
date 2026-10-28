import 'package:edu_admin/feature/school_screen/model/class_item.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:edu_admin/feature/school_screen/model/info_item.dart';
import 'package:edu_admin/feature/school_screen/widget/info_tile.dart';
import 'package:edu_admin/feature/school_screen/widget/screen_header.dart';
import 'package:edu_admin/feature/school_screen/widget/status_chip.dart';
import 'package:flutter/material.dart';

class ClassDetailScreen extends StatelessWidget {
  final ClassItem item;

  const ClassDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final List<InfoItem> setupItems = [
      InfoItem(
        title: 'Student roster',
        subtitle: '${item.students} enrolled students',
      ),
      const InfoItem(title: 'Subjects', subtitle: '6 active subjects'),
      const InfoItem(
        title: 'Teacher assignments',
        subtitle: '4 assigned teachers',
      ),
      const InfoItem(title: 'Schedule', subtitle: 'Mon–Fri · 8:00–2:00'),
      const InfoItem(title: 'Attendance', subtitle: 'Today 96% present'),
    ];

    return Scaffold(
      backgroundColor: ColorSystem.appBG,
      body: Column(
        children: [
          ScreenHeader(
            title: item.name,
            subtitle: 'Class & subject setup',
            showBack: true,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              children: [
                _buildHeroCard(),
                const SizedBox(height: 24),
                Text(
                  'Class setup',
                  style: TextStyle(
                    color: ColorSystem.lnk,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ...setupItems.map((setup) => InfoTile(item: setup)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Big pink card with the class name, status, teacher and student count
  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorSystem.light.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorSystem.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ColorSystem.lnk,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              StatusChip(label: 'Active', color: ColorSystem.success),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Homeroom · ${item.teacher}',
            style: TextStyle(color: ColorSystem.muted, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Text(
            '${item.students} enrolled students',
            style: TextStyle(color: ColorSystem.muted, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
