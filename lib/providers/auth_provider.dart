import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mindfullshelter/models/user_model.dart';
import 'package:mindfullshelter/utils/api_constants.dart';
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

  void setImage(File file) {
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

      print('Status Code: ${response.statusCode}');
      print('Body: ${response.body}');

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

      print('Login Status: ${response.statusCode}');
      print('Login Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('auth_token', data['access_token']);

        if (data['user'] != null) {
          _currentUser = User.fromJson(data['user']);
        }

        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error Login: $e');
    }
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
    } catch (e) {
      print('Error during logout: $e');
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
      print('Send OTP Response: ${response.body}');

      if (response.statusCode == 200) {
        _resetEmail = email;
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error Send OTP: $e');
    }

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
      print('Verify OTP Response: ${response.body}');

      if (response.statusCode == 200) {
        _validatedOtp = otp;
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error Verify OTP: $e');
    }

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

      print('Reset Password Response: ${response.body}');

      if (response.statusCode == 200) {
        _resetEmail = null;
        _validatedOtp = null;

        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error Reset Password: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> updateProfile(String username, String email) async {
    _isLoading = true;
    notifyListeners();

    try {
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

      if (_imageFile != null) {
        if (await _imageFile!.exists()) {
          final ext = _imageFile!.path.split('.').last.toLowerCase();
          final mime = ext == 'png' ? 'png' : 'jpeg';
          request.files.add(
            await http.MultipartFile.fromPath(
              'profile_photo',
              _imageFile!.path,
              contentType: http.MediaType('image', mime),
            ),
          );
        }
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _currentUser = User.fromJson(data['user']);
        _imageFile = null;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        print('Gagal Update: ${response.body}');
      }
    } catch (e) {
      print('Update Profile Error: $e');
    }

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
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }
}
