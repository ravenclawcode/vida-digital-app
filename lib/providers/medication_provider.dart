import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/medication_model.dart';
import '../utils/api_constants.dart';

class MedicationProvider with ChangeNotifier {
  List<MedicationEntry> _todayEntries = [];
  bool _isLoading = false;

  List<MedicationEntry> get todayEntries => _todayEntries;
  bool get isLoading => _isLoading;

  double get progress {
    if (_todayEntries.isEmpty) return 0.0;
    return _todayEntries.where((e) => e.isTaken).length / _todayEntries.length;
  }

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return {'Authorization': 'Bearer $token', 'Accept': 'application/json'};
  }

  Future<void> fetchMedications() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(ApiConstants.medicationToday),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body)['data'];
        _todayEntries = data.map((item) {
          return MedicationEntry(
            id: item['id'],
            medication: Medication.fromJson(item),
            isTaken: item['status'] == 'taken',
          );
        }).toList();
      }
    } catch (e) {
      print("Error fetch: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMedication(String name, String time) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.medicationStore),
        headers: await _getHeaders(),
        body: {'name': name, 'time': time},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Berhasil simpan ke DB");
        await fetchMedications();
      } else {
        debugPrint("Gagal Simpan: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error Exception: $e");
    }
  }

  Future<void> toggleTaken(String medicationId) async {
    final entryIndex = _todayEntries.indexWhere(
      (e) => e.medication.id == medicationId,
    );
    if (entryIndex == -1) return;

    final newStatus = _todayEntries[entryIndex].isTaken ? 'skipped' : 'taken';

    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/medications/$medicationId/status'),
        headers: await _getHeaders(),
        body: {'status': newStatus},
      );

      if (response.statusCode == 200) {
        _todayEntries[entryIndex].isTaken = !_todayEntries[entryIndex].isTaken;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error update status: $e");
    }
  }

  Future<void> deleteMedication(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConstants.baseUrl}/medications/$id'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        _todayEntries.removeWhere((e) => e.medication.id == id);
        notifyListeners();
      }
    } catch (e) {
      print("Error delete: $e");
    }
  }
}
