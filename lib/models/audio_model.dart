class AudioMindfulness {
  final String id;
  final String title;
  final String category;
  final String description;
  final int duration;
  final String audioUrl;
  final String coverUrl;

  AudioMindfulness({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.duration,
    required this.audioUrl,
    required this.coverUrl,
  });

  factory AudioMindfulness.fromJson(Map<String, dynamic> json) {
    return AudioMindfulness(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      description: json['description'] ?? '',
      duration: _parseDurationToSeconds(json['duration'].toString()),
      audioUrl: json['audio_url'],
      coverUrl: json['cover_url'],
    );
  }

  static int _parseDurationToSeconds(String durationString) {
    try {
      List<String> parts = durationString.split(':');
      if (parts.length == 2) {
        return int.parse(parts[0]) * 60 + int.parse(parts[1]);
      }
      return int.tryParse(durationString) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  String get durationFormatted {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
