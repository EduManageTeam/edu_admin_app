import 'dart:async';

import 'package:edu_admin/feature/home_feature/config/app_clock.dart';
import 'package:edu_admin/feature/home_feature/config/app_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:edu_admin/feature/people_screen/provider/people_provider.dart';

import '../../../model/color_system.dart';
import '../model/dashboard_stats.dart';
import '../provider/dashboard_provider.dart';
import 'absent_details_screen.dart';
import 'attendance_overview_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  // ======================================================================
  // WHERE EACH CARD OPENS - change these 4 lines to choose.
  //
  // A) Open a TAB of the bottom navigation bar (the bar stays visible):
  //      _goToTab(AppTabs.students)   // or .people / .school / .more / .home
  //
  // B) Open a plain page on top (NO bottom bar, with a back button):
  //      _openPage(context, const SomeDetailPage())
  // ======================================================================
  void _openStudents(BuildContext context, WidgetRef ref) =>
      _goToTab(AppTabs.students);

  void _openTeachers(BuildContext context, WidgetRef ref) {
    ref.read(peopleTabProvider.notifier).state = 0; // Teachers side
    _goToTab(AppTabs.people);
  }

  void _openParents(BuildContext context, WidgetRef ref) {
    ref.read(peopleTabProvider.notifier).state = 1; // Parents side
    _goToTab(AppTabs.people);
  }

  void _openClasses(BuildContext context, WidgetRef ref) =>
      _goToTab(AppTabs.school);

  void _goToTab(int tab) => AppTabs.goTo(tab);

  void _openPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);

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
                            const _LiveDate(),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: ColorSystem.info.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 10,
                          color: ColorSystem.success,
                        ),
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
                        const _LiveClock(),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ===== SCROLLABLE PART (pull down to refresh) =====
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(dashboardStatsProvider);
                  await ref.read(dashboardStatsProvider.future);
                },
                color: ColorSystem.primary,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  children: statsAsync.when<List<Widget>>(
                    loading: () => [
                      Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: ColorSystem.primary,
                          ),
                        ),
                      ),
                    ],
                    error: (error, _) => [
                      _ErrorBox(
                        message: error.toString().replaceFirst(
                          'Exception: ',
                          '',
                        ),
                        onRetry: () => ref.invalidate(dashboardStatsProvider),
                      ),
                    ],
                    data: (stats) => _content(context, ref, stats),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Everything below the locked header, filled with the real numbers
  List<Widget> _content(BuildContext context, WidgetRef ref, DashboardStats s) {
    final percent = (s.presentRatio * 100).round();

    return [
      // Stat cards (2 x 2) - tap a card to open its page
      Row(
        children: [
          _StatCard(
            title: 'Students',
            value: '${s.students}',
            note: 'Enrolled',
            onTap: () => _openStudents(context,ref),
          ),
          const SizedBox(width: 12),
          _StatCard(
            title: 'Teachers',
            value: '${s.teachers}',
            note: 'Faculty',
            onTap: () => _openTeachers(context,ref),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          _StatCard(
            title: 'Parents',
            value: '${s.parents}',
            note: 'Linked accounts',
            onTap: () => _openParents(context,ref),
          ),
          const SizedBox(width: 12),
          _StatCard(
            title: 'Classes',
            value: '${s.classes}',
            note: 'Across all grades',
            onTap: () => _openClasses(context,ref),
          ),
        ],
      ),
      const SizedBox(height: 24),

      // Attendance title + "See more"
      Row(
        children: [
          Expanded(
            child: Text(
              "Today's Attendance",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorSystem.lnk,
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: ColorSystem.primary,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      AttendanceOverviewScreen(summary: s.allAttendance),
                ),
              );
            },
            child: const Row(
              children: [
                Text(
                  'See more',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                Icon(Icons.chevron_right, size: 18),
              ],
            ),
          ),
        ],
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
                  '$percent%',
                  style: TextStyle(
                    color: ColorSystem.success,
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Present today',
                  style: TextStyle(color: ColorSystem.muted, fontSize: 12),
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
                        text: '${s.present} Present',
                        color: ColorSystem.success,
                      ),
                      _Chip(
                        text: '${s.absent} Absent',
                        color: ColorSystem.danger,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${s.late} Late • ${s.permission} Permission',
                    style: TextStyle(color: ColorSystem.muted, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  LinearPercentIndicator(
                    padding: EdgeInsets.zero,
                    percent: s.presentRatio.clamp(0.0, 1.0),
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
        number: '${s.absent}',
        title: '${s.absent} absences today',
        subtitle: 'Tap to see who is absent',
        color: ColorSystem.warning,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AbsentDetailsScreen(records: s.absentList),
            ),
          );
        },
      ),
    ];
  }
}

// Today's date in Cambodia, e.g. "Friday, 30 October 2026"
class _LiveDate extends StatefulWidget {
  const _LiveDate();

  @override
  State<_LiveDate> createState() => _LiveDateState();
}

class _LiveDateState extends State<_LiveDate> {
  static const _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  late String _text = _format(AppClock.now());
  Timer? _timer;

  static String _format(DateTime d) =>
      '${_days[d.weekday - 1]}, ${d.day} ${_months[d.month - 1]} ${d.year}';

  @override
  void initState() {
    super.initState();
    // Redraw only when the date changes (midnight or after the clock syncs)
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final text = _format(AppClock.now());
      if (text != _text) {
        setState(() => _text = text);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(_text, style: TextStyle(color: ColorSystem.muted));
  }
}

// Clock with real Cambodia time (from the server, not the phone)
class _LiveClock extends StatefulWidget {
  const _LiveClock();

  @override
  State<_LiveClock> createState() => _LiveClockState();
}

class _LiveClockState extends State<_LiveClock> {
  late String _text = _format(AppClock.now());
  Timer? _timer;

  static String _format(DateTime d) {
    final hour = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final minute = d.minute.toString().padLeft(2, '0');
    final period = d.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  @override
  void initState() {
    super.initState();
    // Check every second, but only redraw when the shown text changes
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final text = _format(AppClock.now());
      if (text != _text) {
        setState(() => _text = text);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // stop the timer when the screen closes
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: TextStyle(color: ColorSystem.muted, fontSize: 12),
    );
  }
}

// Shown when loading fails
class _ErrorBox extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorBox({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Column(
        children: [
          Icon(Icons.error_outline, size: 40, color: ColorSystem.danger),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: ColorSystem.danger),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorSystem.primary,
              foregroundColor: ColorSystem.surface,
            ),
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

// Stat card (Students, Teachers, ...). Tap to open its page.
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String note;
  final VoidCallback onTap;

  const _StatCard({
    required this.title,
    required this.value,
    required this.note,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: ColorSystem.surface,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: ColorSystem.border),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: ColorSystem.muted,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: ColorSystem.muted,
                    ),
                  ],
                ),
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
                Text(
                  note,
                  style: TextStyle(color: ColorSystem.muted, fontSize: 11),
                ),
              ],
            ),
          ),
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
  final VoidCallback? onTap;

  const _ReviewTile({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}
