import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../model/color_system.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSystem.appBG,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Header
            Text(
              'EDUSCHOOL • CEO',
              style: TextStyle(
                color: ColorSystem.primary,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Executive Overview',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: ColorSystem.lnk,
              ),
            ),
            Text(
              'Monday, 26 October 2026',
              style: TextStyle(color: ColorSystem.muted),
            ),
            const SizedBox(height: 20),

            // Health card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ColorSystem.dark, ColorSystem.primary],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'School Health Index',
                        style: TextStyle(color: ColorSystem.light),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: ColorSystem.surface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'ON TARGET',
                          style: TextStyle(
                            color: ColorSystem.success,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '92 /100',
                    style: TextStyle(
                      color: ColorSystem.surface,
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Attendance, academics and staffing remain stable.',
                    style: TextStyle(color: ColorSystem.light, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Stat cards
            const Row(
              children: [
                _StatCard(title: 'Students', value: '428', note: '+12 term'),
                SizedBox(width: 12),
                _StatCard(title: 'Teachers', value: '32', note: '31 active'),
                SizedBox(width: 12),
                _StatCard(title: 'Classes', value: '18', note: 'All staffed'),
              ],
            ),
            const SizedBox(height: 24),

            // Attendance
            Text(
              'Today at a glance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorSystem.lnk,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorSystem.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: ColorSystem.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's Attendance",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: ColorSystem.lnk,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '92.3%',
                    style: TextStyle(
                      color: ColorSystem.success,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '395 present • 18 absent • 10 late',
                    style: TextStyle(color: ColorSystem.muted, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  LinearPercentIndicator(
                    padding: EdgeInsets.zero,
                    percent: 0.923,
                    lineHeight: 8,
                    animation: true,
                    animationDuration: 800,
                    barRadius: const Radius.circular(8),
                    progressColor: ColorSystem.success,
                    backgroundColor: ColorSystem.border,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Leadership signals
            Text(
              'Leadership signals',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorSystem.lnk,
              ),
            ),
            const SizedBox(height: 12),
            _SignalTile(
              letter: 'G',
              title: 'Grade 3B',
              subtitle: 'Attendance below target · 89%',
              color: ColorSystem.warning.withValues(alpha: 0.12),
              letterColor: ColorSystem.warning,
            ),
            const SizedBox(height: 10),
            _SignalTile(
              letter: 'M',
              title: 'Monthly report',
              subtitle: 'October executive summary is ready',
              color: ColorSystem.info.withValues(alpha: 0.12),
              letterColor: ColorSystem.info,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String note;

  const _StatCard({
    required this.title,
    required this.value,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: ColorSystem.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: ColorSystem.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(color: ColorSystem.muted, fontSize: 12)),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: ColorSystem.lnk,
              ),
            ),
            const SizedBox(height: 4),
            Text(note,
                style: TextStyle(color: ColorSystem.muted, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _SignalTile extends StatelessWidget {
  final String letter;
  final String title;
  final String subtitle;
  final Color color;
  final Color letterColor;

  const _SignalTile({
    required this.letter,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.letterColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColorSystem.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ColorSystem.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              letter,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: letterColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: ColorSystem.lnk,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: ColorSystem.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: ColorSystem.muted),
        ],
      ),
    );
  }
}
