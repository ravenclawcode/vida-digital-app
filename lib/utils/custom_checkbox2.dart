import 'package:flutter/material.dart';
import 'package:mindfullshelter/utils/app_colors.dart';

class CustomCheckbox2 extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showError;

  const CustomCheckbox2({
    super.key,
    required this.value,
    required this.onChanged,
    this.showError = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: value ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
            color: showError && !value
                ? AppColors.borderErrorColor
                : (value ? AppColors.primary : AppColors.borderColor),
            width: 1,
          ),
        ),
        child: value
            ? Icon(Icons.check, size: 12, color: AppColors.background)
            : null,
      ),
    );
  }
}
