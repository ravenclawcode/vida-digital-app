import 'package:flutter/material.dart';
import '../models/mood_model.dart';
import '../services/mood_service.dart';
import '../data/dummy_data.dart';

class MoodProvider with ChangeNotifier {
  final MoodService _service = MoodService();
  List<MoodEntry> _weeklyLogs = [];
  bool _isLoading = false;

  List<MoodEntry> get weeklyLogs => _weeklyLogs;
  bool get isLoading => _isLoading;

  Future<void> fetchWeeklyMood() async {
    _isLoading = true;
    notifyListeners();

    try {
      final List data = await _service.fetchWeeklyMood();

      _weeklyLogs = data.where((item) => item['mood_code'] != null).map((item) {
        final moodDetail = DummyData.moods.firstWhere(
          (m) => m.id == item['mood_code'],
          orElse: () => DummyData.moods.first,
        );

        return MoodEntry(
          id: item['id'].toString(),
          date: DateTime.parse(item['date']),
          mood: moodDetail,
        );
      }).toList();
    } catch (_) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveMood(Mood mood) async {
    final success = await _service.storeMood(mood.id);
    if (success) {
      await fetchWeeklyMood();
    }
  }

  Future<void> deleteMood(String id) async {
    final success = await _service.deleteMood(id);
    if (success) {
      _weeklyLogs.removeWhere((log) => log.id == id);
      notifyListeners();
    }
  }

  MoodEntry? getMoodForDay(int dayIndex) {
    final targetWeekday = dayIndex + 1;
    try {
      return _weeklyLogs.firstWhere((log) => log.date.weekday == targetWeekday);
    } catch (_) {
      return null;
    }
  }
}
