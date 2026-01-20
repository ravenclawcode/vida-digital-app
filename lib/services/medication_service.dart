import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_constants.dart';

class MedicationService {
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return {'Authorization': 'Bearer $token', 'Accept': 'application/json'};
  }

  Future<List<dynamic>> fetchTodayMedications() async {
    final response = await http.get(
      Uri.parse(ApiConstants.medicationToday),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    }
    throw Exception('Gagal mengambil data obat');
  }

  Future<void> addMedication(String name, String time, bool isEveryday) async {
    final response = await http.post(
      Uri.parse(ApiConstants.medicationStore),
      headers: await _getHeaders(),
      body: {'name': name, 'time': time, 'is_everyday': isEveryday ? '1' : '0'},
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Gagal menambah obat');
    }
  }

  Future<void> updateMedication(
    String id,
    String name,
    String time,
    bool isEveryday,
  ) async {
    final response = await http.put(
      Uri.parse('${ApiConstants.baseUrl}/medications/$id'),
      headers: await _getHeaders(),
      body: {'name': name, 'time': time, 'is_everyday': isEveryday ? '1' : '0'},
    );
    if (response.statusCode != 200) throw Exception('Gagal memperbarui obat');
  }

  Future<void> updateStatus(String id, String status) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/medications/$id/status'),
      headers: await _getHeaders(),
      body: {'status': status},
    );
    if (response.statusCode != 200) throw Exception('Gagal update status');
  }

  Future<void> deleteMedication(String id) async {
    final response = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}/medications/$id'),
      headers: await _getHeaders(),
    );
    if (response.statusCode != 200) throw Exception('Gagal menghapus obat');
  }
}
