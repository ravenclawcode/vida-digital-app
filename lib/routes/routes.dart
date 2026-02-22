import 'package:flutter/material.dart';
import 'package:mindfullshelter/screens/auth/forgot_password_confirm_screen.dart';
import 'package:mindfullshelter/screens/auth/forgot_password_input_email_screen.dart';
import 'package:mindfullshelter/screens/auth/forgot_password_input_new_password_screen.dart';
import 'package:mindfullshelter/screens/auth/forgot_password_input_otp_screen.dart';
import 'package:mindfullshelter/screens/auth/aktivation_account_screen.dart';
import 'package:mindfullshelter/screens/auth/signin_screen.dart';
import 'package:mindfullshelter/screens/auth/signup_screen.dart';
import 'package:mindfullshelter/screens/audio/audio_mindfulness_screen.dart';
import 'package:mindfullshelter/screens/chat/chat_message_screen.dart';
import 'package:mindfullshelter/screens/chat/chat_screen.dart';
import 'package:mindfullshelter/screens/education/detail_article_screen.dart';
import 'package:mindfullshelter/screens/education/detail_video_screen.dart';
import 'package:mindfullshelter/screens/home/chatbot_screen.dart';
import 'package:mindfullshelter/screens/education/education_screen.dart';
import 'package:mindfullshelter/screens/home/anonymous_comunity_screen.dart';
import 'package:mindfullshelter/screens/home/medication_reminder_screen.dart';
import 'package:mindfullshelter/screens/home/mood_tracker_screen.dart';
import 'package:mindfullshelter/screens/home/main_screen.dart';
import 'package:mindfullshelter/screens/home/patient_screen.dart';
import 'package:mindfullshelter/screens/onboarding/get_started_screen.dart';
import 'package:mindfullshelter/screens/onboarding/splash_screen.dart';
import 'package:mindfullshelter/screens/home/home_screen.dart';
import 'package:mindfullshelter/screens/onboarding/introduction_screen.dart';
import 'package:mindfullshelter/screens/profile/change_password_screen.dart';
import 'package:mindfullshelter/screens/profile/edit_profile_screen.dart';
import 'package:mindfullshelter/screens/profile/help_support_screen.dart';
import 'package:mindfullshelter/screens/profile/notification_screen.dart';
import 'package:mindfullshelter/screens/profile/privacy_security_screen.dart';
import 'package:mindfullshelter/screens/profile/profile_screen.dart';
import 'package:mindfullshelter/screens/terms%20&%20conditions/terms_and_conditions_screen.dart';
import 'package:mindfullshelter/screens/test%20phq-9/question_test_phq_screen.dart';
import 'package:mindfullshelter/screens/test%20phq-9/test_phq_screen.dart';
import 'package:mindfullshelter/screens/test%20phq-9/test_result_phq_screen.dart';
import 'package:mindfullshelter/screens/tools/tools_screen.dart';
import 'package:mindfullshelter/utils/app_theme.dart';

class Routes {
  static const String main = '/';
  static const String splash = '/splash';
  static const String introduction = '/introduction';
  static const String activationAccountScreen = '/activationaccountscreen';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String termsAndConditions = '/termsandconditions';
  static const String getStarted = '/getstarted';
  static const String forgotPasswordInputEmail = '/forgotpassword-inputemail';
  static const String forgotPasswordInputOtp = '/forgotpassword-inputotp';
  static const String forgotPasswordInputConfirm = '/forgotpassword-confirm';
  static const String forgotPasswordInputNewPassword =
      '/forgotpassword-inputnewpassword';
  static const String home = '/home';
  static const String chat = '/chat';
  static const String tools = '/tools';
  static const String profile = '/profile';
  static const String testPHQ = '/test-phq';
  static const String questionsPHQ = '/phq9-questions';
  static const String testResultPHQ = '/test-phq-result';
  static const String chatMessage = '/chatmessage';
  static const String patient = '/patient';
  static const String editProfile = '/editprofile';
  static const String medicationReminder = '/medicationreminder';
  static const String moodTracker = '/moodtracker';
  static const String audioMindfulness = '/audiomindfulness';
  static const String anonymousComunity = '/anonymouscomunity';
  static const String chatbot = '/chatbot';
  static const String education = '/education';
  static const String detailVideo = '/detailvideo';
  static const String detailArticle = '/detailarticle';
  static const String notification = '/notification';
  static const String privacySecurity = '/privacy-security';
  static const String helpSupport = '/help-support';
  static const String changePassword = '/change-password';
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.splash:
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    case Routes.main:
      return MaterialPageRoute(builder: (_) => const MainScreen());
    case Routes.introduction:
      return MaterialPageRoute(builder: (_) => const IntroductionScreen());
    case Routes.activationAccountScreen:
      return MaterialPageRoute(builder: (_) => const ActivationAccountScreen());
    case Routes.signIn:
      final role = settings.arguments as String? ?? 'pasien';

