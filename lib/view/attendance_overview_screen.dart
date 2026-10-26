import 'package:edu_admin/model/color_system.dart';
import 'package:edu_admin/model/info_item.dart';
import 'package:edu_admin/widget/info_tile.dart';
import 'package:edu_admin/widget/metric_card.dart';
import 'package:edu_admin/widget/screen_header.dart';
import 'package:flutter/material.dart';

class AttendanceOverviewScreen extends StatelessWidget {
  const AttendanceOverviewScreen({super.key});

  static const List<InfoItem> _items = [
    InfoItem(title: 'Present', subtitle: '395 students'),
    InfoItem(title: 'Absent', subtitle: '18 students'),
    InfoItem(title: 'Late', subtitle: '10 students'),
    InfoItem(title: 'Permission', subtitle: '5 students'),
    InfoItem(title: 'Pending classes', subtitle: '2 classes'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSystem.appBG,
      body: Column(
        children: [
          const ScreenHeader(
            title: 'Attendance Overview',
            subtitle: 'School-wide operational view',
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              children: [
                const MetricCard(
                  value: '92%',
                  bars: [0.38, 0.56, 0.49, 0.71, 0.65, 0.84, 0.78, 1.0],
                ),
                const SizedBox(height: 24),
                Text(
                  'Breakdown',
                  style: TextStyle(
                    color: ColorSystem.lnk,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ..._items.map((item) => InfoTile(item: item)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
