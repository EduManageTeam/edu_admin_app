import 'package:edu_admin/feature/school_screen/model/attendance_model.dart';
import 'package:edu_admin/feature/school_screen/model/info_item.dart';
import 'package:edu_admin/feature/school_screen/provider/attendance_provider.dart';
import 'package:edu_admin/feature/school_screen/widget/info_tile.dart';
import 'package:edu_admin/feature/school_screen/widget/metric_card.dart';
import 'package:edu_admin/feature/school_screen/widget/screen_header.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttendanceOverviewScreen extends ConsumerWidget {
  /// true = show a back arrow (when opened from another screen)
  final bool showBack;

  const AttendanceOverviewScreen({super.key, this.showBack = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(attendanceSummaryProvider);
    final datesAsync = ref.watch(attendanceDatesProvider);
    final selectedDate = ref.watch(selectedAttendanceDateProvider);

    return Scaffold(
      backgroundColor: ColorSystem.appBG,
      body: Column(
        children: [
          ScreenHeader(
            title: 'Attendance Overview',
            subtitle: 'Recorded Attendance',
            showBack: showBack,
          ),
          Expanded(
            child: RefreshIndicator(
              color: ColorSystem.primary,
              onRefresh: () async {
                ref.invalidate(attendanceResponseProvider);
                await ref.read(attendanceResponseProvider.future);
              },
              child: summaryAsync.when(
                loading: () => _buildLoading(),
                error: (error, stackTrace) =>
                    _buildError(context, ref, error),
                data: (summary) => _buildData(
                  context,
                  ref,
                  summary,
                  selectedDate,
                  datesAsync,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Loading state ──────────────────────────────────────────────────────

  Widget _buildLoading() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      children: [
        const SizedBox(height: 80),
        Center(
          child: Column(
            children: [
              CircularProgressIndicator(color: ColorSystem.primary),
              const SizedBox(height: 16),
              Text(
                'Loading attendance records…',
                style: TextStyle(color: ColorSystem.muted, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Error state ────────────────────────────────────────────────────────

  Widget _buildError(BuildContext context, WidgetRef ref, Object error) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      children: [
        const SizedBox(height: 40),
        // Error banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: ColorSystem.danger.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: ColorSystem.danger.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.error_outline,
                size: 18,
                color: ColorSystem.danger,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  error.toString(),
                  style: TextStyle(
                    color: ColorSystem.danger,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: OutlinedButton.icon(
            onPressed: () {
              ref.invalidate(attendanceResponseProvider);
            },
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Retry'),
            style: OutlinedButton.styleFrom(
              foregroundColor: ColorSystem.primary,
              side: BorderSide(color: ColorSystem.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Data state ─────────────────────────────────────────────────────────

  Widget _buildData(
    BuildContext context,
    WidgetRef ref,
    AttendanceSummary summary,
    String selectedDate,
    AsyncValue<List<String>> datesAsync,
  ) {
    final displayDate = formatDateForDisplay(selectedDate);
    final today = getTodayDatePrefix();
    final isToday = selectedDate == today;
    final dateLabel = isToday ? 'Today · $displayDate' : displayDate;

    // Breakdown items using record counts (not distinct students)
    final breakdownItems = <InfoItem>[
      InfoItem(
        title: 'Present records',
        subtitle:
            '${summary.present} record${summary.present == 1 ? '' : 's'}',
      ),
      InfoItem(
        title: 'Absent records',
        subtitle:
            '${summary.absent} record${summary.absent == 1 ? '' : 's'}',
      ),
      InfoItem(
        title: 'Late records',
        subtitle: '${summary.late} record${summary.late == 1 ? '' : 's'}',
      ),
      InfoItem(
        title: 'Permission records',
        subtitle:
            '${summary.permission} record${summary.permission == 1 ? '' : 's'}',
      ),
      if (summary.unknown > 0)
        InfoItem(
          title: 'Other records',
          subtitle:
              '${summary.unknown} record${summary.unknown == 1 ? '' : 's'}',
        ),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      children: [
        // Date selector row (guaranteed consistent with selectedDate)
        _buildDateSelector(context, ref, selectedDate, today, datesAsync),
        const SizedBox(height: 16),

        // Metric card showing present rate among recorded statuses
        MetricCard(
          value: summary.presentRateText,
          bars: _computeBars(summary),
          statusLabel: dateLabel,
          statusColor: isToday ? ColorSystem.success : ColorSystem.info,
          title: 'Present rate',
        ),
        const SizedBox(height: 6),

        // Clarifying label: Rate among recorded statuses
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Rate among recorded statuses for $displayDate',
            style: TextStyle(
              color: ColorSystem.muted,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Distinct recorded students info badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: ColorSystem.info.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: ColorSystem.info.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.people_outline,
                size: 18,
                color: ColorSystem.info,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  summary.recordedTotal == 0
                      ? 'No attendance records for $displayDate'
                      : '${summary.recordedTotal} record${summary.recordedTotal == 1 ? '' : 's'} from '
                          '${summary.distinctStudents} distinct student${summary.distinctStudents == 1 ? '' : 's'}',
                  style: TextStyle(
                    color: ColorSystem.info,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Visual status distribution with clear labels and dynamic values
        if (summary.recordedTotal > 0) ...[
          _buildStatusDistribution(summary),
          const SizedBox(height: 24),
        ],

        // Breakdown section
        Text(
          'Breakdown',
          style: TextStyle(
            color: ColorSystem.lnk,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        if (summary.recordedTotal == 0)
          _buildEmptyState(displayDate)
        else
          ...breakdownItems.map((item) => InfoTile(item: item)),
      ],
    );
  }

  // ── Date selector ──────────────────────────────────────────────────────

  Widget _buildDateSelector(
    BuildContext context,
    WidgetRef ref,
    String selectedDate,
    String today,
    AsyncValue<List<String>> datesAsync,
  ) {
    return Row(
      children: [
        Icon(Icons.calendar_today, size: 16, color: ColorSystem.muted),
        const SizedBox(width: 8),
        Text(
          formatDateForDisplay(selectedDate),
          style: TextStyle(
            color: ColorSystem.lnk,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (selectedDate == today) ...[
          const SizedBox(width: 6),
          Text(
            '(Today)',
            style: TextStyle(
              color: ColorSystem.muted,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        const Spacer(),
        datesAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (err, stackTrace) => const SizedBox.shrink(),
          data: (dates) {
            // Ensure selectedDate is always part of the dropdown items to prevent desync
            final allDates = dates.contains(selectedDate)
                ? dates
                : ([selectedDate, ...dates]..sort((a, b) => b.compareTo(a)));

            if (allDates.length <= 1) return const SizedBox.shrink();

            return _DateDropdown(
              dates: allDates,
              selectedDate: selectedDate,
              today: today,
              onChanged: (date) {
                ref.read(selectedAttendanceDateProvider.notifier).state = date;
              },
            );
          },
        ),
      ],
    );
  }

  // ── Status distribution card ───────────────────────────────────────────

  Widget _buildStatusDistribution(AttendanceSummary summary) {
    final total = summary.recordedTotal;

    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recorded status distribution',
            style: TextStyle(
              color: ColorSystem.lnk,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          _buildProgressRow(
            label: 'Present records',
            count: summary.present,
            total: total,
            color: ColorSystem.success,
          ),
          const SizedBox(height: 10),
          _buildProgressRow(
            label: 'Absent records',
            count: summary.absent,
            total: total,
            color: ColorSystem.danger,
          ),
          const SizedBox(height: 10),
          _buildProgressRow(
            label: 'Late records',
            count: summary.late,
            total: total,
            color: ColorSystem.warning,
          ),
          const SizedBox(height: 10),
          _buildProgressRow(
            label: 'Permission records',
            count: summary.permission,
            total: total,
            color: ColorSystem.info,
          ),
          if (summary.unknown > 0) ...[
            const SizedBox(height: 10),
            _buildProgressRow(
              label: 'Other records',
              count: summary.unknown,
              total: total,
              color: ColorSystem.muted,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressRow({
    required String label,
    required int count,
    required int total,
    required Color color,
  }) {
    // Proportional value strictly clamped between 0.0 and 1.0
    // Zero count renders as 0.0, not a misleading minimum bar
    final progress = total > 0 ? (count / total).clamp(0.0, 1.0) : 0.0;
    final percent = total > 0 ? (count / total * 100) : 0.0;
    final percentText = percent == percent.roundToDouble()
        ? '${percent.toInt()}%'
        : '${percent.toStringAsFixed(1)}%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: ColorSystem.lnk,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$count record${count == 1 ? '' : 's'} ($percentText)',
              style: TextStyle(
                color: ColorSystem.muted,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Container(
            height: 8,
            width: double.infinity,
            color: color.withValues(alpha: 0.12),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(color: color),
            ),
          ),
        ),
      ],
    );
  }

  // ── Empty state for a date with no records ─────────────────────────────

  Widget _buildEmptyState(String displayDate) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.event_busy,
            size: 48,
            color: ColorSystem.muted.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 12),
          Text(
            'No attendance recorded',
            style: TextStyle(
              color: ColorSystem.muted,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'There are no attendance records for $displayDate.',
            style: TextStyle(color: ColorSystem.muted, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // ── Bar chart data for MetricCard ──────────────────────────────────────

  /// Generates proportional bar heights for MetricCard.
  /// Zero counts render as 0.0 (no misleading minimum bar).
  /// All values are strictly clamped between 0.0 and 1.0.
  List<double> _computeBars(AttendanceSummary summary) {
    if (summary.recordedTotal == 0) {
      return const [0.0, 0.0, 0.0, 0.0];
    }

    final total = summary.recordedTotal.toDouble();
    return [
      (summary.present / total).clamp(0.0, 1.0),
      (summary.absent / total).clamp(0.0, 1.0),
      (summary.late / total).clamp(0.0, 1.0),
      (summary.permission / total).clamp(0.0, 1.0),
    ];
  }
}

// ── Date dropdown widget ─────────────────────────────────────────────────

class _DateDropdown extends StatelessWidget {
  final List<String> dates;
  final String selectedDate;
  final String today;
  final ValueChanged<String> onChanged;

  const _DateDropdown({
    required this.dates,
    required this.selectedDate,
    required this.today,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: ColorSystem.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColorSystem.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: dates.contains(selectedDate) ? selectedDate : dates.first,
          isDense: true,
          icon: Icon(
            Icons.arrow_drop_down,
            size: 18,
            color: ColorSystem.muted,
          ),
          style: TextStyle(
            color: ColorSystem.lnk,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          items: dates.map((date) {
            final formatted = formatDateForDisplay(date);
            final label = date == today ? '$formatted (Today)' : formatted;
            return DropdownMenuItem<String>(
              value: date,
              child: Text(label),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
      ),
    );
  }
}
