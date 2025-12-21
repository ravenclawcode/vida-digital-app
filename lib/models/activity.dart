import 'package:flutter/widgets.dart';

class Activity {
  final String id;
  final String title;
  final DateTime date;
  final Widget icon;
  final Color color;

 Activity({
    required this.id,
    required this.title,
    required this.date,
    required this.icon,
    required this.color,
  });
}