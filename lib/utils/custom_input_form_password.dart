import 'package:flutter/material.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';

class CustomInputFormPassword extends StatefulWidget {
  final TextEditingController controller;
  final bool isConfirm;
  final TextEditingController? passwordController;

  const CustomInputFormPassword({
    super.key,
    required this.controller,
    this.isConfirm = false,
    this.passwordController,
  });

  @override
  State<CustomInputFormPassword> createState() =>
      _CustomInputFormPasswordState();
}

class _CustomInputFormPasswordState extends State<CustomInputFormPassword> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      keyboardType: TextInputType.visiblePassword,
      style: AppTextStyles.textForm,
      maxLines: 1,
      cursorColor: AppColors.textPrimary,
      cursorErrorColor: AppColors.textPrimary,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.backgroundForm,
        hintText: widget.isConfirm ? 'Konfirmasi Kata Sandi' : 'Kata Sandi',
        hintStyle: AppTextStyles.hintForm,
        suffixIcon: IconButton(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Image.asset(
            _obscure ? icVisibilityOff : icVisibility,
            width: 20,
            height: 18,
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
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
          return widget.isConfirm
              ? 'Konfirmasi kata sandi harus diisi'
              : 'Kata Sandi harus diisi';
        }
        if (!widget.isConfirm && value.length < 6) {
          return 'Password minimal 6 karakter';
        }
        if (widget.isConfirm &&
            (widget.passwordController?.text.trim() ?? '') != value.trim()) {
          return 'Kata sandi tidak cocok';
        }
        return null;
      },
    );
  }
}
