import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mindfullshelter/models/terms%20conditions.dart';
import 'package:mindfullshelter/providers/terms_conditions_provider.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button1.dart';
import 'package:mindfullshelter/utils/custom_button5.dart';
import 'package:mindfullshelter/utils/custom_checkbox1.dart';
import 'package:provider/provider.dart';

class TermsOfService extends StatefulWidget {
  const TermsOfService({super.key});

  @override
  State<TermsOfService> createState() => _TermsOfServiceState();
}

class _TermsOfServiceState extends State<TermsOfService> {
  bool positionEnd = false;
  bool showCheckboxError = false;
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TermsAndConditionsProvider>(context);
    final terms = provider.getTerms(TermsType.termsofService);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: ListView(
        controller: scrollController,
        children: [
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              "Terakhir diperbaharui: ${terms.lastUpdated.toString().split(' ')[0]}",
              style: AppTextStyles.heading5,
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: terms.clauses.map((clause) {
                List<String> paragraphs = clause.description.split('\n');

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clause.title,
                      style: AppTextStyles.heading3Bold.copyWith(fontSize: 16),
                    ),
                    SizedBox(height: 6),
                    ...paragraphs.map((text) {
                      if (text.trim().isEmpty) return SizedBox();
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: Text(
                          text,
                          style: AppTextStyles.bodyExtraLarge.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      );
                    }).toList(),
                    SizedBox(height: 10),
                  ],
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomCheckbox1(
                  value: terms.isAgree,
                  showError: showCheckboxError,
                  onChanged: (value) {
                    provider.toggleAgree(TermsType.termsofService);
                    if (value) {
                      setState(() => showCheckboxError = false);
                    }
                  },
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Saya telah membaca dan menyatakan\nsetuju untuk mengikuti Syarat &\nKetentuan Penggunaan Sistem yang\nada pada VIDA Digital.",
                    style: AppTextStyles.bodyExtraLarge.copyWith(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          terms.isAgree
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: CustomButton1(
                    onTap: () {
                      Navigator.pop(context, true);
                    },
                    label: "Setuju dan Lanjutkan",
                  ),
                )
              : SizedBox(height: 48),
          SizedBox(height: 85),
        ],
      ),
      floatingActionButton: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.6),
            ),
            padding: EdgeInsets.only(left: 25, right: 25, bottom: 20),
            child: CustomButton5(
              onTap: () {
                if (positionEnd) {
                  scrollController.animateTo(
                    scrollController.position.minScrollExtent,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                  setState(() => positionEnd = false);
                } else {
                  scrollController.animateTo(
                    scrollController.position.maxScrollExtent,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                  setState(() => positionEnd = true);
                }
              },
              icon: positionEnd ? icBackUp : icBackDown,
              label: positionEnd ? "Scroll ke Atas" : "Scroll ke bawah",
            ),
          ),
        ),
      ),
    );
  }
}
