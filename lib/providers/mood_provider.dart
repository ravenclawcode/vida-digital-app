import 'package:flutter/material.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import '../models/mood_model.dart';
import '../services/mood_service.dart';

class MoodProvider with ChangeNotifier {
  final MoodService _service = MoodService();
  List<MoodEntry> _weeklyLogs = [];
  bool _isLoading = false;

  List<MoodEntry> get weeklyLogs => _weeklyLogs;
  bool get isLoading => _isLoading;

  static final List<Mood> moodMasterList = [
    Mood(id: '6', emoji: Image.asset(icHappy), label: 'Senang'),
    Mood(id: '5', emoji: Image.asset(icCalm), label: 'Tenang'),
    Mood(id: '4', emoji: Image.asset(icNormal), label: 'Biasa'),
    Mood(id: '3', emoji: Image.asset(icTired), label: 'Lelah'),
    Mood(id: '2', emoji: Image.asset(icSad), label: 'Sedih'),
    Mood(id: '1', emoji: Image.asset(icAnxious), label: 'Cemas'),
  ];

  MoodEntry? getMoodForDay(int dayIndex) {
    final targetWeekday = dayIndex + 1;

    try {
      return _weeklyLogs.firstWhere((log) => log.date.weekday == targetWeekday);
    } catch (_) {
      return null;
    }
  }

  Future<void> fetchWeeklyMood() async {
    _isLoading = true;
    notifyListeners();

    try {
      final List data = await _service.fetchWeeklyMood();

      _weeklyLogs = data.where((item) => item['mood_code'] != null).map((item) {
        final moodDetail = moodMasterList.firstWhere(
          (m) => m.id == item['mood_code'].toString(),
          orElse: () => moodMasterList[2],
        );

        return MoodEntry(
          id: item['id'].toString(),
          date: DateTime.parse(item['date']),
          mood: moodDetail,
        );
      }).toList();
    } catch (e) {
      debugPrint("Error fetching mood: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveMood(Mood mood) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _service.storeMood(mood.id);
      if (success) {
        await fetchWeeklyMood();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error saving mood: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteMood(String id) async {
    try {
      final success = await _service.deleteMood(id);
      if (success) {
        _weeklyLogs.removeWhere((log) => log.id == id);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error deleting mood: $e");
      return false;
    }
  }
}
