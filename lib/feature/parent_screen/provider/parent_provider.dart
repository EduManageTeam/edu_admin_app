import 'package:edu_admin/feature/home_feature/service/auth_service.dart';
import 'package:edu_admin/feature/parent_screen/model/parent_model.dart';
import 'package:edu_admin/feature/parent_screen/model/parentresponse_model.dart';
import 'package:edu_admin/feature/parent_screen/model/parentstat_model.dart';
import 'package:edu_admin/feature/parent_screen/service/parent_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Authentication token
final authTokenProvider = FutureProvider<String?>(
  (ref) => AuthService.getToken(),
);

// Parent service
final parentServiceProvider = FutureProvider<ParentService>((ref) async {
  final token = await ref.watch(authTokenProvider.future);

  if (token == null || token.trim().isEmpty) {
    throw StateError('Admin is not logged in');
  }

  return ParentService(token: token);
});

// Cache all parent info

final allParentDetailsProvider = FutureProvider<List<ParentDetailModel>>((
  ref,
) async {
  final totalTimer = Stopwatch()..start();
  try {
    final parentService = await ref.watch(parentServiceProvider.future);

    final apiTimer = Stopwatch()..start();

    final details = await parentService.getAllParentDetails();

    apiTimer.stop();

    debugPrint('Parent Api details: ${apiTimer.elapsedMilliseconds} ms');
    // debugPrint('total parent: ${details.length}');

    return details;
  } finally {
    totalTimer.stop();

    debugPrint('Total Parent Loading: ${totalTimer.elapsedMilliseconds} ms');
  }
});

// Search parents
final parentSearchProvider = StateProvider<String>((ref) => '');

// Filter parents
final parentFilterProvider = StateProvider<String>((ref) => 'all');

// Get parent list <- shared cache
final parentAllProvider = FutureProvider<ParentResponse>((ref) async {
  final details = await ref.watch(allParentDetailsProvider.future);

  final parents = details.map((detail) => detail.parent).toList();

  int linked = 0;
  int unlinked = 0;

  for (final parent in parents) {
    if (parent.childrenCount > 0) {
      linked++;
    } else {
      unlinked++;
    }
  }
  return ParentResponse(
    parents: parents,
    stats: ParentStats(
      total: parents.length,
      linked: linked,
      unlinked: unlinked,
    ),
  );
});

// Get parent profile <- cached list
final parentDetailProvider = FutureProvider.family<ParentDetailModel, int>((
  ref,
  parentId,
) async {
  final parents = await ref.watch(allParentDetailsProvider.future);

  for (final detail in parents) {
    if (detail.parent.id == parentId) {
      return detail;
    }
  }

  throw StateError('Parent not found: $parentId');
});

// Parent notifier
class ParentNotifier extends AsyncNotifier<ParentResponse> {
  Future<ParentService> get service => ref.read(parentServiceProvider.future);

  @override
  @override
  Future<ParentResponse> build() async {
    final search = ref.watch(parentSearchProvider);
    final filter = ref.watch(parentFilterProvider);

    final response = await ref.watch(parentAllProvider.future);

    final keyword = search.trim().toLowerCase();
    final selectedFilter = filter.trim().toLowerCase();

    // Reuse the original response if no filters are applied.
    if (keyword.isEmpty && selectedFilter == 'all') {
      return response;
    }

    // Filter cached data locally.
    final parents = response.parents.where((parent) {
      final matchesSearch =
          keyword.isEmpty ||
          parent.name.toLowerCase().contains(keyword) ||
          parent.phone.toLowerCase().contains(keyword) ||
          parent.id.toString() == keyword;

      final matchesFilter =
          selectedFilter == 'all' ||
          (selectedFilter == 'linked' && parent.childrenCount > 0) ||
          (selectedFilter == 'unlinked' && parent.childrenCount == 0);

      return matchesSearch && matchesFilter;
    }).toList();

    int linked = 0;
    int unlinked = 0;

    for (final parent in parents) {
      if (parent.childrenCount > 0) {
        linked++;
      } else {
        unlinked++;
      }
    }

    return ParentResponse(
      parents: parents,
      stats: ParentStats(
        total: parents.length,
        linked: linked,
        unlinked: unlinked,
      ),
    );
  }

  // Refresh parent list
  Future<void> loading() async {
    ref.invalidate(allParentDetailsProvider);

    await ref.read(allParentDetailsProvider.future);
  }

  // Add parent
  Future<void> addParent(ParentModel parent) async {
    final parentService = await service;

    await parentService.addParent(parent);

    ref.invalidate(allParentDetailsProvider);
  }

  // Update parent
  Future<void> updateParent(int id, ParentModel parent) async {
    final parentService = await service;

    await parentService.updateParent(id, {
      'name': parent.name,
      'gender': parent.gender,
      'phone': parent.phone,
      'email': parent.email,
      'address': parent.address,
      'photo': parent.photo,
    });

    ref.invalidate(allParentDetailsProvider);
  }

  // Delete parent
  Future<void> deleteParent(int id) async {
    final parentService = await service;

    await parentService.deleteParent(id);

    ref.invalidate(allParentDetailsProvider);
  }

  // Reset parent password (Admin only)
  Future<void> resetParentPassword({
    required int parentId,
    required String password,
    required String confirmPassword,
  }) async {
    final parentService = await service;

    await parentService.resetParentPassword(
      parentId: parentId,
      password: password,
      confirmPassword: confirmPassword,
    );
  }
}

// Parent provider
final parentProvider = AsyncNotifierProvider<ParentNotifier, ParentResponse>(
  ParentNotifier.new,
);

// Add parent form state
class AddParentFormState {
  final String? gender;
  final bool isCreating;

  const AddParentFormState({this.gender, this.isCreating = false});

  AddParentFormState copyWith({String? gender, bool? isCreating}) {
    return AddParentFormState(
      gender: gender ?? this.gender,
      isCreating: isCreating ?? this.isCreating,
    );
  }
}

// Add parent form notifier
class AddParentFormNotifier extends Notifier<AddParentFormState> {
  final formKey = GlobalKey<FormState>();

  final userIdController = TextEditingController(text: 'Auto assigned');

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  @override
  AddParentFormState build() {
    ref.onDispose(() {
      userIdController.dispose();
      nameController.dispose();
      phoneController.dispose();
      emailController.dispose();
      addressController.dispose();
    });

    return const AddParentFormState();
  }

  // Set gender
  void setGender(String? value) {
    state = state.copyWith(gender: value);
  }

  // Validate email
  bool isValidEmail(String value) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
  }

  // Validate phone
  bool isValidPhone(String value) {
    return RegExp(r'^[0-9+\s-]{8,15}$').hasMatch(value);
  }

  // Create parent
  Future<void> createParent() async {
    if (state.isCreating) return;

    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (state.gender == null) {
      throw StateError('Please select a gender.');
    }

    state = state.copyWith(isCreating: true);

    try {
      final parent = ParentModel(
        id: 0,
        name: nameController.text.trim(),
        gender: state.gender!.toLowerCase(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim().isEmpty
            ? null
            : emailController.text.trim(),
        address: addressController.text.trim(),
        photo: null,
        childrenCount: 0,
      );

      await ref.read(parentProvider.notifier).addParent(parent);
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isCreating: false);
      }
    }
  }
}

// Add parent form provider
final addParentFormProvider =
    NotifierProvider.autoDispose<AddParentFormNotifier, AddParentFormState>(
      AddParentFormNotifier.new,
    );
