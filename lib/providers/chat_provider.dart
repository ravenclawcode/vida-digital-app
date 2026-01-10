import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import '../services/chat_service.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _service = ChatService();
  List<Chat> _messages = [];
  bool _isLoading = false;

  List<Chat> get messages => _messages;
  bool get isLoading => _isLoading;

  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners();
    try {
      _messages = await _service.fetchHistory();
    } catch (e) {
      debugPrint("Error Load History: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendChat(String text) async {
    final userMessage = Chat(
      message: text,
      sender: 'user',
      timestamp: DateTime.now(),
    );
    _messages.add(userMessage);
    notifyListeners();

    try {
      final botReply = await _service.sendMessage(text);
      _messages.add(botReply);
    } catch (e) {
      print("DEBUG ERROR: $e");
      _messages.add(
        Chat(message: "Error: $e", sender: 'bot', timestamp: DateTime.now()),
      );
    }
    notifyListeners();
  }
}
