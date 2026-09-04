import 'package:flutter/material.dart';
import 'package:mindfullshelter/routes/routes.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button1.dart';
import 'package:mindfullshelter/utils/custom_button11.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final PageController _controller = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: 60),
            _buildHeaderWelcome(),
            SizedBox(height: 10),
            Expanded(child: Image.asset(illustration9)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: CustomButton11(
                onTap: () => Navigator.pushNamed(
                  context,
                  Routes.activationAccountScreen,
                ),
                label: 'Daftar',
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: CustomButton1(
                onTap: () => Navigator.pushNamed(context, Routes.signIn),
                label: 'Masuk',
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderWelcome() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icLogo, height: 28),
            SizedBox(width: 10),
            Text('VIDA', style: AppTextStyles.headingIntroduction),
          ],
        ),
        SizedBox(height: 16),
        Text('Selamat Datang', style: AppTextStyles.subHeadingIntroduction),
        SizedBox(height: 11),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Yuk, masuk dan temukan ',
                style: AppTextStyles.descIntroduction.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              TextSpan(
                text: 'dukungan mental\ndan edukasi ',
                style: AppTextStyles.descIntroduction.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: 'bagi penyintas ',
                style: AppTextStyles.descIntroduction.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              TextSpan(
                text: 'HIV/AIDS.',
                style: AppTextStyles.descIntroduction.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
