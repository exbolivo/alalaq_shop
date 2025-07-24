import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

            // ✅ الشعار
            Center(
              child: SvgPicture.asset(
                'assets/images/logoApp.svg',
                width: screenWidth * 0.55, // ✅ تم تعديل الحجم هنا ليكون موحدًا مع باقي الصفحات
              ),
            ),

            SizedBox(height: screenHeight * 0.12),

            // ✅ الأزرار الأربعة
            buildButton(context, screenWidth, 'لوحة تحكم البائع'),
            SizedBox(height: screenHeight * 0.015),
            buildButton(context, screenWidth, 'لوحة تحكم العميل'),
            SizedBox(height: screenHeight * 0.015),
            buildButton(context, screenWidth, 'متاجر المشتركين'),
            SizedBox(height: screenHeight * 0.015),
            buildButton(context, screenWidth, 'المنتجات'),

            const Spacer(),

            // ✅ الجملة السفلية
            const Text(
              'سيتم التحديث قريبًا',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 16,
                color: Colors.black,
              ),
            ),

            SizedBox(height: screenHeight * 0.04),
          ],
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context, double screenWidth, String title) {
    return SizedBox(
      width: screenWidth * 0.7,
      height: 45,
      child: ElevatedButton(
        onPressed: () {
          // TODO: تنفيذ التنقل لاحقًا
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF0000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'Tajawal',
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
