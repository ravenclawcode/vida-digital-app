import 'package:flutter/material.dart';
import 'package:mindfullshelter/providers/anonymouse_provider.dart';
import 'package:mindfullshelter/utils/custom_button1.dart';
import 'package:mindfullshelter/utils/custom_button2.dart';
import 'package:mindfullshelter/utils/custom_button4.dart';
import 'package:provider/provider.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/models/anonymous_model.dart';

class CustomPostDialog extends StatefulWidget {
  const CustomPostDialog({super.key});

  @override
  State<CustomPostDialog> createState() => _CustomPostDialogState();
}

class _CustomPostDialogState extends State<CustomPostDialog> {
  final TextEditingController _controller = TextEditingController();
  Category selectedCategory = Category.umum;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _hasText) {
        setState(() => _hasText = hasText);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isForbidden(String text) {
    final cleanText = text.replaceAll(RegExp(r'[\s\-\.]'), '');
    final phoneRegex = RegExp(r'(?:\+62|62|0)8[1-9][0-9]{6,10}');

    final forbiddenWords = ['wa', 'whatsapp', 'nomer', 'kontak', 'hubungi'];

    if (phoneRegex.hasMatch(cleanText)) return true;

    for (var word in forbiddenWords) {
      if (text.toLowerCase().contains(word)) return true;
    }

    return false;
  }

  Future<void> _submit() async {
    final content = _controller.text.trim();

    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cerita tidak boleh kosong')),
      );
      return;
    }

    Navigator.pop(context);

    if (_isForbidden(content)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Gagal: Demi keamanan, dilarang membagikan kontak pribadi.',
          ),
        ),
      );
      return;
    }

    final provider = context.read<AnonymousProvider>();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Berhasil mengunggah postingan')));

    try {
      await provider.addPost(selectedCategory.label, content);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengunggah postingan')),
      );
    }
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
                  Text('Posting Anonim', style: AppTextStyles.titleAddPost),
                  SizedBox(height: 4),
                  Text(
                    'Bagikan ceritamu dengan aman',
                    style: AppTextStyles.descAddPost,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Kategori', style: AppTextStyles.bodyPost),
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: AlignmentGeometry.centerLeft,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: Category.values.map((cat) {
                        final isSelected = selectedCategory == cat;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = cat;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.background,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.borderTabbar,
                              ),
                            ),
                            child: Text(
                              cat.label,
                              style: AppTextStyles.tabbarCategory.copyWith(
                                color: isSelected
                                    ? AppColors.textWhite
                                    : AppColors.textPrimary,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Ceritamu', style: AppTextStyles.bodyPost),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _controller,
                    maxLines: 3,
                    style: AppTextStyles.addStory,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: 'Tulis ceritamu...',
                      hintStyle: AppTextStyles.addStory.copyWith(
                        color: AppColors.textLight,
                      ),
                      filled: true,
                      fillColor: AppColors.backgroundList,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),
                  SizedBox(height: 20),
                  _hasText
                      ? CustomButton1(onTap: _submit, label: 'Posting')
                      : CustomButton4(
                          label: Text('Posting', style: AppTextStyles.button1),
                        ),
                  SizedBox(height: 5),
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
