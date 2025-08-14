// lib/views/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/navigator_helper.dart';

const double kEyeBox = 22; // إطار موحّد لأيقونة العين

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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final email = emailController.text.trim();
    final password = passwordController.text;

    // تسجيل وهمي للتجربة
    if (email == 'demo@demo.com' && password == 'demo') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userToken', 'dummyToken');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تسجيل الدخول بنجاح')),
      );
      goToHome(context, replace: true);
    } else {
      setState(() => _errorMessage = 'بيانات الدخول غير صحيحة');
    }

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB1E2F3),
      // ✅ فعّل تحجيم المحتوى تلقائيًا عند ظهور الكيبورد
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(), // إغلاق الكيبورد عند اللمس بالخارج
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                // ✅ لا نضع padding هنا حتى لا تتضاعف المسافات
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: buildLoginContent(context),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildLoginContent(BuildContext context) {
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

        SizedBox(height: h * 0.15),

        // الحقول
        Column(
          children: [
            // حقل البريد
            buildTextField(
              controller: emailController,
              hint: 'البريد الإلكتروني',
              icon: 'assets/icons/iconEmail.svg',
              obscure: false,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,                  // ✅ كيبورد إيميل
              autofillHints: const [AutofillHints.username, AutofillHints.email], // ✅ أوتوفيل
            ),

            SizedBox(height: h * 0.02),

            // حقل كلمة المرور
            buildTextField(
              controller: passwordController,
              hint: 'كلمة المرور',
              icon: 'assets/icons/iconLock.svg',
              obscure: _obscurePassword,
              isPasswordField: true,
              toggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => loginUser(),                    // ✅ Enter ينفذ الدخول
              autofillHints: const [AutofillHints.password],           // ✅ أوتوفيل
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

            SizedBox(height: h * 0.05), // مسافة أمان قبل الزر
          ],
        ),

        const Spacer(), // يدفع الزر للأسفل عندما لا يوجد كيبورد

        // ✅ الجزء السفلي (الزر + رابط إنشاء حساب) مرفوع تلقائيًا بقدر ارتفاع الكيبورد
        SafeArea(
          top: false,
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: [
                // زر تسجيل الدخول
                SizedBox(
                  width: w * 0.7,
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

                SizedBox(height: h * 0.02),

                // إنشاء حساب
                GestureDetector(
                  onTap: () => goToRegister(context),
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

                SizedBox(height: h * 0.04),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// ويدجت حقل إدخال موحّد
  Widget buildTextField({
    required TextEditingController controller,
    required String hint,
    required String icon,
    required bool obscure,
    VoidCallback? toggleVisibility,
    bool isPasswordField = false,
    TextInputAction textInputAction = TextInputAction.done,
    TextInputType? keyboardType,
    List<String>? autofillHints,
    ValueChanged<String>? onFieldSubmitted,
  }) {
    final w = MediaQuery.of(context).size.width;

    return SizedBox(
      width: w * 0.7,
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        obscuringCharacter: '•',
        textAlign: TextAlign.right,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        autofillHints: autofillHints,
        onFieldSubmitted: onFieldSubmitted,
        style: const TextStyle(fontSize: 20, fontFamily: 'Tajawal'),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // ✅ توحيد البادينغ

          // أيقونة نوع الحقل (يمين)
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 15),
            child: SvgPicture.asset(
              icon,
              width: 20,
              height: 20,
              fit: BoxFit.scaleDown,
            ),
          ),

          // أيقونة العين (يسار) تظهر فقط في حقل كلمة المرور
          prefixIcon: isPasswordField
              ? SizedBox(
            width: 56, // عرض ثابت لمنطقة العين
            child: InkWell(
              onTap: toggleVisibility,
              borderRadius: BorderRadius.circular(12),
              child: Center(
                child: SizedBox(
                  width: kEyeBox, // 22px إطار موحد
                  height: kEyeBox,
                  child: SvgPicture.asset(
                    obscure
                        ? 'assets/icons/iconEyeClosed.svg'
                        : 'assets/icons/iconEyeOpen.svg',
                  ),
                ),
              ),
            ),
          )
              : null,

          // لا نحجز مساحة إذا ما في أيقونة يسار
          prefixIconConstraints:
          isPasswordField ? const BoxConstraints.tightFor(width: 56, height: 56) : null,

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
