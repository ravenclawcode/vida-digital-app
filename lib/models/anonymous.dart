enum Category {
  umum('Umum'),
  stres('Stres & Tekanan'),
  mentalHealth('Kesehatan Mental'),
  tidur('Tidur & Kesehatan'),
  sosial('Kehidupan Sosial'),
  selfCare('Perawatan Diri');

  final String label;
  const Category(this.label);
}

class AnonymousPost {
  final String id;
  final String content;
  final DateTime timestamp;
  final int likes;
  final int commentsCount;
  final Category category;
  final bool isLiked;

  AnonymousPost({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.category,
    this.likes = 0,
    this.commentsCount = 0,
    this.isLiked = false,
  });

  String get categoryLabel => category.label;

  String get formattedTime {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inDays > 0) return '${diff.inDays} hari lalu';
    if (diff.inHours > 0) return '${diff.inHours} jam lalu';
    if (diff.inMinutes > 0) return '${diff.inMinutes} menit lalu';
    return 'Baru saja';
  }
}

class AnonymousComment {
  final String id;
  final String postId;
  final String content;
  final DateTime timestamp;

  AnonymousComment({
    required this.id,
    required this.postId,
    required this.content,
    required this.timestamp,
  });

  String get formattedTime {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inDays > 0) return '${diff.inDays} hari lalu';
    if (diff.inHours > 0) return '${diff.inHours} jam lalu';
    if (diff.inMinutes > 0) return '${diff.inMinutes} menit lalu';
    return 'Baru saja';
  }
}
