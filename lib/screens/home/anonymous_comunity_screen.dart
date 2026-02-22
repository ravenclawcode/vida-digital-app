import 'package:flutter/material.dart';
import 'package:mindfullshelter/providers/anonymouse_provider.dart';
import 'package:mindfullshelter/utils/custom_dialog_delete_post.dart';
import 'package:mindfullshelter/utils/custom_search_form_community.dart';
import 'package:mindfullshelter/utils/session_manager.dart';
import 'package:provider/provider.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/custom_button10.dart';
import 'package:mindfullshelter/utils/custom_button8.dart';
import 'package:mindfullshelter/utils/custom_button9.dart';
import 'package:mindfullshelter/utils/custom_post_dialog.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_theme.dart';
import '../../models/anonymous_model.dart';

class AnonymousComunityScreen extends StatefulWidget {
  const AnonymousComunityScreen({super.key});

  @override
  State<AnonymousComunityScreen> createState() =>
      _AnonymousComunityScreenState();
}

class _AnonymousComunityScreenState extends State<AnonymousComunityScreen> {
  final GlobalKey _menuKey = GlobalKey();
  final TextEditingController _commentController = TextEditingController();
  final searchController = TextEditingController();
  bool _hasText = false;
  int? expandedPostIndex;
  int? role;
  OverlayEntry? overlayEntry;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadRole();
    Future.microtask(() => context.read<AnonymousProvider>().loadPosts());
    _commentController.addListener(() {
      final hasText = _commentController.text.trim().isNotEmpty;
      if (hasText != _hasText) {
        setState(() => _hasText = hasText);
      }
    });
  }

  void _loadRole() async {
    final sessionRole = await SessionManager().getRole();
    setState(() {
      role = sessionRole;
    });
  }

  void _openCreatePostDialog() {
    showDialog(context: context, builder: (_) => CustomPostDialog()).then((_) {
      setState(() {
        expandedPostIndex = null;
      });
    });
  }

  void _deleteChat(AnonymousPost post) async {
    showDialog(
      context: context,
      builder: (_) => CustomDialogDeletePost(post.id, postId: post.id),
    ).then((confirmed) {
      if (confirmed == true) {
        setState(() {
          expandedPostIndex = null;
        });
      }
    });
  }

  bool _isForbidden(String text) {
    final cleanText = text.replaceAll(RegExp(r'[\s\-\.]'), '');
    final phoneRegex = RegExp(r'(?:\+62|62|0)8[1-9][0-9]{6,10}');

    final forbiddenWords = ['wa', 'whatsapp', 'nomer', 'kontak', 'hubungi'];

    if (phoneRegex.hasMatch(cleanText)) return true;

    for (var word in forbiddenWords) {
      if (text.toLowerCase().contains(word)) return true;
    }
    return false;
  }

  Widget _buildPostHeader(AnonymousPost post) {
    final String displayName = (role != 1 || post.isMine)
        ? post.authorName
        : 'Anonim';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAvatar(displayName, post.authorPhoto, post.isMine || role != 1),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(displayName, style: AppTextStyles.namePost),
              Text(post.timeAgo, style: AppTextStyles.datePost),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.accentLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(post.categoryLabel, style: AppTextStyles.categoryPost),
        ),
        if (role != 1) SizedBox(width: 14) else SizedBox(width: 8),
        if (role != 1)
          InkWell(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            onTap: () => _deleteChat(post),
            child: Image.asset(icDelete1, height: 18),
          )
        else
          Builder(
            builder: (context) {
              return InkWell(
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                onTap: () {
                  final renderBox = context.findRenderObject() as RenderBox;
                  final position = renderBox.localToGlobal(Offset.zero);
                  _showPostMenuAtPosition(position, post);
                },
                child: Icon(Icons.more_vert, size: 20),
              );
            },
          ),
      ],
    );
  }

  Widget _buildAvatar(
    String name,
    String? photoUrl,
    bool showRealPhoto, {
    double size = 34,
  }) {
    if (showRealPhoto && photoUrl != null && photoUrl.isNotEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: ClipOval(
          child: photoUrl.contains('assets/')
              ? Image.asset(photoUrl, fit: BoxFit.cover)
              : Image.network(
                  photoUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildInitialAvatar(name, size),
                ),
        ),
      );
    }
    return _buildInitialAvatar(showRealPhoto ? name : 'Anonim', size);
  }

  Widget _buildInitialAvatar(String name, double size) {
    String initial = name.isNotEmpty ? name[0].toUpperCase() : 'A';
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
        style: AppTextStyles.profileChat.copyWith(fontSize: size * 0.45),
      ),
    );
  }

  void _showPostMenuAtPosition(Offset position, AnonymousPost post) {
    overlayEntry?.remove();

    const double menuWidth = 120.0;
    const double menuHeight = 40.0;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double left = position.dx;
    if (position.dx + menuWidth > screenWidth - 45) {
      left = screenWidth - menuWidth - 45;
    }

    double top = position.dy + 28;
    if (top + menuHeight > screenHeight - 8) {
      top = screenHeight - menuHeight - 8;
    }

    overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                overlayEntry?.remove();
                overlayEntry = null;
              },
            ),
          ),
          Positioned(
            left: left,
            top: top,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: menuWidth,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: post.isMine ? Color(0xFFFFE8E6) : Color(0xFFF1F1F1),
                    width: 0.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 3),
                      blurRadius: 10,
                      spreadRadius: 1,
                      color: AppColors.shadow.withValues(alpha: 0.1),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        overlayEntry?.remove();
                        overlayEntry = null;
                        if (post.isMine) {
                          context.read<AnonymousProvider>().removePost(post.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Postingan berhasil dihapus'),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Postingan berhasil dilaporkan'),
                            ),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              post.isMine ? icDelete : icReport,
                              height: post.isMine ? 12 : 11,
                            ),
                            SizedBox(width: 8),
                            Text(
                              post.isMine ? 'Hapus' : 'Laporkan',
                              style: post.isMine
                                  ? AppTextStyles.dropMenuPost.copyWith(
                                      color: Colors.red,
                                    )
                                  : AppTextStyles.dropMenuPost,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(overlayEntry!);
  }

  @override
  void dispose() {
    searchController.dispose();
    _commentController.dispose();
    overlayEntry?.remove();
    overlayEntry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            _buildHeader(),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<AnonymousProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading && provider.posts.isEmpty) {
                    return Center(
                      child: Text(
                        'Mohon tunggu...',
                        style: AppTextStyles.textLoading,
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () => provider.loadPosts(),
                    color: AppColors.primary,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          if (role == 1)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                              ),
                              child: CustomButton8(
                                onTap: _openCreatePostDialog,
                                icon: icComment,
                                label: 'Buat Postingan Anonim',
                              ),
                            )
                          else
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: CustomSearchFormCommunity(
                                controller: searchController,
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value;
                                  });
                                },
                              ),
                            ),
                          const SizedBox(height: 20),
                          provider.posts.isEmpty
                              ? Center(
                                  child: Text(
                                    'Belum ada postingan komunitas',
                                    style: AppTextStyles.noContent,
                                  ),
                                )
                              : _buildPostsList(provider.posts),
                          const SizedBox(height: 20),
                          _buildComunityGuideline(),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
          Text('Komunitas Anonim', style: AppTextStyles.heading3Bold),
        ],
      ),
    );
  }

  Widget _buildPostsList(List<AnonymousPost> posts) {
    final filteredPosts = posts.where((post) {
      final String name = post.authorName.toLowerCase();
      final String content = post.content.toLowerCase();
      final String query = _searchQuery.toLowerCase();

      return name.contains(query) || content.contains(query);
    }).toList();

    if (filteredPosts.isEmpty) {
      return Center(
        child: Text(
          _searchQuery.isEmpty
              ? 'Postingan tidak ditemukan'
              : 'Postingan "$_searchQuery" tidak ditemukan',
          style: AppTextStyles.noContent,
        ),
      );
    }

    return ListView.builder(
      key: ValueKey('list_$_searchQuery'),
      padding: const EdgeInsets.symmetric(horizontal: 25),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredPosts.length,
      itemBuilder: (context, index) {
        final post = filteredPosts[index];
        return _buildPostCard(
          post,
          isExpanded: expandedPostIndex == index,
          index: index,
          isLast: index == filteredPosts.length - 1,
        );
      },
    );
  }

  Widget _buildPostCard(
    AnonymousPost post, {
    required bool isExpanded,
    required int index,
    required bool isLast,
  }) {
    final provider = context.read<AnonymousProvider>();
    final comments = provider.getCommentsForPost(post.id);

    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
      padding: EdgeInsets.fromLTRB(20, 20, 20, 23),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFFE9E9E9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPostHeader(post),
          SizedBox(height: 16),
          Text(post.content, style: AppTextStyles.descPost),
          SizedBox(height: 12),
          _buildActionButtons(post, index),
          SizedBox(height: 12),
          Divider(height: 0.8, color: Color(0xFFE9E9E9)),
          AnimatedSize(
            duration: Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 180),
              opacity: isExpanded ? 1 : 0,
              child: isExpanded
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 6),

                        ...comments.map(
                          (comment) => Container(
                            margin: EdgeInsets.only(top: 10),
                            padding: EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.backgroundList,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: _inlineComment(comment),
                          ),
                        ),

                        if (comments.isEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: Text(
                                'Belum ada komentar',
                                style: AppTextStyles.noContent.copyWith(
                                  fontSize: 10,
                                  color: AppColors.textLight,
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: 10),
                        if (role == 1) _buildCommentInputField(post.id),
                      ],
                    )
                  : SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(AnonymousPost post, int index) {
    return Row(
      children: [
        SizedBox(width: 18),
        _likeButton(post),
        SizedBox(width: 25),
        _commentButton(
          post.commentsCount,
          () => setState(() {
            expandedPostIndex = (expandedPostIndex == index) ? null : index;

            _commentController.clear();
            _hasText = false;
          }),
        ),
      ],
    );
  }

  Widget _likeButton(AnonymousPost post) {
    return InkWell(
      onTap: () => context.read<AnonymousProvider>().toggleLike(post.id),
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 180),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Image.asset(
              post.isLiked ? icLikes : icUnLikes,
              key: ValueKey(post.isLiked),
              height: 11.5,
            ),
          ),
          SizedBox(width: 4),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 180),
            child: Text(
              '${post.likesCount}',
              key: ValueKey(post.likesCount),
              style: AppTextStyles.actionPost,
            ),
          ),
        ],
      ),
    );
  }

  Widget _commentButton(int count, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      child: Row(
        children: [
          Image.asset(icComment, height: 11.5),
          SizedBox(width: 4),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 180),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(0, 0.25),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Text(
              '$count',
              key: ValueKey(count),
              style: AppTextStyles.actionPost,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInputField(String postId) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: SizedBox(
            height: 66,
            child: TextField(
              controller: _commentController,
              expands: true,
              maxLines: null,
              textAlignVertical: TextAlignVertical.top,
              textInputAction: TextInputAction.done,
              style: AppTextStyles.commentChat,
              decoration: InputDecoration(
                hintText: 'Tulis komentar...',
                hintStyle: AppTextStyles.commentChat.copyWith(
                  color: AppColors.textLight,
                ),
                filled: true,
                fillColor: AppColors.backgroundList,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        _hasText
            ? CustomButton9(
                onTap: () {
                  final commentText = _commentController.text.trim();

                  FocusScope.of(context).unfocus();

                  if (_isForbidden(commentText)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Gagal: Demi keamanan, dilarang membagikan kontak pribadi.',
                        ),
                      ),
                    );
                    return;
                  }

                  context.read<AnonymousProvider>().addComment(
                    postId,
                    commentText,
                  );

                  _commentController.clear();
                },
                icon: icSendMessage,
              )
            : CustomButton10(icon: icSendMessage),
      ],
    );
  }

  Widget _inlineComment(AnonymousComment comment) {
    final String displayName = comment.authorName;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAvatar(
          displayName,
          comment.authorPhoto,
          displayName != 'Anonim',
          size: 28,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(displayName, style: AppTextStyles.commentNamePost),
                  const SizedBox(width: 5),
                  Text(comment.timeAgo, style: AppTextStyles.commentDatePost),
                ],
              ),
              Text(comment.content, style: AppTextStyles.commentDescPost),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildComunityGuideline() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xFF57D1C9)),
        ),
        child: Padding(
          padding: EdgeInsetsGeometry.fromLTRB(17, 12, 17, 17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pedoman Komunitas', style: AppTextStyles.titleGuidline),
              SizedBox(height: 5),
              Text(
                '• Bersikap baik dan saling mendukung\n• Hormati privasi dan anonimitas\n• Dilarang bullying, pelecehan, dan ujaran kebencian\n• Laporkan konten yang melanggar',
                style: AppTextStyles.descGuidline.copyWith(height: 1.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
