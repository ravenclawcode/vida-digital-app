import 'package:flutter/material.dart';
import 'package:mindfullshelter/utils/app_colors.dart';

class CustomButton9 extends StatelessWidget {
  final VoidCallback? onTap;
  final String icon;
  const CustomButton9({super.key, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 34,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Image.asset(icon),
      ),
    );
  }
}
