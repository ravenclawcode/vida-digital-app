import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mindfullshelter/models/phq_question_model.dart';
import 'package:mindfullshelter/services/phq_question_service.dart';
import 'package:mindfullshelter/utils/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhqQuestionProvider with ChangeNotifier {
  final PhqQuestionService _phqQuestionService = PhqQuestionService();

  List<PhqQuestion> _questions = [];
  final Map<int, int> _answers = {};
  bool _isLoading = false;

  List<PhqQuestion> get questions => _questions;
  Map<int, int> get answers => _answers;
  bool get isLoading => _isLoading;

  Future<void> fetchQuestions() async {
    _isLoading = true;
    notifyListeners();

    try {
      _questions = await _phqQuestionService.fetchQuestions();
    } catch (_) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitResult(String tokenCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final Map<String, int> formattedAnswers = _answers.map(
        (key, value) => MapEntry(key.toString(), value),
      );

      final response = await http.post(
        Uri.parse(ApiConstants.postPhqResult),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'token_code': tokenCode,
          'answers': formattedAnswers,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        debugPrint("Server Error: ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Submit Error: $e");
      return false;
    }
  }

  void setAnswer(int questionId, int score) {
    _answers[questionId] = score;
    notifyListeners();
  }

  int get totalScore {
    return _answers.values.fold(0, (sum, score) => sum + score);
  }

  double get progress =>
      _questions.isEmpty ? 0 : _answers.length / _questions.length;
}
