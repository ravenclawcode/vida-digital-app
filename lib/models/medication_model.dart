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
    final timeParts = json['time'].split(':');

    return Medication(
      id: json['id'],
      name: json['name'],
      isEveryday: json['is_everyday'] == 1 || json['is_everyday'] == true,
      time: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
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
