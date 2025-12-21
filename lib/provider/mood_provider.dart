import 'package:flutter/material.dart';
import '../models/mood.dart';

class MoodProvider extends ChangeNotifier {
  final List<MoodEntry> _entries = [];

  List<MoodEntry> get entries => _entries;

  MoodEntry? moodByDate(DateTime date) {
    try {
      return _entries.firstWhere(
        (e) =>
            e.date.year == date.year &&
            e.date.month == date.month &&
            e.date.day == date.day,
      );
    } catch (_) {
      return null;
    }
  }

  void saveMood({required Mood mood, String? note}) {
    final today = DateTime.now();

    _entries.removeWhere(
      (e) =>
          e.date.year == today.year &&
          e.date.month == today.month &&
          e.date.day == today.day,
    );

    _entries.add(
      MoodEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: today,
        mood: mood,
      ),
    );

    notifyListeners();
  }

  void deleteMood(String id) {
    _entries.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  List<MoodEntry?> weeklyMood(DateTime startOfWeek) {
    return List.generate(7, (index) {
      final date = startOfWeek.add(Duration(days: index));
      return moodByDate(date);
    });
  }
}
