import 'package:edu_admin/feature/school_screen/model/class_item.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

// A card that shows ONE class. It is StatelessWidget because it never changes
// by itself: it only shows the data it receives.
class ClassCard extends StatelessWidget {
  final ClassItem item;

  // VoidCallback = a function with no inputs and no result.
  // The "?" means it is optional (null = tapping does nothing).
  final VoidCallback? onTap;

  const ClassCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    // GestureDetector listens for taps on everything inside it.
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12), // space between cards
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorSystem.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ColorSystem.border),
          // Very soft shadow so the card looks slightly lifted
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
            // Top row: class name (left) and capacity (right)
            Row(
              children: [
                // Expanded + ellipsis stops overflow on narrow phones
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
                // ${...} puts a variable inside a text
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
            // ClipRRect rounds the corners of the progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: item.progress, // 0.0 = empty, 1.0 = full
                minHeight: 6,
                color: ColorSystem.success, // green filled part
                backgroundColor: ColorSystem.border, // empty part
              ),
            ),
          ],
        ),
      ),
    );
  }
}
