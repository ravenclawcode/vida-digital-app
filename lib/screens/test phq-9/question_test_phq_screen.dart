import 'package:flutter/material.dart';
import 'package:mindfullshelter/providers/phq_provider.dart';
import 'package:mindfullshelter/routes/routes.dart';
import 'package:mindfullshelter/utils/custom_button4.dart';
import 'package:mindfullshelter/utils/custom_dialog_exit.dart';
import 'package:provider/provider.dart';
import 'package:mindfullshelter/providers/phq_question_provider.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button1.dart';
import 'package:mindfullshelter/utils/custom_progress_bar.dart';

class QuestionTestPhqScreen extends StatefulWidget {
  const QuestionTestPhqScreen({super.key});

  @override
  State<QuestionTestPhqScreen> createState() => _QuestionTestPhqScreenState();
}

class _QuestionTestPhqScreenState extends State<QuestionTestPhqScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<PhqQuestionProvider>().fetchQuestions(),
    );
  }

  void _showLogoutDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const CustomDialogExit(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final phqProvider = context.watch<PhqQuestionProvider>();

    final args = ModalRoute.of(context)?.settings.arguments;
    final String? tokenCode = args is String ? args : null;

    return Scaffold(
      body: SafeArea(
        child: phqProvider.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.textPink),
              )
            : Column(
                children: [
                  const SizedBox(height: 12),
                  _buildHeader(context),
                  const SizedBox(height: 20),
                  _buildProgress(context, phqProvider),
                  const SizedBox(height: 30),
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildListQuestion(
                        context,
                        phqProvider,
                        tokenCode,
                      ),
                    ),
                  ),
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
            onTap: () => _showLogoutDialog(context),
            child: Image.asset(icBackLeft2, width: 10),
          ),
          const SizedBox(width: 25),
          Text('Tes PHQ-9', style: AppTextStyles.heading3Bold),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildProgress(BuildContext context, PhqQuestionProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomProgressBar(value: provider.progress),
          const SizedBox(height: 8),
          Text(
            '${provider.answers.length} dari ${provider.questions.length} Pertanyaan',
            style: AppTextStyles.questionsTesPHQ.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildListQuestion(
    BuildContext context,
    PhqQuestionProvider provider,
    String? tokenCode,
  ) {
    bool isAllAnswered =
        provider.answers.length == provider.questions.length &&
        provider.questions.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...provider.questions.asMap().entries.map((entry) {
            int index = entry.key;
            var question = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${index + 1}. ${question.questionText}',
                  style: AppTextStyles.questionsTesPHQ.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 10),
                _buildOption(context, question, provider),
                const SizedBox(height: 20),
              ],
            );
          }).toList(),
          isAllAnswered
              ? CustomButton1(
                  onTap: () async {
                    if (tokenCode == null) return;

                    final phqProvider = Provider.of<PhqProvider>(
                      context,
                      listen: false,
                    );
                    final questionProvider = Provider.of<PhqQuestionProvider>(
                      context,
                      listen: false,
                    );

                    bool success = await questionProvider.submitResult(
                      tokenCode,
                    );

                    if (success) {
                      await phqProvider.burnCode(tokenCode);

                      if (mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.testResultPHQ,
                          (route) => false,
                          arguments: questionProvider.totalScore,
                        );
                      }
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Gagal menyimpan hasil tes ke server',
                            ),
                          ),
                        );
                      }
                    }
                  },
                  label: 'Kirim',
                )
              : CustomButton4(
                  label: Text('Kirim', style: AppTextStyles.button1),
                ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context,
    var question,
    PhqQuestionProvider provider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: question.options.map<Widget>((opt) {
        bool isSelected = provider.answers[question.id] == opt.score;

        return GestureDetector(
          onTap: () => provider.setAnswer(question.id, opt.score),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.textPink
                        : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  opt.text,
                  style: AppTextStyles.questionsTesPHQ.copyWith(fontSize: 14),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
