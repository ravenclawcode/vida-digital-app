import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mindfullshelter/services/notification_service.dart';
import '../models/medication_model.dart';
import '../services/medication_service.dart';

class MedicationProvider with ChangeNotifier {
  final MedicationService _service = MedicationService();
  final NotificationService _notificationService = NotificationService();
  List<MedicationEntry> _todayEntries = [];
  bool _isLoading = false;
  Timer? _autoRefreshTimer;

  List<MedicationEntry> get todayEntries => _todayEntries;
  bool get isLoading => _isLoading;

  String? _lastFetchDay;

  final Set<String> _reportedMissedIds = {};

  String _dayKey(DateTime dt) => '${dt.year}-${dt.month}-${dt.day}';

  void _markFetchDay() => _lastFetchDay = _dayKey(DateTime.now());

  bool get _isNewDay => _lastFetchDay != null && _lastFetchDay != _dayKey(DateTime.now());

  Future<void> refreshIfNewDay() async {
    if (_isNewDay) {
      debugPrint('Hari berganti, me-refresh daftar obat...');
      await fetchMedications();
    }
  }

  double get progress {
    if (_todayEntries.isEmpty) return 0.0;
    return _todayEntries.where((e) => e.isTaken).length / _todayEntries.length;
  }

  Future<void> fetchMedications() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _service.fetchTodayMedications();

      _todayEntries = data.map((item) {
        final map = item as Map<String, dynamic>;
        return MedicationEntry(
          id: map['id'].toString(),
          medication: Medication.fromJson(map),
          isTaken: map['status'] == 'taken',
        );
      }).toList();
      if (_isNewDay) _reportedMissedIds.clear();
      _markFetchDay();

      await _notificationService.cancelAllNotifications();

      final bool isReminderEnabled =
          await _notificationService.isReminderEnabled();
      if (!isReminderEnabled) return;

      for (var item in data) {
        try {
          final map = item as Map<String, dynamic>;
          if (map['status'] != 'pending') continue;

          final String medId = map['id'].toString();
          final String medName = (map['name'] ?? '').toString();
          final bool isEveryday =
              map['is_everyday'] == 1 || map['is_everyday'] == true;

          final String timeStr =
              (map['time'] ?? '').toString().replaceAll('.', ':');
          final timeParts = timeStr.split(':');
          if (timeParts.length < 2) continue;
          final int? hour = int.tryParse(timeParts[0]);
          final int? minute = int.tryParse(timeParts[1]);
          if (hour == null || minute == null) continue;

          final now = DateTime.now();
          final scheduledTime = DateTime(
            now.year,
            now.month,
            now.day,
            hour,
            minute,
          );

          await _notificationService.scheduleMedicationReminders(
            id: NotificationService.baseIdFor(medId),
            medicationName: medName,
            scheduledTime: scheduledTime,
            isEveryday: isEveryday,
          );
        } catch (e) {
          debugPrint('Lewati jadwal obat rusak: $e');
          continue;
        }
      }
    } catch (e) {
      print("ERROR FETCHING: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMedication(
    String name,
    String time, {
    bool isEveryday = false,
  }) async {
    try {
      await _service.addMedication(name, time, isEveryday);
      await fetchMedications();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateMedication(
    String id,
    String name,
    String time, {
    bool isEveryday = false,
  }) async {
    try {
      await _notificationService.cancelReminderFor(id);
      await _service.updateMedication(id, name, time, isEveryday);
      await fetchMedications();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleTaken(String medicationId) async {
    final index = _todayEntries.indexWhere(
      (e) => e.medication.id == medicationId || e.id == medicationId,
    );
    if (index == -1) return;

    final newStatus = _todayEntries[index].isTaken ? 'skipped' : 'taken';
    final wasTaken = _todayEntries[index].isTaken;

    try {
      await _service.updateStatus(medicationId, newStatus);
      _todayEntries[index].isTaken = !wasTaken;
      notifyListeners();

      final entry = _todayEntries[index];
      if (!wasTaken) {
        await _notificationService.cancelReminderFor(medicationId);
        if (entry.medication.isEveryday) {
          final now = DateTime.now();
          await _notificationService.scheduleMedicationReminders(
            id: NotificationService.baseIdFor(medicationId),
            medicationName: entry.medication.name,
            scheduledTime: DateTime(
              now.year,
              now.month,
              now.day,
              entry.medication.time.hour,
              entry.medication.time.minute,
            ),
            isEveryday: true,
          );
        }
      } else {
        await fetchMedications();
      }
    } catch (_) {}
  }

  Future<void> deleteMedication(String id) async {
    try {
      await _notificationService.cancelReminderFor(id);
      await _service.deleteMedication(id);
      _todayEntries.removeWhere((e) => e.medication.id == id);
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _fetchMedicationsSilent() async {
    try {
      final data = await _service.fetchTodayMedications();
      _todayEntries = data.map((item) {
        final map = item as Map<String, dynamic>;
        return MedicationEntry(
          id: map['id'].toString(),
          medication: Medication.fromJson(map),
          isTaken: map['status'] == 'taken',
        );
      }).toList();
      _markFetchDay();
      notifyListeners();
    } catch (e) {
      debugPrint("Silent fetch error: $e");
    }
  }

  void startAutoExpiryCheck() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      debugPrint("Checking medication status at: ${DateTime.now()}");
      if (_isNewDay) {
        fetchMedications();
        return;
      }
      _checkMissedStatus();
    });
  }

  Future<void> _checkMissedStatus() async {
    final now = DateTime.now();
    bool hasChanges = false;

    final List<MedicationEntry> toRemove = [];

    for (var entry in _todayEntries) {
      if (!entry.isTaken) {
        final medTime = entry.medication.time;
        final scheduledDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          medTime.hour,
          medTime.minute,
        );

        if (now.isAfter(scheduledDateTime)) {
          toRemove.add(entry);
          hasChanges = true;
        }
      }
    }

    if (hasChanges) {
      for (var item in toRemove) {
        _todayEntries.removeWhere((e) => e.id == item.id);
      }

      debugPrint("Obat kedaluwarsa ditemukan. Menghapus dari UI...");
      notifyListeners();

      for (var item in toRemove) {
        final String medId = item.medication.id;
        if (_reportedMissedIds.add(medId)) {
          try {
            await _service.updateStatus(medId, 'skipped');
          } catch (e) {
            debugPrint('Gagal melaporkan obat terlewat $medId: $e');
          }
        }
      }

      _fetchMedicationsSilent();
    }
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }
}
