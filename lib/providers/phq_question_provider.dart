import 'package:flutter/material.dart';
import 'package:mindfullshelter/models/phq_question_model.dart';
import 'package:mindfullshelter/services/phq_question_service.dart';

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
