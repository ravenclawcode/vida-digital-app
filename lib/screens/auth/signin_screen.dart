import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mindfullshelter/provider/auth_provider.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button1.dart';
import 'package:mindfullshelter/utils/custom_button3.dart';
import 'package:mindfullshelter/utils/custom_button4.dart';
import 'package:mindfullshelter/utils/custom_input_form_email.dart';
import 'package:mindfullshelter/utils/custom_input_form_password.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool get isFormFilled =>
      emailController.text.trim().isNotEmpty ||
      passwordController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    emailController.addListener(() => setState(() {}));
    passwordController.addListener(() => setState(() {}));
  }

  void _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final auth = Provider.of<AuthProvider>(context, listen: false);

    final success = await auth.signIn(email, password);

    if (!mounted) return;

    if (success) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/getstarted',
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email atau password salah')),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
            children: [
              SizedBox(height: 20),
              _buildHeader(icon: icBackLeft1, onTap: () => Navigator.pop(context)),
              SizedBox(height: 25),
              _buildActionForm(),
              SizedBox(height: 35),
              _buildAnotherAction(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader({required String icon, required VoidCallback onTap}) {
    return Column(
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
        SizedBox(height: 20),
        Align(
          alignment: AlignmentGeometry.topLeft,
          child: Text('Masuk', style: AppTextStyles.heading2),
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
          SizedBox(height: 15),
          CustomInputFormPassword(controller: passwordController),
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
                      : Text('Masuk', style: AppTextStyles.button1),
                );
              }
              return CustomButton1(onTap: _handleSignIn, label: 'Masuk');
            },
          ),
          SizedBox(height: 15),
          Align(
            alignment: AlignmentGeometry.topRight,
            child: InkWell(
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              onTap: () =>
                  Navigator.pushNamed(context, '/forgotpassword-inputemail'),
              child: Text(
                'Lupa Kata Sandi?',
                style: AppTextStyles.bodyMediumColors,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnotherAction() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(color: AppColors.borderColor, thickness: 0.8),
            ),
            SizedBox(width: 2),
            Text('ATAU', style: AppTextStyles.heading4),
            SizedBox(width: 2),
            Expanded(
              child: Divider(color: AppColors.borderColor, thickness: 0.8),
            ),
          ],
        ),
        SizedBox(height: 35),
        CustomButton3(
          onTap: () {},
          icon: icGoogle,
          label: 'Masuk dengan Google',
        ),
        SizedBox(height: 35),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Belum punya akun? ',
                style: AppTextStyles.bodyMedium,
              ),
              TextSpan(
                text: 'Daftar',
                style: AppTextStyles.bodyMediumBold,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushNamed(context, '/sign-up');
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
