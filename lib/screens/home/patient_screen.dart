import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mindfullshelter/providers/counselor_provider.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button13.dart';
import 'package:provider/provider.dart';

class PatientScreen extends StatefulWidget {
  const PatientScreen({super.key});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  bool _showMedicationDetail = false;
  bool _showPhqDetail = false;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final patientId = ModalRoute.of(context)?.settings.arguments as String?;

      if (patientId != null) {
        Future.microtask(() {
          if (mounted) {
            context.read<CounselorProvider>().fetchPatientDetail(patientId);
          }
        });
      }
      _isInit = false;
    }
  }

  Map<String, dynamic> _getPhqConfig(int score) {
    if (score <= 4) {
      return {
        'category': 'Minimal',
        'bgColor': const Color(0xFFEFFDF4),
        'labelColor': const Color(0xFF00BC7D),
      };
    } else if (score <= 9) {
      return {
        'category': 'Ringan',
        'bgColor': const Color(0xFFEFF6FF),
        'labelColor': const Color(0xFF165DFB),
      };
    } else if (score <= 14) {
      return {
        'category': 'Sedang',
        'bgColor': const Color(0xFFFEFCE8),
        'labelColor': const Color(0xFFD18700),
      };
    } else if (score <= 19) {
      return {
        'category': 'Cukup Berat',
        'bgColor': const Color(0xFFFFF7ED),
        'labelColor': const Color(0xFFF54900),
      };
    } else {
      return {
        'category': 'Berat',
        'bgColor': const Color(0xFFFEF3F2),
        'labelColor': const Color(0xFFE7000B),
      };
    }
  }

  Color _getMoodColor(double score) {
    if (score >= 4) return const Color(0xFF5ABF8F);
    if (score >= 3) return const Color(0xFFF2AB44);
    return const Color(0xFFEA4335);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CounselorProvider>();
    final patient = provider.selectedPatient;

    if (provider.isLoading || patient == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 11),
            _buildHeader(
              context: context,
              icon: icBackLeft2,
              onTap: () => Navigator.pop(context),
              patientName: patient['name'] ?? 'Pasien',
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: CustomButton13(
                onTap: () => Navigator.pushNamed(
                  context,
                  '/chatmessage',
                  arguments: {'id': patient['id'], 'username': patient['name']},
                ),
                icon: icComment,
                label: 'Buka Obrolan',
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    _buildMedicalCard(context, patient),
                    const SizedBox(height: 16),
                    _buildChartMood(context, patient),
                    const SizedBox(height: 16),
                    _buildResultPHQ(context, patient),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader({
    required BuildContext context,
    required String icon,
    required VoidCallback onTap,
    required String patientName,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          InkWell(onTap: onTap, child: Image.asset(icon, width: 10)),
          const SizedBox(width: 25),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.accentLight,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(icAnonymousProfile),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(patientName, style: AppTextStyles.heading),
                  Text(
                    'Offline',
                    style: AppTextStyles.bodyMediumChatbot.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalCard(BuildContext context, Map<String, dynamic> patient) {
    final double progress = (patient['progress'] ?? 0.0).toDouble();
    final String percentage = "${(progress * 100).toInt()}%";
    final List<dynamic> logs = patient['medication_logs'] ?? [];
    final int lastScore = (patient['last_phq_score'] ?? 0).toInt();
    final Color progressColor = _getPhqConfig(lastScore)['labelColor'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 23),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE9E9E9)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_showMedicationDetail) ...[
                Text('Ringkasan Kepatuhan', style: AppTextStyles.headingTesPHQ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tingkat Kepatuhan Hari Ini',
                      style: AppTextStyles.bodyTesPHQ,
                    ),
                    Text(percentage, style: AppTextStyles.percentageLarge),
                  ],
                ),
                const SizedBox(height: 18),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    minHeight: 10,
                    value: progress,
                    backgroundColor: const Color(0xFFF5F5F5),
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () => setState(() => _showMedicationDetail = true),
                      child: Text('Detail', style: AppTextStyles.actionPatient),
                    ),
                    const SizedBox(width: 8),
                    Image.asset(icNext, height: 10),
                  ],
                ),
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Detail Riwayat Obat',
                      style: AppTextStyles.headingTesPHQ,
                    ),
                    InkWell(
                      onTap: () =>
                          setState(() => _showMedicationDetail = false),
                      child: Text('Tutup', style: AppTextStyles.actionPatient),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                logs.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text("Belum ada data obat hari ini"),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFFFE5F0)),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: logs.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, i) {
                            final log = logs[i];
                            return _buildDrugRow(
                              log['medication_name'] ?? 'Obat',
                              log['is_taken'] == 1
                                  ? icImplemented
                                  : icNotImplemented,
                              log['is_taken'] == 1 ? 'Diminum' : 'Terlewat',
                            );
                          },
                        ),
                      ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrugRow(String name, String icon, String status) {
    final Color statusColor = status == 'Diminum'
        ? const Color(0xFF00A63E)
        : const Color(0xFFEA4335);
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: AppTextStyles.drugName,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Image.asset(icon, height: 12),
            const SizedBox(width: 4),
            Text(
              status,
              style: AppTextStyles.drugStatus.copyWith(color: statusColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultPHQ(BuildContext context, Map<String, dynamic> patient) {
    final int score = (patient['last_phq_score'] ?? 0).toInt();
    final String date = patient['last_phq_date'] ?? '-';
    final phqConfig = _getPhqConfig(score);

    final List<dynamic> history =
        patient['phq_history'] ??
        [
          {'score': score, 'date': date},
        ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 23),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE9E9E9)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_showPhqDetail) ...[
                Text('Hasil Tes PHQ-9', style: AppTextStyles.headingTesPHQ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: phqConfig['bgColor'],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tes Terbaru', style: AppTextStyles.titleTes),
                          Text(date, style: AppTextStyles.dayTes),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text('$score', style: AppTextStyles.poinTes),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: (phqConfig['labelColor'] as Color)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              phqConfig['category'],
                              style: AppTextStyles.categoryPatient.copyWith(
                                color: phqConfig['labelColor'],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () => setState(() => _showPhqDetail = true),
                      child: Text('Detail', style: AppTextStyles.actionPatient),
                    ),
                    const SizedBox(width: 8),
                    Image.asset(icNext, height: 10),
                  ],
                ),
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Detail Riwayat PHQ-9',
                      style: AppTextStyles.headingTesPHQ,
                    ),
                    InkWell(
                      onTap: () => setState(() => _showPhqDetail = false),
                      child: Text('Tutup', style: AppTextStyles.actionPatient),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: history.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = history[index];
                    final int s = (item['score'] ?? 0).toInt();
                    final String d = item['date'] ?? '-';
                    final cat = _getPhqConfig(s)['category'];

                    return _buildPhqHistoryItem(s, cat, d);
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhqHistoryItem(int score, String category, String date) {
    final config = _getPhqConfig(score);
    final Color dynamicBgColor = config['bgColor'];
    final Color dynamicLabelColor = config['labelColor'];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: dynamicBgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: dynamicLabelColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$score',
              style: AppTextStyles.poinAvatarTes.copyWith(
                color: dynamicLabelColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(category, style: AppTextStyles.titleTes),
              Text(date, style: AppTextStyles.dayTes),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartMood(BuildContext context, Map<String, dynamic> patient) {
    final List<dynamic> weeklyMoods =
        patient['weekly_moods'] ?? [0, 0, 0, 0, 0, 0, 0];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE9E9E9)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Log Mood Mingguan', style: AppTextStyles.headingTesPHQ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: AspectRatio(
                aspectRatio: 1.9,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 5,
                    minY: 0,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 1,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: const Color(0xFFE5E7EB),
                        strokeWidth: 1,
                        dashArray: [3, 3],
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const days = [
                              'Sen',
                              'Sel',
                              'Rab',
                              'Kam',
                              'Jum',
                              'Sab',
                              'Min',
                            ];
                            if (value.toInt() >= days.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                days[value.toInt()],
                                style: AppTextStyles.chart,
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            if (value == 0) return const SizedBox.shrink();
                            return Text(
                              value.toInt().toString(),
                              style: AppTextStyles.chart,
                            );
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: List.generate(weeklyMoods.length, (i) {
                      final double val = (weeklyMoods[i] ?? 0.0).toDouble();
                      return _makeGroupData(i, val, _getMoodColor(val));
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y == 0 ? 0.1 : y,
          color: color,
          width: 22,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
      ],
    );
  }
}
