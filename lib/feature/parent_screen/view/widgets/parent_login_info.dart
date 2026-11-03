import 'package:edu_admin/feature/teacher_screen/view/widgets/profilecard_widget.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/teacher_profile_icon_box.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/teacher_profile_section_title.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ParentLoginInfo extends StatelessWidget {
  final String? loginId;

  const ParentLoginInfo({super.key, required this.loginId});

  @override
  Widget build(BuildContext context) {
    final id = loginId?.trim() ?? '';

    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: ProfileSectionTitle(
                title: 'Login Information',
                icon: Icons.shield_outlined,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: ColorSystem.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock_rounded,
                    size: 12,
                    color: ColorSystem.primary,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Admin Only',
                    style: TextStyle(
                      color: ColorSystem.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 9),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: cardDecoration(),
          child: Column(
            children: [
              // Teacher login ID
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: ColorSystem.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const ProfileIconBox(icon: Icons.badge_outlined),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Parent Login ID (U_ID)',
                            style: TextStyle(
                              fontSize: 11,
                              color: ColorSystem.muted,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            id.isEmpty ? 'Not available' : id,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.7,
                              color: ColorSystem.lnk,
                            ),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: id.isEmpty
                          ? null
                          : () async {
                              await Clipboard.setData(ClipboardData(text: id));

                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Login ID copied'),
                                ),
                              );
                            },
                      icon: Icon(Icons.copy_rounded, size: 15),
                      label: Text('Copy'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ColorSystem.primary,
                        side: BorderSide(color: ColorSystem.primary),
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        textStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 12),

              // Password display
              Row(
                children: [
                  ProfileIconBox(icon: Icons.lock_outline_rounded),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Password',
                          style: TextStyle(
                            color: ColorSystem.muted,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '••••••••',
                          style: TextStyle(
                            color: ColorSystem.lnk,
                            fontSize: 17,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.visibility_off_outlined,
                    color: ColorSystem.muted,
                    size: 21,
                  ),
                ],
              ),

              SizedBox(height: 11),

              Text(
                'Login ID cannot be changed. Password can be reset by an authorized admin.',
                style: TextStyle(
                  color: ColorSystem.muted,
                  fontSize: 10,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
