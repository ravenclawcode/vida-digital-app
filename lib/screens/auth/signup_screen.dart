import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mindfullshelter/provider/auth_provider.dart';
import 'package:mindfullshelter/routes/routes.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button1.dart';
import 'package:mindfullshelter/utils/custom_button4.dart';
import 'package:mindfullshelter/utils/custom_checkbox.dart';
import 'package:mindfullshelter/utils/custom_input_form_email.dart';
import 'package:mindfullshelter/utils/custom_input_form_password.dart';
import 'package:mindfullshelter/utils/custom_input_username.dart';
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

  @override
  void initState() {
    super.initState();
    emailController.addListener(() => setState(() {}));
    usernameController.addListener(() => setState(() {}));
    passwordController.addListener(() => setState(() {}));
    confirmPasswordController.addListener(() => setState(() {}));
  }

  void _handleSignUp() async {
    if (!isAgreed) {
      setState(() => showCheckboxError = true);
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    final auth = Provider.of<AuthProvider>(context, listen: false);

    final success = await auth.signUp(email, username, password);

    if (!mounted) return;

    if (success) {
      Navigator.pushNamedAndRemoveUntil(context, '/sign-in', (route) => false);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Pendaftaran gagal')));
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
              SizedBox(height: 45),
              _buildActionForm(),
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
        SizedBox(height: 20),
        Text('Daftar', style: AppTextStyles.heading2),
        SizedBox(height: 20),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Sudah punya akun? ',
                style: AppTextStyles.bodyMedium,
              ),
              TextSpan(
                text: 'Masuk',
                style: AppTextStyles.bodyMediumBold,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushNamed(context, '/sign-in');
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionForm() {
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
          SizedBox(height: 15),
          Row(
            children: [
              CustomCheckbox(
                value: isAgreed,
                showError: showCheckboxError,
                onChanged: (value) {
                  setState(() {
                    isAgreed = value;
                    if (value) showCheckboxError = false;
                  });
                },
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Saya setuju dengan syarat & ketentuan',
                  style: AppTextStyles.bodyMediumBoldColors,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Dengan mendaftar, saya menyetujui ',
                  style: AppTextStyles.bodyExtraSmall,
                ),
                TextSpan(
                  text: 'Ketentuan Layanan ',
                  style: AppTextStyles.bodyExtraSmallBoldColors,
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
                  text:
                      '\nVIDA Digital. Saya juga menyetujui penggunaan data\npenggunaan aplikasi untuk peningkatan layanan. VIDA\nDigital tidak akan membagikan data pribadi Anda. Lihat ',
                  style: AppTextStyles.bodyExtraSmall,
                ),
                TextSpan(
                  text: '\nKebijakan Privasi ',
                  style: AppTextStyles.bodyExtraSmallBoldColors,
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
                  text: 'untuk informasi lebih lanjut.',
                  style: AppTextStyles.bodyExtraSmall,
                ),
              ],
            ),
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
                      : Text('Daftar', style: AppTextStyles.button1),
                );
              }
              return CustomButton1(onTap: _handleSignUp, label: 'Daftar');
            },
          ),
        ],
      ),
    );
  }
}
