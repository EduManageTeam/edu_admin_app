import 'package:edu_admin/feature/home_feature/service/auth_service.dart';
import 'package:edu_admin/feature/parent_screen/model/parent_model.dart';
import 'package:edu_admin/feature/parent_screen/service/parent_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Authentication token state
final authTokenProvider = FutureProvider<String?>((ref) async {
  return await AuthService.getToken();
});

// parent service provider
final parentServiceProvider = FutureProvider<ParentService>((ref) async {
  final token = await ref.watch(authTokenProvider.future);

  if (token == null || token.trim().isEmpty) {
    throw StateError('Admin is not logged in');
  }

  return ParentService(token: token);
});

class ParentNotifier extends AsyncNotifier<List<ParentModel>> {
  Future<ParentService> get service => ref.read(parentServiceProvider.future);

  @override
  Future<List<ParentModel>> build() async {
    final parentService = await ref.watch(parentServiceProvider.future);
    return parentService.getAllParents();
  }

  // reload all parent data 
  Future<void> laoding() async {
    ref.invalidateSelf();
    await future;
  }
  // add or create
  Future<void> addParent(ParentModel parent) async {
    final parentService = await service;
    await parentService.addParent(parent);
    ref.invalidateSelf();
  }
  // update
  Future<void> updateParent(int id, ParentModel parent) async {
    final parentService = await service;
    await parentService.updateParent(id, parent.toJson());
    ref.invalidateSelf();
  }
  // delete
  Future<void> deleteParent(int id) async {
    final parentService = await service;
    await parentService.deleteParent(id);
    ref.invalidateSelf();
  }
}

// Parent state provider
final parentProvider = AsyncNotifierProvider<ParentNotifier, List<ParentModel>>(
  ParentNotifier.new,
);
