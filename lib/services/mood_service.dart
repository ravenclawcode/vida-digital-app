import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_constants.dart';

class MoodService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<Map<String, String>> _getHeaders() async {
    return {
      'Authorization': 'Bearer ${await _getToken()}',
      'Accept': 'application/json',
    };
  }

  Future<List<dynamic>> fetchWeeklyMood() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/moods/weekly'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    }
    throw Exception('Gagal mengambil riwayat mood');
  }

  Future<bool> storeMood(String moodCode) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/moods'),
      headers: await _getHeaders(),
      body: {'mood_code': moodCode},
    );
    return response.statusCode == 200;
  }

  Future<bool> deleteMood(String id) async {
    final response = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}/moods/$id'),
      headers: await _getHeaders(),
    );
    return response.statusCode == 200;
  }
}
