// lib/views/forgot_password_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../helpers/navigator_helper.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    final r = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return r.hasMatch(email);
  }

  Future<void> resetPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      showMessage('يرجى إدخال البريد الإلكتروني');
      return;
    }
    if (!_isValidEmail(email)) {
      showMessage('صيغة البريد الإلكتروني غير صحيحة');
      return;
    }

    setState(() => isLoading = true);

    try {
      final url = Uri.parse('https://sawashop.vip/wp-json/custom/v1/forgot-password');
      final response = await http
          .post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      )
          .timeout(const Duration(seconds: 20));

      if (!mounted) return;
      setState(() => isLoading = false);

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = jsonDecode(response.body);
        if (result['success'] == true) {
          showMessage('تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني');
        } else {
          showMessage(result['message'] ?? 'حدث خطأ أثناء إرسال الرابط');
        }
      } else if (response.statusCode == 404) {
        showMessage('البريد الإلكتروني غير مسجل');
      } else {
        showMessage('تعذر إكمال الطلب. رمز الحالة: ${response.statusCode}');
      }
    } on SocketException {
      if (!mounted) return;
      setState(() => isLoading = false);
      showMessage('لا يوجد اتصال بالإنترنت. حاول مجددًا.');
    } on TimeoutException {
      if (!mounted) return;
      setState(() => isLoading = false);
      showMessage('انتهت مهلة الاتصال. تحقق من الإنترنت ثم أعد المحاولة');
    } on FormatException {
      if (!mounted) return;
      setState(() => isLoading = false);
      showMessage('استجابة غير متوقعة من الخادم');
    } catch (_) {
      if (!mounted) return;
      setState(() => isLoading = false);
      showMessage('حدث خطأ غير متوقع. حاول مرة أخرى');
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, textAlign: TextAlign.center)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB1E2F3),
      // ✅ نفس النمط: نسمح برفع الواجهة مع الكيبورد
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(), // إغلاق الكيبورد عند اللمس بالخارج
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                // ❌ لا نضيف padding سفلي هنا
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: _buildContent(context),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Column(
      children: [
        SizedBox(height: h * 0.12),

        Center(
          child: SvgPicture.asset(
            'assets/images/logoApp.svg',
            width: w * 0.55,
          ),
        ),

        SizedBox(height: h * 0.10),

        const Text(
          'نسيت كلمة المرور؟',
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: h * 0.02),

        SizedBox(
          width: w * 0.7, // ✅ 70% من عرض الشاشة
          child: TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => isLoading ? null : resetPassword(),
            autofillHints: const [AutofillHints.username, AutofillHints.email],
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 20, fontFamily: 'Tajawal'),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // ✅ 20/10
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: SvgPicture.asset(
                  'assets/icons/iconEmail.svg',
                  width: 20,
                  height: 20,
                  fit: BoxFit.scaleDown,
                ),
              ),
              hintText: 'البريد الإلكتروني',
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
                fontFamily: 'Tajawal',
              ),
              filled: true,
              fillColor: const Color(0xFFF9F9F9),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFBFBFBF), width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFBFBFBF), width: 2.0),
              ),
            ),
          ),
        ),

        SizedBox(height: h * 0.02),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'أدخل بريدك الإلكتروني وسنرسل لك رابطًا لإعادة تعيين كلمة المرور',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontFamily: 'Tajawal', color: Colors.black),
          ),
        ),

        const Spacer(),

        // ✅ الجزء السفلي يرتفع ديناميكيًا بقدر ارتفاع الكيبورد
        SafeArea(
          top: false,
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: [
                SizedBox(
                  width: w * 0.7,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : resetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF0000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      'استعادة كلمة المرور',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Tajawal',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: h * 0.04),

                GestureDetector(
                  onTap: () => goBack(context),
                  child: const Text.rich(
                    TextSpan(
                      text: 'لديك حساب؟ ',
                      style: TextStyle(fontSize: 16, fontFamily: 'Tajawal', color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'تسجيل دخول',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: h * 0.04),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
