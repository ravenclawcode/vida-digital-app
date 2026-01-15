class ApiConstants {
  // Base URL
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // -----------------------------------------------------------
  // AUTH (Public & Account)
  // -----------------------------------------------------------
  static const String login = '$baseUrl/login';
  static const String register = '$baseUrl/register';
  static const String userProfile = '$baseUrl/user';
  static const String validateToken = '$baseUrl/validate-token';
  static const String logout = '$baseUrl/logout';
  static const String updateProfile = '$baseUrl/user/update-profile';
  static const String changePassword = '$baseUrl/user/change-password';

  // Forgot Password
  static const String sendOtp = '$baseUrl/password/send-otp';
  static const String verifyOtp = '$baseUrl/password/verify-otp';
  static const String resetPassword = '$baseUrl/password/reset';

  // -----------------------------------------------------------
  // FITUR UTAMA
  // -----------------------------------------------------------
  static const String home = '$baseUrl/home';
  static const String audio = '$baseUrl/audio';
  static const String education = '$baseUrl/education';
  static const String counselors = '$baseUrl/counselors';

  // Mood Tracker
  static const String moodWeekly = '$baseUrl/moods/weekly';
  static const String moodStore = '$baseUrl/moods';

  // Pengingat Obat (Medication)
  static const String medicationToday = '$baseUrl/medications/today';
  static const String medicationStore = '$baseUrl/medications';

  // Komunitas
  static const String community = '$baseUrl/community';

  // Chatbot AI
  static const String chatSend = '$baseUrl/chat/send';
  static const String chatHistory = '$baseUrl/chat/history';
  static const String deleteAllChat = '$baseUrl/chat/clear';
}
