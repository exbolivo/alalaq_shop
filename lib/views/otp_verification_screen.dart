import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

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

            // ✅ شعار التطبيق
            Center(
              child: SvgPicture.asset(
                'assets/images/logoApp.svg',
                width: screenWidth * 0.55, // ✅ تم تعديل الحجم هنا ليكون موحدًا مع الصفحات الأخرى
              ),
            ),

            SizedBox(height: screenHeight * 0.08),

            // ✅ العنوان
            const Text(
              'أدخل رمز التحقق',
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: screenHeight * 0.03),

            // ✅ مربعات الرمز - تصميم مبدئي يدوي لـ 6 خانات
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                return Container(
                  width: 40,
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFBFBFBF), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '-', // placeholder
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                );
              }),
            ),

            SizedBox(height: screenHeight * 0.03),

            // ✅ النص التعريفي
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'تم إرسال رمز مكوّن من 6 أرقام إلى بريدك الإلكتروني',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Tajawal',
                  color: Colors.black,
                ),
              ),
            ),

            const Spacer(),

            // ✅ زر تأكيد الرمز
            SizedBox(
              width: screenWidth * 0.7,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // تنفيذ تأكيد الرمز
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF0000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'تأكيد الرمز',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Tajawal',
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            // ✅ النص السفلي
            const Text(
              'لم يصلك الرمز؟ أعد الإرسال خلال 30 ثانية',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Tajawal',
                color: Colors.black,
              ),
            ),

            SizedBox(height: screenHeight * 0.04),
          ],
        ),
      ),
    );
  }
}
