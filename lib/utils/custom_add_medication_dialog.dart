import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindfullshelter/models/medication_model.dart';
import 'package:mindfullshelter/providers/medication_provider.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button1.dart';
import 'package:mindfullshelter/utils/custom_button2.dart';
import 'package:mindfullshelter/utils/custom_button4.dart';
import 'package:mindfullshelter/utils/custom_checkbox2.dart';
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
  bool isAgreed = false;
  bool showCheckboxError = false;
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
      final provider = context.read<MedicationProvider>();

      if (widget.entry == null) {
        await provider.addMedication(name, timeRaw, isEveryday: isAgreed);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Obat baru berhasil ditambahkan!')),
          );
        }
      } else {
        await provider.updateMedication(
          widget.entry!.medication.id,
          name,
          timeRaw,
          isEveryday: isAgreed,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perubahan obat berhasil disimpan!')),
          );
        }
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memproses data. Coba lagi.')),
        );
      }
    }
  }

  bool get _isChanged {
    if (widget.entry == null) {
      return true;
    }

    final initialName = widget.entry!.medication.name;
    final initialTime =
        '${widget.entry!.medication.time.hour.toString().padLeft(2, '0')}.${widget.entry!.medication.time.minute.toString().padLeft(2, '0')}';
    final initialEveryday = widget.entry!.medication.isEveryday;

    return _nameController.text.trim() != initialName ||
        _timeController.text.trim() != initialTime ||
        isAgreed != initialEveryday;
  }

  bool get _canSubmit {
    if (!_isValid) return false;
    if (widget.entry != null && !_isChanged) {
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();

    if (widget.entry != null) {
      _nameController.text = widget.entry!.medication.name;
      _timeController.text =
          '${widget.entry!.medication.time.hour.toString().padLeft(2, '0')}.'
          '${widget.entry!.medication.time.minute.toString().padLeft(2, '0')}';
      isAgreed = widget.entry!.medication.isEveryday;
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
                  SizedBox(height: 14),
                  Row(
                    children: [
                      CustomCheckbox2(
                        value: isAgreed,
                        showError: showCheckboxError,
                        onChanged: (value) {
                          setState(() {
                            isAgreed = value;
                            if (value) showCheckboxError = false;
                          });
                        },
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Setiap hari',
                        style: AppTextStyles.actionMedication,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _canSubmit
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
