import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mindfullshelter/models/phq_question_model.dart';
import 'package:mindfullshelter/utils/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhqQuestionService {
  Future<List<PhqQuestion>> fetchQuestions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await http.get(
        Uri.parse(ApiConstants.getPhqQuestions),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> data = body['data'];

        return data.map((item) => PhqQuestion.fromJson(item)).toList();
      } else {
        throw Exception('Gagal: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
