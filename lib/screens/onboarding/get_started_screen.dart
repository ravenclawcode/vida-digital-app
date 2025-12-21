import 'package:flutter/material.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button1.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildContent(),
              SizedBox(height: 60),
              CustomButton1(
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (route) => false,
                ),
                label: 'Memulai',
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Hai Serra Gohv! Selamat datang di ',
                style: AppTextStyles.heading2,
              ),
              TextSpan(
                text: 'VIDA Digital',
                style: AppTextStyles.heading2ColorsLight,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 35),
        Text(
          'Ruang aman untuk belajar dan mendapatkan\ndukungan tentang HIV.',
          style: AppTextStyles.bodyMedium,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Image.asset(illustration6, height: 378),
      ],
    );
  }
}
