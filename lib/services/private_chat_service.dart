import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_constants.dart';

class PrivateChatService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<List<dynamic>> fetchContacts() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse(ApiConstants.chatContacts),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    return response.statusCode == 200 ? json.decode(response.body) : [];
  }

  Future<List<dynamic>> fetchMessages(String otherUserId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse("${ApiConstants.privateMessages}/$otherUserId"),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    return response.statusCode == 200 ? json.decode(response.body) : [];
  }

  Future<Map<String, dynamic>> sendMessage(
    String receiverId,
    String message,
  ) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse(ApiConstants.sendPrivateMessage),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'receiver_id': receiverId, 'message': message}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal mengirim pesan');
    }
  }

  Future<void> updateOnlineStatus(bool isOnline) async {
    final token = await _getToken();
    if (token == null) return;

    try {
      await http.post(
        Uri.parse(ApiConstants.updateStatus),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'is_online': isOnline}),
      );
    } catch (_) {}
  }

  Future<bool> deleteChat(String otherUserId) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse("${ApiConstants.privateMessages}/$otherUserId"),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    return response.statusCode == 200;
  }
}
