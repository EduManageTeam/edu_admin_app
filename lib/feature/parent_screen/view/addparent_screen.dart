import 'package:edu_admin/feature/parent_screen/provider/parent_provider.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/dropdown_widget.dart';
import 'package:edu_admin/feature/teacher_screen/view/widgets/textfield_widget.dart';
import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddparentScreen extends ConsumerWidget {
  const AddparentScreen({super.key});

  // Create parent
  Future<void> _submit(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(addParentFormProvider.notifier);

    if (ref.read(addParentFormProvider).isCreating) {
      return;
    }

    // Validate form before submitting
    if (!(notifier.formKey.currentState?.validate() ?? false)) {
      return;
    }

    try {
      await notifier.createParent();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Parent created successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context, true);
    } catch (error, stackTrace) {
      debugPrint('ADD PARENT ERROR: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to create parent: $error'),
          backgroundColor: ColorSystem.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(addParentFormProvider);
    final form = ref.read(addParentFormProvider.notifier);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorSystem.appBG,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: ColorSystem.light,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                children: [
                  IconButton(
                    onPressed: formState.isCreating
                        ? null
                        : () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    color: ColorSystem.lnk,
                  ),
                  const SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Parent',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ColorSystem.lnk,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Complete the required information',
                        style: TextStyle(
                          fontSize: 11,
                          color: ColorSystem.muted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Form(
                  key: form.formKey,
                  child: Column(
                    children: [
                      // Login ID
                      buildTextField(
                        label: 'Login ID',
                        hint: 'Automatically assigned',
                        controller: form.userIdController,
                        readOnly: true,
                      ),

                      const SizedBox(height: 12),

                      // Full name
                      buildTextField(
                        label: 'Full name',
                        hint: 'Parent name',
                        controller: form.nameController,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Required';
                          }

                          if (value.trim().length < 2) {
                            return 'Name must be at least 2 characters';
                          }

                          return null;
                        },
                      ),

                      SizedBox(height: 12),

                      // Gender
                      buildDropdown(
                        label: 'Gender',
                        hint: 'Select gender',
                        items: const ['Male', 'Female', 'Other'],
                        value: formState.gender,
                        onChanged: form.setGender,
                        validator: (value) {
                          return value == null ? 'Required' : null;
                        },
                      ),

                      SizedBox(height: 12),

                      // Phone
                      buildTextField(
                        label: 'Phone',
                        hint: 'Phone number',
                        controller: form.phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return null;
                          }

                          return form.isValidPhone(value)
                              ? null
                              : 'Invalid phone';
                        },
                      ),

                      SizedBox(height: 12),

                      // Email
                      buildTextField(
                        label: 'Email',
                        hint: 'Email address',
                        controller: form.emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return null;
                          }

                          return form.isValidEmail(value.trim())
                              ? null
                              : 'Invalid email';
                        },
                      ),

                      SizedBox(height: 12),

                      // Address
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Address',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: ColorSystem.lnk,
                            ),
                          ),

                          SizedBox(height: 7),

                          TextFormField(
                            controller: form.addressController,
                            keyboardType: TextInputType.multiline,
                            textCapitalization: TextCapitalization.sentences,
                            minLines: 3,
                            maxLines: 5,
                            maxLength: 255,
                            textAlignVertical: TextAlignVertical.top,
                            cursorColor: ColorSystem.primary,
                            style: TextStyle(
                              fontSize: 13,
                              color: ColorSystem.lnk,
                            ),
                            decoration: InputDecoration(
                              hintText:
                                  'Street, village, commune, district, city...',
                              hintStyle: TextStyle(
                                color: ColorSystem.muted,
                                fontSize: 12,
                              ),
                              filled: true,
                              fillColor: ColorSystem.surface,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 15,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: ColorSystem.border,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: ColorSystem.border,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: ColorSystem.primary,
                                  width: 1.5,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: ColorSystem.danger,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),

                      // Create button
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: formState.isCreating
                              ? null
                              : () => _submit(context, ref),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorSystem.primary,
                            foregroundColor: ColorSystem.surface,
                            disabledBackgroundColor: ColorSystem.primary
                                .withValues(alpha: 0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                            shadowColor: ColorSystem.primary.withValues(
                              alpha: 0.3,
                            ),
                          ),
                          child: formState.isCreating
                              ? SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Create parent',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.person_add_alt_1, size: 20),
                                  ],
                                ),
                        ),
                      ),

                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
