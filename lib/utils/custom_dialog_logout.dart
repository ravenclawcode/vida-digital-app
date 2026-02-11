import 'package:flutter/material.dart';
import 'package:mindfullshelter/providers/auth_provider.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button12.dart';
import 'package:mindfullshelter/utils/custom_button2.dart';
import 'package:provider/provider.dart';

class CustomDialogLogout extends StatefulWidget {
  const CustomDialogLogout({super.key});

  @override
  State<CustomDialogLogout> createState() => _CustomDialogLogoutState();
}

class _CustomDialogLogoutState extends State<CustomDialogLogout> {
  void _logout() async {
    await Provider.of<AuthProvider>(context, listen: false).logout();

    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/introduction', (route) => false);
    }
  }

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
                Text('Keluar', style: AppTextStyles.heading3),
                SizedBox(height: 10),
                Text(
                  'Apakah Anda yakin ingin keluar dari\nakun ini?',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                CustomButton12(onTap: _logout, label: 'Keluar'),
                SizedBox(height: 6),
                CustomButton2(
                  onTap: () => Navigator.pop(context),
                  label: 'batal',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
