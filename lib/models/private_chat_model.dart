class PrivateChat {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  bool isDeletedEveryone;
  final bool deletedBySender;
  final bool deletedByReceiver;
  final DateTime timestamp;

  PrivateChat({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    this.isDeletedEveryone = false,
    required this.deletedBySender,
    required this.deletedByReceiver,
    required this.timestamp,
  });

  bool isMe(String currentUserId) => senderId == currentUserId;

  factory PrivateChat.fromJson(Map<String, dynamic> json) {
    return PrivateChat(
      id: json['id']?.toString() ?? '',
      senderId: json['sender_id']?.toString() ?? '',
      receiverId: json['receiver_id']?.toString() ?? '',
      message: json['message'] ?? '',
      isDeletedEveryone:
          json['is_deleted_everyone'] == 1 ||
          json['is_deleted_everyone'] == true,
      deletedBySender:
          json['deleted_by_sender'] == 1 || json['deleted_by_sender'] == true,
      deletedByReceiver:
          json['deleted_by_receiver'] == 1 ||
          json['deleted_by_receiver'] == true,
      timestamp: DateTime.parse(json['created_at']).toLocal(),
    );
  }
}
