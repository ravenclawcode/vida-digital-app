import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mindfullshelter/providers/auth_provider.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button1.dart';
import 'package:mindfullshelter/utils/custom_button4.dart';
import 'package:mindfullshelter/utils/custom_input_form_otp.dart';
import 'package:provider/provider.dart';

class ForgorPasswordInputOtpScreen extends StatefulWidget {
  const ForgorPasswordInputOtpScreen({super.key});

  @override
  State<ForgorPasswordInputOtpScreen> createState() =>
      _ForgorPasswordInputOtpScreenState();
}

class _ForgorPasswordInputOtpScreenState
    extends State<ForgorPasswordInputOtpScreen> {
  final otpController = TextEditingController();

  bool otpError = false;
  String? otpErrorMessage;
  Timer? _timer;
  int _start = 60;
  bool _isTimerActive = true;

  bool get isFormFilled => otpController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    otpController.addListener(() => setState(() {}));
    startTimer();
  }

  void startTimer() {
    _isTimerActive = true;
    _start = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isTimerActive = false;
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  Future<void> _handleSendOtp() async {
    final otp = otpController.text.trim();

    if (otp.length != 5) {
      setState(() {
        otpError = true;
        otpErrorMessage = "Kode OTP harus 5 digit";
      });
      return;
    }

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.verifyOtp(otp);

    if (!mounted) return;

    if (success) {
      setState(() {
        otpError = false;
        otpErrorMessage = null;
      });
      Navigator.pushNamed(context, '/forgotpassword-confirm');
    } else {
      setState(() {
        otpError = true;
        otpErrorMessage = "Kode OTP tidak valid atau kadaluarsa";
      });
    }
  }

  Future<void> _handleResendOtp() async {
    if (_isTimerActive) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final email = auth.resetEmail;

    if (email != null) {
      final success = await auth.forgotPassword(email);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kode OTP baru telah dikirim')),
        );
        startTimer();
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final userEmail = auth.resetEmail ?? "Email Anda";

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                _buildHeader(
                  icon: icBackLeft1,
                  email: userEmail,
                  onTap: () => Navigator.pop(context),
                ),
                SizedBox(height: 20),
                _buildActionForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader({
    required String icon,
    required String email,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: AlignmentGeometry.topLeft,
          child: InkWell(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            onTap: onTap,
            child: Image(image: AssetImage(icon), width: 18),
          ),
        ),
        SizedBox(height: 30),
        Align(
          alignment: AlignmentGeometry.topLeft,
          child: Text('Periksa email Anda', style: AppTextStyles.heading2),
        ),
        SizedBox(height: 20),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Kode telah dikirim ke ',
                style: AppTextStyles.bodyMedium,
              ),
              TextSpan(
                text: '$email\n',
                style: AppTextStyles.bodyMediumBoldColors.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: 'Masukkan kode 5 digit.',
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionForm() {
    return Column(
      children: [
        CustomInputFormOtp(
          controller: otpController,
          hasError: otpError,
          errorMessage: otpErrorMessage,
        ),
        SizedBox(height: 35),
        Consumer<AuthProvider>(
          builder: (context, auth, child) {
            final disabled = !isFormFilled || auth.isLoading;
            if (disabled) {
              return CustomButton4(
                label: auth.isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.background,
                        ),
                      )
                    : Text('Verifikasi Kode', style: AppTextStyles.button1),
              );
            }
            return CustomButton1(
              onTap: _handleSendOtp,
              label: 'Verifikasi Kode',
            );
          },
        ),
        SizedBox(height: 35),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Belum menerima OTP? ',
                style: AppTextStyles.bodyMedium,
              ),
              TextSpan(
                text: _isTimerActive ? 'Kirim ulang ${_start}s' : 'Kirim ulang',
                style: _isTimerActive
                    ? AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textLight,
                      )
                    : AppTextStyles.bodyMediumBold,
                recognizer: TapGestureRecognizer()
                  ..onTap = _isTimerActive ? null : _handleResendOtp,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
