import 'dart:convert';

import 'package:edu_admin/model/color_system.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatelessWidget {
  final String title;
  final ValueChanged<String> onImageSelected;
  final bool isDisabled;

  const ImagePickerWidget({
    super.key,
    this.title = 'Change Photo',
    required this.onImageSelected,
    this.isDisabled = false,
  });

  static Future<void> show(
    BuildContext context, {
    String title = 'Change Photo',
    required ValueChanged<String> onImageSelected,
    bool isDisabled = false,
  }) {
    if (isDisabled) {
      return Future.value();
    }

    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: ColorSystem.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ImagePickerWidget(
        title: title,
        onImageSelected: onImageSelected,
        isDisabled: isDisabled,
      ),
    );
  }

  // Pick photo from camera or gallery
  Future<void> _pickPhoto(BuildContext context, ImageSource source) async {
    if (isDisabled) return;

    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (picked == null) return;

      final bytes = await picked.readAsBytes();

      // Maximum photo size: 2 MB
      if (bytes.length > 2 * 1024 * 1024) {
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Photo must not exceed 2 MB'),
            backgroundColor: ColorSystem.danger,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final base64String = base64Encode(bytes);

      if (!context.mounted) return;

      onImageSelected(base64String);

      debugPrint('Photo selected successfully');
      debugPrint('Photo size: ${bytes.length} bytes');
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to select photo: $error'),
          backgroundColor: ColorSystem.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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

            SizedBox(height: 16),

            Text(
              title,
              style: TextStyle(
                color: ColorSystem.lnk,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(height: 14),

            // Camera option
            ListTile(
              leading: Icon(
                Icons.camera_alt_outlined,
                color: ColorSystem.primary,
              ),
              title: const Text('Take Photo'),
              onTap: isDisabled
                  ? null
                  : () {
                      // Capture screen context before closing sheet
                      final screenContext = Navigator.of(
                        context,
                        rootNavigator: false,
                      ).context;

                      Navigator.pop(context);

                      _pickPhoto(screenContext, ImageSource.camera);
                    },
            ),

            // Gallery option
            ListTile(
              leading: Icon(
                Icons.photo_library_outlined,
                color: ColorSystem.primary,
              ),
              title: const Text('Choose Photo'),
              onTap: isDisabled
                  ? null
                  : () {
                      final screenContext = Navigator.of(
                        context,
                        rootNavigator: false,
                      ).context;

                      Navigator.pop(context);

                      _pickPhoto(screenContext, ImageSource.gallery);
                    },
            ),
          ],
        ),
      ),
    );
  }
}
