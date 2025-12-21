import 'package:flutter/material.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button3.dart';

class MultiSigninScreen extends StatelessWidget {
  const MultiSigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildContent(),
              SizedBox(height: 20),
              CustomButton3(
                onTap: () {},
                icon: icGoogle,
                label: 'Daftar dengan Google',
              ),
              SizedBox(height: 15),
              CustomButton3(
                onTap: () => Navigator.pushNamed(context, '/sign-up'),
                icon: icEmail,
                label: 'Daftar dengan Email',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        Text('VIDA Digital', style: AppTextStyles.heading2Colors),
        SizedBox(height: 80),
        Image.asset(illustration7, width: 160),
        SizedBox(height: 35),
        Text(
          'Langkah Awal untuk\nMerawat Dirimu',
          style: AppTextStyles.heading2,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 2),
        Image.asset(vector1, height: 5, width: 204),
        SizedBox(height: 35),
        Text(
          'Buat akun untuk mendapatkan edukasi\ndan dukungan.',
          style: AppTextStyles.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
