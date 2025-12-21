import 'package:flutter/material.dart';
import 'package:mindfullshelter/data/dummy_data.dart';
import 'package:mindfullshelter/models/user.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  User? _currentUser;
  User? get currentUser => _currentUser;

  Future<bool> signUp(String email, String username, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    final existUser = DummyData.users.any((u) => u.email == email);
    if (existUser) {
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final newUser = User(
      id: (DummyData.users.length + 1).toString(),
      email: email,
      username: username,
      password: password,
    );

    DummyData.users.add(newUser);

    _isLoading = false;
    notifyListeners();

    return true;
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    try {
      final user = DummyData.users.firstWhere(
        (u) => u.email == email && u.password == password,
      );

      _currentUser = user;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    final exist = DummyData.users.any((u) => u.email == email);

    if (exist) {
      _currentUser = DummyData.users.firstWhere((u) => u.email == email);
    }

    _isLoading = false;
    notifyListeners();

    return exist;
  }

  Future<bool> updatePassword(String newPassword) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (_currentUser == null) {
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final updatedUser = _currentUser!.copyWith(password: newPassword);
    _currentUser = updatedUser;

    final index = DummyData.users.indexWhere(
      (u) => u.email == updatedUser.email,
    );
    if (index != -1) {
      DummyData.users[index] = updatedUser;
    }

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> verifyCode(String otp) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    const correctOtp = "12345";

    final isValid = otp == correctOtp;

    _isLoading = false;
    notifyListeners();

    return isValid;
  }
}
