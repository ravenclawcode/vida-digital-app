import 'package:flutter/material.dart';
import 'package:mindfullshelter/providers/private_chat_provider.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/custom_button6.dart';
import 'package:mindfullshelter/utils/custom_button7.dart';
import 'package:mindfullshelter/utils/custom_dialog_delete_chat_message.dart';
import 'package:mindfullshelter/utils/custom_typing_indicator.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_theme.dart';
import 'package:intl/intl.dart';

class ChatMessageScreen extends StatefulWidget {
  const ChatMessageScreen({super.key});

  @override
  State<ChatMessageScreen> createState() => _ChatMessageScreenState();
}

class _ChatMessageScreenState extends State<ChatMessageScreen>
    with WidgetsBindingObserver {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _hasText = false;

  String? receiverId;
  String? receiverName;
  String? lastSeenDisplay;
  bool isOnline = false;

  late PrivateChatProvider _chatProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _messageController.addListener(() {
      if (mounted) {
        setState(() => _hasText = _messageController.text.trim().isNotEmpty);
      }
    });
    _messageController.addListener(() {
      if (mounted) {
        setState(() => _hasText = _messageController.text.trim().isNotEmpty);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (receiverId == null) return;

    if (state == AppLifecycleState.resumed) {
      _chatProvider.updateStatus(true);
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _chatProvider.updateStatus(false);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _chatProvider = Provider.of<PrivateChatProvider>(context, listen: false);

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null && receiverId == null) {
      setState(() {
        receiverId = args['id'];
        receiverName = args['username'];
        isOnline = args['is_online'] ?? false;
        lastSeenDisplay = args['last_seen_display'];
      });

      if (receiverId != null) {
        Future.microtask(() async {
          await _chatProvider.updateStatus(true);
          await _chatProvider.loadMessages(receiverId!);
          _chatProvider.startPolling(receiverId!);
          _scrollToBottom();
        });
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || receiverId == null) return;

    _messageController.clear();

    try {
      await _chatProvider.sendPrivateMessage(receiverId!, text);
      await _chatProvider.loadContacts();
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal mengirim: $e")));
      }
    }
  }

  void _deleteChat() async {
    if (receiverId == null) return;

    showDialog(
      context: context,
      builder: (_) => CustomDialogDeleteChatMessage(receiverId: receiverId!),
    );
  }

  @override
  void dispose() {
    _chatProvider.updateStatus(false);
    WidgetsBinding.instance.removeObserver(this);

    _messageController.dispose();
    _scrollController.dispose();
    _chatProvider.stopPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 11),
            _buildHeader(
              context: context,
              icon: icBackLeft2,
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 4),
            const Divider(color: Color(0xFFE9E9E9), thickness: 0.5),
            Expanded(child: _buildMessagesList()),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader({
    required BuildContext context,
    required String icon,
    required VoidCallback onTap,
  }) {
    final contactIndex = _chatProvider.contacts.indexWhere(
      (c) => c['id'].toString() == receiverId,
    );

    bool currentOnline;
    String statusText;

    if (contactIndex != -1) {
      final contact = _chatProvider.contacts[contactIndex];
      currentOnline = contact['is_online'] == true || contact['is_online'] == 1;
      statusText = currentOnline
          ? 'Online'
          : (contact['last_seen_display'] ?? '');
    } else {
      currentOnline = isOnline;
      statusText = currentOnline ? 'Online' : (lastSeenDisplay ?? '');
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          InkWell(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            onTap: onTap,
            child: Image.asset(icon, width: 10),
          ),
          const SizedBox(width: 25),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              (receiverName != null && receiverName!.isNotEmpty)
                  ? receiverName![0].toUpperCase()
                  : '?',
              style: AppTextStyles.profileChat,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(receiverName ?? 'User', style: AppTextStyles.heading),
              Text(
                statusText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: currentOnline
                      ? const Color(0xFF66BB6A)
                      : const Color(0xFFA8A8A8),
                ),
              ),
            ],
          ),
          const Spacer(),
          Consumer<PrivateChatProvider>(
            builder: (context, provider, _) {
              bool canDelete = provider.messages.isNotEmpty;
              return InkWell(
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                onTap: canDelete ? _deleteChat : null,
                child: Image.asset(
                  canDelete ? icDeleteActive : icDeleteNoactive,
                  height: 20,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return Consumer<PrivateChatProvider>(
      builder: (context, privateChat, _) {
        final messages = privateChat.messages;
        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          itemCount: messages.length + (privateChat.isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == messages.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: CustomTypingIndicator(),
              );
            }

            final msg = messages[index];
            bool isMe = msg.senderId != receiverId;
            return _buildChatBubble(msg.message, msg.timestamp, isMe);
          },
        );
      },
    );
  }

  Widget _buildChatBubble(String text, DateTime time, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : AppColors.borderTabbar,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: Radius.circular(isMe ? 15 : 2.5),
            bottomRight: Radius.circular(isMe ? 2.5 : 15),
          ),
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isMe ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('HH:mm').format(time),
              style: AppTextStyles.bodyMediumChatbot.copyWith(
                color: isMe ? Colors.white70 : AppColors.textLight,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              style: AppTextStyles.bodyChatbot.copyWith(
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Tuliskan pesan Anda...',
                filled: true,
                fillColor: AppColors.backgroundList,
                hintStyle: AppTextStyles.bodyChatbot,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 12),
          _hasText
              ? CustomButton6(onTap: _sendMessage, icon: icSendMessage)
              : CustomButton7(icon: icSendMessage),
        ],
      ),
    );
  }
}
