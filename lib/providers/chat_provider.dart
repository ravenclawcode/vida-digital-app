import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import '../services/chat_service.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _service = ChatService();
  List<Chat> _messages = [];
  bool _isLoading = false;

  List<Chat> get messages => _messages;
  bool get isLoading => _isLoading;

  bool _isBotTyping = false;
  bool get isBotTyping => _isBotTyping;

  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners();
    try {
      _messages = await _service.fetchHistory();

      if (_messages.isEmpty) {
        _messages.add(
          Chat(
            message: "Halo! Aku Teman Hati. Ada yang bisa aku bantu hari ini?",
            sender: 'bot',
            timestamp: DateTime.now(),
          ),
        );
      }
    } catch (_) {
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

    _isBotTyping = true;
    notifyListeners();

    try {
      final botReply = await _service.sendMessage(text);
      _messages.add(botReply);
    } catch (e) {
      _messages.add(
        Chat(message: "Error: $e", sender: 'bot', timestamp: DateTime.now()),
      );
    } finally {
      _isBotTyping = false;
      notifyListeners();
    }
  }

  Future<void> deleteAllChat() async {
    try {
      await _service.deleteAllChat();
      _messages.clear();
      _messages.add(
        Chat(
          message: "Halo! Aku Teman Hati. Ada yang bisa aku bantu hari ini?",
          sender: 'bot',
          timestamp: DateTime.now(),
        ),
      );
      notifyListeners();
    } catch (_) {
    }
  }
}
