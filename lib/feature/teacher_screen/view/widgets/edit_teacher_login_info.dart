import 'package:edu_admin/feature/teacher_screen/view/widgets/edit_teacher_card_style.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/teacher_profile_icon_box.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/teacher_profile_section_title.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditTeacherLoginInfo extends StatefulWidget {
  final String? loginId;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isResetting;
  final VoidCallback? onResetPassword;

  const EditTeacherLoginInfo({
    super.key,
    this.loginId,
    required this.passwordController,
    required this.confirmPasswordController,
    this.isResetting = false,
    this.onResetPassword,
  });

  @override
  State<EditTeacherLoginInfo> createState() => _EditTeacherLoginInfoState();
}

class _EditTeacherLoginInfoState extends State<EditTeacherLoginInfo> {
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  InputDecoration _passwordDecoration(
    String hint,
    bool visible,
    VoidCallback onToggle,
  ) {
    return editTeacherInputDecoration(hint).copyWith(
      suffixIcon: IconButton(
        tooltip: visible ? 'Hide password' : 'Show password',
        icon: Icon(
          visible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: ColorSystem.muted,
          size: 20,
        ),
        onPressed: onToggle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final id = widget.loginId?.trim() ?? '';

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: editTeacherCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileSectionTitle(
            title: 'Login Information',
            icon: Icons.shield_outlined,
            trailing: 'Admin Only',
          ),

          SizedBox(height: 14),

          // Login ID
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: ColorSystem.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const ProfileIconBox(icon: Icons.badge_outlined),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Teacher Login ID (U_ID)',
                        style: TextStyle(
                          color: ColorSystem.muted,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        id.isEmpty ? 'Not available' : id,
                        style: TextStyle(
                          color: ColorSystem.lnk,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Copy Login ID',
                  onPressed: id.isEmpty
                      ? null
                      : () async {
                          await Clipboard.setData(ClipboardData(text: id));

                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Login ID copied')),
                          );
                        },
                  icon: Icon(
                    Icons.copy_rounded,
                    color: ColorSystem.primary,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 10),

          Row(
            children: [
              Icon(Icons.info_outline, color: ColorSystem.primary, size: 15),
              SizedBox(width: 7),
              Expanded(
                child: Text(
                  'Teacher Login ID cannot be changed.',
                  style: TextStyle(color: ColorSystem.primary, fontSize: 11),
                ),
              ),
            ],
          ),

          SizedBox(height: 14),
          Divider(color: ColorSystem.border),
          SizedBox(height: 14),

          // New password
          Row(
            children: [
              const ProfileIconBox(icon: Icons.lock_outline_rounded),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Reset Teacher Password',
                  style: TextStyle(
                    color: ColorSystem.lnk,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          Text(
            'New Password',
            style: TextStyle(color: ColorSystem.muted, fontSize: 12),
          ),
          SizedBox(height: 6),

          TextFormField(
            controller: widget.passwordController,
            obscureText: !_showPassword,
            enableSuggestions: false,
            autocorrect: false,
            maxLength: 255,
            decoration: _passwordDecoration(
              'Enter new password',
              _showPassword,
              () {
                setState(() {
                  _showPassword = !_showPassword;
                });
              },
            ).copyWith(counterText: ''),
            validator: (value) {
              final password = value ?? '';

              if (password.isEmpty &&
                  widget.confirmPasswordController.text.isEmpty) {
                return null;
              }

              if (password.length < 8) {
                return 'Password must be at least 8 characters';
              }

              return null;
            },
          ),

          SizedBox(height: 13),

          Text(
            'Confirm New Password',
            style: TextStyle(color: ColorSystem.muted, fontSize: 12),
          ),
          SizedBox(height: 6),

          TextFormField(
            controller: widget.confirmPasswordController,
            obscureText: !_showConfirmPassword,
            enableSuggestions: false,
            autocorrect: false,
            maxLength: 255,
            decoration: _passwordDecoration(
              'Confirm new password',
              _showConfirmPassword,
              () {
                setState(() {
                  _showConfirmPassword = !_showConfirmPassword;
                });
              },
            ).copyWith(counterText: ''),
            validator: (value) {
              final confirmPassword = value ?? '';

              if (widget.passwordController.text.isEmpty &&
                  confirmPassword.isEmpty) {
                return null;
              }

              if (confirmPassword != widget.passwordController.text) {
                return 'Passwords do not match';
              }

              return null;
            },
          ),

          SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: widget.isResetting ? null : widget.onResetPassword,
              icon: widget.isResetting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.restart_alt_rounded, size: 18),
              label: Text(
                widget.isResetting ? 'Resetting...' : 'Reset Password',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: ColorSystem.primary,
                side: BorderSide(color: ColorSystem.primary),
                minimumSize: const Size.fromHeight(45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.shield_outlined, color: ColorSystem.muted, size: 16),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Only authorized admins can set a new password. '
                  'The existing password cannot be viewed.',
                  style: TextStyle(
                    color: ColorSystem.muted,
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
