// lib/views/otp_verification_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  static const int _otpLength = 6;

  final List<TextEditingController> _controllers =
  List.generate(_otpLength, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
  List.generate(_otpLength, (_) => FocusNode());

  bool _isVerifying = false;

  // عدّاد إعادة الإرسال
  int _secondsRemaining = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    // تركيز أول خانة بعد البناء
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNodes.first.requestFocus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    _timer?.cancel();
    setState(() => _secondsRemaining = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_secondsRemaining <= 1) {
        t.cancel();
        setState(() => _secondsRemaining = 0);
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  void _onChanged(int index, String value) {
    // دعم لصق رمز كامل دفعة واحدة
    if (value.length > 1) {
      final chars = value.replaceAll(RegExp(r'\D'), '').split('');
      for (int i = 0; i < _otpLength; i++) {
        _controllers[i].text = i < chars.length ? chars[i] : '';
      }
      _moveToNextEmptyOrVerify();
      return;
    }

    if (value.isNotEmpty && index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    _tryVerifyIfComplete();
  }

  void _moveToNextEmptyOrVerify() {
    for (int i = 0; i < _otpLength; i++) {
      if (_controllers[i].text.isEmpty) {
        _focusNodes[i].requestFocus();
        return;
      }
    }
    _tryVerifyIfComplete();
  }

  String get _code => _controllers.map((c) => c.text.trim()).join();

  bool get _isComplete =>
      _code.length == _otpLength && !_code.contains(RegExp(r'\D'));

  void _tryVerifyIfComplete() {
    if (_isComplete) {
      FocusScope.of(context).unfocus();
      // _confirmCode(); // إن أردت التأكيد التلقائي
      setState(() {}); // لتحديث حالة زر التأكيد
    } else {
      setState(() {}); // تحديث حالة الزر عند الكتابة
    }
  }

  Future<void> _confirmCode() async {
    if (!_isComplete || _isVerifying) return;

    setState(() => _isVerifying = true);

    // TODO: استدعاء API للتحقق من الرمز (_code)
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    setState(() => _isVerifying = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم تأكيد الرمز: $_code', textAlign: TextAlign.center)),
    );

    // TODO: التوجيه حسب منطق التطبيق
    // Navigator.of(context).pushReplacement(...);
  }

  void _resendCode() {
    if (_secondsRemaining != 0) return;
    // TODO: استدعاء API لإعادة إرسال الرمز
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إرسال الرمز مجددًا', textAlign: TextAlign.center)),
    );
    _startResendTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB1E2F3),
      // ✅ رفع الواجهة تلقائياً مع ظهور الكيبورد
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(), // إغلاق الكيبورد عند النقر بالخارج
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

        SizedBox(height: h * 0.08),

        const Text(
          'أدخل رمز التحقق',
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: h * 0.03),

        // ✅ 6 خانات OTP قابلة للكتابة + تنقّل تلقائي + محددات إدخال
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_otpLength, (index) {
            return Container(
              width: 44,
              height: 56,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9),
                border: Border.all(color: const Color(0xFFBFBFBF), width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontFamily: 'Tajawal'),
                keyboardType: TextInputType.number,
                textInputAction:
                index == _otpLength - 1 ? TextInputAction.done : TextInputAction.next,
                maxLength: 1,
                buildCounter: (_, {required int currentLength, required bool isFocused, int? maxLength}) =>
                const SizedBox.shrink(),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(1),
                ],
                onChanged: (value) => _onChanged(index, value),
                onSubmitted: (_) {
                  if (index == _otpLength - 1 && _isComplete) _confirmCode();
                },
              ),
            );
          }),
        ),

        SizedBox(height: h * 0.03),

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

        // ✅ الجزء السفلي يرتفع ديناميكيًا بقدر ارتفاع الكيبورد
        SafeArea(
          top: false,
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: [
                // زر تأكيد الرمز
                SizedBox(
                  width: w * 0.7,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isVerifying || !_isComplete ? null : _confirmCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF0000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isVerifying
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      'تأكيد الرمز',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Tajawal',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: h * 0.02),

                // نص/زر إعادة الإرسال مع عدّاد
                TextButton(
                  onPressed: _secondsRemaining == 0 ? _resendCode : null,
                  child: Text(
                    _secondsRemaining == 0
                        ? 'إعادة إرسال الرمز'
                        : 'لم يصلك الرمز؟ أعد الإرسال خلال $_secondsRemaining ثانية',
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Tajawal',
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
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
