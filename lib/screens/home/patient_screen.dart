import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mindfullshelter/models/patient_model.dart';
import 'package:mindfullshelter/providers/counselor_provider.dart';
import 'package:mindfullshelter/providers/private_chat_provider.dart';
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
  Timer? _statusTimer;

  @override
  void initState() {
    super.initState();
    _statusTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        context.read<PrivateChatProvider>().loadContacts();
        final patientId = ModalRoute.of(context)?.settings.arguments as String?;
        context.read<CounselorProvider>().fetchPatientDetail(
          patientId!,
          isSilent: true,
        );
      }
    });
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }

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
        'bgRoundColor': const Color(0xFFC8FFDB),
        'labelColor': const Color(0xFF00A63E),
      };
    } else if (score <= 9) {
      return {
        'category': 'Ringan',
        'bgColor': const Color(0xFFEFF6FF),
        'bgRoundColor': const Color(0xFFD5E8FF),
        'labelColor': const Color(0xFF165DFB),
      };
    } else if (score <= 14) {
      return {
        'category': 'Sedang',
        'bgColor': const Color(0xFFFEFCE8),
        'bgRoundColor': const Color(0xFFFFE7C3),
        'labelColor': const Color(0xFFD18700),
      };
    } else if (score <= 19) {
      return {
        'category': 'Cukup Berat',
        'bgColor': const Color(0xFFFFF7ED),
        'bgRoundColor': const Color(0xFFFFDDCF),
        'labelColor': const Color(0xFFF54900),
      };
    } else {
      return {
        'category': 'Berat',
        'bgColor': const Color(0xFFFEF3F2),
        'bgRoundColor': const Color(0xFFFFD0D2),
        'labelColor': const Color(0xFFE7000B),
      };
    }
  }

  Map<String, dynamic> _getPatientStatusStyle(String status, double progress) {
    Color progressColor;

    if (progress < 0) {
      progressColor = const Color(0xFFE0E0E0);
    } else {
      double percentage = progress * 100;
      if (percentage >= 80) {
        progressColor = const Color(0xFF00BC7D);
      } else if (percentage >= 60) {
        progressColor = const Color(0xFF00BBA7);
      } else if (percentage >= 40) {
        progressColor = const Color(0xFFFE9900);
      } else {
        progressColor = const Color(0xFFFF1F57);
      }
    }

    switch (status) {
      case 'Sangat Baik':
        return {
          'status': 'Sangat Baik',
          'bgColor': const Color(0xFFD0FAE5),
          'textColor': const Color(0xFF007A56),
          'progressColor': progressColor,
        };
      case 'Baik':
        return {
          'status': 'Baik',
          'bgColor': const Color(0xFFCBFBF1),
          'textColor': const Color(0xFF00786F),
          'progressColor': progressColor,
        };
      case 'Perlu Perhatian':
        return {
          'status': 'Perlu Perhatian',
          'bgColor': const Color(0xFFFEF3C6),
          'textColor': const Color(0xFFBA4D00),
          'progressColor': progressColor,
        };
      case 'Belum Ada Data':
        return {
          'status': 'Belum Ada Data',
          'bgColor': const Color(0xFFF5F5F5),
          'textColor': const Color(0xFF757575),
          'progressColor': progressColor,
        };
      case 'Kritis':
        return {
          'status': 'Kritis',
          'bgColor': const Color(0xFFFEE4E6),
          'textColor': const Color(0xFFC70036),
          'progressColor': progressColor,
        };
      default:
        return {
          'status': status.isEmpty ? 'Belum Ada Data' : status,
          'bgColor': const Color(0xFFF5F5F5),
          'textColor': const Color(0xFF707070),
          'progressColor': progressColor,
        };
    }
  }

  Color _getMoodColor(double score) {
    if (score >= 4) return const Color(0xFF5ABF8F);
    if (score >= 3) return const Color(0xFFF2AB44);
    return const Color(0xFFEA4335);
  }

  String _formatDateOnly(String date) {
    if (date == '-') return '-';
    List<String> parts = date.split(' ');
    if (parts.length >= 2) {
      return "${parts[0]} ${parts[1]}";
    }
    return date;
  }

  Widget _buildAnimatedContent({required bool show, required Widget child}) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            axisAlignment: -1.0,
            child: child,
          ),
        );
      },
      child: show ? child : const SizedBox.shrink(),
    );
  }

  Map<String, List<MedicationLog>> _groupLogsByDay(List<MedicationLog> logs) {
    Map<String, List<MedicationLog>> grouped = {};
    final dayOrder = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];

    for (var log in logs) {
      String key = log.dayName;
      if (key.isNotEmpty) {
        if (!grouped.containsKey(key)) grouped[key] = [];
        grouped[key]!.add(log);
      }
    }

    var sortedKeys = grouped.keys.toList()
      ..sort((a, b) => dayOrder.indexOf(a).compareTo(dayOrder.indexOf(b)));

    return {for (var key in sortedKeys) key: grouped[key]!};
  }

  String _getEmojiForScore(double score) {
    int s = score.toInt();
    switch (s) {
      case 6:
        return '😊';
      case 5:
        return '😌';
      case 4:
        return '😐';
      case 3:
        return '😔';
      case 2:
        return '😟';
      case 1:
        return '😴';
      default:
        return '';
    }
  }

  String _getInitials(String name) {
    if (name.isEmpty) return "U";
    List<String> names = name.trim().split(" ");
    if (names.length >= 2) {
      return "${names[0][0]}${names[1][0]}".toUpperCase();
    }
    return name[0].toUpperCase();
  }

  Widget _buildDefaultAvatar(String username) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        _getInitials(username),
        style: AppTextStyles.profileChat.copyWith(fontSize: 18),
      ),
    );
  }

  Widget _buildPatientProfileImage(String? photoPath, String username) {
    if (photoPath != null && photoPath.isNotEmpty) {
      if (photoPath.startsWith('assets/')) {
        return Image.asset(
          photoPath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _buildDefaultAvatar(username),
        );
      }

      if (photoPath.startsWith('http')) {
        return Image.network(
          photoPath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _buildDefaultAvatar(username),
        );
      }
    }
    return _buildDefaultAvatar(username);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CounselorProvider>();
    final patient = provider.selectedPatient;

    if (patient == null && provider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (patient == null) {
      return const Scaffold(body: Center(child: Text("Data tidak ditemukan")));
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
              patientName: patient.name,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: CustomButton13(
                onTap: () {
                  final chatProv = context.read<PrivateChatProvider>();
                  final liveStatus = chatProv.getContactStatus(
                    patient.id.toString(),
                  );

                  Navigator.pushNamed(
                    context,
                    '/chatmessage',
                    arguments: {
                      'id': patient.id.toString(),
                      'username': patient.name,
                      'is_online': liveStatus != null
                          ? (liveStatus['is_online'] == true ||
                                liveStatus['is_online'] == 1)
                          : patient.isOnline,
                      'last_seen_display':
                          liveStatus?['last_seen_display'] ??
                          patient.lastSeenDisplay,
                      'profile_photo_url': patient.profilePhotoUrl,
                    },
                  );
                },
                icon: icComment,
                label: 'Buka Obrolan',
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  final patientId =
                      ModalRoute.of(context)?.settings.arguments as String?;
                  if (patientId != null) {
                    await context.read<CounselorProvider>().fetchPatientDetail(
                      patientId,
                    );
                  }
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
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
    return Consumer2<CounselorProvider, PrivateChatProvider>(
      builder: (context, counselorProv, chatProv, child) {
        final patient = counselorProv.selectedPatient;
        final String patientId = patient?.id.toString() ?? '';

        final liveStatus = chatProv.getContactStatus(patientId);

        bool currentOnline = liveStatus != null
            ? (liveStatus['is_online'] == true || liveStatus['is_online'] == 1)
            : (patient?.isOnline ?? false);

        String statusText = currentOnline
            ? 'Online'
            : (liveStatus?['last_seen_display'] ??
                  patient?.lastSeenDisplay ??
                  'Offline');

        final String? patientPhoto = patient?.profilePhotoUrl;

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
                    decoration: BoxDecoration(
                      color: AppColors.accentLight,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: _buildPatientProfileImage(
                        patientPhoto,
                        patientName,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(patientName, style: AppTextStyles.heading),
                      Text(
                        statusText,
                        style: AppTextStyles.bodyMediumChatbot.copyWith(
                          color: currentOnline
                              ? const Color(0xFF66BB6A)
                              : AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMedicalCard(BuildContext context, Patient patient) {
    final double rawProgress = patient.progress;
    final String percentage = rawProgress < 0
        ? "0%"
        : "${(rawProgress * 100).toInt()}%";
    final double indicatorValue = rawProgress < 0 ? 0.0 : rawProgress;

    final List<MedicationLog> logs = patient.medicationLogs ?? [];
    final groupedLogs = _groupLogsByDay(logs);
    final style = _getPatientStatusStyle(patient.status, rawProgress);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
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
            _buildAnimatedContent(
              show: !_showMedicationDetail,
              child: Column(
                key: const ValueKey('med_summary'),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ringkasan Kepatuhan',
                    style: AppTextStyles.headingTesPHQ,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tingkat Kepatuhan Obat',
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
                      value: indicatorValue,
                      backgroundColor: const Color(0xFFF5F5F5),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        style['progressColor'],
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () =>
                            setState(() => _showMedicationDetail = true),
                        child: Text(
                          'Detail',
                          style: AppTextStyles.actionPatient,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Image.asset(icNext, height: 10),
                    ],
                  ),
                ],
              ),
            ),
            _buildAnimatedContent(
              show: _showMedicationDetail,
              child: Column(
                key: const ValueKey('med_detail'),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        child: Text(
                          'Tutup',
                          style: AppTextStyles.actionPatient,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  groupedLogs.isEmpty
                      ? Center(
                          child: Text(
                            "Belum ada riwayat obat",
                            style: AppTextStyles.noContent,
                          ),
                        )
                      : Column(
                          children: groupedLogs.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFAFC),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: const Color(0xFFFFE5F0),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          entry.key,
                                          style: AppTextStyles.dayMedical,
                                        ),
                                        Text(
                                          entry.value.isNotEmpty
                                              ? entry.value.first.dateFormatted
                                              : '-',
                                          style: AppTextStyles.dayTes,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    ...entry.value.map(
                                      (log) => _buildDrugRow(
                                        log.medicationName,
                                        log.isTaken
                                            ? icImplemented
                                            : icNotImplemented,
                                        log.isTaken ? 'Diminum' : 'Terlewat',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrugRow(String name, String icon, String status) {
    final Color statusColor = status == 'Diminum'
        ? const Color(0xFF00A63E)
        : const Color(0xFFEA4335);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: AppTextStyles.drugName.copyWith(fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Image.asset(icon, height: 14),
            const SizedBox(width: 6),
            Text(
              status,
              style: AppTextStyles.drugStatus.copyWith(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultPHQ(BuildContext context, Patient patient) {
    final int score = (patient.lastPhqScore ?? 0).toInt();
    final String date = patient.lastPhqDate ?? '-';
    final phqConfig = _getPhqConfig(score);

    final List<PhqHistory> history = patient.phqHistory ?? [];
    final bool isDataEmpty = date == '-';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
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
            _buildAnimatedContent(
              show: !_showPhqDetail,
              child: Column(
                key: const ValueKey('phq_summary'),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hasil Tes PHQ-9', style: AppTextStyles.headingTesPHQ),
                  const SizedBox(height: 18),
                  if (isDataEmpty)
                    Center(
                      child: Text(
                        "Belum ada hasil tes",
                        style: AppTextStyles.noContent,
                      ),
                    )
                  else ...[
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
                              Text(
                                'Tes Terbaru',
                                style: AppTextStyles.titleTes,
                              ),
                              Text(
                                _formatDateOnly(date),
                                style: AppTextStyles.dayTes,
                              ),
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
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          overlayColor: WidgetStateProperty.all(
                            Colors.transparent,
                          ),
                          onTap: () => setState(() => _showPhqDetail = true),
                          child: Text(
                            'Detail',
                            style: AppTextStyles.actionPatient,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Image.asset(icNext, height: 10),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            _buildAnimatedContent(
              show: _showPhqDetail,
              child: Column(
                key: const ValueKey('phq_detail'),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Detail Riwayat PHQ-9',
                        style: AppTextStyles.headingTesPHQ,
                      ),
                      InkWell(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        overlayColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ),
                        onTap: () => setState(() => _showPhqDetail = false),
                        child: Text(
                          'Tutup',
                          style: AppTextStyles.actionPatient,
                        ),
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
                      final int s = item.score;
                      final String d = item.date;
                      final cat = item.category;
                      return _buildPhqHistoryItem(s, cat, d);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhqHistoryItem(int score, String category, String date) {
    final config = _getPhqConfig(score);
    final Color dynamicBgColor = config['bgColor'];
    final Color dynamicBgRoundColor = config['bgRoundColor'];
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
              color: dynamicBgRoundColor,
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
              Text(_formatDateOnly(date), style: AppTextStyles.dayTes),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartMood(BuildContext context, Patient patient) {
    final List<int> weeklyMoods = patient.weeklyMoods ?? [0, 0, 0, 0, 0, 0, 0];
    final String rangeDate = patient.moodWeekRange ?? "-";

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Log Mood Mingguan', style: AppTextStyles.headingTesPHQ),
                Text(
                  rangeDate,
                  style: AppTextStyles.dayTes.copyWith(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: AspectRatio(
                aspectRatio: 1.6,
                child: BarChart(
                  BarChartData(
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (group) => Color(0xFFF5F5F5),
                        tooltipBorderRadius: BorderRadius.circular(6),
                        tooltipPadding: EdgeInsets.only(
                          left: 8,
                          right: 8,
                          top: 6,
                          bottom: 2,
                        ),
                        tooltipMargin: 6,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            _getEmojiForScore(rod.toY),
                            TextStyle(fontSize: 18),
                          );
                        },
                      ),
                    ),
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 6.5,
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
                            if (value.toInt() < 0 ||
                                value.toInt() >= days.length) {
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
                            if (value == 0 || value > 6) {
                              return const SizedBox.shrink();
                            }
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
                      return _makeGroupData(
                        i,
                        weeklyMoods[i].toDouble(),
                        _getMoodColor(weeklyMoods[i].toDouble()),
                      );
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
          width: 28,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
      ],
    );
  }
}
