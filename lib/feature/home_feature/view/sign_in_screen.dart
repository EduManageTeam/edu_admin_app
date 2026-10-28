import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/color_system.dart';
import '../../main_shell/main_screen.dart';
import '../provider/auth_provider.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  bool _hidePassword = true;

  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final success = await ref
        .read(authNotifierProvider.notifier)
        .login(_userIdController.text.trim(), _passwordController.text);
    if (!mounted) return;
    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    }
  }

  InputDecoration _inputStyle(String hint, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: ColorSystem.surface,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: ColorSystem.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: ColorSystem.primary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: ColorSystem.appBG,
      // The WHOLE page scrolls, so the keyboard never causes an overflow
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Red header
            Container(
              width: double.infinity,
              color: ColorSystem.primary,
              padding: const EdgeInsets.fromLTRB(24, 70, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EduSchool',
                    style: TextStyle(color: ColorSystem.surface, fontSize: 20),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Executive Portal',
                    style: TextStyle(
                      color: ColorSystem.surface,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Secure school leadership access',
                    style: TextStyle(color: ColorSystem.light, fontSize: 13),
                  ),
                ],
              ),
            ),

            // Form
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: ColorSystem.lnk,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Use your assigned User ID and password.',
                    style: TextStyle(color: ColorSystem.muted),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'User ID',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: ColorSystem.lnk,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _userIdController,
                    decoration: _inputStyle('CEO-001'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Password',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: ColorSystem.lnk,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: _hidePassword,
                    decoration: _inputStyle(
                      '••••••••',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hidePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: ColorSystem.muted,
                        ),
                        onPressed: () {
                          setState(() => _hidePassword = !_hidePassword);
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(color: ColorSystem.primary),
                      ),
                    ),
                  ),
                  if (authState.error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        authState.error!,
                        style: TextStyle(
                          color: ColorSystem.danger,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorSystem.primary,
                        foregroundColor: ColorSystem.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: authState.isLoading ? null : _signIn,
                      child: authState.isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Sign in',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Leadership accounts are created by the system administrator.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: ColorSystem.muted),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
