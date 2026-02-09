import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mindfullshelter/models/user_model.dart';
import 'package:mindfullshelter/utils/api_constants.dart';
import 'package:mindfullshelter/utils/session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _resetEmail;
  String? get resetEmail => _resetEmail;

  String? _validatedOtp;
  String? get validatedOtp => _validatedOtp;

  File? _imageFile;
  File? get imageFile => _imageFile;

  User? _currentUser;
  User? get currentUser => _currentUser;

  void setImage(File? file) {
    _imageFile = file;
    notifyListeners();
  }

  void updateUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null) {
      await fetchUserProfile();
      return true;
    }
    return false;
  }

  Future<bool> validateActivation(String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.validateToken(token);

      _isLoading = false;
      notifyListeners();
      return response.statusCode == 200;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp({
    required String username,
    required String email,
    required String password,
    required String tokenCode,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.register(
        username,
        email,
        password,
        tokenCode,
      );

      _isLoading = false;
      notifyListeners();
      return response.statusCode == 201;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _authService.login(email, password);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final int rawRoleId = data['user']['role_id'];

        int sessionRole = (rawRoleId == 2) ? 0 : 1;

        await SessionManager().saveSession(data['access_token'], sessionRole);

        _currentUser = User.fromJson(data['user']);
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
    } catch (_) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> forgotPassword(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.sendOtp(email);

      if (response.statusCode == 200) {
        _resetEmail = email;
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (_) {}

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> verifyOtp(String otp) async {
    if (_resetEmail == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.verifyOtp(_resetEmail!, otp);

      if (response.statusCode == 200) {
        _validatedOtp = otp;
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (_) {}

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> updatePassword(String newPassword) async {
    if (_resetEmail == null || _validatedOtp == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.resetPassword(
        email: _resetEmail!,
        otp: _validatedOtp!,
        password: newPassword,
      );

      if (response.statusCode == 200) {
        _resetEmail = null;
        _validatedOtp = null;

        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (_) {}

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> updateProfile({
    required String username,
    required String email,
    required String gender,
    String? avatarUrl,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await http.post(
        Uri.parse(ApiConstants.updateProfile),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: {
          'username': username,
          'email': email,
          'gender': gender,
          'profile_photo': avatarUrl ?? _currentUser?.profilePhotoUrl ?? "",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['user'] != null) {
          _currentUser = User.fromJson(data['user']);
          _imageFile = null;
        }
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse(ApiConstants.userProfile),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _currentUser = User.fromJson(data['user']);
        notifyListeners();
      }
    } catch (_) {}
  }
}
