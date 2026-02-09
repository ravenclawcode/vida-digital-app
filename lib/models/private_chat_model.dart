class PrivateChat {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;

  PrivateChat({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  bool isMe(String currentUserId) => senderId == currentUserId;

  factory PrivateChat.fromJson(Map<String, dynamic> json) {
    return PrivateChat(
      id: json['id']?.toString() ?? '',
      senderId: json['sender_id']?.toString() ?? '',
      receiverId: json['receiver_id']?.toString() ?? '',
      message: json['message'] ?? '',
      timestamp: DateTime.parse(json['created_at']).toLocal(),
    );
  }
}
