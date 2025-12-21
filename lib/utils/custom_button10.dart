import 'package:flutter/material.dart';
import 'package:mindfullshelter/utils/app_colors.dart';

class CustomButton10 extends StatelessWidget {
  final String icon;
  const CustomButton10({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      child: Container(
        width: 40,
        height: 34,
        decoration: BoxDecoration(
          color: AppColors.buttonOff,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Image.asset(icon),
      ),
    );
  }
}
