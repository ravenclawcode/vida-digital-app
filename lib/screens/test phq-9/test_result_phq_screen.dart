import 'package:flutter/material.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button1.dart';

class TestResultPhqScreen extends StatefulWidget {
  final int score;
  const TestResultPhqScreen({super.key, required this.score});

  @override
  State<TestResultPhqScreen> createState() => _TestResultPhqScreenState();
}

class _TestResultPhqScreenState extends State<TestResultPhqScreen> {
  Map<String, dynamic> _getResultConfig(int score) {
    if (score <= 4) {
      return {
        'category': 'Minimal',
        'bgColor': const Color(0xFFEFFDF4),
        'labelColor': const Color(0xFF00A63E),
        'recommendation':
            '• Skor Anda menunjukkan gejala depresi minimal\n• Tetap jaga kesehatan mental dengan aktivitas positif\n• Istirahat yang cukup dan pola makan teratur.',
      };
    } else if (score <= 9) {
      return {
        'category': 'Ringan',
        'bgColor': const Color(0xFFEFF6FF),
        'labelColor': const Color(0xFF165DFB),
        'recommendation':
            '• Skor Anda menunjukkan gejala depresi ringan\n• Pertimbangkan untuk berbicara dengan konselor\n• Lakukan teknik relaksasi secara rutin.',
      };
    } else if (score <= 14) {
      return {
        'category': 'Sedang',
        'bgColor': const Color(0xFFFEFCE8),
        'labelColor': const Color(0xFFD18700),
        'recommendation':
            '• Skor Anda menunjukkan gejala depresi sedang\n• Sangat disarankan untuk berkonsultasi\n• Monitor perubahan suasana hati Anda setiap hari.',
      };
    } else if (score <= 19) {
      return {
        'category': 'Cukup Berat',
        'bgColor': const Color(0xFFFFF7ED),
        'labelColor': const Color(0xFFF54900),
        'recommendation':
            '• Skor Anda menunjukkan gejala depresi cukup berat\n• Sangat penting untuk segera berkonsultasi\n• Jangan ragu mencari dukungan dari orang terdekat.',
      };
    } else {
      return {
        'category': 'Berat',
        'bgColor': const Color(0xFFFEF3F2),
        'labelColor': const Color(0xFFE7000B),
        'recommendation':
            '• Skor Anda menunjukkan gejala depresi berat\n• Segera cari bantuan profesional medis atau psikolog\n• Hubungi layanan darurat jika ada pikiran menyakiti diri sendiri.',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = _getResultConfig(widget.score);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            _buildHeader(context),
            const SizedBox(height: 20),
            _buildResultCard(context, config),
            const SizedBox(height: 20),
            _buildRecommendationCard(context, config),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: CustomButton1(
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                ),
                label: 'Kembali',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Center(
      child: Text('Hasil Tes PHQ-9', style: AppTextStyles.heading3Bold),
    );
  }

  Widget _buildResultCard(BuildContext context, Map<String, dynamic> config) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        height: 177,
        width: double.infinity,
        decoration: BoxDecoration(
          color: config['bgColor'],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${widget.score}', style: AppTextStyles.poinTesPHQ),
            Text('dari 27 poin', style: AppTextStyles.totalTesPHQ),
            const SizedBox(height: 8),
            Text(
              config['category'],
              style: AppTextStyles.categoryTesPHQ.copyWith(
                color: config['labelColor'],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context,
    Map<String, dynamic> config,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE9E9E9)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(17, 12, 17, 17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Rekomendasi', style: AppTextStyles.titleGuidline),
              const SizedBox(height: 5),
              Text(
                config['recommendation'],
                style: AppTextStyles.descGuidline.copyWith(height: 1.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
