import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_constants.dart';

class MedicationService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<List<dynamic>> fetchTodayMedications() async {
    final response = await http.get(
      Uri.parse(ApiConstants.medicationToday),
      headers: {'Authorization': 'Bearer ${await _getToken()}', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    }
    throw Exception('Gagal mengambil data obat');
  }

  Future<bool> addMedication(String name, String time) async {
    final response = await http.post(
      Uri.parse(ApiConstants.medicationStore),
      headers: {'Authorization': 'Bearer ${await _getToken()}', 'Accept': 'application/json'},
      body: {'name': name, 'time': time},
    );
    return response.statusCode == 200;
  }

  Future<bool> updateStatus(String id, String status) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.medicationStore}/$id/status'),
      headers: {'Authorization': 'Bearer ${await _getToken()}', 'Accept': 'application/json'},
      body: {'status': status},
    );
    return response.statusCode == 200;
  }
}