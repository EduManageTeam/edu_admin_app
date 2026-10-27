import 'dart:async';

import 'package:edu_admin/feature/parent_screen/model/parent_model.dart';
import 'package:edu_admin/feature/parent_screen/service/parent_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ParentNotifier extends AsyncNotifier<List<ParentModel>> {
  final ParentService service = ParentService();

  @override
  Future<List<ParentModel>> build() async {
    return await service.getAllParents();
  }

  // reload all parent data
  Future<void> loading() async {
    state = const AsyncLoading();
    // auto catches errors & turns it into an AsyncError state
    state = await AsyncValue.guard(() => service.getAllParents());
  }

  // add new parent
  Future<void> addParent(ParentModel parent) async {
    state = const AsyncLoading();
    final newParent = await service.addParent(parent);

    if (newParent != null) {
      await loading();
    } else {
      await loading();
      throw Exception("Failed to add parent. Please try again.");
    }
  }

  // update parent
  Future<void> updateParent(int id, ParentModel parent) async {
    state = const AsyncLoading();
    final updatedParent = await service.updateParent(id, parent.toJson());

    if (updatedParent != null) {
      await loading();
    } else {
      await loading();
      throw Exception("Failed to update parent. Please try again."); // Failure
    }
  }

  // delete parent
  Future<void> deleteParent(int id) async {
    state = const AsyncLoading();
    final isDelete = await service.deleteParent(id);

    if (isDelete) {
      await loading();
    } else {
      await loading();
      throw Exception(
        "Failed to delete parent. They may have already been removed.",
      ); // Failure
    }
  }
}

final parentProvider = AsyncNotifierProvider<ParentNotifier, List<ParentModel>>(
  ParentNotifier.new,
);
