import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_constants.dart';

class AuthService {
  Future<http.Response> validateToken(String tokenCode) async {
    return await http.post(
      Uri.parse(ApiConstants.validateToken),
      body: {'token_code': tokenCode},
    );
  }

  Future<http.Response> register(
    String username,
    String email,
    String password,
    String tokenCode,
  ) async {
    return await http.post(
      Uri.parse(ApiConstants.register),
      headers: {'Accept': 'application/json'},
      body: {
        'token_code': tokenCode,
        'username': username,
        'email': email,
        'password': password,
      },
    );
  }

  Future<http.Response> login(String email, String password) async {
    return await http.post(
      Uri.parse(ApiConstants.login),
      headers: {'Accept': 'application/json'},
      body: {'email': email, 'password': password},
    );
  }

  Future<http.Response> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    return await http.post(
      Uri.parse(ApiConstants.logout),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
  }

  Future<http.Response> sendOtp(String email) async {
    return await http.post(
      Uri.parse(ApiConstants.sendOtp),
      headers: {'Accept': 'application/json'},
      body: {'email': email},
    );
  }

  Future<http.Response> verifyOtp(String email, String otp) async {
    return await http.post(
      Uri.parse(ApiConstants.verifyOtp),
      headers: {'Accept': 'application/json'},
      body: {'email': email, 'otp': otp},
    );
  }

  Future<http.Response> resetPassword({
    required String email,
    required String otp,
    required String password,
  }) async {
    return await http.post(
      Uri.parse(ApiConstants.resetPassword),
      headers: {'Accept': 'application/json'},
      body: {
        'email': email,
        'otp': otp,
        'password': password,
        'password_confirmation': password,
      },
    );
  }

  Future<http.StreamedResponse> updateProfile({
    required String username,
    required String email,
    required String gender,
    File? imageFile,
    String? avatarUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConstants.updateProfile),
    );

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    request.fields['username'] = username;
    request.fields['email'] = email;
    request.fields['gender'] = gender;

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('profile_photo', imageFile.path),
      );
    } else if (avatarUrl != null) {
      request.fields['profile_photo'] = avatarUrl;
    }

    return await request.send();
  }

  Future<void> updateOnlineStatus(bool isOnline) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    await http.post(
      Uri.parse(ApiConstants.updateStatus),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: {'is_online': isOnline ? '1' : '0'},
    );
  }

  Future<http.Response> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    return await http.post(
      Uri.parse(ApiConstants.changePassword),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPassword,
      },
    );
  }

  Future<http.Response> deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    return await http.delete(
      Uri.parse(ApiConstants.deleteAccount),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
  }
}
