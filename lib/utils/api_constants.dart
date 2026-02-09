class ApiConstants {
  static const String baseUrl = 'http://172.20.10.3:8000/api';

  static const String login = '$baseUrl/login';
  static const String register = '$baseUrl/register';
  static const String userProfile = '$baseUrl/user';
  static const String validateToken = '$baseUrl/validate-token';
  static const String logout = '$baseUrl/logout';
  static const String updateProfile = '$baseUrl/user/update-profile';
  static const String changePassword = '$baseUrl/user/change-password';
  static const String sendOtp = '$baseUrl/password/send-otp';
  static const String verifyOtp = '$baseUrl/password/verify-otp';
  static const String resetPassword = '$baseUrl/password/reset';
  static const String home = '$baseUrl/home';
  static const String audio = '$baseUrl/audio';
  static const String education = '$baseUrl/education';
  static const String counselors = '$baseUrl/counselors';
  static const String moodWeekly = '$baseUrl/moods/weekly';
  static const String moodStore = '$baseUrl/moods';
  static const String medicationToday = '$baseUrl/medications/today';
  static const String medicationStore = '$baseUrl/medications';
  static const String community = '$baseUrl/community';
  static const String chatSend = '$baseUrl/chatbot/send';
  static const String chatHistory = '$baseUrl/chat/history';
  static const String deleteAllChat = '$baseUrl/chat/clear';
  static const String generatePhqCode = '$baseUrl/phq-generate';
  static const String deletePhqCode = '$baseUrl/phq-delete';
  static const String validatePhqCode = '$baseUrl/phq-validate';
  static const String markPhqCodeUsed = '$baseUrl/phq-mark-used';
  static const String getPhqQuestions = '$baseUrl/phq-questions';
  static const String postPhqResult = '$baseUrl/phq-results';
  static const String getPatients = '$baseUrl/counselor/patients';
  static const String storeSoap = '$baseUrl/soap';
  static const String chatContacts = '$baseUrl/chat/contacts';
  static const String privateMessages = '$baseUrl/chat/messages';
  static const String sendPrivateMessage = '$baseUrl/chat/send';
}
