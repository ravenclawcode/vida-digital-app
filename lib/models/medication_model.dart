import 'package:flutter/material.dart';

class Medication {
  final String id;
  final String name;
  final TimeOfDay time;
  final bool isEveryday;

  Medication({
    required this.id,
    required this.name,
    required this.time,
    this.isEveryday = false,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    final String id = json['id'].toString();

    final String rawTime = (json['time'] ?? '').toString().replaceAll('.', ':');
    final timeParts = rawTime.split(':');
    final int hour = timeParts.isNotEmpty ? int.tryParse(timeParts[0]) ?? 0 : 0;
    final int minute =
        timeParts.length > 1 ? int.tryParse(timeParts[1]) ?? 0 : 0;

    return Medication(
      id: id,
      name: (json['name'] ?? '').toString(),
      isEveryday: json['is_everyday'] == 1 || json['is_everyday'] == true,
      time: TimeOfDay(
        hour: hour.clamp(0, 23),
        minute: minute.clamp(0, 59),
      ),
    );
  }
}

class MedicationEntry {
  final String id;
  final Medication medication;
  bool isTaken;

  MedicationEntry({
    required this.id,
    required this.medication,
    this.isTaken = false,
  });
}
