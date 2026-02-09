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
      print("Jumlah pasien didapat: ${_patients.length}");
    } catch (e) {
      print("Koneksi gagal atau data format salah: $e");
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
      print("Gagal mengambil detail pasien: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
