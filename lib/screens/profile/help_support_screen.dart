import 'package:flutter/material.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              _buildHeader(context),
              SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text('Hubungi Kami', style: AppTextStyles.headingHome),
              ),
              SizedBox(height: 14),
              _buildContactMe(context),
              SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  'Pertanyaan Umum',
                  style: AppTextStyles.headingHome,
                ),
              ),
              SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: _buildFAQ(context),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          InkWell(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            onTap: () => Navigator.pop(context),
            child: Image.asset(icBackLeft2, width: 10),
          ),
          SizedBox(width: 25),
          Text('Bantuan & Dukungan', style: AppTextStyles.heading3Bold),
        ],
      ),
    );
  }

  Widget _buildContactMe(BuildContext context) {
    final features = [
      {
        'icon': icGmail,
        'title': 'Email',
        'subtitle': 'ravenclawcodeid@gmail.com',
        'onTap': () async {
          final Uri emailLaunchUri = Uri(
            scheme: 'mailto',
            path: 'ravenclawcodeid@gmail.com',
            queryParameters: {'subject': 'Bantuan & Dukungan - VIDA Digital'},
          );

          try {
            await launchUrl(emailLaunchUri);
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tidak ada aplikasi email yang terinstall.'),
                ),
              );
            }
          }
        },
      },
      {
        'icon': icInstagram,
        'title': 'Instagram',
        'subtitle': '@vidadigital.ung',
        'onTap': () async {
          final Uri url = Uri.parse(
            'https://www.instagram.com/vidadigital.ung/',
          );

          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tidak dapat membuka Instagram.')),
            );
          }
        },
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: features.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: item['onTap'] as VoidCallback,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Image.asset(item['icon'] as String),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'] as String,
                              style: AppTextStyles.titleChat.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              item['subtitle'] as String,
                              style: AppTextStyles.subtitleChat,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFAQ(BuildContext context) {
    final questions = [
      {
        'title': 'Bagaimana menjaga privasi saya di VIDA Digital?',
        'subtitle':
            'VIDA Digital menggunakan enkripsi end-to-end untuk melindungi semua data Anda. Mode anonim memastikan identitas Anda tidak terungkap dalam chat komunitas. Kami tidak pernah membagikan informasi pribadi Anda tanpa izin eksplisit',
      },
      {
        'title': 'Apakah saya bisa menghapus akun saya?',
        'subtitle':
            'Ya, Anda dapat menghapus akun melalui menu Profil > Privasi & Keamanan > Hapus Akun. Semua data Anda akan dihapus secara permanen',
      },
      {
        'title': 'Bagaimana cara melaporkan konten yang tidak pantas',
        'subtitle':
            'Jika Anda menemukan konten yang tidak pantas di komunitas anonim, tekan pilihan titik 3, lalu pilih laporkan. Tim VIDA akan meninjau laporan dalam 24 jam',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final menu = questions[index];
          final bool isExpanded = _expandedIndex == index;
          final bool isLastItem = index == questions.length - 1;

          return InkWell(
            onTap: () {
              setState(() {
                _expandedIndex = isExpanded ? null : index;
              });
            },
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 8, 15, isLastItem ? 7 : 0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          menu['title'] as String,
                          style: AppTextStyles.titleMenu,
                        ),
                      ),
                      const SizedBox(width: 10),
                      AnimatedRotation(
                        duration: const Duration(milliseconds: 300),
                        turns: isExpanded ? 0.5 : 0,
                        child: Image.asset(icBottom, height: 6),
                      ),
                    ],
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: double.infinity,
                      child: isExpanded
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 4),
                              child: Text(
                                menu['subtitle'] as String,
                                style: AppTextStyles.subtitleMenu,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                  if (!isLastItem) ...[
                    const SizedBox(height: 8),
                    const Divider(color: Color(0xFFE9E9E9), height: 1),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
