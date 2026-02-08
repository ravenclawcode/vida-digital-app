import 'package:flutter/material.dart';
import 'package:mindfullshelter/providers/soap_provider.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:provider/provider.dart';

class CustomInputFormPatient extends StatefulWidget {
  final TextEditingController controller;

  const CustomInputFormPatient({super.key, required this.controller});

  @override
  State<CustomInputFormPatient> createState() => _CustomInputFormPatientState();
}

class _CustomInputFormPatientState extends State<CustomInputFormPatient> {
  @override
  Widget build(BuildContext context) {
    final patients = context.watch<SoapProvider>().patients;

    return DropdownButtonFormField<String>(
      items: patients.map((patient) {
        return DropdownMenuItem<String>(
          value: patient['id'].toString(),
          child: Text(patient['username']),
        );
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
