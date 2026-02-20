import 'package:flutter/material.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';

class CustomSearchFormCommunity extends StatefulWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;

  const CustomSearchFormCommunity({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  State<CustomSearchFormCommunity> createState() =>
      _CustomSearchFormCommunityState();
}

class _CustomSearchFormCommunityState extends State<CustomSearchFormCommunity> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      keyboardType: TextInputType.text,
      style: AppTextStyles.textForm,
      maxLines: 1,
      cursorColor: AppColors.textPrimary,
      cursorErrorColor: AppColors.textPrimary,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        filled: true,
        fillColor: AppColors.backgroundList,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16, right: 4),
          child: Image.asset(icSearch, height: 16, width: 16),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 30),
        hintText: 'Cari berdasarkan nama...',
        hintStyle: AppTextStyles.hintForm,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.backgroundList),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.backgroundList),
        ),
      ),
      validator: (value) {
        return null;
      },
    );
  }
}
