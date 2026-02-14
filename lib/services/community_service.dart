import 'dart:convert';
import 'package:flutter/foundation.dart';
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

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('data')) {
          final List data = responseData['data'];
          return data.map((item) => AnonymousPost.fromJson(item)).toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint("Error: $e");
      throw Exception('Gagal memuat postingan');
    }
  }

  Future<bool> storePost(String category, String content) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.community),
        headers: await _headers(),
        body: jsonEncode({'category': category, 'content': content}),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (_) {
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
