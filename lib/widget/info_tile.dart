import 'package:edu_admin/model/color_system.dart';
import 'package:edu_admin/model/info_item.dart';
import 'package:flutter/material.dart';

class InfoTile extends StatelessWidget {
  final InfoItem item;
  final VoidCallback? onTap;

  const InfoTile({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ColorSystem.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: ColorSystem.border),
          boxShadow: [
            BoxShadow(
              color: ColorSystem.lnk.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Letter box
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ColorSystem.light,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                item.letter,
                style: TextStyle(
                  color: ColorSystem.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: ColorSystem.lnk,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: ColorSystem.muted, fontSize: 13),
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
