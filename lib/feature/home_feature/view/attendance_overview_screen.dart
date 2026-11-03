import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../model/color_system.dart';
import '../model/attendance_summary.dart';

// The 4 statuses, always in this order
const _labels = ['Present', 'Absent', 'Late', 'Permission'];

Color _colorOf(int i) => [
  ColorSystem.success,
  ColorSystem.primary,
  ColorSystem.warning,
  ColorSystem.info,
][i];

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String _shortDate(DateTime d) => '${d.day} ${_months[d.month - 1]}';

/// Opens from "See more" on the dashboard. Shows ALL days, not only today.
class AttendanceOverviewScreen extends StatelessWidget {
  final AttendanceSummary summary;

  const AttendanceOverviewScreen({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSystem.appBG,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 20, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                      color: ColorSystem.lnk,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Attendance Overview',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: ColorSystem.lnk,
                          ),
                        ),
                        Text(
                          'All days • ${summary.total} records',
                          style: TextStyle(
                            color: ColorSystem.muted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: summary.total == 0
                  ? Center(
                      child: Text(
                        'No attendance records yet',
                        style: TextStyle(color: ColorSystem.muted),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      children: [
                        _RateCard(summary: summary),
                        const SizedBox(height: 16),

                        // Present / Absent / Late / Permission cards
                        Row(
                          children: [
                            _CountCard(index: 0, summary: summary),
                            const SizedBox(width: 12),
                            _CountCard(index: 1, summary: summary),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _CountCard(index: 2, summary: summary),
                            const SizedBox(width: 12),
                            _CountCard(index: 3, summary: summary),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Graph: overall split
                        const _SectionTitle('Overall split'),
                        const SizedBox(height: 12),
                        _CardBox(child: _SplitChart(summary: summary)),
                        const SizedBox(height: 24),

                        // Highlights
                        if (summary.daily.isNotEmpty) ...[
                          const _SectionTitle('Highlights'),
                          const SizedBox(height: 12),
                          _Highlights(daily: summary.daily),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: ColorSystem.lnk,
      ),
    );
  }
}

// White rounded box used around charts
class _CardBox extends StatelessWidget {
  final Widget child;

  const _CardBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ColorSystem.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorSystem.border),
      ),
      child: child,
    );
  }
}

// Big "overall present rate" card
class _RateCard extends StatelessWidget {
  final AttendanceSummary summary;

  const _RateCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final percent = (summary.presentRatio * 100).round();

    return _CardBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overall present rate',
            style: TextStyle(color: ColorSystem.muted, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Text(
            '$percent%',
            style: TextStyle(
              color: ColorSystem.success,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          LinearPercentIndicator(
            padding: EdgeInsets.zero,
            percent: summary.presentRatio.clamp(0.0, 1.0),
            lineHeight: 8,
            animation: true,
            animationDuration: 800,
            barRadius: const Radius.circular(8),
            progressColor: ColorSystem.success,
            backgroundColor: ColorSystem.border,
          ),
        ],
      ),
    );
  }
}

// One card: Present / Absent / Late / Permission
class _CountCard extends StatelessWidget {
  final int index; // 0 present, 1 absent, 2 late, 3 permission
  final AttendanceSummary summary;

  const _CountCard({required this.index, required this.summary});

  @override
  Widget build(BuildContext context) {
    final values = [
      summary.present,
      summary.absent,
      summary.late,
      summary.permission,
    ];
    final value = values[index];
    final percent = (summary.ratioOf(value) * 100).round();

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
            Row(
              children: [
                Icon(Icons.circle, size: 9, color: _colorOf(index)),
                const SizedBox(width: 6),
                Text(
                  _labels[index],
                  style: TextStyle(color: ColorSystem.muted, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '$value',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: ColorSystem.lnk,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$percent% of records',
              style: TextStyle(color: ColorSystem.muted, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

// Donut chart: share of each status over all days
class _SplitChart extends StatelessWidget {
  final AttendanceSummary summary;

  const _SplitChart({required this.summary});

  @override
  Widget build(BuildContext context) {
    final values = [
      summary.present,
      summary.absent,
      summary.late,
      summary.permission,
    ];

    return Row(
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 46,
                  sections: [
                    for (var i = 0; i < 4; i++)
                      if (values[i] > 0)
                        PieChartSectionData(
                          value: values[i].toDouble(),
                          color: _colorOf(i),
                          radius: 22,
                          showTitle: false,
                        ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${summary.total}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: ColorSystem.lnk,
                    ),
                  ),
                  Text(
                    'records',
                    style: TextStyle(color: ColorSystem.muted, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            children: List.generate(4, (i) {
              final percent = (summary.ratioOf(values[i]) * 100).round();
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Icon(Icons.circle, size: 9, color: _colorOf(i)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _labels[i],
                        style: TextStyle(color: ColorSystem.lnk, fontSize: 13),
                      ),
                    ),
                    Text(
                      '${values[i]} • $percent%',
                      style: TextStyle(color: ColorSystem.muted, fontSize: 12),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

// Best day and the day with the most absences
class _Highlights extends StatelessWidget {
  final List<DailyAttendance> daily;

  const _Highlights({required this.daily});

  @override
  Widget build(BuildContext context) {
    final withRecords = daily.where((d) => d.total > 0).toList();

    // Best present rate (latest day wins a tie)
    var best = withRecords.first;
    for (final d in withRecords) {
      if (d.presentRatio >= best.presentRatio) best = d;
    }

    // Most absences
    var worst = withRecords.first;
    for (final d in withRecords) {
      if (d.absent > worst.absent) worst = d;
    }

    return Row(
      children: [
        _HighlightCard(
          label: 'Best day',
          date: _shortDate(best.date),
          note: '${(best.presentRatio * 100).round()}% present',
          color: ColorSystem.success,
        ),
        const SizedBox(width: 12),
        _HighlightCard(
          label: 'Most absences',
          date: worst.absent == 0 ? '-' : _shortDate(worst.date),
          note: '${worst.absent} absent',
          color: ColorSystem.primary,
        ),
      ],
    );
  }
}

class _HighlightCard extends StatelessWidget {
  final String label;
  final String date;
  final String note;
  final Color color;

  const _HighlightCard({
    required this.label,
    required this.date,
    required this.note,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: ColorSystem.muted, fontSize: 12),
            ),
            const SizedBox(height: 6),
            Text(
              date,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              note,
              style: TextStyle(color: ColorSystem.muted, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
