import 'package:flutter/material.dart';
import 'package:mindfullshelter/providers/auth_provider.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button12.dart';
import 'package:mindfullshelter/utils/custom_button2.dart';
import 'package:provider/provider.dart';

class CustomDialogRemoveAccount extends StatefulWidget {
  const CustomDialogRemoveAccount({super.key});

  @override
  State<CustomDialogRemoveAccount> createState() =>
      _CustomDialogRemoveAccountState();
}

class _CustomDialogRemoveAccountState extends State<CustomDialogRemoveAccount> {
  @override
  Widget build(BuildContext context) {
    void _remove() async {
      final navigator = Navigator.of(context);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      bool success = await authProvider.removeAccount();

      if (success) {
        if (navigator.canPop()) {
          navigator.pop();
        }
        navigator.pushNamedAndRemoveUntil('/introduction', (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menghapus akun. Silakan coba lagi.'),
          ),
        );
      }
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          clipBehavior: Clip.antiAlias,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(color: AppColors.background),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Hapus Akun', style: AppTextStyles.heading3),
                const SizedBox(height: 10),
                const Text(
                  'Apakah Anda yakin ingin menghapus akun ini? Tindakan ini bersifat permanen dan akun Anda tidak dapat dipulihkan kembali',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                CustomButton12(onTap: _remove, label: 'Hapus'),
                const SizedBox(height: 6),
                CustomButton2(
                  onTap: () => Navigator.pop(context),
                  label: 'Batal',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
