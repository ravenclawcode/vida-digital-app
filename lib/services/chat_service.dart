import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_model.dart';
import '../utils/api_constants.dart';

class ChatService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    print("DEBUG: Token yang dikirim ke Chat: $token");
    return token;
  }

  Future<List<Chat>> fetchHistory() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse(ApiConstants.chatHistory),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((json) => Chat.fromJson(json)).toList();
    }
    throw Exception('Gagal mengambil riwayat pesan');
  }

  Future<Chat> sendMessage(String message) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse(ApiConstants.chatSend),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'message': message}),
    );

    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      return Chat.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }
}
