import 'package:flutter/material.dart';
import 'package:mindfullshelter/providers/chat_provider.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button12.dart';
import 'package:mindfullshelter/utils/custom_button2.dart';
import 'package:provider/provider.dart';

class CustomDialogDeleteChatbot extends StatefulWidget {
  const CustomDialogDeleteChatbot({super.key});

  @override
  State<CustomDialogDeleteChatbot> createState() =>
      _CustomDialogDeleteChatbotState();
}

class _CustomDialogDeleteChatbotState extends State<CustomDialogDeleteChatbot> {
  void _submit() async {
    await context.read<ChatProvider>().deleteAllChat();

    if (mounted) {
      Navigator.pop(context);
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
                Text('Hapus Percakapan', style: AppTextStyles.heading3),
                SizedBox(height: 10),
                Text(
                  'Apakah Anda yakin ingin menghapus\nsemua pesan percakapan ini?',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                CustomButton12(onTap: _submit, label: 'Hapus'),
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
