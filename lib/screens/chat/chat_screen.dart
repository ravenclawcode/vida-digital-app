import 'package:flutter/material.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 11),
              _buildHeader(context),
              SizedBox(height: 25),
              _buildContentTop(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('Chat', style: AppTextStyles.heading3Bold)],
      ),
    );
  }

  Widget _buildContentTop(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 3),
              color: Color(0xFFFAB1C6).withValues(alpha: 0.80),
              blurRadius: 10,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ruang Berbagi', style: AppTextStyles.headingChat),
              SizedBox(height: 4),
              Text(
                'Teman VIDA siap mendampingi Anda dengan aman dan privat',
                style: AppTextStyles.bodyChat,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
