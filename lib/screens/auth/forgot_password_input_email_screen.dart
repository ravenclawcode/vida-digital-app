import 'package:flutter/material.dart';
import 'package:mindfullshelter/providers/auth_provider.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button1.dart';
import 'package:mindfullshelter/utils/custom_button4.dart';
import 'package:mindfullshelter/utils/custom_input_form_email.dart';
import 'package:provider/provider.dart';

class ForgotPasswordInputEmailScreen extends StatefulWidget {
  const ForgotPasswordInputEmailScreen({super.key});

  @override
  State<ForgotPasswordInputEmailScreen> createState() =>
      _ForgotPasswordInputEmailScreenState();
}

class _ForgotPasswordInputEmailScreenState
    extends State<ForgotPasswordInputEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool get isFormFilled => emailController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    emailController.addListener(() => setState(() {}));
  }

  _handleSendEmail() async {
    if (!_formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final auth = Provider.of<AuthProvider>(context, listen: false);

    final success = await auth.forgotPassword(email);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kode OTP telah dikirim ke email Anda')),
      );
      Navigator.pushNamed(context, '/forgotpassword-inputotp');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email tidak ditemukan atau server error'),
        ),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              _buildHeader(
                icon: icBackLeft1,
                onTap: () => Navigator.pop(context),
              ),
              SizedBox(height: 20),
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
          child: Text('Lupa Kata Sandi', style: AppTextStyles.heading2),
        ),
        SizedBox(height: 20),
        Align(
          alignment: AlignmentGeometry.topLeft,
          child: Text(
            'Silakan masukkan email Anda untuk mengatur\nulang kata sandi.',
            style: AppTextStyles.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildActionForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomInputFormEmail(controller: emailController),
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
                      : Text('Reset Kata Sandi', style: AppTextStyles.button1),
                );
              }
              return CustomButton1(
                onTap: _handleSendEmail,
                label: 'Reset Kata Sandi',
              );
            },
          ),
        ],
      ),
    );
  }
}
