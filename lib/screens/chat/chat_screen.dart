import 'package:flutter/material.dart';
import 'package:mindfullshelter/providers/private_chat_provider.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await context.read<PrivateChatProvider>().loadContacts();

    if (mounted) {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  Widget _buildProfileImage(String? photoPath, String username) {
    if (photoPath != null && photoPath.isNotEmpty) {
      if (photoPath.startsWith('assets/')) {
        return Image.asset(photoPath, fit: BoxFit.cover);
      }
      if (photoPath.startsWith('http')) {
        return Image.network(photoPath, fit: BoxFit.cover);
      }
    }
    return Center(
      child: Text(username[0].toUpperCase(), style: AppTextStyles.profileChat),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PrivateChatProvider>(
      builder: (context, provider, child) {
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
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),
                _buildHeader(),
                const SizedBox(height: 32),
                _buildContentTop(),
                const SizedBox(height: 30),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await provider.loadContacts();
                    },
                    child: _buildContactList(provider),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactList(PrivateChatProvider provider) {
    final List<dynamic> sortedContacts = List.from(provider.contacts);

    sortedContacts.sort((a, b) {
      String? timeAStr = a['last_message_at'];
      String? timeBStr = b['last_message_at'];

      if (timeAStr != null && timeBStr != null) {
        return DateTime.parse(timeBStr).compareTo(DateTime.parse(timeAStr));
      }
      if (timeAStr != null && timeBStr == null) return -1;
      if (timeAStr == null && timeBStr != null) return 1;
      return (a['username'] ?? '').compareTo(b['username'] ?? '');
    });

    return ListView.builder(
      itemCount: sortedContacts.length,
      padding: const EdgeInsets.only(bottom: 20),
      itemBuilder: (context, index) {
        final user = sortedContacts[index];
        return _buildCounselorCard(user);
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Center(child: Text('Chat', style: AppTextStyles.heading3Bold)),
    );
  }

  Widget _buildContentTop() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 3),
              color: const Color(0xFFFAB1C6).withOpacity(0.80),
              blurRadius: 10,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Teman Vida',
                      style: AppTextStyles.headingChat.copyWith(fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Berbagi dengan aman dan privat bersama Teman VIDA',
                      style: AppTextStyles.bodyChat,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Image.asset(icMedicalChat, height: 68),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCounselorCard(dynamic user) {
    bool isUserOnline = user['is_online'] == true || user['is_online'] == 1;

    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 15),
      child: InkWell(
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/chatmessage',
            arguments: {
              'id': user['id'].toString(),
              'username': user['username'],
              'is_online': isUserOnline,
              'last_seen_display': user['last_seen_display'],
              'profile_photo_url': user['profile_photo_url'],
            },
          ).then((_) {
            if (mounted) {
              context.read<PrivateChatProvider>().loadContacts();
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 3),
                blurRadius: 10,
                color: AppColors.shadow.withOpacity(0.10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: _buildProfileImage(
                          user['profile_photo_url'],
                          user['username'],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: isUserOnline
                              ? const Color(0xFF66BB6A)
                              : const Color(0xFFA8A8A8),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.background,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user['username'], style: AppTextStyles.titleChat),
                      Text(
                        user['last_message'] ?? 'Ketuk untuk memulai chat',
                        style: AppTextStyles.subtitleChat.copyWith(
                          fontStyle:
                              (user['last_message']?.contains('menghapus') ??
                                      false) ||
                                  (user['last_message']?.contains('dihapus') ??
                                      false)
                              ? FontStyle.italic
                              : FontStyle.normal,
                          color:
                              (user['last_message']?.contains('menghapus') ??
                                      false) ||
                                  (user['last_message']?.contains('dihapus') ??
                                      false)
                              ? AppColors.textLight
                              : AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      user['last_message_time'] ?? '',
                      style: AppTextStyles.timeChat,
                    ),
                    if (user['unread_count'] <= 0) const SizedBox(height: 20),
                    if (user['unread_count'] > 0) ...[
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: Color(0xFFEA4335),
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(
                          user['unread_count'].toString(),
                          style: AppTextStyles.unreadChat,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
