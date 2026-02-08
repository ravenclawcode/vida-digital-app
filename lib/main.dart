import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mindfullshelter/providers/phq_provider.dart';
import 'package:mindfullshelter/providers/phq_question_provider.dart';
import 'package:mindfullshelter/providers/soap_provider.dart';
import 'package:mindfullshelter/providers/terms_conditions_provider.dart';
import 'package:mindfullshelter/providers/anonymouse_provider.dart';
import 'package:mindfullshelter/providers/audio_provider.dart';
import 'package:mindfullshelter/providers/auth_provider.dart';
import 'package:mindfullshelter/providers/chat_provider.dart';
import 'package:mindfullshelter/providers/education_provider.dart';
import 'package:mindfullshelter/providers/medication_provider.dart';
import 'package:mindfullshelter/providers/mood_provider.dart';
import 'package:mindfullshelter/routes/routes.dart';
import 'package:mindfullshelter/services/my_audio_handler.dart';
import 'package:mindfullshelter/services/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'utils/app_theme.dart';

late MyAudioHandler audioHandler;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.ravenclawcode.vida',
      androidNotificationChannelName: 'Vida Mindfulness Audio',
      androidStopForegroundOnPause: true,
      androidNotificationIcon: 'mipmap/ic_launcher',
    ),
  );

  await NotificationService().init();

  await _requestNotificationPermissions();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  try {
    await initializeDateFormatting('id_ID', null);
  } catch (_) {}

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TermsAndConditionsProvider()),
        ChangeNotifierProvider(create: (_) => MedicationProvider()),
        ChangeNotifierProvider(create: (_) => MoodProvider()),
        ChangeNotifierProvider(create: (_) => AudioProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => EducationProvider()),
        ChangeNotifierProvider(create: (_) => AnonymousProvider()),
        ChangeNotifierProvider(create: (_) => PhqQuestionProvider()),
        ChangeNotifierProvider(create: (_) => PhqProvider()),
        ChangeNotifierProvider(create: (_) => SoapProvider()),
      ],
      child: const VidaApp(),
    ),
  );
}

Future<void> _requestNotificationPermissions() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  if (await Permission.scheduleExactAlarm.isDenied) {
    await Permission.scheduleExactAlarm.request();
  }
}

class VidaApp extends StatelessWidget {
  const VidaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VIDA Digital',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: Routes.splash,
      onGenerateRoute: generateRoute,
    );
  }
}
