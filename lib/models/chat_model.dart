class Chat {
  final String message;
  final String sender;
  final DateTime timestamp;

  Chat({required this.message, required this.sender, required this.timestamp});

  bool get isUser => sender == 'user';

  factory Chat.fromJson(Map<String, dynamic> json) {
    DateTime parsedTime;

    try {
      if (json['time'] != null) {
        if (json['time'].contains('T') || json['time'].contains('-')) {
          parsedTime = DateTime.parse(json['time']).toLocal();
        } else {
          List<String> parts = json['time'].split('.');
          DateTime now = DateTime.now();
          parsedTime = DateTime(
            now.year,
            now.month,
            now.day,
            int.parse(parts[0]),
            int.parse(parts[1]),
          );
        }
      } else {
        parsedTime = DateTime.now();
      }
    } catch (e) {
      parsedTime = DateTime.now();
    }

    return Chat(
      message: json['message'] ?? '',
      sender: json['sender'] ?? 'bot',
      timestamp: parsedTime,
    );
  }
}
