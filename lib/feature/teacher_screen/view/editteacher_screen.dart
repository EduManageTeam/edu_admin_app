import 'package:edu_admin/feature/teacher_screen/model/teacher_model.dart';
import 'package:edu_admin/feature/teacher_screen/provider/teacher_proivder.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/edit_teacher_header.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/edit_teacher_personal_form.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/edit_teacher_login_info.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/edit_teacher_classes.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditTeacherScreen extends ConsumerStatefulWidget {
  final TeacherModel teacher;
  final String? loginId;
  final String? joined;
  final List<Map<String, dynamic>> assignedClasses;

  const EditTeacherScreen({
    super.key,
    required this.teacher,
    this.loginId,
    this.joined,
    this.assignedClasses = const [],
  });

  @override
  ConsumerState<EditTeacherScreen> createState() => _EditTeacherScreenState();
}

class _EditTeacherScreenState extends ConsumerState<EditTeacherScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;

  // Password controllers
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late String _gender;
  late String _status;

  bool _isSaving = false;
  bool _isResetting = false;

  @override
  void initState() {
    super.initState();

    final teacher = widget.teacher;

    _nameController = TextEditingController(text: teacher.name);
    _phoneController = TextEditingController(text: teacher.phone);
    _emailController = TextEditingController(text: teacher.email ?? '');
    _addressController = TextEditingController(text: teacher.address);

    final gender = teacher.gender.trim().toLowerCase();

    _gender = ['male', 'female', 'other'].contains(gender) ? gender : 'other';

    final status = teacher.status.trim().toLowerCase();

    _status = ['active', 'inactive'].contains(status) ? status : 'active';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();

    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  // Validate password
  bool _validatePassword() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password.isEmpty && confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a new password')),
      );
      return false;
    }

    if (password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 8 characters')),
      );
      return false;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return false;
    }

    return true;
  }

  // Reset teacher password
  Future<void> _resetPassword() async {
    if (_isSaving || _isResetting) return;

    if (!_validatePassword()) return;

    setState(() {
      _isResetting = true;
    });

    try {
      await ref
          .read(teacherProvider.notifier)
          .resetTeacherPassword(
            teacherId: widget.teacher.id,
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
          );

      if (!mounted) return;

      // Clear password only after success
      _passwordController.clear();
      _confirmPasswordController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Teacher password reset successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to reset password: $error'),
          backgroundColor: ColorSystem.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isResetting = false;
        });
      }
    }
  }

  // Save teacher personal information
  Future<void> _saveTeacher() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSaving || _isResetting) return;

    setState(() => _isSaving = true);

    final updatedTeacher = TeacherModel(
      id: widget.teacher.id,
      name: _nameController.text.trim(),
      gender: _gender,
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      address: _addressController.text.trim(),
      photo: widget.teacher.photo,
      status: _status,
    );

    try {
      await ref
          .read(teacherProvider.notifier)
          .updateTeacher(widget.teacher.id, updatedTeacher);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Teacher updated successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to update teacher: $error'),
          backgroundColor: ColorSystem.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSystem.appBG,

      // App bar
      appBar: AppBar(
        backgroundColor: ColorSystem.appBG,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ColorSystem.lnk,
            size: 19,
          ),
          onPressed: _isSaving || _isResetting
              ? null
              : () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Teacher',
          style: TextStyle(
            color: ColorSystem.lnk,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
                  children: [
                    // Teacher header
                    EditTeacherHeader(teacher: widget.teacher, status: _status),

                    SizedBox(height: 14),

                    // Personal information
                    EditTeacherPersonalForm(
                      nameController: _nameController,
                      phoneController: _phoneController,
                      emailController: _emailController,
                      addressController: _addressController,
                      gender: _gender,
                      status: _status,
                      joined: widget.joined,
                      onGenderChanged: (value) {
                        setState(() => _gender = value);
                      },
                      onStatusChanged: (value) {
                        setState(() => _status = value);
                      },
                    ),

                    SizedBox(height: 14),

                    // Login information
                    EditTeacherLoginInfo(
                      loginId: widget.loginId,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      isResetting: _isResetting,
                      onResetPassword: _resetPassword,
                    ),

                    SizedBox(height: 14),

                    // Assigned classes
                    EditTeacherClasses(classes: widget.assignedClasses),
                  ],
                ),
              ),

              // Bottom buttons
              Container(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                decoration: BoxDecoration(
                  color: ColorSystem.appBG,
                  border: Border(top: BorderSide(color: ColorSystem.border)),
                ),
                child: Row(
                  children: [
                    // Cancel
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isSaving || _isResetting
                            ? null
                            : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ColorSystem.primary,
                          minimumSize: const Size.fromHeight(48),
                          side: BorderSide(color: ColorSystem.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        child: Text('Cancel'),
                      ),
                    ),

                    SizedBox(width: 10),

                    // Save changes
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isSaving || _isResetting
                            ? null
                            : _saveTeacher,
                        icon: _isSaving
                            ? SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Icon(Icons.save_rounded, size: 18),
                        label: Text(_isSaving ? 'Saving...' : 'Save Changes'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorSystem.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
