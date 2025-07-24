import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'login_screen.dart'; // ✅ تأكد أن المسار صحيح

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFB1E2F3), // ✅ تم تعديل لون الخلفية هنا
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.12),

            // ✅ الشعار بالحجم الموحد مع صفحة تسجيل الدخول
            Center(
              child: SvgPicture.asset(
                'assets/images/logoApp.svg',
                width: screenWidth * 0.55, // ✅ نفس الحجم تمامًا
              ),
            ),

            const Spacer(),

            // ✅ الزر + النص
            Column(
              children: [
                SizedBox(
                  width: screenWidth * 0.7,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF0000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'سجل الآن',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Tajawal',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.012),

                const Text(
                  'مرحبًا بك في تطبيقنا',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: screenHeight * 0.04),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
