import 'package:flutter/material.dart';
import 'package:mindfullshelter/providers/auth_provider.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button1.dart';
import 'package:mindfullshelter/utils/custom_button4.dart';
import 'package:mindfullshelter/utils/custom_input_key_tes_phq9.dart';
import 'package:provider/provider.dart';

class TestPhqScreen extends StatefulWidget {
  const TestPhqScreen({super.key});

  @override
  State<TestPhqScreen> createState() => _TestPhqScreenState();
}

class _TestPhqScreenState extends State<TestPhqScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _keyController = TextEditingController();
  bool get isFormFilled => _keyController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _keyController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            _buildHeader(context),
            const SizedBox(height: 20),
            _buildInformationCard(),
            const SizedBox(height: 20),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          InkWell(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            onTap: () => Navigator.pop(context),
            child: Image.asset(icBackLeft2, width: 10),
          ),
          const SizedBox(width: 25),
          Text('Tes PHQ-9', style: AppTextStyles.heading3Bold),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildInformationCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: Color(0xFFF1FFFE),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFF57D1C9)),
      ),
      child: Row(
        children: [
          Text('💡', style: TextStyle(fontSize: 32)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'PHQ-9 adalah kuesioner standar untuk menilai tingkat keparahan depresi',
              style: AppTextStyles.bodyLargeChatbot,
            ),
          ),
        ],
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
                Image.asset(icKey, height: 16),
                SizedBox(width: 10),
                Text('Masukan Kode Akses', style: AppTextStyles.headingTesPHQ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'Anda memerlukan kode akses dari konselor untuk mengikuti tes ini. Silakan hubungi konselor Anda untuk mendapatkan kode.', style: AppTextStyles.bodyTesPHQ,
            ),
            SizedBox(height: 16),
            Text('Kode Akses', style: AppTextStyles.subTesPHQ,),
            SizedBox(height: 12),
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
        children: [
          CustomInputKeyTesPhq9(controller: _keyController),
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
                          'Verifikasi & Mulai Tes',
                          style: AppTextStyles.button1,
                        ),
                );
              }
              return CustomButton1(
                onTap: () {},
                label: 'Verifikasi & Mulai Tes',
              );
            },
          ),
        ],
      ),
    );
  }
}
