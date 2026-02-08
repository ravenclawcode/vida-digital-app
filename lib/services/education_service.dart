import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mindfullshelter/utils/api_constants.dart';
import '../models/education_model.dart';

class EducationService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<List<EducationContent>> fetchEducation() async {
    try {
      final token = await _getToken();

      final response = await http.get(
        Uri.parse(ApiConstants.education),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List data = json.decode(response.body)['data'];
        return data.map((item) => EducationContent.fromJson(item)).toList();
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } catch (_) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> postLike(String id) async {
    try {
      final token = await _getToken();

      final response = await http.post(
        Uri.parse('${ApiConstants.education}/$id/like'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
