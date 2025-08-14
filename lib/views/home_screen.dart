// lib/views/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;

    // بيانات تجريبية (يمكن استبدالها لاحقاً ببيانات API)
    final items = List.generate(12, (i) => 'منتج ${i + 1}');

    // ✅ صورة المنتج التجريبية
    const dummyProductImage = 'assets/images/ProDemo.jpg';

    // ✅ ارتفاع مرن للّوغو، مع حد أدنى/أقصى
    final logoHeight = (screenHeight * 0.045).clamp(28.0, 48.0);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.only(
              top: screenHeight * 0.12,
              bottom: screenHeight * 0.04,
            ),
            child: Column(
              children: [
                // ===== Header: شعار يسار + مساحة يمين فارغة =====
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                  child: Directionality(
                    textDirection: TextDirection.ltr, // يضمن بقاء الشعار "يسار"
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/logoApp.svg',
                          height: logoHeight,
                          fit: BoxFit.contain,
                          semanticsLabel: 'شعار التطبيق',
                          placeholderBuilder: (_) => SizedBox(
                            height: logoHeight,
                            width: logoHeight,
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(height: 1, thickness: 1),
                const SizedBox(height: 16),

                // ===== Grid المنتجات =====
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: items.length,
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 180, // ~3 أعمدة على الموبايل
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 22,
                        childAspectRatio: 0.9,
                      ),
                      itemBuilder: (context, index) {
                        return _ProductCard(
                          title: items[index],
                          imagePath: dummyProductImage,
                          onBuy: () => _confirmBuy(context),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                const Text(
                  'جميع الحقوق محفوظة',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmBuy(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'تم الشراء',
          textDirection: TextDirection.rtl,
          style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'شكراً لطلبك! تم تأكيد عملية الشراء.',
          textDirection: TextDirection.rtl,
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('حسناً', style: TextStyle(fontFamily: 'Tajawal')),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onBuy;

  const _ProductCard({
    required this.title,
    required this.imagePath,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // صورة المنتج
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(color: const Color(0xFFD9D9D9));
                  },
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: [
                          Colors.black.withValues(alpha: 0.08), // ✅ بدل withOpacity
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // زر "اطلب الآن"
        Semantics(
          button: true,
          label: 'اطلب الآن لـ $title',
          child: SizedBox(
            width: double.infinity,
            height: 38,
            child: ElevatedButton(
              onPressed: onBuy,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF0000),
                foregroundColor: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('اطلب الآن'),
            ),
          ),
        ),
      ],
    );
  }
}
