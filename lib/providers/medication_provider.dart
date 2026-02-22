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
        return MedicationEntry(
          id: item['id'],
          medication: Medication.fromJson(item),
          isTaken: item['status'] == 'taken',
        );
      }).toList();

      await _notificationService.cancelAllNotifications();

      for (var item in data) {
        if (item['status'] == 'pending') {
          final timeStr = item['time'];
          final timeParts = timeStr.split(':');

          final now = DateTime.now();
          final scheduledTime = DateTime(
            now.year,
            now.month,
            now.day,
            int.parse(timeParts[0]),
            int.parse(timeParts[1]),
          );

          await _notificationService.scheduleMedicationReminders(
            id: item['id'].hashCode.abs(),
            medicationName: item['name'],
            scheduledTime: scheduledTime,
          );
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
      await _notificationService.cancelReminder(id.hashCode.abs());
      await _service.updateMedication(id, name, time, isEveryday);
      await fetchMedications();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleTaken(String medicationId) async {
    final index = _todayEntries.indexWhere(
      (e) => e.medication.id == medicationId,
    );
    if (index == -1) return;

    final newStatus = _todayEntries[index].isTaken ? 'skipped' : 'taken';

    try {
      await _service.updateStatus(medicationId, newStatus);
      _todayEntries[index].isTaken = !_todayEntries[index].isTaken;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> deleteMedication(String id) async {
    try {
      await _notificationService.cancelReminder(id.hashCode.abs());
      await _service.deleteMedication(id);
      _todayEntries.removeWhere((e) => e.medication.id == id);
      notifyListeners();
    } catch (_) {}
  }

  void startAutoExpiryCheck() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      debugPrint("Checking medication status at: ${DateTime.now()}");
      _checkMissedStatus();
    });
  }

  void _checkMissedStatus() {
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

      _fetchMedicationsSilent();
    }
  }

  Future<void> _fetchMedicationsSilent() async {
    try {
      final data = await _service.fetchTodayMedications();
      _todayEntries = data.map((item) {
        return MedicationEntry(
          id: item['id'],
          medication: Medication.fromJson(item),
          isTaken: item['status'] == 'taken',
        );
      }).toList();
      notifyListeners();
    } catch (e) {
      debugPrint("Silent fetch error: $e");
    }
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }
}
