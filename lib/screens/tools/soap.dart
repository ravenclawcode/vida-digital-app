import 'package:flutter/material.dart';
import 'package:mindfullshelter/providers/auth_provider.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button1.dart';
import 'package:mindfullshelter/utils/custom_button4.dart';
import 'package:mindfullshelter/utils/custom_input_form_patient.dart';
import 'package:mindfullshelter/utils/custom_input_form_soap.dart';
import 'package:provider/provider.dart';

class Soap extends StatefulWidget {
  const Soap({super.key});

  @override
  State<Soap> createState() => _SoapState();
}

class _SoapState extends State<Soap> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _patientController = TextEditingController();
  final TextEditingController _subjectiveController = TextEditingController();
  final TextEditingController _objectiveController = TextEditingController();
  final TextEditingController _assessmentController = TextEditingController();
  final TextEditingController _planController = TextEditingController();
  bool get isFormFilled =>
      _patientController.text.trim().isNotEmpty &&
      _subjectiveController.text.trim().isNotEmpty &&
      _objectiveController.text.trim().isNotEmpty &&
      _assessmentController.text.trim().isNotEmpty &&
      _planController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _patientController.addListener(() => setState(() {}));
    _subjectiveController.addListener(() => setState(() {}));
    _objectiveController.addListener(() => setState(() {}));
    _assessmentController.addListener(() => setState(() {}));
    _planController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [const SizedBox(height: 16), _buildContent()],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 23),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xFFE9E9E9)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(icNotes, height: 16),
                SizedBox(width: 10),
                Text('Dokumentasi SOAP', style: AppTextStyles.headingTesPHQ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'Format dokumentasi terstruktur untuk pertemuan pasien (Subjective, Objective, Assessment, Plan).',
              style: AppTextStyles.bodyTesPHQ,
            ),
            _buildActionForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 14),
          Text('Pasien', style: AppTextStyles.subTesPHQ),
          SizedBox(height: 12),
          CustomInputFormPatient(controller: _patientController),
          SizedBox(height: 16),
          Text('Subjective', style: AppTextStyles.subTesPHQ),
          SizedBox(height: 12),
          CustomInputFormSoap(controller: _subjectiveController),
          SizedBox(height: 16),
          Text('Objective', style: AppTextStyles.subTesPHQ),
          SizedBox(height: 12),
          CustomInputFormSoap(controller: _objectiveController),
          SizedBox(height: 16),
          Text('Assessment', style: AppTextStyles.subTesPHQ),
          SizedBox(height: 12),
          CustomInputFormSoap(controller: _assessmentController),
          SizedBox(height: 16),
          Text('Plan', style: AppTextStyles.subTesPHQ),
          SizedBox(height: 12),
          CustomInputFormSoap(controller: _planController),
          SizedBox(height: 15),
          Consumer<AuthProvider>(
            builder: (context, auth, child) {
              final disabled = !isFormFilled || auth.isLoading;
              if (disabled) {
                return CustomButton4(
                  label: auth.isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.background,
                          ),
                        )
                      : Text(
                          'Simpan Catatan SOAP',
                          style: AppTextStyles.button1,
                        ),
                );
              }
              return CustomButton1(onTap: () {}, label: 'Simpan Catatan SOAP');
            },
          ),
        ],
      ),
    );
  }
}
