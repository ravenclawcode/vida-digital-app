class Chat {
  final String message;
  final String sender;
  final DateTime timestamp;

  Chat({
    required this.message,
    required this.sender,
    required this.timestamp,
  });

  bool get isUser => sender == 'user';

  factory Chat.fromJson(Map<String, dynamic> json) {
    DateTime now = DateTime.now();
    if (json['time'] != null) {
      List<String> parts = json['time'].split('.');
      now = DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
    }

    return Chat(
      message: json['message'] ?? '',
      sender: json['sender'] ?? 'bot',
      timestamp: now,
    );
  }
}