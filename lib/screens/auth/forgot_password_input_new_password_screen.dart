import 'package:flutter/material.dart';
import 'package:mindfullshelter/providers/auth_provider.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button1.dart';
import 'package:mindfullshelter/utils/custom_button4.dart';
import 'package:mindfullshelter/utils/custom_dialog_successful.dart';
import 'package:mindfullshelter/utils/custom_input_form_password.dart';
import 'package:provider/provider.dart';

class ForgotPasswordInputNewPasswordScreen extends StatefulWidget {
  const ForgotPasswordInputNewPasswordScreen({super.key});

  @override
  State<ForgotPasswordInputNewPasswordScreen> createState() =>
      _ForgotPasswordInputNewPasswordScreenState();
}

class _ForgotPasswordInputNewPasswordScreenState
    extends State<ForgotPasswordInputNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool get isFormFilled =>
      passwordController.text.trim().isNotEmpty ||
      confirmPasswordController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    passwordController.addListener(() => setState(() {}));
    confirmPasswordController.addListener(() => setState(() {}));
  }

  Future<void> _handleUpdatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final newPassword = passwordController.text.trim();

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.updatePassword(newPassword);

    if (!mounted) return;

    if (success) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => CustomDialogSuccessful(),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal memperbarui kata sandi. Silakan coba lagi.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
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
        Text('Atur kata sandi baru', style: AppTextStyles.heading2),
        SizedBox(height: 20),
        Text(
          'Pastikan kata sandi Anda berbeda dari kata sandi sebelumnya.',
          style: AppTextStyles.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildActionForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomInputFormPassword(controller: passwordController),
          SizedBox(height: 15),
          CustomInputFormPassword(
            controller: confirmPasswordController,
            isConfirm: true,
            passwordController: passwordController,
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
                      : Text(
                          'Perbarui Kata Sandi',
                          style: AppTextStyles.button1,
                        ),
                );
              }
              return CustomButton1(
                onTap: _handleUpdatePassword,
                label: 'Perbarui Kata Sandi',
              );
            },
          ),
        ],
      ),
    );
  }
}
