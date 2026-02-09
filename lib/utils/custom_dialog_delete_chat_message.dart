import 'package:flutter/material.dart';
import 'package:mindfullshelter/providers/private_chat_provider.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button12.dart';
import 'package:mindfullshelter/utils/custom_button2.dart';
import 'package:provider/provider.dart';

class CustomDialogDeleteChatMessage extends StatelessWidget {
  final String receiverId;

  const CustomDialogDeleteChatMessage({super.key, required this.receiverId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(color: AppColors.background),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Hapus Percakapan', style: AppTextStyles.heading3),
                const SizedBox(height: 10),
                const Text(
                  'Apakah Anda yakin ingin menghapus\nsemua pesan percakapan ini?',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                CustomButton12(
                  onTap: () async {
                    await context.read<PrivateChatProvider>().deleteMessages(
                      receiverId,
                    );
                    if (context.mounted) Navigator.pop(context);
                  },
                  label: 'Hapus',
                ),
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
