import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindfullshelter/providers/phq9_provider.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button1.dart';
import 'package:provider/provider.dart';

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
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 23),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE9E9E9)),
        ),
        child: Consumer<PhqProvider>(
          builder: (context, phqProvider, child) {
            bool hasCode = phqProvider.currentCode != null;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(icStethoscope, height: 16),
                    const SizedBox(width: 10),
                    Text(
                      'Generate Kode PHQ-9',
                      style: AppTextStyles.headingTesPHQ,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Buat kode unik untuk penilaian skrining depresi PHQ-9. Bagikan kode ini kepada pasien.',
                  style: AppTextStyles.bodyTesPHQ,
                ),
                const SizedBox(height: 18),
                CustomButton1(
                  onTap: phqProvider.isLoading
                      ? () {}
                      : () => phqProvider.createNewCode(),
                  label: 'Buat Kode',
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  alignment: Alignment.topCenter,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: hasCode ? 1 : 0,
                    child: hasCode
                        ? Padding(
                            padding: const EdgeInsets.only(top: 18),
                            child: _buildActionForm(
                              phqProvider.currentCode!.code,
                              phqProvider,
                            ),
                          )
                        : const SizedBox(width: double.infinity, height: 0),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionForm(String code, PhqProvider provider) {
    return Container(
      height: 104,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFFE8F1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kode yang dibuat',
            style: AppTextStyles.bodyTesPHQ.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.only(left: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFFFE8F1)),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(code, style: AppTextStyles.keyTesPHQ),
                ),
              ),
              const SizedBox(width: 10),
              _buildSmallButton(icCopy, () {
                Clipboard.setData(ClipboardData(text: code));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Kode berhasil disalin!'),
                    duration: Duration(seconds: 1),
                  ),
                );
              }),
              const SizedBox(width: 6),
              _buildSmallButton(icDelete, () => provider.removeCodeLocal()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallButton(String icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      child: Container(
        height: 33,
        width: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFFFE8F1)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Image.asset(icon),
        ),
      ),
    );
  }
}
