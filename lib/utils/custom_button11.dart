import 'package:flutter/material.dart';
import 'package:mindfullshelter/utils/app_theme.dart';

class CustomButton11 extends StatelessWidget {
  final VoidCallback? onTap;
  final String label;
  const CustomButton11({super.key, required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Color(0xFFFF8DAF),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(label, style: AppTextStyles.button1),
      ),
    );
  }
}
