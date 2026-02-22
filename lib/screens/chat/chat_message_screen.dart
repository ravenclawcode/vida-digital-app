import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindfullshelter/providers/auth_provider.dart';
import 'package:mindfullshelter/providers/private_chat_provider.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/custom_button6.dart';
import 'package:mindfullshelter/utils/custom_button7.dart';
import 'package:mindfullshelter/utils/custom_dialog_delete_chat_message.dart';
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
  bool isOnline = false;
  bool _isInitializing = true;
  String? receiverId;
  String? receiverName;
  String? lastSeenDisplay;
  String? profilePhotoUrl;
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
      receiverId = args['id']?.toString();
      receiverName = args['username'];
      profilePhotoUrl = args['profile_photo_url'];
      isOnline = args['is_online'] == true || args['is_online'] == 1;
      lastSeenDisplay = args['last_seen_display'];

      Future.microtask(() async {
        setState(() => _isInitializing = true);
        _chatProvider.clearMessages();

        if (receiverId != null) {
          await _chatProvider.updateStatus(true);
          await _chatProvider.loadMessages(receiverId!);
          _chatProvider.startPolling(receiverId!);
          _scrollToBottom();
        }

        if (mounted) {
          setState(() => _isInitializing = false);
        }
      });
    }
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

  void _showDeleteOptions(dynamic msg) {
    final otherId = receiverId ?? '';
    bool isMe = msg.senderId.toString() != receiverId.toString();
    bool isDeleted = msg.isDeletedEveryone ?? false;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 8),
            Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 25),
            if (!isDeleted)
              ListTile(
                visualDensity: VisualDensity(vertical: -2),
                leading: Image.asset(icCopyText, height: 22),
                title: Text('Salin Pesan', style: AppTextStyles.optionChat),
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  Clipboard.setData(ClipboardData(text: msg.message));
                  Navigator.pop(context);
                },
              ),
            ListTile(
              visualDensity: VisualDensity(vertical: -2),
              leading: Image.asset(
                icDelete,
                height: 22,
                color: AppColors.textPrimary,
              ),
              title: Text('Hapus untuk saya', style: AppTextStyles.optionChat),
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onTap: () {
                Navigator.pop(context);
                _chatProvider.deleteSingleMessage(
                  messageId: msg.id.toString(),
                  type: 'me',
                  otherUserId: otherId,
                );
              },
            ),
            if (isMe && !isDeleted)
              ListTile(
                visualDensity: VisualDensity(vertical: -2),
                leading: Image.asset(icDelete, height: 22),
                title: Text(
                  'Hapus untuk semua',
                  style: AppTextStyles.optionChat.copyWith(
                    color: Color(0xFFEA4335),
                  ),
                ),
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  Navigator.pop(context);
                  _chatProvider.deleteSingleMessage(
                    messageId: msg.id.toString(),
                    type: 'everyone',
                    otherUserId: otherId,
                  );
                },
              ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || receiverId == null) return;

    _messageController.clear();
    _chatProvider.stopPolling();

    try {
      await _chatProvider.sendPrivateMessage(receiverId!, text);
      _scrollToBottom();
    } catch (e) {
      debugPrint("Gagal mengirim: $e");
    } finally {
      if (mounted) _chatProvider.startPolling(receiverId!);
    }
  }

  void _deleteChat() async {
    if (receiverId == null) return;
    showDialog(
      context: context,
      builder: (_) => CustomDialogDeleteChatMessage(receiverId: receiverId!),
    );
  }

  Widget _buildPatientProfileImage(String? photoPath, String username) {
    if (photoPath != null && photoPath.isNotEmpty) {
      if (photoPath.startsWith('assets/')) {
        return Image.asset(photoPath, fit: BoxFit.cover);
      }
      if (photoPath.startsWith('http')) {
        return Image.network(photoPath, fit: BoxFit.cover);
      }
    }
    return Center(
      child: Text(
        username.isNotEmpty ? username[0].toUpperCase() : '?',
        style: AppTextStyles.profileChat,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authUser = context.watch<AuthProvider>().currentUser;
    final bool isCounselor = authUser?.roleId == 2;

    return PopScope(
      child: Consumer<PrivateChatProvider>(
        builder: (context, privateChat, child) {
          if (_isInitializing) {
            return Scaffold(
              backgroundColor: AppColors.background,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Mohon tunggu...', style: AppTextStyles.textLoading),
                  ],
                ),
              ),
            );
          }

          return Scaffold(
            backgroundColor: AppColors.background,
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  _buildHeader(
                    context: context,
                    icon: icBackLeft2,
                    onTap: () {
                      if (isCounselor) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/',
                          (route) => false,
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  const SizedBox(height: 4),
                  const Divider(color: Color(0xFFE9E9E9), thickness: 0.5),
                  Expanded(child: _buildMessagesList()),
                  _buildMessageInput(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader({
    required BuildContext context,
    required String icon,
    required VoidCallback onTap,
  }) {
    return Consumer<PrivateChatProvider>(
      builder: (context, provider, child) {
        final contact = provider.getContactStatus(receiverId ?? '');

        bool currentOnline = contact != null
            ? (contact['is_online'] == true || contact['is_online'] == 1)
            : isOnline;

        String statusText = currentOnline
            ? 'Online'
            : (contact?['last_seen_display'] ?? lastSeenDisplay ?? 'Offline');

        bool canDelete = provider.messages.isNotEmpty;

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
                child: ClipOval(
                  child: _buildPatientProfileImage(
                    profilePhotoUrl,
                    receiverName ?? '',
                  ),
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
              InkWell(
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                onTap: canDelete ? _deleteChat : null,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                  child: Image.asset(
                    canDelete ? icDeleteActive : icDeleteNoactive,
                    key: ValueKey<bool>(canDelete),
                    height: 20,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessagesList() {
    return Consumer<PrivateChatProvider>(
      builder: (context, privateChat, _) {
        final messages = privateChat.messages;

        if (privateChat.isLoading && messages.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Memuat pesan...', style: AppTextStyles.textLoading),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            if (receiverId != null) {
              await privateChat.loadMessages(receiverId!, isSilent: true);
            }
          },
          child: ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final msg = messages[index];
              bool isMe = msg.senderId.toString() != receiverId.toString();
              return _buildChatBubble(msg, isMe, key: ValueKey(msg.id));
            },
          ),
        );
      },
    );
  }

  Widget _buildChatBubble(dynamic msg, bool isMe, {Key? key}) {
    bool isDeleted = msg.isDeletedEveryone ?? false;

    return GestureDetector(
      onLongPress: () => _showDeleteOptions(msg),
      child: Align(
        key: key,
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.only(bottom: 15),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: isDeleted
                ? Color(0xFFF5F5F5)
                : (isMe ? AppColors.primary : Color(0xFFF5F5F5)),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
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
                isDeleted
                    ? (isMe
                          ? "Anda menghapus pesan ini"
                          : "Pesan ini telah dihapus")
                    : msg.message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDeleted
                      ? AppColors.textLight
                      : (isMe ? AppColors.textWhite : AppColors.textPrimary),
                  fontStyle: isDeleted ? FontStyle.italic : FontStyle.normal,
                ),
              ),
              SizedBox(height: 4),
              Text(
                DateFormat('HH:mm').format(msg.timestamp),
                style: AppTextStyles.bodyMediumChatbot.copyWith(
                  color: isDeleted
                      ? AppColors.textLight
                      : (isMe ? AppColors.textWhite : AppColors.textLight),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              onSubmitted: (_) => _sendMessage(),
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
}
