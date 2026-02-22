import 'package:flutter/material.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button12.dart';
import 'package:mindfullshelter/utils/custom_dialog_remove_account.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  void _removeAccount() async {
    showDialog(context: context, builder: (_) => CustomDialogRemoveAccount());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            _buildHeader(context),
            const SizedBox(height: 20),
            _buildContent(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: CustomButton12(onTap: _removeAccount, label: 'Hapus Akun'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          InkWell(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            onTap: () => Navigator.pop(context),
            child: Image.asset(icBackLeft2, width: 10),
          ),
          SizedBox(width: 25),
          Text('Privasi & Keamanan', style: AppTextStyles.heading3Bold),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      onTap: () {
        Navigator.pushNamed(context, '/change-password');
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ubah Kata Sandi', style: AppTextStyles.titleChat),
                      Text(
                        'Update kata sandi akun Anda',
                        style: AppTextStyles.subtitleChat,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Image.asset(icNext, height: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
