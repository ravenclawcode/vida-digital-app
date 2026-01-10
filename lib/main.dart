import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mindfullshelter/providers/terms_conditions_provider.dart';
import 'package:mindfullshelter/providers/anonymouse_provider.dart';
import 'package:mindfullshelter/providers/audio_provider.dart';
import 'package:mindfullshelter/providers/auth_provider.dart';
import 'package:mindfullshelter/providers/chat_provider.dart';
import 'package:mindfullshelter/providers/education_provider.dart';
import 'package:mindfullshelter/providers/medication_provider.dart';
import 'package:mindfullshelter/providers/mood_provider.dart';
import 'package:mindfullshelter/routes/routes.dart';
import 'package:provider/provider.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  try {
    await initializeDateFormatting('id_ID', null);
  } catch (e) {
    debugPrint('Kesalahan saat menginisialisasi format tanggal: $e');
  }

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
      ],
      child: const VidaApp(),
    ),
  );
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