      return MaterialPageRoute(
        builder: (_) => SignInScreen(role: role),
        settings: settings,
      );
    case Routes.signUp:
      return MaterialPageRoute(
        builder: (_) => const SignUpScreen(),
        settings: settings,
      );
    case Routes.termsAndConditions:
      final tabIndex = settings.arguments as int? ?? 0;
      return MaterialPageRoute(
        builder: (_) => TermsAndConditionsScreen(tabIndex: tabIndex),
      );
    case Routes.getStarted:
      return MaterialPageRoute(builder: (_) => const GetStartedScreen());
    case Routes.forgotPasswordInputEmail:
      return MaterialPageRoute(
        builder: (_) => const ForgotPasswordInputEmailScreen(),
      );
    case Routes.forgotPasswordInputOtp:
      return MaterialPageRoute(
        builder: (_) => const ForgorPasswordInputOtpScreen(),
      );
    case Routes.forgotPasswordInputConfirm:
      return MaterialPageRoute(
        builder: (_) => const ForgotPasswordConfirmScreen(),
      );
    case Routes.forgotPasswordInputNewPassword:
      return MaterialPageRoute(
        builder: (_) => const ForgotPasswordInputNewPasswordScreen(),
      );
    case Routes.home:
      return MaterialPageRoute(builder: (_) => const HomeScreen());
    case Routes.chat:
      return MaterialPageRoute(builder: (_) => const ChatScreen());
    case Routes.tools:
      return MaterialPageRoute(builder: (_) => const ToolsScreen(tabIndex: 0));
    case Routes.profile:
      return MaterialPageRoute(builder: (_) => const ProfileScreen());
    case Routes.testPHQ:
      return MaterialPageRoute(builder: (_) => const TestPhqScreen());
    case Routes.questionsPHQ:
      return MaterialPageRoute(
        builder: (_) => const QuestionTestPhqScreen(),
        settings: settings,
      );
    case Routes.testResultPHQ:
      final score = settings.arguments as int? ?? 0;
      return MaterialPageRoute(
        builder: (_) => TestResultPhqScreen(score: score),
      );
    case Routes.chatMessage:
      return MaterialPageRoute(
        builder: (_) => const ChatMessageScreen(),
        settings: settings,
      );
    case Routes.patient:
      return MaterialPageRoute(
        builder: (_) => const PatientScreen(),
        settings: settings,
      );
    case Routes.editProfile:
      return MaterialPageRoute(builder: (_) => const EditProfileScreen());
    case Routes.medicationReminder:
      return MaterialPageRoute(
        builder: (_) => const MedicationReminderScreen(),
      );
    case Routes.moodTracker:
      return MaterialPageRoute(builder: (_) => const MoodTrackerScreen());
    case Routes.audioMindfulness:
      return MaterialPageRoute(builder: (_) => const AudioMindfulnessScreen());
    case Routes.anonymousComunity:
      return MaterialPageRoute(builder: (_) => const AnonymousComunityScreen());
    case Routes.chatbot:
      return MaterialPageRoute(builder: (_) => const ChatbotScreen());
    case Routes.education:
      return MaterialPageRoute(
        builder: (_) => const EducationScreen(tabIndex: 0),
      );
    case Routes.detailVideo:
      final videoId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (_) => DetailVideoScreen(videoId: videoId),
      );
    case Routes.detailArticle:
      final articleId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (_) => DetailArticleScreen(articleId: articleId),
      );
    case Routes.notification:
      return MaterialPageRoute(builder: (_) => const NotificationScreen());
    case Routes.privacySecurity:
      return MaterialPageRoute(builder: (_) => const PrivacySecurityScreen());
    case Routes.helpSupport:
      return MaterialPageRoute(builder: (_) => const HelpSupportScreen());
    case Routes.changePassword:
      return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text(
              'No route defined for ${settings.name}',
              style: AppTextStyles.bodyLarge,
            ),
          ),
        ),
      );
  }
}
