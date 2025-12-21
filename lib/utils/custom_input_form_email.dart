import 'package:flutter/material.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';

class CustomInputFormEmail extends StatefulWidget {
  final TextEditingController controller;

  const CustomInputFormEmail({super.key, required this.controller});

  @override
  State<CustomInputFormEmail> createState() => _CustomInputFormEmailState();
}

class _CustomInputFormEmailState extends State<CustomInputFormEmail> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.emailAddress,
      style: AppTextStyles.textForm,
      maxLines: 1,
      cursorColor: AppColors.textPrimary,
      cursorErrorColor: AppColors.textPrimary,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        filled: true,
        fillColor: AppColors.backgroundForm,
        hintText: 'Alamat Email',
        hintStyle: AppTextStyles.hintForm,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.backgroundForm),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.backgroundForm),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 2, color: AppColors.borderErrorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 2, color: AppColors.borderErrorColor),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Alamat email harus diisi';
        }
        if (!value.trim().contains('@gmail.com')) {
          return 'Alamat email harus mengandung @gmail.com';
        }
        return null;
      },
    );
  }
}
