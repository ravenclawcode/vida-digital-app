import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindfullshelter/models/medication_model.dart';
import 'package:mindfullshelter/providers/medication_provider.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button1.dart';
import 'package:mindfullshelter/utils/custom_button2.dart';
import 'package:mindfullshelter/utils/custom_button4.dart';
import 'package:mindfullshelter/utils/time_dash_formatter.dart';
import 'package:provider/provider.dart';

class CustomAddMedicationDialog extends StatefulWidget {
  final MedicationEntry? entry;

  const CustomAddMedicationDialog({super.key, this.entry});

  @override
  State<CustomAddMedicationDialog> createState() =>
      _CustomAddMedicationDialogState();
}

class _CustomAddMedicationDialogState extends State<CustomAddMedicationDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  bool get _isValid =>
      _nameController.text.trim().isNotEmpty && _parseTime() != null;

  DateTime? _parseTime() {
    final text = _timeController.text.trim();
    final parts = text.split('.');

    if (parts.length != 2) return null;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null ||
        minute == null ||
        hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59) {
      return null;
    }

    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  void _submit() async {
    final String name = _nameController.text.trim();
    final String timeRaw = _timeController.text.trim().replaceAll('.', ':');

    if (name.isEmpty || timeRaw.isEmpty) return;

    try {
      await context.read<MedicationProvider>().addMedication(name, timeRaw);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan obat. Coba lagi.')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.entry != null) {
      _nameController.text = widget.entry!.medication.name;
      _timeController.text =
          '${widget.entry!.medication.time.hour.toString().padLeft(2, '0')}.'
          '${widget.entry!.medication.time.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            clipBehavior: Clip.antiAlias,
            child: Container(
              padding: EdgeInsets.fromLTRB(25, 25, 25, 15),
              color: AppColors.background,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.entry == null ? 'Tambah Obat' : 'Edit Obat',
                    style: AppTextStyles.titleAddPost,
                  ),

                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Nama Obat',
                      style: AppTextStyles.bodyPost.copyWith(fontSize: 14),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan nama obat',
                      hintStyle: AppTextStyles.addStory.copyWith(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                      filled: true,
                      fillColor: AppColors.backgroundList,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.all(12),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Waktu',
                      style: AppTextStyles.bodyPost.copyWith(fontSize: 14),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _timeController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TimeDotFormatter(),
                    ],
                    decoration: InputDecoration(
                      hintText: '--.--',
                      filled: true,
                      fillColor: AppColors.backgroundList,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.all(12),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),

                  SizedBox(height: 20),
                  _isValid
                      ? CustomButton1(
                          onTap: _submit,
                          label: widget.entry == null ? 'Tambah' : 'Simpan',
                        )
                      : CustomButton4(
                          label: Text(
                            widget.entry == null ? 'Tambah' : 'Simpan',
                            style: AppTextStyles.button1,
                          ),
                        ),

                  SizedBox(height: 6),
                  CustomButton2(
                    onTap: () => Navigator.pop(context),
                    label: 'batal',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
