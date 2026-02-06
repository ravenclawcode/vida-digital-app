import 'package:flutter/material.dart';
import 'package:mindfullshelter/models/phq9_model.dart';
import 'dart:convert';

import 'package:mindfullshelter/services/phq9_service.dart';

class PhqProvider with ChangeNotifier {
  final PhqService _service = PhqService();
  PhqCode? _currentCode;
  bool _isLoading = false;

  PhqCode? get currentCode => _currentCode;
  bool get isLoading => _isLoading;

  Future<void> createNewCode() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _service.generateCode();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _currentCode = PhqCode.fromJson(data['data']);
      }
    } catch (e) {
      print(e);
    }
    _isLoading = false;
    notifyListeners();
  }

  void removeCodeLocal() {
    _currentCode = null;
    notifyListeners();
  }

  Future<bool> validatePatientCode(String code) async {
  _isLoading = true;
  notifyListeners();

  try {
    final response = await _service.validateCode(code);
    _isLoading = false;
    notifyListeners();
    
    return response.statusCode == 200;
  } catch (e) {
    _isLoading = false;
    notifyListeners();
    return false;
  }
}
}