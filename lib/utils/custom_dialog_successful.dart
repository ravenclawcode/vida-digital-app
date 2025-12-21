import 'package:flutter/material.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button1.dart';

class CustomDialogSuccessful extends StatelessWidget {
  const CustomDialogSuccessful({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          clipBehavior: Clip.antiAlias,
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            decoration: BoxDecoration(color: AppColors.background),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Berhasil', style: AppTextStyles.heading3),
                SizedBox(height: 10),
                Text(
                  'Selamat! Kata sandi Anda telah\ndiubah. Klik lanjutkan untuk masuk.',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                CustomButton1(
                  onTap: () {
                    Navigator.pop(context);
                    Future.microtask(() {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/sign-in',
                        ModalRoute.withName('/introduction'),
                      );
                    });
                  },
                  label: 'Lanjutkan',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
