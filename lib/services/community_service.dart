import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_constants.dart';
import '../models/anonymous_model.dart';

class CommunityService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<Map<String, String>> _headers() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<AnonymousPost>> fetchPosts() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.community),
        headers: await _headers(),
      );

      print("DEBUG FETCH Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('data')) {
          final List data = responseData['data'];
          return data.map((item) => AnonymousPost.fromJson(item)).toList();
        }
      } else {
        print("DETAIL ERROR LARAVEL: ${response.body}");
      }
      throw Exception('Struktur data tidak sesuai');
    } catch (e) {
      print("DEBUG FETCH Error: $e");
      throw Exception('Gagal memuat postingan');
    }
  }

  Future<bool> storePost(String category, String content) async {
    try {
      final token = await _getToken();
      print("DEBUG: Mengirim Post dengan Token: ${token?.substring(0, 10)}...");

      final response = await http.post(
        Uri.parse(ApiConstants.community),
        headers: await _headers(),
        body: jsonEncode({'category': category, 'content': content}),
      );

      print("DEBUG: Status Code: ${response.statusCode}");
      print("DEBUG: Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 422) {
        print("DEBUG: Validasi Gagal! Pastikan content > 5 karakter.");
        return false;
      } else if (response.statusCode == 401) {
        print("DEBUG: Token Kadaluarsa / Tidak Terdeteksi.");
        return false;
      }
      return false;
    } catch (e) {
      print("DEBUG: Terjadi Exception: $e");
      return false;
    }
  }

  Future<bool?> toggleLike(String postId) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.community}/$postId/like'),
      headers: await _headers(),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['is_liked'];
    }
    return null;
  }

  Future<bool> storeComment(String postId, String comment) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.community}/$postId/comment'),
      headers: await _headers(),
      body: jsonEncode({'comment': comment}),
    );
    return response.statusCode == 200;
  }

  Future<bool> deletePost(String postId) async {
    final response = await http.delete(
      Uri.parse('${ApiConstants.community}/$postId'),
      headers: await _headers(),
    );
    return response.statusCode == 200;
  }
}
