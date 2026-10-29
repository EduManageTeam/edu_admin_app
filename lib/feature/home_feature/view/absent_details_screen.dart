import 'package:flutter/material.dart';

import '../../../model/color_system.dart';
import '../model/dashboard_stats.dart';

/// Opens when you tap "absences today" on the dashboard.
class AbsentDetailsScreen extends StatelessWidget {
  final List<AbsentRecord> records;

  const AbsentDetailsScreen({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSystem.appBG,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with back button
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 20, 0),
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
                          'Absent Today',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: ColorSystem.lnk,
                          ),
                        ),
                        Text(
                          '${records.length} students need follow-up',
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

            // List
            Expanded(
              child: records.isEmpty
                  ? Center(
                      child: Text(
                        'No absences today',
                        style: TextStyle(color: ColorSystem.muted),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: records.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) =>
                          _AbsentTile(record: records[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AbsentTile extends StatelessWidget {
  final AbsentRecord record;

  const _AbsentTile({required this.record});

  @override
  Widget build(BuildContext context) {
    final initial = record.name.isEmpty
        ? '?'
        : record.name.substring(0, 1).toUpperCase();

    // Second line: class and note, only the parts that exist
    final details = [
      if (record.className.isNotEmpty) record.className,
      if (record.note.isNotEmpty) record.note,
    ].join(' • ');

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
              color: ColorSystem.danger.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ColorSystem.danger,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: ColorSystem.lnk,
                  ),
                ),
                if (details.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    details,
                    style: TextStyle(color: ColorSystem.muted, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
