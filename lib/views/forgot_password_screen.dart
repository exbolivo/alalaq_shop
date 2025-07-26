import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  Future<void> resetPassword() async {
    // استخدام الايميل الوهمي
    final email = 'demo@demo.com';

    if (email.isEmpty) {
      showMessage('يرجى إدخال البريد الإلكتروني');
      return;
    }

    setState(() => isLoading = true);

    final url = Uri.parse('https://sawashop.vip/wp-json/custom/v1/forgot-password');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['success'] == true) {
        showMessage('تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني');
      } else {
        showMessage(result['message'] ?? 'حدث خطأ أثناء إرسال الرابط');
      }
    } else {
      showMessage('البريد الإلكتروني غير صحيح أو غير مسجل');
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, textAlign: TextAlign.center)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFB1E2F3),
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).viewInsets.bottom,
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.12),
                Center(
                  child: SvgPicture.asset(
                    'assets/images/logoApp.svg',
                    width: screenWidth * 0.55,
                  ),
                ),
                SizedBox(height: screenHeight * 0.10),

                const Text(
                  'نسيت كلمة المرور؟',
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: screenWidth * 0.7,
                    child: TextFormField(
                      controller: emailController,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 20, fontFamily: 'Tajawal'),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
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
                ),

                SizedBox(height: screenHeight * 0.02),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'أدخل بريدك الإلكتروني وسنرسل لك رابطًا لإعادة تعيين كلمة المرور',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontFamily: 'Tajawal', color: Colors.black),
                  ),
                ),

                const Spacer(),

                SizedBox(
                  width: screenWidth * 0.7,
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

                SizedBox(height: screenHeight * 0.02),

                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // ← العودة إلى تسجيل الدخول
                  },
                  child: Text.rich(
                    TextSpan(
                      text: 'لديك حساب؟ ',
                      style: const TextStyle(fontSize: 16, fontFamily: 'Tajawal', color: Colors.black),
                      children: const <TextSpan>[
                        TextSpan(
                          text: 'تسجيل دخول',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
