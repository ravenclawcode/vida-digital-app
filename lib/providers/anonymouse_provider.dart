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
    } catch (_) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPost(String category, String content) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _service.storePost(category, content);

      if (success) {
        await loadPosts();
      }
    } catch (_) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleLike(String postId) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final oldPost = _posts[index];

    final isNowLiked = !oldPost.isLiked;
    _posts[index] = oldPost.copyWith(
      isLiked: isNowLiked,
      likesCount: isNowLiked ? oldPost.likesCount + 1 : oldPost.likesCount - 1,
    );
    notifyListeners();

    try {
      final result = await _service.toggleLike(postId);

      if (result == null) {
        throw Exception("Gagal update server");
      }
    } catch (e) {
      _posts[index] = oldPost;
      notifyListeners();
    }
  }

  Future<void> addComment(String postId, String commentText) async {
    if (commentText.isEmpty) return;

    final success = await _service.storeComment(postId, commentText);
    if (success) {
      await loadPosts();
    }
  }

  Future<void> removePost(String postId) async {
    final success = await _service.deletePost(postId);
    if (success) {
      _posts.removeWhere((post) => post.id == postId);
      notifyListeners();
    }
  }

  List<AnonymousComment> getCommentsForPost(String postId) {
    try {
      return _posts.firstWhere((post) => post.id == postId).comments;
    } catch (e) {
      return [];
    }
  }
}
