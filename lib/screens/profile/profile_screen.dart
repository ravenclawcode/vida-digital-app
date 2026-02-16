import 'package:flutter/material.dart';
import 'package:mindfullshelter/providers/auth_provider.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:mindfullshelter/utils/custom_dialog_logout.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _capitalizeEachWord(String text) {
    if (text.isEmpty) return 'User';
    return text
        .split(' ')
        .map((word) {
          if (word.isEmpty) return "";
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  void _showLogoutDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const CustomDialogLogout(),
    );
  }

  Widget _buildProfileImage(AuthProvider auth) {
    final user = auth.currentUser;
    final String? photoUrl = user?.profilePhotoUrl;
    final String username = user?.username ?? 'User';

    if (auth.imageFile != null) {
      return Image.file(auth.imageFile!, fit: BoxFit.cover);
    }

    if (photoUrl != null && photoUrl.isNotEmpty) {
      if (photoUrl.startsWith('http')) {
        return Image.network(
          photoUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildDefaultAvatar(username),
        );
      }
      return Image.asset(photoUrl, fit: BoxFit.cover);
    }

    return _buildDefaultAvatar(username);
  }

  Widget _buildDefaultAvatar(String username, {double size = 88}) {
    String initial = username.isNotEmpty ? username[0].toUpperCase() : 'U';
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: AppTextStyles.profileChat.copyWith(fontSize: size * 0.4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 11),
              _buildHeader(context),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Spacer(),
              Text('Profil', style: AppTextStyles.heading3Bold),
              Spacer(),
              InkWell(
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                onTap: () => _showLogoutDialog(context),
                child: Image.asset(icLogout, height: 18),
              ),
            ],
          ),
          SizedBox(height: 35),
          Consumer<AuthProvider>(
            builder: (context, auth, child) {
              return Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColors.accentLight,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(child: _buildProfileImage(auth)),
              );
            },
          ),
          SizedBox(height: 15),
          Consumer<AuthProvider>(
            builder: (context, auth, child) {
              final user = auth.currentUser;
              final String displayUsername = _capitalizeEachWord(
                user?.username ?? 'User',
              );
              final String displayEmail = user?.email ?? 'email@example.com';

              return Column(
                children: [
                  Text(displayUsername, style: AppTextStyles.usernameProfile),
                  const SizedBox(height: 2),
                  Text(displayEmail, style: AppTextStyles.emailProfile),
                ],
              );
            },
          ),
          SizedBox(height: 10),
          InkWell(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            onTap: () => Navigator.pushNamed(context, '/editprofile'),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Color(0xFFE9E9E9)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text('Edit Profil', style: AppTextStyles.actionProfile),
            ),
          ),
          SizedBox(height: 25),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xFFE9E9E9)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: _buildOptionMenu(context),
          ),
          SizedBox(height: 18),
          Text('VIDA Digital v1.0.0', style: AppTextStyles.versionApp),
        ],
      ),
    );
  }

  Widget _buildOptionMenu(BuildContext context) {
    final menus = [
      {
        'icon': icNotification,
        'title': 'Notifikasi',
        'subtitle': 'Atur pengingat dan pemberitahuan',
        'color': AppColors.accentLight,
        'route': '/notification',
      },
      {
        'icon': icLock,
        'title': 'Privasi & Keamanan',
        'subtitle': 'Kontrol privasi dan keamana data',
        'color': AppColors.accentLight,
        'route': '/privacy&security',
      },
      {
        'icon': icFAQ,
        'title': 'Bantuan & Dukungan',
        'subtitle': 'FAQ dan hubungi tim support',
        'color': AppColors.accentLight,
        'route': '/help&support',
      },
    ];
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: menus.length,
      itemBuilder: (context, index) {
        final menu = menus[index];
        final bool isLastItem = index == menus.length - 1;
        return InkWell(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          child: Padding(
            padding: EdgeInsets.fromLTRB(5, 8, 5, isLastItem ? 7 : 0),
            child: Column(
              children: [
                Row(
                  children: [
                    // Padding(
                    //   padding: EdgeInsets.only(left: 6),
                    //   child: Container(
                    //     width: 36,
                    //     height: 36,
                    //     decoration: BoxDecoration(
                    //       color: AppColors.accentLight,
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //     child: Padding(
                    //       padding: EdgeInsets.all(9),
                    //       child: Image.asset(menu['icon'] as String),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          menu['title'] as String,
                          style: AppTextStyles.titleMenu,
                        ),
                        Text(
                          menu['subtitle'] as String,
                          style: AppTextStyles.subtitleMenu,
                        ),
                      ],
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Image.asset(icNext, height: 10),
                    ),
                  ],
                ),
                if (!isLastItem) ...[
                  SizedBox(height: 4),
                  Divider(color: Color(0xFFE9E9E9)),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
