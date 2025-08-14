import 'dart:async';
import 'package:flutter/material.dart';

import 'views/welcome_screen.dart';
import 'views/home_screen.dart';
import 'views/login_screen.dart';
import 'views/register_screen.dart';
import 'views/forgot_password_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String appTitle = 'Alalaq Shop';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Tajawal',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      // شاشة الإقلاع (Flutter screen بعد نظام أندرويد)
      home: const SplashScreen(),

      // المسارات المسماة
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // وقت الإقلاع (قصير لتقليل الانتظار)
    _timer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return; // حماية من استدعاء Navigator بعد التخلص من الودجت
      Navigator.of(context).pushReplacementNamed('/welcome');
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // أزلنا السطر غير المستخدم:
    // final screenHeight = MediaQuery.of(context).size.height;
    return const _SplashScaffold();
  }
}

class _SplashScaffold extends StatelessWidget {
  const _SplashScaffold();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFB1E2F3), // نفس لون شاشة النظام
      body: SafeArea(
        child: Center(
          child: Image.asset(
            'assets/images/iconApp.png',
            height: screenHeight * 0.25,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
