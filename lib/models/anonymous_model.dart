class AnonymousPost {
  final String id;
  final String authorName;
  final String categoryLabel;
  final String content;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final bool isMine;
  final String timeAgo;
  final List<AnonymousComment> comments;

  AnonymousPost({
    required this.id,
    required this.authorName,
    required this.categoryLabel,
    required this.content,
    required this.likesCount,
    required this.commentsCount,
    required this.isLiked,
    required this.isMine,
    required this.timeAgo,
    required this.comments,
  });

  factory AnonymousPost.fromJson(Map<String, dynamic> json) {
    return AnonymousPost(
      id: json['id']?.toString() ?? '',
      authorName: json['author_name'] ?? 'Anonim',
      categoryLabel: json['category'] ?? 'Umum',
      content: json['content'] ?? '',
      likesCount: json['likes_count'] ?? 0,
      commentsCount: json['comments_count'] ?? 0,
      isLiked: json['is_liked'] == true || json['is_liked'] == 1,
      isMine: json['is_mine'] == true || json['is_mine'] == 1,
      timeAgo: json['time_ago'] ?? '',
      comments: (json['comments'] as List? ?? [])
          .map((c) => AnonymousComment.fromJson(c))
          .toList(),
    );
  }
}

class AnonymousComment {
  final String content;
  final String timeAgo;
  final String authorName;
  final bool isMine;

  AnonymousComment({
    required this.content,
    required this.timeAgo,
    required this.authorName,
    required this.isMine,
  });

  factory AnonymousComment.fromJson(Map<String, dynamic> json) {
    return AnonymousComment(
      content: json['comment'] ?? '',
      timeAgo: json['time_ago'] ?? '',
      authorName: json['author_name'] ?? 'Anonim',
      isMine: json['is_mine'] ?? false,
    );
  }
}

enum Category {
  umum('Umum'),
  curhat('Curhat'),
  motivasi('Motivasi'),
  tanya('Tanya');

  final String label;
  const Category(this.label);
}
