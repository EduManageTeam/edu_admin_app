import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';


class SummaryCard extends StatelessWidget {
  final String term;
  final int roomsOpen;
  final int activeClasses;
  final int subjects;
  final int unassigned;

  const SummaryCard({
    super.key,
    required this.term,
    required this.roomsOpen,
    required this.activeClasses,
    required this.subjects,
    required this.unassigned,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorSystem.info.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorSystem.info.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  term,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ColorSystem.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // "2 Rooms Open" chip
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: ColorSystem.light,
                  borderRadius: BorderRadius.circular(20), 
                ),
                child: Text(
                  '$roomsOpen Rooms Open',
                  style: TextStyle(
                    color: ColorSystem.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$activeClasses Active Classes',
            style: TextStyle(
              color: ColorSystem.lnk,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Subjects $subjects  •  Unassigned $unassigned',
            style: TextStyle(color: ColorSystem.muted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
