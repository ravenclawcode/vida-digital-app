import 'package:flutter/material.dart';
import 'package:mindfullshelter/utils/app_colors.dart';

class CustomCheckbox1 extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showError;

  const CustomCheckbox1({
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
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: value ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: showError && !value
                ? AppColors.borderErrorColor
                : (value ? AppColors.primary : AppColors.borderColor),
            width: 1,
          ),
        ),
        child: value
            ? Icon(Icons.check, size: 14, color: AppColors.background)
            : null,
      ),
    );
  }
}
