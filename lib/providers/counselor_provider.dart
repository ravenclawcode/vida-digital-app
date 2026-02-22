import 'package:flutter/material.dart';
import 'package:mindfullshelter/models/patient_model.dart';
import '../services/counselor_service.dart';

class CounselorProvider with ChangeNotifier {
  final CounselorService _service = CounselorService();

  List<Patient> _patients = [];
  Patient? _selectedPatient;
  bool _isLoading = false;

  List<Patient> get patients => _patients;
  Patient? get selectedPatient => _selectedPatient;
  bool get isLoading => _isLoading;

  Future<void> fetchPatients({bool isSilent = false}) async {
    if (!isSilent) {
      _isLoading = true;
      notifyListeners();
    }

    try {
      final List<dynamic> data = await _service.fetchPatients();
      _patients = data.map((json) => Patient.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Error Provider Fetch Patients: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSelectedPatient() {
    if (_selectedPatient == null) return;
    _selectedPatient = null;
    notifyListeners();
  }

  Future<void> fetchPatientDetail(String id, {bool isSilent = false}) async {
    if (!isSilent) {
      _isLoading = true;

      Future.microtask(() => notifyListeners());
    }

    try {
      final Map<String, dynamic> response = await _service.fetchPatientDetail(
        id,
      );
      _selectedPatient = Patient.fromJson(response);
    } catch (e) {
      debugPrint("Error Provider Fetch Detail: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitPhqResult(String token, Map<int, int> answers) async {
    try {
      final response = await _service.postPhqResult(token, answers);
      return response != null;
    } catch (e) {
      debugPrint("Error Submit PHQ: $e");
      return false;
    }
  }

  void updateSelectedPatientStatus(bool isOnline, String lastSeen) {
    _selectedPatient = _selectedPatient?.copyWith(
      isOnline: isOnline,
      lastSeenDisplay: lastSeen,
    );
    notifyListeners();
  }

  void updateUnreadCount(int count) {
    _selectedPatient = _selectedPatient?.copyWith(unread: count);
    notifyListeners();
  }

  void updateStatusOnline(bool online, String time) {
    _selectedPatient = _selectedPatient?.copyWith(
      isOnline: online,
      lastSeenDisplay: time,
    );
    notifyListeners();
  }
}
