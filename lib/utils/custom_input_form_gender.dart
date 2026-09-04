import 'package:flutter/material.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';

class CustomInputFormGender extends StatefulWidget {
  final TextEditingController controller;

  const CustomInputFormGender({super.key, required this.controller});

  @override
  State<CustomInputFormGender> createState() => _CustomInputFormGenderState();
}

class _CustomInputFormGenderState extends State<CustomInputFormGender> {
  final List<String> _genderOptions = ["Laki-laki", "Perempuan", "Lainnya"];

  @override
  Widget build(BuildContext context) {
    String? currentValue = _genderOptions.contains(widget.controller.text)
        ? widget.controller.text
        : null;

    return DropdownButtonFormField<String>(
      initialValue: currentValue,
      items: _genderOptions.map((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      style: AppTextStyles.textForm,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        filled: true,
        fillColor: AppColors.backgroundList,
        hintText: 'Jenis Kelamin',
        hintStyle: AppTextStyles.hintForm,
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.backgroundList),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.backgroundList),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 2, color: AppColors.borderErrorColor),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 2, color: AppColors.borderErrorColor),
        ),
      ),
      onChanged: (String? value) {
        setState(() {
          widget.controller.text = value ?? '';
        });
      },
    );
  }
}
