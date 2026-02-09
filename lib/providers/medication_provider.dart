import 'package:flutter/material.dart';
import 'package:mindfullshelter/services/notification_service.dart';
import '../models/medication_model.dart';
import '../services/medication_service.dart';

class MedicationProvider with ChangeNotifier {
  final MedicationService _service = MedicationService();
  final NotificationService _notificationService = NotificationService();
  List<MedicationEntry> _todayEntries = [];
  bool _isLoading = false;

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

      for (var entry in _todayEntries) {
        final safeId = entry.medication.id.hashCode.abs();

        _notificationService.scheduleMedicationReminders(
          id: safeId,
          medicationName: entry.medication.name,
          scheduledTime: _convertTimeOfDayToDateTime(entry.medication.time),
        );
      }
    } catch (_) {
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

  DateTime _convertTimeOfDayToDateTime(TimeOfDay time) {
    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
