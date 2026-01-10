import 'package:flutter/material.dart';

class Mood {
  final String id;
  final String label;
  final Widget emoji;

  Mood({required this.id, required this.label, required this.emoji});
}

class MoodEntry {
  final String id;
  final Mood mood;
  final DateTime date;

  MoodEntry({required this.id, required this.mood, required this.date});
}
