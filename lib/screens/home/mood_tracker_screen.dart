import 'package:flutter/material.dart';
import 'package:mindfullshelter/data/dummy_data.dart';
import 'package:mindfullshelter/models/mood_model.dart';
import 'package:mindfullshelter/providers/mood_provider.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_button1.dart';
import 'package:mindfullshelter/utils/custom_button4.dart';
import 'package:mindfullshelter/utils/custom_circle_painter.dart';
import 'package:provider/provider.dart';

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  Mood? selectedMood;

  void _handleDeleteMood(String id) async {
    try {
      await context.read<MoodProvider>().deleteMood(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Riwayat mood berhasil dihapus')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Gagal menghapus mood')));
      }
    }
  }

  void _handleSaveMood() async {
    if (selectedMood == null) return;

    try {
      await context.read<MoodProvider>().saveMood(selectedMood!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mood berhasil disimpan!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Gagal menyimpan mood')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 11),
              _buildHeader(
                context: context,
                icon: icBackLeft2,
                onTap: () => Navigator.pop(context),
              ),
              SizedBox(height: 20),
              _buildContent(context),
              SizedBox(height: 25),
              _buildWeaklyMoodCheck(context),
            ],
          ),
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
          Text('Mood Tracker', style: AppTextStyles.heading3Bold),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        padding: EdgeInsets.all(20),
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(icPulse, height: 17.6),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Bagaimana perasaan Anda hari ini?',
                    style: AppTextStyles.headingMood.copyWith(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Text(
              'Ketuk emoji yang sesuai dengan suasana hatimu\nsaat ini.',
              style: AppTextStyles.bodyLargeMood,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: DummyData.moods.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
              ),
              itemBuilder: (context, index) {
                final mood = DummyData.moods[index];
                final isSelected = selectedMood?.id == mood.id;

                return InkWell(
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  onTap: () {
                    setState(() {
                      selectedMood = mood;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.accentLight
                          : AppColors.backgroundList,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.textPink
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 48, height: 48, child: mood.emoji),
                        SizedBox(height: 3),
                        Text(
                          mood.label,
                          style: AppTextStyles.bodyExtraLargeMood,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            selectedMood != null
                ? CustomButton1(label: 'Simpan Mood', onTap: _handleSaveMood)
                : CustomButton4(
                    label: Text('Simpan Mood', style: AppTextStyles.button1),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeaklyMoodCheck(BuildContext context) {
    final moodProvider = context.watch<MoodProvider>();
    final days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(15),
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
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(icCalendar, height: 15.5),
                  SizedBox(width: 10),
                  Text('Minggu Ini', style: AppTextStyles.headingMood),
                ],
              ),
              SizedBox(height: 10),
              Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: List.generate(7, (index) {
    final entry = moodProvider.getMoodForDay(index);
    final now = DateTime.now();
    
    // Cek apakah kolom ini adalah hari ini
    // now.weekday bernilai 1 (Senin) sampai 7 (Minggu)
    final bool isToday = (index + 1) == now.weekday;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          decoration: BoxDecoration(
            // Warna background hanya muncul jika hari ini
            color: isToday ? AppColors.backgroundList : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                days[index],
                style: AppTextStyles.bodyMediumMood,
              ),
              const SizedBox(height: 5),
              entry != null
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: entry.mood.emoji,
                    )
                  : CustomPaint(
                      painter: CustomCirclePainter(),
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: Center(
                          child: Text(
                            '?',
                            style: AppTextStyles.bodySmallMood,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
        if (entry != null && isToday)
          Positioned(
            top: -3,
            right: -4,
            child: GestureDetector(
              onTap: () => _handleDeleteMood(entry.id),
              child: Image.asset(icRemove, height: 12),
            ),
          ),
      ],
    );
  }),
),
            ],
          ),
        ),
      ),
    );
  }
}
