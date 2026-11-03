import 'package:edu_admin/feature/school_screen/model/info_item.dart';
import 'package:edu_admin/feature/school_screen/widget/info_tile.dart';
import 'package:edu_admin/feature/school_screen/widget/metric_card.dart';
import 'package:edu_admin/feature/school_screen/widget/screen_header.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

class ScoresOverviewScreen extends StatelessWidget {
  // true = show a back arrow (when opened from another screen)
  final bool showBack;

  const ScoresOverviewScreen({super.key, this.showBack = false});

  // Demo data for school-wide operational view
  static const List<InfoItem> _items = [
    InfoItem(title: 'Mathematics', subtitle: '87 average'),
    InfoItem(title: 'English', subtitle: '84 average'),
    InfoItem(title: 'Science', subtitle: '86 average'),
    InfoItem(title: 'Social Studies', subtitle: '81 average'),
    InfoItem(title: 'Art & Design', subtitle: '90 average'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSystem.appBG,
      body: Column(
        children: [
          ScreenHeader(
            title: 'Scores Overview',
            subtitle: 'School-wide operational view',
            showBack: showBack,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              children: [
                // Clear Demo Data banner
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: ColorSystem.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: ColorSystem.warning.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 18,
                        color: ColorSystem.warning,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'DEMO DATA — School-wide operational view (not real-time class data)',
                          style: TextStyle(
                            color: ColorSystem.warning,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                MetricCard(
                  value: '84.6',
                  bars: const [0.38, 0.56, 0.49, 0.71, 0.65, 0.84, 0.78, 1.0],
                  statusLabel: 'DEMO DATA',
                  statusColor: ColorSystem.warning,
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
