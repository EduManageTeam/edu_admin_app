import 'package:edu_admin/feature/parent_screen/model/parent_model.dart';
import 'package:edu_admin/feature/parent_screen/provider/parent_provider.dart';
import 'package:edu_admin/feature/parent_screen/view/widgets/field_widget.dart';
import 'package:edu_admin/feature/teacher_screen/view/util/string_util.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/profilecard_widget.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditParentScreen extends ConsumerStatefulWidget {
  final ParentModel parent;
  final String? loginId;
  final String? joined;
  final List<ParentChildModel> linkedChildren;

  const EditParentScreen({
    super.key,
    required this.parent,
    this.loginId,
    this.joined,
    this.linkedChildren = const [],
  });

  @override
  ConsumerState<EditParentScreen> createState() => _EditParentScreenState();
}

class _EditParentScreenState extends ConsumerState<EditParentScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late String _gender;

  bool _isSaving = false;
  bool _isResetting = false;

  @override
  void initState() {
    super.initState();

    final parent = widget.parent;

    _nameController = TextEditingController(text: parent.name);
    _phoneController = TextEditingController(text: parent.phone);
    _emailController = TextEditingController(text: parent.email ?? '');
    _addressController = TextEditingController(text: parent.address);

    final gender = parent.gender.trim().toLowerCase();

    _gender = ['male', 'female', 'other'].contains(gender) ? gender : 'other';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          'Edit Parent',
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
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
                  children: [
                    _editHeader(),
                    const SizedBox(height: 14),
                    _personalForm(),
                    const SizedBox(height: 14),
                    _loginInfo(),
                    const SizedBox(height: 14),
                    _linkedChildren(),
                  ],
                ),
              ),

              // Fixed bottom buttons
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                decoration: BoxDecoration(
                  color: ColorSystem.surface,
                  border: Border(top: BorderSide(color: ColorSystem.border)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 14,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
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
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isSaving || _isResetting
                            ? null
                            : _saveParent,
                        icon: _isSaving
                            ? const SizedBox(
                                width: 16,
                                height: 16,
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
                            borderRadius: BorderRadius.circular(14),
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

  Widget _childRow(ParentChildModel child) {
    final studentClass = child.studentClass;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: ColorSystem.primary.withValues(alpha: 0.10),
        child: Text(
          getInitials(child.name),
          style: TextStyle(
            color: ColorSystem.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      title: Text(
        child.name,
        style: TextStyle(
          color: ColorSystem.lnk,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        studentClass == null
            ? 'No class assigned'
            : 'Grade ${studentClass.grade} • '
                  '${studentClass.name} • Room ${studentClass.room}',
        style: TextStyle(color: ColorSystem.muted, fontSize: 11),
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: ColorSystem.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: ColorSystem.lnk,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _editHeader() {
    final assigned = widget.parent.childrenCount > 0;
    final data = widget.parent;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: cardDecoration(),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: ColorSystem.primary.withValues(alpha: 0.10),
            child: Text(
              getInitials(data.name),
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: ColorSystem.primary,
              ),
            ),
          ),
          SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ColorSystem.lnk,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Parent ID #${data.id}',
                  style: TextStyle(color: ColorSystem.muted, fontSize: 12),
                ),
                SizedBox(height: 7),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      assigned
                          ? Icons.check_circle_outline_rounded
                          : Icons.info_outline_rounded,
                      size: 13,
                      color: assigned
                          ? ColorSystem.success
                          : ColorSystem.warning,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      assigned ? 'Assigned' : 'Unassigned',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: assigned
                            ? ColorSystem.success
                            : ColorSystem.warning,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _personalForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Personal Information', Icons.person_outline_rounded),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: cardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              field(
                label: 'Full Name',
                controller: _nameController,
                requiredField: true,
              ),
              const SizedBox(height: 14),
              Text(
                'Gender',
                style: TextStyle(
                  color: ColorSystem.lnk,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _gender,
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('Male')),
                  DropdownMenuItem(value: 'female', child: Text('Female')),
                  DropdownMenuItem(value: 'other', child: Text('Other')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _gender = value);
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: ColorSystem.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide(color: ColorSystem.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide(
                      color: ColorSystem.primary,
                      width: 1.8,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              field(
                label: 'Phone',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                requiredField: true,
                validator: (value) {
                  final phone = value?.trim() ?? '';
                  if (phone.isEmpty) return 'Phone is required';
                  if (!RegExp(r'^[0-9+\s-]{8,15}$').hasMatch(phone)) {
                    return 'Enter a valid phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 14),
              field(
                label: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  final email = value?.trim() ?? '';
                  if (email.isEmpty) return null;
                  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 14),
              field(
                label: 'Address',
                controller: _addressController,
                maxLines: 2,
                requiredField: true,
              ),
              if (widget.joined != null) ...[
                const SizedBox(height: 14),
                Text(
                  'Joined: ${widget.joined}',
                  style: TextStyle(color: ColorSystem.muted, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _loginInfo() {
    final loginId = widget.loginId?.trim() ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Login Information', Icons.lock_outline_rounded),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: cardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.badge_outlined,
                    color: ColorSystem.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Login ID',
                    style: TextStyle(color: ColorSystem.muted, fontSize: 12),
                  ),
                  const Spacer(),
                  Flexible(
                    child: Text(
                      loginId.isEmpty ? 'Not available' : loginId,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: ColorSystem.lnk,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Copy Login ID',
                    onPressed: loginId.isEmpty
                        ? null
                        : () async {
                            await Clipboard.setData(
                              ClipboardData(text: loginId),
                            );
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Login ID copied'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                    icon: Icon(
                      Icons.copy_rounded,
                      size: 19,
                      color: ColorSystem.primary,
                    ),
                  ),
                ],
              ),
              Divider(),
              SizedBox(height: 8),
              Text(
                'Reset Parent Password',
                style: TextStyle(
                  color: ColorSystem.lnk,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 12),
              field(label: 'New Password', controller: _passwordController),
              SizedBox(height: 12),
              field(
                label: 'Confirm Password',
                controller: _confirmPasswordController,
              ),
              SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isSaving || _isResetting ? null : _resetPassword,
                  icon: _isResetting
                      ? const SizedBox(
                          width: 17,
                          height: 17,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.lock_reset_rounded),
                  label: Text(_isResetting ? 'Resetting...' : 'Reset Password'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ColorSystem.primary,
                    minimumSize: const Size.fromHeight(46),
                    side: BorderSide(color: ColorSystem.primary),
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
    );
  }

  Widget _linkedChildren() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Linked Children', Icons.family_restroom_rounded),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: cardDecoration(),
          child: widget.linkedChildren.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'No linked children',
                      style: TextStyle(color: ColorSystem.muted, fontSize: 12),
                    ),
                  ),
                )
              : Column(
                  children: [
                    for (int i = 0; i < widget.linkedChildren.length; i++) ...[
                      _childRow(widget.linkedChildren[i]),
                      if (i < widget.linkedChildren.length - 1)
                        Divider(color: ColorSystem.border),
                    ],
                  ],
                ),
        ),
      ],
    );
  }

  bool _validatePassword() {
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    String? message;

    if (password.isEmpty || confirm.isEmpty) {
      message = 'Please enter and confirm the new password';
    } else if (password.length < 8) {
      message = 'Password must be at least 8 characters';
    } else if (password != confirm) {
      message = 'Passwords do not match';
    }

    if (message != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      return false;
    }

    return true;
  }

  // Reset parent password
  Future<void> _resetPassword() async {
    if (_isSaving || _isResetting) return;
    if (!_validatePassword()) return;

    setState(() => _isResetting = true);

    try {
      await ref
          .read(parentProvider.notifier)
          .resetParentPassword(
            parentId: widget.parent.id,
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
          );

      if (!mounted) return;

      _passwordController.clear();
      _confirmPasswordController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Parent password reset successfully'),
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
        setState(() => _isResetting = false);
      }
    }
  }

  // Save parent personal information
  Future<void> _saveParent() async {
    if (_isSaving || _isResetting) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSaving = true);

    final updatedParent = ParentModel(
      id: widget.parent.id,
      name: _nameController.text.trim(),
      gender: _gender,
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      address: _addressController.text.trim(),
      photo: widget.parent.photo,
      childrenCount: widget.parent.childrenCount,
    );

    try {
      await ref
          .read(parentProvider.notifier)
          .updateParent(widget.parent.id, updatedParent);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Parent updated successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to update parent: $error'),
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
}
