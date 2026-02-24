import 'package:flutter/material.dart';
import 'package:mindfullshelter/providers/auth_provider.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button1.dart';
import 'package:mindfullshelter/utils/custom_button4.dart';
import 'package:mindfullshelter/utils/custom_input_form_password.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final currentPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool get isFormFilled =>
      currentPasswordController.text.trim().isNotEmpty ||
      passwordController.text.trim().isNotEmpty ||
      confirmPasswordController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    passwordController.addListener(() => setState(() {}));
    confirmPasswordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.changePasswordProfile(
      currentPassword: currentPasswordController.text.trim(),
      newPassword: passwordController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kata sandi berhasil diperbarui')),
      );

      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password saat ini salah atau terjadi error.'),
        ),
      );
    }
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
              const SizedBox(height: 12),
              _buildHeader(context),
              const SizedBox(height: 10),
              SizedBox(height: 20),
              _buildActionForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        InkWell(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          onTap: () => Navigator.pop(context),
          child: Image.asset(icBackLeft2, width: 10),
        ),
        SizedBox(width: 25),
        Text('Ubah Kata Sandi', style: AppTextStyles.heading3Bold),
      ],
    );
  }

  Widget _buildActionForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Kata Sandi Saat Ini', style: AppTextStyles.headingProfile),
          const SizedBox(height: 8),
          CustomInputFormPassword(
            controller: currentPasswordController,
            hintText: 'Masukkan kata sandi saat ini',
          ),
          const SizedBox(height: 18),
          Text('Kata Sandi Baru', style: AppTextStyles.headingProfile),
          const SizedBox(height: 8),
          CustomInputFormPassword(
            controller: passwordController,
            hintText: 'Masukkan password baru',
          ),
          const SizedBox(height: 18),
          Text(
            'Konfirmasi Kata Sandi Baru',
            style: AppTextStyles.headingProfile,
          ),
          const SizedBox(height: 8),
          CustomInputFormPassword(
            controller: confirmPasswordController,
            isConfirm: true,
            passwordController: passwordController,
            hintText: 'Masukkan ulang password baru',
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
                      : Text('Ubah Kata Sandi', style: AppTextStyles.button1),
                );
              }
              return CustomButton1(
                onTap: _handleUpdatePassword,
                label: 'Ubah Kata Sandi',
              );
            },
          ),
        ],
      ),
    );
  }
}
