import 'package:flutter/material.dart';
import 'package:mindfullshelter/data/dummy_data.dart';
import 'package:mindfullshelter/provider/mood_provider.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_circle_painter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(height: 22),
              _buildWelcomeCard(),
              SizedBox(height: 22),
              _buildQuickMoodCheck(context),
              SizedBox(height: 26),
              Text('Fitur Utama', style: AppTextStyles.headingHome),
              SizedBox(height: 16),
              _buildFeatureGrid(context),
              SizedBox(height: 26),
              _buildRecentActivity(),
              SizedBox(height: 26),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Selamat Datang,',
                    style: AppTextStyles.welcomeHome,
                  ),
                  TextSpan(text: '\nSerra Gohv', style: AppTextStyles.nameHome),
                ],
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.accentLight,
            shape: BoxShape.circle,
          ),
          child: Image.asset(icAnonymousProfile, height: 18),
        ),
      ],
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 3),
            blurRadius: 10,
            spreadRadius: 2,
            color: AppColors.shadow.withValues(alpha: 0.05),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('VIDA Digital', style: AppTextStyles.headingWelcome),
                SizedBox(height: 5),
                Text(
                  'Platform Edukasi dan Dukungan Mental bagi Penyintas HIV/AIDS',
                  style: AppTextStyles.bodyWelcome,
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Container(
            width: 57,
            height: 57,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Image.asset(icLogoAccent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickMoodCheck(BuildContext context) {
    final moodProvider = context.watch<MoodProvider>();

    final startOfWeek = DateTime.now().subtract(
      Duration(days: DateTime.now().weekday - 1),
    );

    final weeklyMood = moodProvider.weeklyMood(startOfWeek);

    final days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      onTap: () => Navigator.pushNamed(context, '/moodtracker'),
      child: Container(
        height: 145,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 3),
              blurRadius: 10,
              spreadRadius: 2,
              color: AppColors.shadow.withValues(alpha: 0.05),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(icPulse, height: 17.6),
                  SizedBox(width: 10),
                  Text('Mood Tracker', style: AppTextStyles.headingMood),
                ],
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  final value = weeklyMood[index];

                  return Column(
                    children: [
                      value != null
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: value.mood.emoji,
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
                      SizedBox(height: 5),
                      Text(days[index], style: AppTextStyles.bodyMediumMood),
                    ],
                  );
                }),
              ),
              SizedBox(height: 13),
              Text(
                'Lacak suasana hati Anda setiap hari',
                style: AppTextStyles.bodyLargeMood,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context) {
    final features = [
      {
        'icon': icAudio,
        'title': 'Audio Mindfulness',
        'subtitle': 'Musik & Relaksasi',
        'color': Color(0xFFDCFFFB),
        'route': '/audiomindfulness',
      },
      {
        'icon': icComunity,
        'title': 'Komunitas Anonim',
        'subtitle': 'Chatbot 24/7',
        'color': Color(0xFFFFF7D2),
        'route': '/anonymouscomunity',
      },
      {
        'icon': icChatbot,
        'title': 'Teman Hati',
        'subtitle': 'Berbagi Cerita',
        'color': Color(0xFFDEF5FF),
        'route': '/chatbot',
      },
      {
        'icon': icEducation,
        'title': 'Edukasi',
        'subtitle': 'Info HIV/AIDS',
        'color': Color(0xFFFFE5F0),
        'route': '/education',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.3,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return InkWell(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          onTap: () => Navigator.pushNamed(context, feature['route'] as String),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 3),
                  blurRadius: 10,
                  spreadRadius: 2,
                  color: AppColors.shadow.withValues(alpha: 0.05),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: feature['color'] as Color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image(image: AssetImage(feature['icon'] as String)),
                ),
                SizedBox(height: 12),
                Text(
                  feature['title'] as String,
                  style: AppTextStyles.titleFeature,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 3),
                Text(
                  feature['subtitle'] as String,
                  style: AppTextStyles.descriptionFeature,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 3),
            blurRadius: 10,
            spreadRadius: 2,
            color: AppColors.shadow.withValues(alpha: 0.05),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Aktivitas Terakhir', style: AppTextStyles.headingHome),
            SizedBox(height: 10),
            ...DummyData.activity.take(3).map((value) {
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: AppColors.backgroundList,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: value.color,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(6),
                          child: value.icon,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              value.title,
                              style: AppTextStyles.titleActivity,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              _getRelativeTime(value.date),
                              style: AppTextStyles.dateActivity,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  String _getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit lalu';
    } else {
      return 'Baru saja';
    }
  }
}
