import 'package:flutter/material.dart';
import 'package:mindfullshelter/utils/app_colors.dart';

class CustomButton4 extends StatelessWidget {
  final Widget label;
  const CustomButton4({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.buttonOff,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: label,
      ),
    );
  }
}
