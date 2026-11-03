import 'dart:convert';

import 'package:edu_admin/feature/teacher_screen/model/teacher_model.dart';
import 'package:edu_admin/feature/teacher_screen/provider/teacher_proivder.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/edit_teacher_header.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/edit_teacher_personal_form.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/edit_teacher_login_info.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/edit_teacher_classes.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

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

  // Existing or newly selected Base64 photo
  String? _photoBase64;

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

    // Load existing photo
    _photoBase64 = teacher.photo;

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

  // Pick teacher photo from camera or gallery
  Future<void> _pickPhoto(ImageSource source) async {
    if (_isSaving || _isResetting) return;

    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (picked == null) return;

      final bytes = await picked.readAsBytes();

      // Same maximum decoded photo size as Laravel: 2 MB
      if (bytes.length > 2 * 1024 * 1024) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Photo must not exceed 2 MB'),
            backgroundColor: ColorSystem.danger,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final base64String = base64Encode(bytes);

      if (!mounted) return;

      setState(() {
        _photoBase64 = base64String;
      });

      debugPrint('Teacher photo selected successfully');
      debugPrint('Photo size: ${bytes.length} bytes');
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to select photo: $error'),
          backgroundColor: ColorSystem.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Show camera/gallery options
  void _showPhotoOptions() {
    if (_isSaving || _isResetting) return;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: ColorSystem.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: ColorSystem.border,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'Change Teacher Photo',
                  style: TextStyle(
                    color: ColorSystem.lnk,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 14),

                ListTile(
                  leading: Icon(
                    Icons.camera_alt_outlined,
                    color: ColorSystem.primary,
                  ),
                  title: const Text('Take Photo'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickPhoto(ImageSource.camera);
                  },
                ),

                ListTile(
                  leading: Icon(
                    Icons.photo_library_outlined,
                    color: ColorSystem.primary,
                  ),
                  title: const Text('Choose Photo'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickPhoto(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
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
                    // Header: profile photo with camera edit icon
                    EditTeacherHeader(
                      teacher: widget.teacher,
                      status: _status,
                      photoBase64: _photoBase64,
                      onEditPhoto: _showPhotoOptions,
                    ),

                    const SizedBox(height: 14),

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

                    const SizedBox(height: 14),

                    // Login information
                    EditTeacherLoginInfo(
                      loginId: widget.loginId,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      isResetting: _isResetting,
                      onResetPassword: _resetPassword,
                    ),

                    const SizedBox(height: 14),

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
                        child: const Text('Cancel'),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Save changes
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isSaving || _isResetting
                            ? null
                            : _saveTeacher,
                        icon: _isSaving
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.save_rounded, size: 18),
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

  // Save teacher information and photo
  Future<void> _saveTeacher() async {
    if (_isSaving || _isResetting) return;

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final updatedTeacher = TeacherModel(
      id: widget.teacher.id,
      name: _nameController.text.trim(),
      gender: _gender,
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      address: _addressController.text.trim(),

      // Existing or newly selected Base64 photo
      photo: _photoBase64,

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
      debugPrint('UPDATE TEACHER ERROR: $error');

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
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}
