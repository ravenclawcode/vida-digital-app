import 'package:flutter/material.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button12.dart';
import 'package:mindfullshelter/utils/custom_button2.dart';

class CustomDialogExit extends StatefulWidget {
  const CustomDialogExit({super.key});

  @override
  State<CustomDialogExit> createState() => _CustomDialogExitState();
}

class _CustomDialogExitState extends State<CustomDialogExit> {
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
                Text('Keluar Tes', style: AppTextStyles.heading3),
                SizedBox(height: 10),
                Text(
                  'Apakah Anda yakin ingin keluar\nsekarang?',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                CustomButton12(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (route) => false,
                    );
                  },
                  label: 'Keluar',
                ),
                SizedBox(height: 6),
                CustomButton2(
                  onTap: () => Navigator.pop(context),
                  label: 'Lanjut',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
