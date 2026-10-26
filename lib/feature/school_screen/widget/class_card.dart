import 'package:edu_admin/feature/school_screen/model/class_item.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

class ClassCard extends StatelessWidget {
  final ClassItem item;

  const ClassCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorSystem.surface,
        borderRadius: BorderRadius.circular(16),
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
            children: [
              Expanded(
                child: Text(
                  item.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ColorSystem.lnk,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Capacity ${item.students} / ${item.capacity}',
                style: TextStyle(
                  color: ColorSystem.lnk,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${item.room}  •  ${item.teacher}',
            style: TextStyle(color: ColorSystem.muted, fontSize: 12),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: item.progress,
              minHeight: 6,
              color: ColorSystem.success,
              backgroundColor: ColorSystem.border,
            ),
          ),
        ],
      ),
    );
  }
}
