import 'package:flutter/material.dart';
import '../../../model/color_system.dart';
import 'dashboard_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  // Shared style for the text fields
  InputDecoration _inputStyle(String hint) {
    return InputDecoration(
      hintText: hint,
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
    return Scaffold(
      backgroundColor: ColorSystem.appBG,
      body: Column(
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
          Expanded(
            child: Padding(
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
                  TextField(decoration: _inputStyle('CEO-001')),
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
                    obscureText: true,
                    decoration: _inputStyle('••••••••'),
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
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DashboardScreen(),
                          ),
                        );
                      },
                      child: const Text(
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
          ),
        ],
      ),
    );
  }
}
