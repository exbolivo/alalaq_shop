// lib/views/splash_screen.dart
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:alalaq_shop/views/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const Duration kSplashDuration = Duration(milliseconds: 1800);
  Timer? _timer;

  // استعمل شعار مخصص للسلاش بدون دائرة وخلفية شفافة
  final ImageProvider _logoProvider =
  const AssetImage('assets/images/splash_logo.png');

  @override
  void initState() {
    super.initState();
    _timer = Timer(kSplashDuration, _goNext);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // تحميل الشعار مسبقًا لتفادي أي وميض
    precacheImage(_logoProvider, context);
  }

  void _goNext() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
    );
    // أو: Navigator.of(context).pushReplacementNamed('/welcome');
  }

  @override
  void dispose() {
    _timer?.cancel(); // أمان عند إغلاق الصفحة
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final shortestSide = math.min(size.width, size.height);

    return Scaffold(
      backgroundColor: const Color(0xFFb1e2f3), // نفس اللون المطلوب
      body: Center(
        child: Image(
          image: _logoProvider,
          width: shortestSide * 0.35, // حجم متوازن لكل الأجهزة
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}
