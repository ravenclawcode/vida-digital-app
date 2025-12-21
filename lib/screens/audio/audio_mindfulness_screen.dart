import 'package:flutter/material.dart';
import 'package:mindfullshelter/screens/audio/audio_player_sheet.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_theme.dart';
import '../../data/dummy_data.dart';
import '../../models/audio.dart';

class AudioMindfulnessScreen extends StatefulWidget {
  const AudioMindfulnessScreen({super.key});

  @override
  State<AudioMindfulnessScreen> createState() => _AudioMindfulnessScreenState();
}

class _AudioMindfulnessScreenState extends State<AudioMindfulnessScreen> {
  String selectedCategory = 'Semua';
  final List<String> categories = ['Semua', 'Relaksasi', 'Meditasi', 'Tidur'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 11),
            _buildHeader(
              context: context,
              icon: icBackLeft2,
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: 20),
            _buildCategoryFilter(),
            Expanded(child: _buildAudioList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader({
    required BuildContext context,
    required String icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          InkWell(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            onTap: onTap,
            child: Image.asset(icon, width: 10),
          ),
          SizedBox(width: 25),
          Text('Audio Mindfulness', style: AppTextStyles.heading3Bold),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 25),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category;
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: 12),
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.borderTabbar,
                ),
              ),
              child: Center(
                child: Text(
                  category,
                  style: AppTextStyles.tabCategoryAudio.copyWith(
                    color: isSelected
                        ? AppColors.textWhite
                        : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAudioList() {
    final filteredAudios = selectedCategory == 'Semua'
        ? DummyData.audioMindfulness
        : DummyData.audioMindfulness
              .where((audio) => audio.category == selectedCategory)
              .toList();

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      itemCount: filteredAudios.length,
      itemBuilder: (context, index) {
        final audio = filteredAudios[index];
        return _buildAudioCard(audio);
      },
    );
  }

  Widget _buildAudioCard(AudioMindfulness audio) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: Offset(3, 3),
            blurRadius: 10,
            spreadRadius: 1,
            color: AppColors.shadow.withValues(alpha: 0.10),
          ),
        ],
      ),
      margin: EdgeInsets.only(bottom: 15),
      child: InkWell(
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        onTap: () {
          _showAudioPlayer(audio);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    audio.thumbnailUrl,
                    style: TextStyle(fontSize: 35),
                  ),
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      audio.title,
                      style: AppTextStyles.titleAudio,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      audio.description,
                      style: AppTextStyles.descAudio,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accentLight,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            audio.category,
                            style: AppTextStyles.categoryAudio,
                          ),
                        ),
                        SizedBox(width: 10),
                        Image.asset(icTime, height: 11),
                        SizedBox(width: 4),
                        Text(
                          audio.durationFormatted,
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAudioPlayer(AudioMindfulness audio) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AudioPlayerSheet(audio: audio),
    );
  }
}
