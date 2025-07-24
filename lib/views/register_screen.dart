import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;

  Future<void> registerUser() async {
    final username = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      showMessage('يرجى ملء جميع الحقول');
      return;
    }

    if (password != confirmPassword) {
      showMessage('كلمة المرور وتأكيدها غير متطابقتين');
      return;
    }

    setState(() => isLoading = true);

    final url = Uri.parse('https://sawashop.vip/wp-json/custom/v1/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    setState(() => isLoading = false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      if (responseData['success'] == true) {
        showMessage('تم إنشاء الحساب بنجاح');
        // بعد النجاح يمكن التوجيه إلى صفحة تسجيل الدخول
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context); // أو استخدم pushNamed إذا عندك routes
        });
      } else {
        showMessage(responseData['message'] ?? 'فشل في إنشاء الحساب');
      }
    } else {
      showMessage('حدث خطأ أثناء إنشاء الحساب: ${response.body}');
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

            // Full Name Field
            buildTextField(
              hint: 'الاسم الكامل',
              iconPath: 'assets/icons/iconUser.svg',
              controller: fullNameController,
              isPassword: false,
              screenWidth: screenWidth,
            ),
            SizedBox(height: screenHeight * 0.02),

            // Email Field
            buildTextField(
              hint: 'البريد الإلكتروني',
              iconPath: 'assets/icons/iconEmail.svg',
              controller: emailController,
              isPassword: false,
              screenWidth: screenWidth,
            ),
            SizedBox(height: screenHeight * 0.02),

            // Password Field
            buildTextField(
              hint: 'كلمة المرور',
              iconPath: 'assets/icons/iconLock.svg',
              controller: passwordController,
              isPassword: true,
              isVisible: _passwordVisible,
              onVisibilityToggle: () {
                setState(() => _passwordVisible = !_passwordVisible);
              },
              screenWidth: screenWidth,
            ),
            SizedBox(height: screenHeight * 0.02),

            // Confirm Password Field
            buildTextField(
              hint: 'تأكيد كلمة المرور',
              iconPath: 'assets/icons/iconLock.svg',
              controller: confirmPasswordController,
              isPassword: true,
              isVisible: _confirmPasswordVisible,
              onVisibilityToggle: () {
                setState(() => _confirmPasswordVisible = !_confirmPasswordVisible);
              },
              screenWidth: screenWidth,
            ),

            const Spacer(),

            // CTA Button
            GestureDetector(
              onTap: isLoading ? null : registerUser,
              child: Container(
                width: screenWidth * 0.7,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isLoading ? Colors.grey : const Color(0xFFFF0000),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'إنشاء حساب',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Tajawal',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Text below button
            const Text(
              'لديك حساب؟ تسجيل دخول',
              style: TextStyle(
                fontSize: 16,
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

  Widget buildTextField({
    required String hint,
    required String iconPath,
    required bool isPassword,
    required TextEditingController controller,
    bool isVisible = false,
    VoidCallback? onVisibilityToggle,
    required double screenWidth,
  }) {
    return Container(
      width: screenWidth * 0.7,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        border: Border.all(color: const Color(0xFFBFBFBF), width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          if (isPassword)
            GestureDetector(
              onTap: onVisibilityToggle,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: SvgPicture.asset(
                  isVisible
                      ? 'assets/icons/iconEyeOpen.svg'
                      : 'assets/icons/iconEyeClosed.svg',
                  width: isVisible ? 20 : 18,
                  height: isVisible ? 19 : 6.5,
                ),
              ),
            ),
          const Spacer(),
          Expanded(
            flex: 4,
            child: TextField(
              controller: controller,
              obscureText: isPassword && !isVisible,
              style: const TextStyle(fontSize: 18, fontFamily: 'Tajawal'),
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '',
              ),
            ),
          ),
          const SizedBox(width: 10),
          SvgPicture.asset(
            iconPath,
            width: iconPath.contains('Email') ? 20 : iconPath.contains('Lock') ? 16 : 20,
            height: iconPath.contains('Email') ? 20 : iconPath.contains('Lock') ? 24.57 : 20,
          ),
        ],
      ),
    );
  }
}
