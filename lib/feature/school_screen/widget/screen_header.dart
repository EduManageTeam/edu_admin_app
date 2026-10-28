import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';

class ScreenHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showBack;

  const ScreenHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: ColorSystem.light.withValues(alpha: 0.5),

      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: ColorSystem.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  if (showBack) ...[
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Navigator.maybePop(context),
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                        color: ColorSystem.lnk,
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: ColorSystem.lnk,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: ColorSystem.muted,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!showBack)
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ColorSystem.light,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: ColorSystem.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
