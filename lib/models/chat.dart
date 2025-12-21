class Chat {
  final String id;
  final String message;
  final bool isUser;
  final DateTime timestamp;

  Chat({
    required this.id,
    required this.message,
    required this.isUser,
    required this.timestamp,
  });
}
