import 'dart:convert';

import 'package:http/http.dart' as http;
import '../utils/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhqService {
  Future<http.Response> generateCode() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    return await http.post(
      Uri.parse(ApiConstants.generatePhqCode),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
  }

  Future<http.Response> deleteCode(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return await http.delete(
      Uri.parse(ApiConstants.deletePhqCode),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
  }

  Future<http.Response> validateCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    return await http.post(
      Uri.parse(ApiConstants.validatePhqCode),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'token_code': code}),
    );
  }

  Future<http.Response> useCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    return await http.post(
      Uri.parse("${ApiConstants.baseUrl}/phq-mark-used"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'token_code': code}),
    );
  }
}
