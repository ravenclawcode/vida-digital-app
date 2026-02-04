import 'package:flutter/material.dart';
import 'package:mindfullshelter/models/medication_model.dart';
import 'package:mindfullshelter/providers/medication_provider.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_add_medication_dialog.dart';
import 'package:mindfullshelter/utils/custom_button8.dart';
import 'package:provider/provider.dart';

class MedicationReminderScreen extends StatefulWidget {
  const MedicationReminderScreen({super.key});

  @override
  State<MedicationReminderScreen> createState() =>
      _MedicationReminderScreenState();
}

class _MedicationReminderScreenState extends State<MedicationReminderScreen> {
  void _addMedication() async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const CustomAddMedicationDialog(),
    );
  }

  void _handleDeleteMedication(
    BuildContext context,
    MedicationEntry entry,
  ) async {
    try {
      await context.read<MedicationProvider>().deleteMedication(
        entry.medication.id,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Obat "${entry.medication.name}" berhasil dihapus'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Gagal menghapus obat')));
      }
    }
  }

  void _handleEditMedication(
    BuildContext context,
    MedicationEntry entry,
  ) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => CustomAddMedicationDialog(entry: entry),
    );
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: CustomButton8(
                        onTap: _addMedication,
                        icon: icAdd,
                        label: 'Tambah Obat Baru',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Consumer<MedicationProvider>(
                      builder: (context, provider, _) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                              ),
                              child: Text(
                                'Daftar Obat (${provider.todayEntries.length})',
                                style: AppTextStyles.headingMedication,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildMedicationList(provider.todayEntries),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildTips(),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationList(List<MedicationEntry> entries) {
    if (entries.isEmpty) {
      return Center(
        child: Text('Belum ada obat tersedia', style: AppTextStyles.noContent),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final isLast = index == entries.length - 1;
        return _buildMedicationCard(entries[index], isLast);
      },
    );
  }

  Widget _buildMedicationCard(MedicationEntry entry, isLast) {
    return Container(
      height: 58,
      margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 3),
            blurRadius: 10,
            spreadRadius: 2,
            color: AppColors.shadow.withValues(alpha: 0.10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 22),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.medication.name,
                  style: AppTextStyles.titleMedication.copyWith(fontSize: 13),
                ),
                const SizedBox(height: 1),
                Row(
                  children: [
                    Image.asset(icTime, height: 10),
                    const SizedBox(width: 3),
                    Text(
                      '${entry.medication.time.hour.toString().padLeft(2, '0')}.${entry.medication.time.minute.toString().padLeft(2, '0')}',
                      style: AppTextStyles.dateMedication.copyWith(
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),

            GestureDetector(
              onTap: () => _handleEditMedication(context, entry),
              child: Image.asset(icEdit, height: 16),
            ),

            const SizedBox(width: 18),

            GestureDetector(
              onTap: () => _handleDeleteMedication(context, entry),
              child: Image.asset(icDelete1, height: 17),
            ),
          ],
        ),
      ),
    );
  }
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
        Text('Kelola Obat', style: AppTextStyles.heading3Bold),
      ],
    ),
  );
}

Widget _buildTips() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF57D1C9)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(17, 12, 17, 17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tips', style: AppTextStyles.titleGuidline),
            const SizedBox(height: 5),
            Text(
              '• Atur waktu sesuai jadwal minum obat Anda\n• Obat akan ditampilkan di beranda untuk pengingat\n• Tandai obat yang sudah diminum di beranda.',
              style: AppTextStyles.descGuidline.copyWith(height: 1.7),
            ),
          ],
        ),
      ),
    ),
  );
}
