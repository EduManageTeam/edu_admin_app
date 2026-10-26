import 'package:edu_admin/model/color_system.dart';
import 'package:edu_admin/widget/status_chip.dart';
import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  final String value;
  final List<double> bars;

  const MetricCard({super.key, required this.value, required this.bars});

  @override
  Widget build(BuildContext context) {
    const double chartHeight = 90;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Key metric',
                style: TextStyle(color: ColorSystem.muted, fontSize: 13),
              ),
              StatusChip(label: 'Live', color: ColorSystem.success),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: ColorSystem.lnk,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: chartHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final entry in bars.asMap().entries)
                      Container(
                        width: 14,
                        height: chartHeight * entry.value,
                        margin: const EdgeInsets.only(left: 6),
                        decoration: BoxDecoration(
                          color: entry.key == bars.length - 1
                              ? ColorSystem.primary
                              : ColorSystem.primary.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
