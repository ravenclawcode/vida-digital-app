import 'package:flutter/material.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';

class CustomInputFormSoap extends StatefulWidget {
  final TextEditingController controller;

  const CustomInputFormSoap({super.key, required this.controller});

  @override
  State<CustomInputFormSoap> createState() => _CustomInputFormSoapState();
}

class _CustomInputFormSoapState extends State<CustomInputFormSoap> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        controller: widget.controller,
        keyboardType: TextInputType.text,
        style: AppTextStyles.textForm,
        maxLines: null,
        minLines: 3,
        cursorColor: AppColors.textPrimary,
        cursorErrorColor: AppColors.textPrimary,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          filled: true,
          fillColor: AppColors.backgroundList,
          hintText: 'Tuliskan disini...',
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
          if (value == null || value.isEmpty) {
            return 'Form harus diisi';
          }
          return null;
        },
      ),
    );
  }
}
