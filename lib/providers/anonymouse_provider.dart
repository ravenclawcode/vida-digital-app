import 'package:flutter/material.dart';
import '../models/anonymous_model.dart';
import '../services/community_service.dart';

class AnonymousProvider extends ChangeNotifier {
  final CommunityService _service = CommunityService();

  List<AnonymousPost> _posts = [];
  bool _isLoading = false;

  List<AnonymousPost> get posts => _posts;
  bool get isLoading => _isLoading;

  Future<void> loadPosts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _posts = await _service.fetchPosts();
    } catch (e) {
      debugPrint("Error Load Posts: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPost(String category, String content) async {
    _isLoading = true;
    notifyListeners();

    final success = await _service.storePost(category, content);
    
    if (success) {
      print("DEBUG: Upload Berhasil, Memuat ulang post...");
      await loadPosts();
    } else {
      print("DEBUG: Upload Gagal di level Provider.");
    }

    _isLoading = false;
    notifyListeners();
}

  Future<void> toggleLike(String postId) async {
    final success = await _service.toggleLike(postId);
    if (success != null) {
      await loadPosts();
    }
  }

  Future<void> addComment(String postId, String comment) async {
    if (comment.isEmpty) return;

    final success = await _service.storeComment(postId, comment);
    if (success) {
      await loadPosts();
    }
  }

  List<AnonymousComment> getCommentsForPost(String postId) {
    try {
      return _posts.firstWhere((post) => post.id == postId).comments;
    } catch (e) {
      return [];
    }
  }

  Future<void> removePost(String postId) async {
  final success = await _service.deletePost(postId);
  if (success) {
    _posts.removeWhere((post) => post.id == postId);
    notifyListeners();
  }
}
}
