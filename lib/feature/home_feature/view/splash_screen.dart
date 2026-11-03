import 'dart:async';

import 'package:edu_admin/feature/home_feature/view/sign_in_screen.dart';
import 'package:flutter/material.dart';

import '../../../model/color_system.dart';
import '../../main_shell/main_screen.dart';
import '../service/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _dotsTimer;
  int _dots = 0; // 0 -> 1 -> 2 -> 3 -> back to 0

  @override
  void initState() {
    super.initState();

    // Animate the dots: nothing -> . -> .. -> ... and loop
    _dotsTimer = Timer.periodic(const Duration(milliseconds: 400), (_) {
      setState(() {
        _dots = (_dots + 1) % 4;
      });
    });

    _goNext();
  }

  // Decide where to go: saved token -> main screen, no token -> sign in
  Future<void> _goNext() async {
    final token = await AuthService.getToken();
    await Future.delayed(const Duration(seconds: 2)); // show the splash a bit
    if (!mounted) return;

    final loggedIn = token != null && token.isNotEmpty;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => loggedIn ? const MainScreen() : const SignInScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _dotsTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSystem.primary,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const Spacer(flex: 3),
              // Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: ColorSystem.surface,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  'E',
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                    color: ColorSystem.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'EduSchool',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: ColorSystem.surface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Executive App',
                style: TextStyle(fontSize: 18, color: ColorSystem.light),
              ),
              const SizedBox(height: 16),
              Text(
                'School Management System',
                style: TextStyle(fontSize: 13, color: ColorSystem.light),
              ),
              const Spacer(flex: 4),
              // Loading text: the dots sit in a fixed-width box,
              // so the words do not move while the dots change
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Loading secure workspace',
                    style: TextStyle(fontSize: 12, color: ColorSystem.light),
                  ),
                  SizedBox(
                    width: 14,
                    child: Text(
                      '.' * _dots,
                      style: TextStyle(fontSize: 12, color: ColorSystem.light),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
