import 'dart:async';
import 'package:flutter/material.dart';
import '../models/private_chat_model.dart';
import '../services/private_chat_service.dart';

class PrivateChatProvider with ChangeNotifier {
  final PrivateChatService _service = PrivateChatService();

  List<dynamic> _contacts = [];
  List<PrivateChat> _messages = [];
  bool _isLoading = false;
  Timer? _timer;

  List<dynamic> get contacts => _contacts;
  List<PrivateChat> get messages => _messages;
  bool get isLoading => _isLoading;

  Future<void> loadContacts() async {
    _contacts = await _service.fetchContacts();
    notifyListeners();
  }

  Future<void> loadMessages(String otherUserId) async {
    final data = await _service.fetchMessages(otherUserId);
    _messages = data.map((json) => PrivateChat.fromJson(json)).toList();
    notifyListeners();
  }

  Future<void> sendPrivateMessage(String receiverId, String text) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _service.sendMessage(receiverId, text);

      if (result != null) {
        final newMessage = PrivateChat.fromJson(result);
        _messages.add(newMessage);
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteMessages(String otherUserId) async {
    try {
      final success = await _service.deleteChat(otherUserId);
      if (success) {
        _messages.clear();
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  void startPolling(String otherUserId) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      loadMessages(otherUserId);
    });
  }

  void stopPolling() {
    _timer?.cancel();
  }
}
