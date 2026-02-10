import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_constants.dart';

class CounselorService {
  Future<List<dynamic>> fetchPatients() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    try {
      final response = await http.get(
        Uri.parse(ApiConstants.getPatients),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'] ?? [];
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      print("Error Catch: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchPatientDetail(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('${ApiConstants.getPatients}/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded['data'];
    } else {
      print("Error Detail: ${response.statusCode} - ${response.body}");
      throw Exception('Gagal mengambil detail pasien');
    }
  }

  // TAMBAHKAN FUNGSI INI DI BAWAH
  Future<Map<String, dynamic>> postPhqResult(String tokenCode, Map<int, int> answers) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.postPhqResult),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'token_code': tokenCode,
          'answers': answers,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Gagal mengirim hasil PHQ');
      }
    } catch (e) {
      print("Error Post PHQ: $e");
      rethrow;
    }
  }
}