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
        child: Column(
          children: [
            // ===== LOCKED PART (does not scroll) =====
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EDUSCHOOL • ADMIN',
                        style: TextStyle(
                          color: ColorSystem.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Dashboard',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: ColorSystem.lnk,
                        ),
                      ),
                      Text(
                        'Term 2 • Active Session • Day 48',
                        style: TextStyle(color: ColorSystem.muted),
                      ),
                    ],
                  ),
                ),
                // Avatar
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: ColorSystem.light,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'A',
                    style: TextStyle(
                      color: ColorSystem.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Status banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: ColorSystem.info.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(Icons.circle, size: 10, color: ColorSystem.success),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Campus operations healthy',
                      style: TextStyle(
                        color: ColorSystem.success,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    '08:42 AM',
                    style: TextStyle(color: ColorSystem.muted, fontSize: 12),
                  ),
                ],
              ),
            ),
                ],
              ),
            ),

            // ===== SCROLLABLE PART =====
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
            // Stat cards (2 x 2)
            const Row(
              children: [
                _StatCard(
                    title: 'Students', value: '14628', note: '+12 this month'),
                SizedBox(width: 12),
                _StatCard(title: 'Teachers', value: '302', note: '31 active'),
              ],
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                _StatCard(
                    title: 'Parents', value: '356', note: 'Linked accounts'),
                SizedBox(width: 12),
                _StatCard(
                    title: 'Classes', value: '18', note: 'Across all grades'),
              ],
            ),
            const SizedBox(height: 24),

            // Attendance
            Text(
              "Today's Attendance",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorSystem.lnk,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: ColorSystem.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: ColorSystem.border),
              ),
              child: Row(
                children: [
                  // Left: big percentage
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '92%',
                        style: TextStyle(
                          color: ColorSystem.success,
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Present today',
                        style:
                            TextStyle(color: ColorSystem.muted, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  // Right: chips + bar
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _Chip(
                              text: '395 Present',
                              color: ColorSystem.success,
                            ),
                            _Chip(
                              text: '18 Absent',
                              color: ColorSystem.danger,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '10 Late • 5 Permission',
                          style:
                              TextStyle(color: ColorSystem.muted, fontSize: 12),
                        ),
                        const SizedBox(height: 10),
                        LinearPercentIndicator(
                          padding: EdgeInsets.zero,
                          percent: 0.92,
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
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Requires review
            Text(
              'Requires Review',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorSystem.lnk,
              ),
            ),
            const SizedBox(height: 12),
            _ReviewTile(
              number: '3',
              title: '3 unexcused absences',
              subtitle: 'Immediate guardian follow-up required',
              color: ColorSystem.warning,
            ),
            const SizedBox(height: 10),
            _ReviewTile(
              number: '2',
              title: '2 classes pending roll call',
              subtitle: 'Assign cover before 9:15 AM',
              color: ColorSystem.info,
            ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Small stat card (Students, Teachers, ...)
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
        padding: const EdgeInsets.all(16),
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
                fontSize: 30,
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

// Rounded label (395 Present / 18 Absent)
class _Chip extends StatelessWidget {
  final String text;
  final Color color;

  const _Chip({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Row in "Requires Review"
class _ReviewTile extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;
  final Color color;

  const _ReviewTile({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.color,
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
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
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
                const SizedBox(height: 2),
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
