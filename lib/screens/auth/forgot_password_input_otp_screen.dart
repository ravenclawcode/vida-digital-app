import 'package:flutter/material.dart';
import 'package:mindfullshelter/provider/auth_provider.dart';
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

  bool get isFormFilled => otpController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    otpController.addListener(() => setState(() {}));
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
    final success = await auth.verifyCode(otp);

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
        otpErrorMessage = "Kode OTP tidak valid";
      });
    }
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              SizedBox(height: 20),
              _buildHeader(icon: icBackLeft1, onTap: () => Navigator.pop(context)),
              SizedBox(height: 15),
              _buildActionForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader({required String icon, required VoidCallback onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          onTap: onTap,
          child: Image(image: AssetImage(icon), width: 18),
        ),
        SizedBox(height: 20),
        Text('Periksa email Anda', style: AppTextStyles.heading2),
        SizedBox(height: 20),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Kode telah dikirim ke ',
                style: AppTextStyles.bodyMedium,
              ),
              TextSpan(
                text: 'vidadigital@gmail.com\n',
                style: AppTextStyles.bodyMediumBoldColors,
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
        SizedBox(height: 15),
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
      ],
    );
  }
}
