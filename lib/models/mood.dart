import 'package:flutter/widgets.dart';

class Mood {
  final String id;
  final Widget emoji;
  final String label;

  Mood({
    required this.id,
    required this.emoji,
    required this.label,
  });
}

class MoodEntry {
  final String id;
  final DateTime date;
  final Mood mood;

  MoodEntry({
    required this.id,
    required this.date,
    required this.mood,
  });
}
