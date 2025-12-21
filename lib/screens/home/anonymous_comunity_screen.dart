import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mindfullshelter/provider/anonymouse_provider.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/custom_button10.dart';
import 'package:mindfullshelter/utils/custom_button8.dart';
import 'package:mindfullshelter/utils/custom_button9.dart';
import 'package:mindfullshelter/utils/custom_post_dialog.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_theme.dart';
import '../../models/anonymous.dart';

class AnonymousComunityScreen extends StatefulWidget {
  const AnonymousComunityScreen({super.key});

  @override
  State<AnonymousComunityScreen> createState() =>
      _AnonymousComunityScreenState();
}

class _AnonymousComunityScreenState extends State<AnonymousComunityScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _hasText = false;
  int? expandedPostIndex;

  @override
  void initState() {
    super.initState();
    _commentController.addListener(() {
      final hasText = _commentController.text.trim().isNotEmpty;
      if (hasText != _hasText) {
        setState(() => _hasText = hasText);
      }
    });
  }

  void _openCreatePostDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => CustomPostDialog(),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 12),
            _buildHeader(),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: CustomButton8(
                        onTap: _openCreatePostDialog,
                        icon: icComment,
                        label: 'Buat Postingan Anonim',
                      ),
                    ),
                    SizedBox(height: 15),
                    Consumer<AnonymousProvider>(
                      builder: (context, provider, child) {
                        return _buildPostsList(provider.posts);
                      },
                    ),
                    SizedBox(height: 3),
                    _buildComunityGuideline(),
                    SizedBox(height: 15),
                  ],
                ),
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
    if (posts.isEmpty) {
      return Center(
        child: Text('Belum ada postingan.', style: AppTextStyles.namePost),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 25),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        final isExpanded = expandedPostIndex == index;

        return _buildPostCard(post, isExpanded: isExpanded, index: index);
      },
    );
  }

  Widget _buildPostCard(
    AnonymousPost post, {
    required bool isExpanded,
    required int index,
  }) {
    final provider = context.read<AnonymousProvider>();
    final comments = provider.getCommentsForPost(post.id);

    return Container(
      margin: EdgeInsets.only(bottom: 15),
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

          if (isExpanded) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 6),
                ...comments
                    .map(
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
                    )
                    .toList(),

                if (comments.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: Text(
                        'Belum ada komentar.',
                        style: AppTextStyles.commentDatePost,
                      ),
                    ),
                  ),

                SizedBox(height: 10),
                _buildCommentInputField(post.id),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPostHeader(AnonymousPost post) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.accentLight,
            shape: BoxShape.circle,
          ),
          child: Image.asset(icAnonymousProfile, height: 14),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Anonim', style: AppTextStyles.namePost),
              Text(post.formattedTime, style: AppTextStyles.datePost),
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
        SizedBox(width: 8),
        Icon(Icons.more_vert, size: 20),
      ],
    );
  }

  Widget _buildActionButtons(AnonymousPost post, int index) {
    return Row(
      children: [
        SizedBox(width: 18),
        _actionButton(
          Image.asset(post.isLiked ? icLikes : icUnLikes, height: 11.5),
          '${post.likes}',
          onTap: () => context.read<AnonymousProvider>().toggleLike(post.id),
        ),
        SizedBox(width: 25),
        _actionButton(
          Image.asset(icComment, height: 11.5),
          '${post.commentsCount}',
          onTap: () => setState(() {
            expandedPostIndex = (expandedPostIndex == index) ? null : index;
          }),
        ),
      ],
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
                contentPadding: EdgeInsets.symmetric(
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
        SizedBox(width: 8),
        _hasText
            ? CustomButton9(
                onTap: () {
                  context.read<AnonymousProvider>().addComment(
                    postId,
                    _commentController.text,
                  );
                  _commentController.clear();
                  FocusScope.of(context).unfocus();
                },
                icon: icSendMessage,
              )
            : CustomButton10(icon: icSendMessage),
      ],
    );
  }

  Widget _inlineComment(AnonymousComment comment) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.accentLight,
            shape: BoxShape.circle,
          ),
          child: Image.asset(icAnonymousProfile, height: 12),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Anonim', style: AppTextStyles.commentNamePost),
                  SizedBox(width: 5),
                  Text(
                    comment.formattedTime,
                    style: AppTextStyles.commentDatePost,
                  ),
                ],
              ),
              Text(comment.content, style: AppTextStyles.commentDescPost),
            ],
          ),
        ),
      ],
    );
  }

  Widget _actionButton(Widget icon, String label, {VoidCallback? onTap}) {
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      child: Row(
        children: [
          icon,
          SizedBox(width: 4),
          Text(label, style: AppTextStyles.actionPost),
        ],
      ),
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
                '• Bersikap baik dan saling mendukung\n• Hormati privasi dan anonimitas\n• Dilarang bullying, pelecehan, dan ujaran kebencian\n• Jika dalam krisis, segera cari bantuan\n• Laporkan konten yang mencurigakan',
                style: AppTextStyles.descGuidline.copyWith(height: 1.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
