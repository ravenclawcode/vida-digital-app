import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mindfullshelter/services/private_chat_service.dart';
import '../models/private_chat_model.dart';

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

  Future<void> loadMessages(String otherUserId, {bool isSilent = false}) async {
    if (!isSilent) {
      _isLoading = true;
      notifyListeners();
    }

    try {
      final data = await _service.fetchMessages(otherUserId);
      List<PrivateChat> serverMessages = data
          .map((json) => PrivateChat.fromJson(json))
          .toList();

      _messages = serverMessages;

      _contacts = await _service.fetchContacts();
    } catch (e) {
      debugPrint("Error loadMessages: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendPrivateMessage(String receiverId, String text) async {
    try {
      final result = await _service.sendMessage(receiverId, text);
      if (result != null) {
        final newMessage = PrivateChat.fromJson(result);
        if (!_messages.any((m) => m.id == newMessage.id)) {
          _messages.add(newMessage);
        }
        await loadContacts();
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateStatus(bool isOnline) async {
    await _service.updateOnlineStatus(isOnline);
  }

  Future<void> deleteMessages(String otherUserId) async {
    try {
      final success = await _service.deleteChat(otherUserId);

      if (success) {
        _messages.clear();

        notifyListeners();

        await loadContacts();
      }
    } catch (e) {
      debugPrint("Error Clear Chat: $e");
      rethrow;
    }
  }

  Future<void> deleteSingleMessage({
    required String messageId,
    required String type,
    required String otherUserId,
  }) async {
    try {
      if (type == 'everyone') {
        int index = _messages.indexWhere((m) => m.id == messageId);
        if (index != -1) {
          _messages[index].isDeletedEveryone = true;
          notifyListeners();
        }
      } else {
        _messages.removeWhere((m) => m.id == messageId);
        notifyListeners();
      }

      final response = await _service.deleteMessage(messageId, type);

      if (response['success'] == true) {
        await Future.delayed(const Duration(seconds: 1));
        await loadMessages(otherUserId, isSilent: true);
      }
    } catch (e) {
      debugPrint("Error Delete: $e");
    }
  }

  void startPolling(String otherUserId) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      await loadMessages(otherUserId, isSilent: true);
    });
  }

  void stopPolling() {
    _timer?.cancel();
  }

  Map<String, dynamic>? getContactStatus(String userId) {
    try {
      return contacts.firstWhere(
        (c) => c['id'].toString() == userId.toString(),
      );
    } catch (_) {
      return null;
    }
  }

  void startGlobalContactsPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      loadContacts();
    });
  }

  void clearMessages() {
    _messages = [];
    notifyListeners();
  }
}
