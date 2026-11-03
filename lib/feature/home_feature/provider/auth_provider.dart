import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../service/auth_service.dart';

/// State of the sign-in form.
class AuthState {
  final bool isLoading;
  final String? error;

  const AuthState({this.isLoading = false, this.error});
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  /// Returns true when the login worked (the token is saved).
  Future<bool> login(String userId, String password) async {
    if (userId.isEmpty || password.isEmpty) {
      state = const AuthState(error: 'Please enter your ID and password.');
      return false;
    }
    state = const AuthState(isLoading: true);
    try {
      await AuthService.login(userId, password);
      state = const AuthState();
      return true;
    } catch (e) {
      state = AuthState(error: e.toString().replaceFirst('Exception: ', ''));
      return false;
    }
  }
}

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
