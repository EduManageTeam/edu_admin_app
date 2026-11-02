import 'dart:convert';

import 'package:edu_admin/feature/teacher_screen/model/teacher_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

ImageProvider? teacherAvatarProvider(TeacherModel teacher) {
  final photo = teacher.photo;

  if (photo == null || photo.trim().isEmpty) {
    return null;
  }

  try {
    final base64String = photo.contains(',') ? photo.split(',').last : photo;

    return MemoryImage(base64Decode(base64.normalize(base64String.trim())));
  } catch (e) {
    debugPrint('Invalid teacher photo: $e');
    return null;
  }
}

final teacherPhotoProvider = StateProvider.autoDispose<String?>((ref) => null);
