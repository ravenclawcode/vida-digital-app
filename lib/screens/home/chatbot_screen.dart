import 'package:flutter/material.dart';
import 'package:mindfullshelter/providers/chat_provider.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/custom_button6.dart';
import 'package:mindfullshelter/utils/custom_button7.dart';
import 'package:mindfullshelter/utils/custom_dialog_delete_chatbot.dart';
import 'package:mindfullshelter/utils/custom_typing_indicator.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_theme.dart';
import '../../models/chat_model.dart';
import 'package:intl/intl.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<ChatProvider>().loadHistory();
      _scrollToBottom();
    });
    _messageController.addListener(() {
      setState(() => _hasText = _messageController.text.trim().isNotEmpty);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();

    Future.delayed(const Duration(milliseconds: 50), () => _scrollToBottom());

    context.read<ChatProvider>().sendChat(text).then((_) {
      Future.delayed(
        const Duration(milliseconds: 100),
        () => _scrollToBottom(),
      );
    });
  }

  void _deleteChat() async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const CustomDialogDeleteChatbot(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 12),
            _buildHeader(
              context: context,
              icon: icBackLeft2,
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: 15),
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
    final bool canDelete = context.watch<ChatProvider>().messages.length > 1;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
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
          SizedBox(width: 25),
          Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text('🤖', style: TextStyle(fontSize: 16)),
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Teman Hati', style: AppTextStyles.heading),
                  Text('Online', style: AppTextStyles.bodyMediumChatbot),
                ],
              ),
            ],
          ),
          Spacer(),
          InkWell(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            onTap: canDelete ? _deleteChat : null,
            child: Image.asset(
              canDelete ? icDeleteActive : icDeleteNoactive,
              height: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xFFF1FFFE),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFF57D1C9)),
      ),
      child: Row(
        children: [
          Text('💡', style: TextStyle(fontSize: 32)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Aku di sini untuk mendengarkan dan membantumu merasa lebih baik',
              style: AppTextStyles.bodyLargeChatbot,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, _) {
        final messages = chatProvider.messages;
        final int typingOffset = chatProvider.isBotTyping ? 1 : 0;

        return ListView.builder(
          controller: _scrollController,
          itemCount: messages.length + 1 + typingOffset,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: _buildWelcomeCard(),
              );
            }

            if (chatProvider.isBotTyping && index == messages.length + 1) {
              return _buildTypingIndicator();
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: _buildMessageBubble(messages[index - 1]),
            );
          },
        );
      },
    );
  }

  Widget _buildMessageBubble(Chat message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: message.isUser ? AppColors.primary : AppColors.borderTabbar,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(message.isUser ? 15 : 2.5),
            bottomRight: Radius.circular(message.isUser ? 2.5 : 15),
          ),
        ),
        child: Column(
          crossAxisAlignment: message.isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: message.isUser ? Colors.white : AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 2),
            Text(
              DateFormat('HH:mm').format(message.timestamp),
              style: AppTextStyles.bodyMediumChatbot.copyWith(
                color: message.isUser
                    ? AppColors.textWhite
                    : AppColors.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, -5),
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
            ),
          ),
          SizedBox(width: 12),
          _hasText
              ? CustomButton6(onTap: _sendMessage, icon: icSendMessage)
              : CustomButton7(icon: icSendMessage),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return const CustomTypingIndicator();
  }
}
