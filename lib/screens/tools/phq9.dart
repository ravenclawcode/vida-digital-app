import 'package:flutter/material.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button1.dart';

class Phq9 extends StatefulWidget {
  const Phq9({super.key});

  @override
  State<Phq9> createState() => _Phq9State();
}

class _Phq9State extends State<Phq9> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [const SizedBox(height: 16), _buildContent()]),
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
                Image.asset(icStethoscope, height: 16),
                SizedBox(width: 10),
                Text('Generate Kode PHQ-9', style: AppTextStyles.headingTesPHQ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'Buat kode unik untuk penilaian skrining depresi PHQ-9. Bagikan kode ini kepada pasien untuk menyelesaikan penilaian mereka.',
              style: AppTextStyles.bodyTesPHQ,
            ),
            SizedBox(height: 18),
            CustomButton1(onTap: () {}, label: 'Buat Kode'),
          ],
        ),
      ),
    );
  }
}
