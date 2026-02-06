import 'package:flutter/material.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';

class CustomInputFormPatient extends StatefulWidget {
  final TextEditingController controller;

  const CustomInputFormPatient({super.key, required this.controller});

  @override
  State<CustomInputFormPatient> createState() => _CustomInputFormPatientState();
}

class _CustomInputFormPatientState extends State<CustomInputFormPatient> {
  final List<String> _genderOptions = ['Vida1', 'Vida2', 'Vida3'];

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
        hintText: 'Pilih pasien',
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Pilih pasien harus diisi';
        }
        return null;
      },
      onChanged: (String? value) {
        setState(() {
          widget.controller.text = value ?? '';
        });
      },
    );
  }
}
