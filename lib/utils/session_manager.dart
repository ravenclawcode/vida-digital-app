import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String keyToken = "auth_token";
  static const String keyRole = "user_role";

  Future<void> saveSession(String token, int roleId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyToken, token);
    await prefs.setInt(keyRole, roleId);
  }

  Future<int?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(keyRole);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyToken);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
