import 'package:flutter/material.dart';
import '../services/counselor_service.dart';

class CounselorProvider with ChangeNotifier {
  final CounselorService _service = CounselorService();

  List<dynamic> _patients = [];
  Map<String, dynamic>? _selectedPatient;
  bool _isLoading = false;

  List<dynamic> get patients => _patients;
  Map<String, dynamic>? get selectedPatient => _selectedPatient;
  bool get isLoading => _isLoading;

  Future<void> fetchPatients() async {
    _isLoading = true;
    _patients = [];
    notifyListeners();
    try {
      _patients = await _service.fetchPatients();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPatientDetail(String id) async {
    _isLoading = true;
    _selectedPatient = null;
    notifyListeners();

    try {
      final response = await _service.fetchPatientDetail(id);
      
      _selectedPatient = response;
      
    } catch (e) {
      debugPrint("Gagal mengambil detail pasien: $e");
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
      debugPrint("Gagal mengirim hasil PHQ: $e");
      return false;
    }
  }

  void updateSelectedPatientStatus(bool isOnline, String lastSeen) {
  if (_selectedPatient != null) {
    _selectedPatient!['is_online'] = isOnline;
    _selectedPatient!['last_seen_display'] = lastSeen;
    notifyListeners();
  }
}
}