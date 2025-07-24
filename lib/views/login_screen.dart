import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> loginUser() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final url = Uri.parse('https://alalaqshop.com/wp-json/jwt-auth/v1/token');

    try {
      final response = await http.post(
        url,
        body: {
          'username': emailController.text.trim(),
          'password': passwordController.text,
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['token'] != null) {
        final token = data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userToken', token);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تسجيل الدخول بنجاح')),
        );

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          _errorMessage = data['message'] ?? 'فشل تسجيل الدخول';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ أثناء الاتصال بالسيرفر';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFB1E2F3),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.12),
            Center(
              child: SvgPicture.asset(
                'assets/images/logoApp.svg',
                width: screenWidth * 0.55,
              ),
            ),
            SizedBox(height: screenHeight * 0.15),
            Expanded(
              child: Column(
                children: [
                  buildTextField(
                    controller: emailController,
                    hint: 'البريد الإلكتروني',
                    icon: 'assets/icons/iconEmail.svg',
                    obscure: false,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  buildTextField(
                    controller: passwordController,
                    hint: 'كلمة المرور',
                    icon: 'assets/icons/iconLock.svg',
                    obscure: _obscurePassword,
                    toggleVisibility: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    isPasswordField: true,
                  ),
                  if (_errorMessage.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      _errorMessage,
                      style: const TextStyle(
                        color: Colors.red,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                  const Spacer(),
                  SizedBox(
                    width: screenWidth * 0.7,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : loginUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF0000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        'تسجيل دخول',
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
                      // TODO: الانتقال إلى شاشة إنشاء حساب
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: 'زائر جديد؟ ',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Tajawal',
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: 'إنشاء حساب',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hint,
    required String icon,
    required bool obscure,
    VoidCallback? toggleVisibility,
    bool isPasswordField = false,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        textAlign: TextAlign.right,
        style: const TextStyle(fontSize: 20, fontFamily: 'Tajawal'),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 15),
            child: SvgPicture.asset(
              icon,
              width: 20,
              height: 20,
              fit: BoxFit.scaleDown,
            ),
          ),
          prefixIcon: isPasswordField
              ? Padding(
            padding: const EdgeInsets.only(left: 12),
            child: GestureDetector(
              onTap: toggleVisibility,
              child: SvgPicture.asset(
                obscure
                    ? 'assets/icons/iconEyeClosed.svg'
                    : 'assets/icons/iconEyeOpen.svg',
                width: obscure ? 18 : 20,
                height: obscure ? 6.5 : 19,
              ),
            ),
          )
              : null,
          prefixIconConstraints: const BoxConstraints(minWidth: 50),
          hintText: hint,
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
    );
  }
}
