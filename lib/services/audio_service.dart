import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_constants.dart';

class AudioService {
  Future<List<dynamic>> fetchAudios({String? category}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    String url = ApiConstants.audio; 
    
    if (category != null && category != 'Semua') {
      url += '?category=$category';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Gagal mengambil data audio');
    }
  }
}