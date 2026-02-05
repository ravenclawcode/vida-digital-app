import 'package:flutter/material.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';

class CustomInputKeyTesPhq9 extends StatefulWidget {
  final TextEditingController controller;

  const CustomInputKeyTesPhq9({super.key, required this.controller});

  @override
  State<CustomInputKeyTesPhq9> createState() => _CustomInputKeyTesPhq9State();
}

class _CustomInputKeyTesPhq9State extends State<CustomInputKeyTesPhq9> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.text,
      style: AppTextStyles.textForm,
      maxLines: 1,
      cursorColor: AppColors.textPrimary,
      cursorErrorColor: AppColors.textPrimary,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        filled: true,
        fillColor: AppColors.backgroundList,
        hintText: 'Masukan kode akses',
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
          return 'Kode akses harus diisi';
        }
        if (value.trim().length < 5) {
          return 'Kode akses terlalu pendek';
        }
        return null;
      },
    );
  }
}
