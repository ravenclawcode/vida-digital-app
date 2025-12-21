class AudioMindfulness {
  final String id;
  final String title;
  final String description;
  final String category;
  final int duration;
  final String audioUrl;
  final String thumbnailUrl;

  AudioMindfulness({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.duration,
    required this.audioUrl,
    required this.thumbnailUrl,
  });

  String get durationFormatted {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
