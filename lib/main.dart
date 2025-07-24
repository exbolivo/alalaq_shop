import 'package:flutter/material.dart';
import 'views/welcome_screen.dart'; // ✅ شاشة البداية
import 'views/home_screen.dart';   // ✅ تأكد من وجود هذا الملف

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alalaq Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Tajawal',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),

      // ✅ إضافة التوجيه
      routes: {
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
