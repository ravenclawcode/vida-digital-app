import 'package:flutter/material.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';

class CustomButton13 extends StatelessWidget {
  final VoidCallback? onTap;
  final String icon;
  final String label;
  const CustomButton13({
    super.key,
    required this.onTap,
    required this.icon,
    required this.label,
  });

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
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, height: 13.5, color: AppColors.textWhite),
            SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.button1.copyWith(
                color: AppColors.textWhite,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
