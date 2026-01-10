import 'package:flutter/material.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';

class CustomInputFormUsername extends StatefulWidget {
  final TextEditingController controller;

  const CustomInputFormUsername({super.key, required this.controller});

  @override
  State<CustomInputFormUsername> createState() =>
      _CustomInputFormUsernameState();
}

class _CustomInputFormUsernameState extends State<CustomInputFormUsername> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.name,
      style: AppTextStyles.textForm,
      maxLines: 1,
      cursorColor: AppColors.textPrimary,
      cursorErrorColor: AppColors.textPrimary,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        filled: true,
        fillColor: AppColors.backgroundList,
        hintText: 'Nama Pengguna',
        hintStyle: AppTextStyles.hintForm,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.backgroundList),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.backgroundList),
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
          return 'Nama pengguna harus diisi';
        }
        if (value.trim().length < 3) {
          return 'Nama pengguna minimal 3 karakter';
        }
        return null;
      },
    );
  }
}
