import 'package:edu_admin/feature/home_feature/service/auth_service.dart';
import 'package:edu_admin/feature/home_feature/view/sign_in_screen.dart';
import 'package:edu_admin/feature/main_shell/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding); // keep splash up

  final token = await AuthService.getToken();
  final loggedIn = token != null && token.isNotEmpty;

  runApp(ProviderScope(child: MyApp(loggedIn: loggedIn)));
  FlutterNativeSplash.remove(); // hide splash, app is ready
}

class MyApp extends StatelessWidget {
  final bool loggedIn;
  const MyApp({super.key, required this.loggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: loggedIn ? const MainScreen() : const SignInScreen(),
    );
  }
}
