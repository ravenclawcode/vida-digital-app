class Patient {
  final String id;
  final String name;
  final String? profilePhotoUrl;
  final String status;
  final double progress;
  final int unread;
  final bool isOnline;
  final String lastSeenDisplay;
  final int? lastPhqScore;
  final String? lastPhqDate;
  final List<MedicationLog>? medicationLogs;
  final List<int>? weeklyMoods;
  final List<PhqHistory>? phqHistory;
  final String? moodWeekRange;

  Patient({
    required this.id,
    required this.name,
    this.profilePhotoUrl,
    required this.status,
    required this.progress,
    required this.unread,
    required this.isOnline,
    required this.lastSeenDisplay,
    this.lastPhqScore,
    this.lastPhqDate,
    this.medicationLogs,
    this.weeklyMoods,
    this.phqHistory,
    this.moodWeekRange,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Pasien',
      profilePhotoUrl: json['profile_photo_url'],
      status: json['status']?.toString() ?? 'Perlu Perhatian',
      progress: _parseDouble(json['progress']),
      unread: int.tryParse(json['unread']?.toString() ?? '0') ?? 0,
      isOnline: json['is_online'] == true || json['is_online'] == 1,
      lastSeenDisplay: json['last_seen_display'] ?? 'Offline',
      lastPhqScore: json['last_phq_score'] != null
          ? int.tryParse(json['last_phq_score'].toString())
          : null,
      lastPhqDate: json['last_phq_date'],
      moodWeekRange: json['mood_week_range'],
      weeklyMoods: json['weekly_moods'] != null
          ? List<int>.from(
              (json['weekly_moods'] as List).map(
                (m) =>
                    int.tryParse(m.toString()) ??
                    double.tryParse(m.toString())?.toInt() ??
                    0,
              ),
            )
          : null,
      medicationLogs: json['medication_logs'] != null
          ? (json['medication_logs'] as List)
                .map((i) => MedicationLog.fromJson(i))
                .toList()
          : null,
      phqHistory: json['phq_history'] != null
          ? (json['phq_history'] as List)
                .map((i) => PhqHistory.fromJson(i))
                .toList()
          : null,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  Patient copyWith({
    bool? isOnline,
    String? lastSeenDisplay,
    int? unread,
    String? profilePhotoUrl,
  }) {
    return Patient(
      id: id,
      name: name,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      status: status,
      progress: progress,
      unread: unread ?? this.unread,
      isOnline: isOnline ?? this.isOnline,
      lastSeenDisplay: lastSeenDisplay ?? this.lastSeenDisplay,
      lastPhqScore: lastPhqScore,
      lastPhqDate: lastPhqDate,
      medicationLogs: medicationLogs,
      weeklyMoods: weeklyMoods,
      phqHistory: phqHistory,
      moodWeekRange: moodWeekRange,
    );
  }
}

class MedicationLog {
  final String medicationName;
  final bool isTaken;
  final String dayName;
  final String dateFormatted;

  MedicationLog({
    required this.medicationName,
    required this.isTaken,
    required this.dayName,
    required this.dateFormatted,
  });

  factory MedicationLog.fromJson(Map<String, dynamic> json) {
    return MedicationLog(
      medicationName: json['medication_name'] ?? 'Obat',
      isTaken:
          json['is_taken'] == 1 ||
          json['is_taken'] == true ||
          json['status'] == 'taken',
      dayName: json['day_name'] ?? '',
      dateFormatted: json['date_formatted'] ?? '',
    );
  }
}

class PhqHistory {
  final int score;
  final String date;
  final String category;

  PhqHistory({required this.score, required this.date, required this.category});

  factory PhqHistory.fromJson(Map<String, dynamic> json) {
    return PhqHistory(
      score: int.tryParse(json['score'].toString()) ?? 0,
      date: json['date'] ?? '',
      category: json['category'] ?? '-',
    );
  }
}
