import 'package:flutter/material.dart';
import 'package:mindfullshelter/models/medication_model.dart';
import 'package:mindfullshelter/providers/auth_provider.dart';
import 'package:mindfullshelter/providers/medication_provider.dart';
import 'package:mindfullshelter/providers/mood_provider.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_circle_painter.dart';
import 'package:mindfullshelter/utils/session_manager.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? role;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MedicationProvider>().fetchMedications();
      context.read<MoodProvider>().fetchWeeklyMood();
    });
    _checkSession();
  }

  void _checkSession() async {
    int? sessionRole = await SessionManager().getRole();
    setState(() {
      role = sessionRole;
    });

    if (sessionRole == 1) {
      Future.microtask(() {
        context.read<MedicationProvider>().fetchMedications();
        context.read<MoodProvider>().fetchWeeklyMood();
      });
    } else {
      // Jika konselor (0), fetch data daftar pasien (buat provider baru nanti)
      // context.read<CounselorProvider>().fetchPatients();
    }
  }

  String _capitalizeEachWord(String text) {
    if (text.isEmpty) return 'User';
    return text
        .split(' ')
        .map((word) {
          if (word.isEmpty) return "";
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  Widget _buildProfileImage(AuthProvider auth) {
    final user = auth.currentUser;
    final String? photoPath = user?.profilePhotoUrl;

    if (auth.imageFile != null && auth.imageFile!.path.isNotEmpty) {
      return Image.file(auth.imageFile!, fit: BoxFit.cover);
    }

    if (photoPath != null && photoPath.isNotEmpty) {
      if (photoPath.contains('assets/')) {
        return Image.asset(
          photoPath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(),
        );
      }

      return Image.network(
        photoPath,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: SizedBox(
              width: 15,
              height: 15,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(),
      );
    }

    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Image.asset(icAnonymousProfile),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (role == null) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 22),
              if (role == 1) ...[
                _buildTesPHQ(context),
                const SizedBox(height: 22),
                _buildMedicationReminder(context),
                const SizedBox(height: 22),
                _buildQuickMoodCheck(context),
                const SizedBox(height: 26),
                Text('Fitur Utama', style: AppTextStyles.headingHome),
                const SizedBox(height: 16),
                _buildFeatureGrid(context),
              ] else ...[
                _buildCounselorPatientList(),
              ],
              const SizedBox(height: 26),
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
            Consumer<AuthProvider>(
              builder: (context, auth, child) {
                final String rawName = auth.currentUser?.username ?? 'User';
                final String formattedName = _capitalizeEachWord(rawName);

                return Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Selamat Datang,',
                        style: AppTextStyles.welcomeHome,
                      ),
                      TextSpan(
                        text: '\n$formattedName',
                        style: AppTextStyles.nameHome,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        Consumer<AuthProvider>(
          builder: (context, auth, child) {
            return Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.accentLight,
                shape: BoxShape.circle,
              ),
              child: ClipOval(child: _buildProfileImage(auth)),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTesPHQ(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      onTap: () => Navigator.pushNamed(context, '/test-phq'),
      child: Container(
        width: double.infinity,
        height: 95,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 3),
              color: Color(0xFFFAB1C6).withValues(alpha: 0.80),
              blurRadius: 10,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tes Kesehatan Mental PHQ-9',
                    style: AppTextStyles.headingChat.copyWith(fontSize: 15),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Evaluasi kondisi mental Anda',
                    style: AppTextStyles.bodyChat,
                  ),
                ],
              ),
              Image.asset(icMedical, height: 53),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicationReminder(BuildContext context) {
    final provider = context.watch<MedicationProvider>();

    final List<MedicationEntry> entries = provider.todayEntries;

    entries.sort((a, b) {
      if (a.isTaken != b.isTaken) {
        return a.isTaken ? -1 : 1;
      }

      final aTime = a.medication.time.hour * 60 + a.medication.time.minute;
      final bTime = b.medication.time.hour * 60 + b.medication.time.minute;
      return aTime.compareTo(bTime);
    });

    return AnimatedSize(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Container(
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
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Image.asset(icSchedule, height: 15.5),
                  SizedBox(width: 10),
                  Text(
                    'Jadwal Obat Hari Ini',
                    style: AppTextStyles.headingMedication,
                  ),
                  Spacer(),
                  InkWell(
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    onTap: () =>
                        Navigator.pushNamed(context, '/medicationreminder'),
                    child: Image.asset(icAdd, height: 14),
                  ),
                ],
              ),

              SizedBox(height: 10),

              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: provider.progress),
                duration: Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                builder: (context, value, _) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      minHeight: 6,
                      value: value,
                      backgroundColor: Color(0xFFF5F5F5),
                      valueColor: AlwaysStoppedAnimation(AppColors.textPink),
                    ),
                  );
                },
              ),
              SizedBox(height: 12),
              entries.isEmpty
                  ? Center(
                      child: Text(
                        'Belum ada obat ditambahkan',
                        style: AppTextStyles.noContent.copyWith(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                  : AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        key: ValueKey(entries.map((e) => e.id).join()),
                        itemCount: entries.length,
                        itemBuilder: (context, index) {
                          final entry = entries[index];

                          return Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              height: 50,
                              decoration: BoxDecoration(
                                color: entry.isTaken
                                    ? Color(0xFFFDFDFD)
                                    : Color(0xFFFFFAFC),
                                border: Border.all(
                                  color: entry.isTaken
                                      ? Color(0xFFE9E9E9)
                                      : Color(0xFFFFE5F0),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: 12, right: 22),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: entry.isTaken
                                            ? Color(0xFFF5F5F5)
                                            : Color(0xFFFFE5F0),
                                        shape: BoxShape.circle,
                                      ),
                                      child: AnimatedSwitcher(
                                        duration: Duration(milliseconds: 250),
                                        transitionBuilder: (child, animation) {
                                          return ScaleTransition(
                                            scale: animation,
                                            child: FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            ),
                                          );
                                        },
                                        child: entry.isTaken
                                            ? Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                  10,
                                                  9,
                                                  8,
                                                  9,
                                                ),
                                                child: Image.asset(
                                                  icChecklist,
                                                  key: ValueKey(
                                                    'check_${entry.id}',
                                                  ),
                                                ),
                                              )
                                            : Padding(
                                                padding: EdgeInsets.all(7),
                                                child: Image.asset(
                                                  icMedicine,
                                                  key: ValueKey(
                                                    'med_${entry.id}',
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          entry.medication.name,
                                          style: AppTextStyles.titleMedication
                                              .copyWith(
                                                decoration: entry.isTaken
                                                    ? TextDecoration.lineThrough
                                                    : TextDecoration.none,
                                                color: entry.isTaken
                                                    ? AppColors.textSecondary
                                                    : null,
                                              ),
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(icTime, height: 9),
                                            SizedBox(width: 3),
                                            Text(
                                              '${entry.medication.time.hour.toString().padLeft(2, '0')}.${entry.medication.time.minute.toString().padLeft(2, '0')}',
                                              style:
                                                  AppTextStyles.dateMedication,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    InkWell(
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      overlayColor: WidgetStateProperty.all(
                                        Colors.transparent,
                                      ),
                                      onTap: () =>
                                          provider.toggleTaken(entry.id),
                                      child: Text(
                                        entry.isTaken ? 'Batal' : 'Tanda',
                                        style: AppTextStyles.actionMedication
                                            .copyWith(
                                              color: entry.isTaken
                                                  ? AppColors.textSecondary
                                                  : AppColors.textPink,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickMoodCheck(BuildContext context) {
    final moodProvider = context.watch<MoodProvider>();
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
              color: AppColors.shadow.withValues(alpha: 0.10),
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
                  final entry = moodProvider.getMoodForDay(index);

                  return Column(
                    children: [
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
                  color: AppColors.shadow.withValues(alpha: 0.10),
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

  Widget _buildCounselorPatientList() {
    final patients = [
      {'name': 'Vida1', 'status': 'Sangat Baik'},
      {'name': 'Vida2', 'status': 'Perlu Perhatian'},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: patients.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                patients[index]['name'] as String,
                style: AppTextStyles.titleFeature,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
