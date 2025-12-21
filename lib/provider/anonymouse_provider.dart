import 'package:flutter/material.dart';
import 'package:mindfullshelter/data/dummy_data.dart';
import 'package:mindfullshelter/models/anonymous.dart';

class AnonymousProvider with ChangeNotifier {
  final List<AnonymousPost> _posts = [...DummyData.anonymousPosts];
  final List<AnonymousComment> _comments = [...DummyData.anonymousComments];

  List<AnonymousPost> get posts => _posts;

  List<AnonymousComment> getCommentsForPost(String postId) {
    return _comments.where((comment) => comment.postId == postId).toList();
  }

  void addPost(String content, Category category) {
    final newPost = AnonymousPost(
      id: 'post_${DateTime.now().millisecondsSinceEpoch}',
      content: content,
      timestamp: DateTime.now(),
      category: category,
    );
    _posts.insert(0, newPost); 
    notifyListeners();
  }

  void addComment(String postId, String content) {
    final newComment = AnonymousComment(
      id: 'com_${DateTime.now().millisecondsSinceEpoch}',
      postId: postId,
      content: content,
      timestamp: DateTime.now(),
    );
    _comments.add(newComment);

    final postIndex = _posts.indexWhere((p) => p.id == postId);
    if (postIndex != -1) {
      final p = _posts[postIndex];
      _posts[postIndex] = AnonymousPost(
        id: p.id,
        content: p.content,
        timestamp: p.timestamp,
        category: p.category,
        likes: p.likes,
        commentsCount: p.commentsCount + 1,
      );
    }
    notifyListeners();
  }

  void toggleLike(String postId) {
  final index = _posts.indexWhere((p) => p.id == postId);
  if (index != -1) {
    final p = _posts[index];
    final bool currentlyLiked = p.isLiked;

    _posts[index] = AnonymousPost(
      id: p.id,
      content: p.content,
      timestamp: p.timestamp,
      category: p.category,
      commentsCount: p.commentsCount,
      isLiked: !currentlyLiked, 
      likes: currentlyLiked ? p.likes - 1 : p.likes + 1, 
    );
    notifyListeners();
  }
}
}
