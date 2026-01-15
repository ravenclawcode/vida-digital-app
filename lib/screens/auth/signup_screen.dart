import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mindfullshelter/providers/auth_provider.dart';
import 'package:mindfullshelter/routes/routes.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button1.dart';
import 'package:mindfullshelter/utils/custom_button4.dart';
import 'package:mindfullshelter/utils/custom_checkbox1.dart';
import 'package:mindfullshelter/utils/custom_input_form_email.dart';
import 'package:mindfullshelter/utils/custom_input_form_password.dart';
import 'package:mindfullshelter/utils/custom_input_form_username.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isAgreed = false;
  bool showCheckboxError = false;
  bool get isFormFilled {
    return [
          emailController,
          usernameController,
          passwordController,
          confirmPasswordController,
        ].every((c) => c.text.trim().isNotEmpty) &&
        isAgreed;
  }

  void _handleSignUp(String? tokenCode) async {
    if (!isAgreed) {
      setState(() => showCheckboxError = true);
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    if (tokenCode == null || tokenCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sesi aktivasi habis, silakan ulang.')),
      );
      return;
    }

    final email = emailController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final successRegister = await authProvider.signUp(
      username: username,
      email: email,
      password: password,
      tokenCode: tokenCode,
    );

    if (!mounted) return;

    if (successRegister) {
      await authProvider.login(email, password);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pendaftaran Berhasil!')));

      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.getStarted,
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Pendaftaran gagal. Email/Username mungkin sudah terpakai.',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Object? args = ModalRoute.of(context)?.settings.arguments;
    final String? tokenCode = args is String ? args : null;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              _buildHeader(
                context: context,
                icon: icBackLeft1,
                onTap: () => Navigator.pop(context),
              ),
              SizedBox(height: 35),
              _buildActionForm(tokenCode),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader({
    required BuildContext context,
    required String icon,
    required VoidCallback onTap,
  }) {
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
        SizedBox(height: 30),
        Text('Daftar', style: AppTextStyles.heading2),
      ],
    );
  }

  Widget _buildActionForm(String? tokenCode) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomInputFormEmail(controller: emailController),
          SizedBox(height: 15),
          CustomInputFormUsername(controller: usernameController),
          SizedBox(height: 15),
          CustomInputFormPassword(controller: passwordController),
          SizedBox(height: 15),
          CustomInputFormPassword(
            controller: confirmPasswordController,
            isConfirm: true,
            passwordController: passwordController,
          ),
          SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 3),
                child: CustomCheckbox1(
                  value: isAgreed,
                  showError: showCheckboxError,
                  onChanged: (value) {
                    setState(() {
                      isAgreed = value;
                      if (value) showCheckboxError = false;
                    });
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Saya menyetujui ',
                        style: AppTextStyles.bodyMediumBoldColors.copyWith(
                          fontSize: 12,
                          height: 1.6,
                        ),
                      ),
                      TextSpan(
                        text: 'Ketentuan & Layanan ',
                        style: AppTextStyles.bodyExtraSmallBoldColors.copyWith(
                          fontSize: 12,
                          height: 1.6,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            final agreed = await Navigator.pushNamed(
                              context,
                              Routes.termsAndConditions,
                              arguments: 0,
                            );
                            if (agreed == true) {
                              setState(() {
                                isAgreed = true;
                                showCheckboxError = false;
                              });
                            }
                          },
                      ),
                      TextSpan(
                        text: 'serta ',
                        style: AppTextStyles.bodyMediumBoldColors.copyWith(
                          fontSize: 12,
                          height: 1.6,
                        ),
                      ),
                      TextSpan(
                        text: '\nKebijakan Privasi ',
                        style: AppTextStyles.bodyExtraSmallBoldColors.copyWith(
                          fontSize: 12,
                          height: 1.6,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            final agreed = await Navigator.pushNamed(
                              context,
                              Routes.termsAndConditions,
                              arguments: 1,
                            );
                            if (agreed == true) {
                              setState(() {
                                isAgreed = true;
                                showCheckboxError = false;
                              });
                            }
                          },
                      ),
                      TextSpan(
                        text: 'yang berlaku di VIDA Digital.',
                        style: AppTextStyles.bodyMediumBoldColors.copyWith(
                          fontSize: 12,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
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
                      : Text('Daftar', style: AppTextStyles.button1),
                );
              }
              return CustomButton1(
                onTap: () => _handleSignUp(tokenCode),
                label: 'Daftar',
              );
            },
          ),
        ],
      ),
    );
  }
}
