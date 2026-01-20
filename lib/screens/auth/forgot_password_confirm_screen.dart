import 'package:flutter/material.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button1.dart';

class ForgotPasswordConfirmScreen extends StatelessWidget {
  const ForgotPasswordConfirmScreen({super.key});

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
                context: context,
                icon: icBackLeft1,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader({
    required context,
    required String icon,
    required VoidCallback onTap,
  }) {
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
          child: Text('Reset Kata Sandi', style: AppTextStyles.heading2),
        ),
        SizedBox(height: 20),
        Align(
          alignment: AlignmentGeometry.topLeft,
          child: Text(
            'Kata sandi Anda berhasil diatur ulang. Klik\nkonfirmasi untuk membuat kata sandi baru.',
            style: AppTextStyles.bodyMedium,
          ),
        ),
        SizedBox(height: 35),
        CustomButton1(
          onTap: () =>
              Navigator.pushNamed(context, '/forgotpassword-inputnewpassword'),
          label: 'Konfirmasi',
        ),
      ],
    );
  }
}
