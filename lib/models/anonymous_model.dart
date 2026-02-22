class AnonymousPost {
  final String id;
  final String authorName;
  final String? authorPhoto;
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
    this.authorPhoto,
    required this.categoryLabel,
    required this.content,
    required this.likesCount,
    required this.commentsCount,
    required this.isLiked,
    required this.isMine,
    required this.timeAgo,
    required this.comments,
  });

  AnonymousPost copyWith({
    String? id,
    String? authorName,
    String? authorPhoto,
    String? categoryLabel,
    String? content,
    int? likesCount,
    int? commentsCount,
    bool? isLiked,
    bool? isMine,
    String? timeAgo,
    List<AnonymousComment>? comments,
  }) {
    return AnonymousPost(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      authorPhoto: authorPhoto ?? this.authorPhoto,
      categoryLabel: categoryLabel ?? this.categoryLabel,
      content: content ?? this.content,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLiked: isLiked ?? this.isLiked,
      isMine: isMine ?? this.isMine,
      timeAgo: timeAgo ?? this.timeAgo,
      comments: comments ?? this.comments,
    );
  }

  factory AnonymousPost.fromJson(Map<String, dynamic> json) {
    return AnonymousPost(
      id: json['id']?.toString() ?? '',
      authorName: json['author_name'] ?? 'Anonim',
      authorPhoto: json['author_photo'],
      categoryLabel: json['category'] ?? 'Umum',
      content: json['content'] ?? '',
      likesCount: json['likes_count'] is int
          ? json['likes_count']
          : int.tryParse(json['likes_count']?.toString() ?? '0') ?? 0,
      commentsCount: json['comments_count'] is int
          ? json['comments_count']
          : int.tryParse(json['comments_count']?.toString() ?? '0') ?? 0,
      isLiked:
          json['is_liked'] == true ||
          json['is_liked'] == 1 ||
          json['is_liked']?.toString() == "1",
      isMine:
          json['is_mine'] == true ||
          json['is_mine'] == 1 ||
          json['is_mine']?.toString() == "1",
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
  final String? authorPhoto;
  final bool isMine;

  AnonymousComment({
    required this.content,
    required this.timeAgo,
    required this.authorName,
    this.authorPhoto,
    required this.isMine,
  });

  factory AnonymousComment.fromJson(Map<String, dynamic> json) {
    return AnonymousComment(
      content: json['comment'] ?? '',
      timeAgo: json['time_ago'] ?? '',
      authorName: json['author_name'] ?? 'Anonim',
      authorPhoto: json['author_photo'],
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
