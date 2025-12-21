import 'package:flutter/material.dart';
import 'package:mindfullshelter/utils/app_colors.dart';

class CustomButton7 extends StatelessWidget {
  final String icon;
  const CustomButton7({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      child: Container(
        width: 54,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.buttonOff,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 13),
        child: Image.asset(icon),
      ),
    );
  }
}
