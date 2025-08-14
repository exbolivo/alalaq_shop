// lib/views/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../helpers/navigator_helper.dart';

const double kEyeBox = 22; // إطار موحّد لأيقونة العين

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // حالات إظهار/إخفاء كلمات المرور
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  // المتحكمات
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    final r = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return r.hasMatch(email);
  }

  Future<void> registerUser() async {
    final username = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      showMessage('يرجى ملء جميع الحقول');
      return;
    }
    if (!_isValidEmail(email)) {
      showMessage('صيغة البريد الإلكتروني غير صحيحة');
      return;
    }
    if (password.length < 6) {
      showMessage('يجب أن تتكون كلمة المرور من 6 أحرف على الأقل');
      return;
    }
    if (password != confirmPassword) {
      showMessage('كلمة المرور وتأكيدها غير متطابقتين');
      return;
    }

    setState(() => isLoading = true);

    // TODO: ربط API التسجيل هنا (WordPress JWT أو أي باك-إند)
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    setState(() => isLoading = false);
    showMessage('تم إنشاء الحساب بنجاح');

    // العودة إلى شاشة تسجيل الدخول
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) goBack(context);
    });
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
      // ✅ رفع المحتوى تلقائياً عند ظهور الكيبورد
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(), // إغلاق الكيبورد بالنقر خارج الحقول
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                // ❌ بدون padding سفلي هنا حتى لا تتضاعف المسافات
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

        // الشعار
        Center(
          child: SvgPicture.asset(
            'assets/images/logoApp.svg',
            width: w * 0.55,
          ),
        ),

        SizedBox(height: h * 0.15),

        // الحقول
        _buildTextField(
          controller: fullNameController,
          hint: 'الاسم الكامل',
          icon: 'assets/icons/iconUser.svg',
          obscure: false,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.name,
          autofillHints: const [AutofillHints.name],
        ),
        SizedBox(height: h * 0.02),

        _buildTextField(
          controller: emailController,
          hint: 'البريد الإلكتروني',
          icon: 'assets/icons/iconEmail.svg',
          obscure: false,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.username, AutofillHints.email],
        ),
        SizedBox(height: h * 0.02),

        _buildTextField(
          controller: passwordController,
          hint: 'كلمة المرور',
          icon: 'assets/icons/iconLock.svg',
          obscure: !_passwordVisible,
          isPasswordField: true,
          toggleVisibility: () => setState(() => _passwordVisible = !_passwordVisible),
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.newPassword],
        ),
        SizedBox(height: h * 0.02),

        _buildTextField(
          controller: confirmPasswordController,
          hint: 'تأكيد كلمة المرور',
          icon: 'assets/icons/iconLock.svg',
          obscure: !_confirmPasswordVisible,
          isPasswordField: true,
          toggleVisibility: () => setState(() => _confirmPasswordVisible = !_confirmPasswordVisible),
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => isLoading ? null : registerUser(),
          autofillHints: const [AutofillHints.newPassword],
        ),

        const Spacer(),

        // ✅ الجزء السفلي (CTA + رابط) يرتفع ديناميكيًا مع الكيبورد
        SafeArea(
          top: false,
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: [
                // زر إنشاء الحساب
                SizedBox(
                  width: w * 0.7,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF0000),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
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

                const SizedBox(height: 10),

                // العودة لتسجيل الدخول
                GestureDetector(
                  onTap: () => goBack(context),
                  child: const Text.rich(
                    TextSpan(
                      text: 'لديك حساب؟ ',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Tajawal',
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: 'تسجيل دخول',
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

  /// ويدجت حقل إدخال موحّد (بنفس معايير الصفحات الأخرى)
  Widget _buildTextField({
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
      width: w * 0.7, // ✅ 70% من عرض الشاشة
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // ✅ 20 / 10
          // أيقونة نوع الحقل (يمين)
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 15),
            child: SvgPicture.asset(
              icon,
              width: icon.contains('iconLock') ? 16 : 20,     // مقاسات الأيقونات المعتمدة
              height: icon.contains('iconLock') ? 24.57 : 20, // Email/User = 20x20
              fit: BoxFit.scaleDown,
            ),
          ),
          // أيقونة العين (يسار) تظهر فقط في حقول كلمة المرور
          prefixIcon: isPasswordField
              ? SizedBox(
            width: 56,
            child: InkWell(
              onTap: toggleVisibility,
              borderRadius: BorderRadius.circular(12),
              child: Center(
                child: SizedBox(
                  width: kEyeBox,
                  height: kEyeBox,
                  child: SvgPicture.asset(
                    // إذا obscure=true يعني الحروف مخفية → نعرض أيقونة "عين مغلقة"
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
