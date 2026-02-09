import 'package:flutter/material.dart';
import 'package:mindfullshelter/models/medication_model.dart';
import 'package:mindfullshelter/providers/auth_provider.dart';
import 'package:mindfullshelter/providers/counselor_provider.dart';
import 'package:mindfullshelter/providers/medication_provider.dart';
import 'package:mindfullshelter/providers/mood_provider.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_circle_painter.dart';
import 'package:mindfullshelter/utils/custom_search_form.dart';
import 'package:mindfullshelter/utils/session_manager.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();
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
      Future.microtask(() {
        context.read<CounselorProvider>().fetchPatients();
      });
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

  Map<String, dynamic> _getPatientStatusStyle(String status) {
    switch (status) {
      case 'Sangat Baik':
        return {
          'bgColor': const Color(0xFFD0FAE5),
          'textColor': const Color(0xFF007A56),
          'progressColor': const Color(0xFF00BC7D),
        };
      case 'Baik':
        return {
          'bgColor': const Color(0xFFD0FAE5), // Sesuai permintaan Anda
          'textColor': const Color(0xFF007A56),
          'progressColor': const Color(0xFF00BBA7),
        };
      case 'Perlu Perhatian':
        return {
          'bgColor': const Color(0xFFFEF3C6),
          'textColor': const Color(0xFFBA4D00),
          'progressColor': const Color(0xFFFE9900),
        };
      case 'Kritis':
        return {
          'bgColor': const Color(0xFFFEE4E6),
          'textColor': const Color(0xFFC70036),
          'progressColor': const Color(0xFFFF1F57),
        };
      default:
        return {
          'bgColor': const Color(0xFFF5F5F5),
          'textColor': Colors.grey,
          'progressColor': Colors.grey,
        };
    }
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
                CustomSearchForm(controller: searchController),
                const SizedBox(height: 20),
                _buildListPatient(),
              ],
              const SizedBox(height: 20),
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

  Widget _buildListPatient() {
    return Consumer<CounselorProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daftar Pasien (${provider.patients.length})',
              style: AppTextStyles.headingMedication,
            ),
            const SizedBox(height: 16),
            provider.patients.isEmpty
                ? const Center(child: Text("Belum ada pasien terdaftar"))
                : _buildCounselorPatientList(provider.patients),
          ],
        );
      },
    );
  }

  Widget _buildCounselorPatientList(List<dynamic> patients) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: patients.length,
      itemBuilder: (context, index) {
        final patient = patients[index];
        final style = _getPatientStatusStyle(patient['status'] ?? 'Baik');

        double progressValue = (patient['progress'] ?? 0).toDouble();
        String progressPercentage = "${(progressValue * 100).toInt()}%";

        // Ambil jumlah unread, pastikan aman dari null
        int unreadCount =
            int.tryParse(patient['unread']?.toString() ?? '0') ?? 0;

        return InkWell(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          onTap: () => Navigator.pushNamed(
            context,
            '/patient',
            arguments: patient['id']
                .toString(), // Pastikan dikirim sebagai String
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 3),
                  blurRadius: 10,
                  spreadRadius: 2,
                  color: AppColors.shadow.withValues(alpha: 0.10),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Gunakan Flexible agar nama yang panjang tidak mendorong elemen lain
                          Flexible(
                            child: Text(
                              patient['name'] as String,
                              style: AppTextStyles.namePatient,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Status Container
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: style['bgColor'],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              patient['status']!,
                              style: AppTextStyles.categoryPatient.copyWith(
                                color: style['textColor'],
                                fontSize:
                                    10, // Ukuran sedikit diperkecil agar aman
                              ),
                            ),
                          ),

                          // Logika: Hanya tampilkan badge jika unread > 0
                          if (unreadCount > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 18,
                              height: 18,
                              decoration: const BoxDecoration(
                                color: Color(0xFFEA4335),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  unreadCount.toString(),
                                  style: AppTextStyles.unreadChat.copyWith(
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TweenAnimationBuilder<double>(
                              tween: Tween<double>(
                                begin: 0,
                                end: progressValue,
                              ),
                              duration: const Duration(milliseconds: 500),
                              builder: (context, value, _) {
                                return ClipRRect(
                                  // Memberikan radius pada progress bar
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    minHeight: 6,
                                    value: value,
                                    backgroundColor: const Color(0xFFF5F5F5),
                                    valueColor: AlwaysStoppedAnimation(
                                      style['progressColor'],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            progressPercentage,
                            style: AppTextStyles.percentage,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Image.asset(icNext, height: 14),
              ],
            ),
          ),
        );
      },
    );
  }
}
