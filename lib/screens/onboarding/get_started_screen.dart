import 'package:flutter/material.dart';
import 'package:mindfullshelter/providers/auth_provider.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button1.dart';
import 'package:provider/provider.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Consumer<AuthProvider>(
                builder: (context, auth, child) {
                  final String rawName = auth.currentUser?.username ?? 'User';

                  return _buildContent(rawName);
                },
              ),
              const SizedBox(height: 40),
              CustomButton1(
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                ),
                label: 'Memulai',
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(String username) {
    return Column(
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Hai $username! Selamat datang di ',
                style: AppTextStyles.heading2.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              TextSpan(
                text: 'VIDA Digital',
                style: AppTextStyles.heading2ColorsLight,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        Text(
          'Ruang aman untuk belajar dan mendapatkan informasi tentang HIV/AIDS.',
          style: AppTextStyles.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        Image.asset(illustration6, height: 389),
      ],
    );
  }
}
