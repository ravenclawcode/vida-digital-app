import 'package:flutter/material.dart';
import 'package:mindfullshelter/providers/education_provider.dart';
import 'package:mindfullshelter/routes/routes.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:provider/provider.dart';

class DetailArticleScreen extends StatelessWidget {
  final String articleId;
  const DetailArticleScreen({super.key, required this.articleId});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EducationProvider>(context, listen: false);
    final article = provider.articles.firstWhere((a) => a.id == articleId);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 11),
            _buildHeader(
              context: context,
              icon: icBackLeft2,
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildContentArticle(context, articleId, article),
                    SizedBox(height: 14),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        'Artikel Terkait',
                        style: AppTextStyles.titleVideo,
                      ),
                    ),
                    SizedBox(height: 12),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: _buildRelateArticle(context, articleId),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildHeader({
  required BuildContext context,
  required String icon,
  required VoidCallback onTap,
}) {
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
        Text('Artikel', style: AppTextStyles.heading3Bold),
      ],
    ),
  );
}

Widget _buildContentArticle(
  BuildContext context,
  String articleId,
  dynamic article,
) {
  List<String> paragraphs = (article.description ?? '')
      .toString()
      .split('\n')
      .map((text) => text.trim())
      .where((text) => text.isNotEmpty)
      .toList();

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 25),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(icTime, height: 12),
            SizedBox(width: 6),
            Text('${article.duration}', style: AppTextStyles.durationDescVideo),
            SizedBox(width: 8),
            Text('•', style: AppTextStyles.durationDescVideo),
            SizedBox(width: 8),
            Text(
              article.publishedAt ?? '',
              style: AppTextStyles.durationDescVideo,
            ),
            SizedBox(width: 12),
            InkWell(
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Row(
                    children: [
                      Image.asset(icShare, height: 10),
                      SizedBox(width: 6),
                      Text('bagikan', style: AppTextStyles.actionButton),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Text(
          article.title ?? '',
          style: AppTextStyles.durationDescVideo.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12),
        ...paragraphs.take(3).map((text) => _buildParagraph(text)),

        if (article.importantNote != null &&
            article.importantNote.toString().isNotEmpty)
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(0, 6, 0, 16),
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  bottom: 0,
                  child: Container(width: 3, color: AppColors.primary),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(18, 13, 15, 13),
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.durationDescVideo.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      children: [
                        TextSpan(
                          text: 'Catatan Penting: ',
                          style: AppTextStyles.durationDescVideo.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        TextSpan(text: article.importantNote),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ...paragraphs.skip(3).map((text) => _buildParagraph(text)),
      ],
    ),
  );
}

Widget _buildRelateArticle(BuildContext context, String currentArticleId) {
  final provider = Provider.of<EducationProvider>(context, listen: false);
  final relatedArticles = provider.articles
      .where((a) => a.id != currentArticleId)
      .toList();

  if (relatedArticles.isEmpty) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          'Tidak ada artikel terkait lainnya',
          style: AppTextStyles.descVideo,
        ),
      ),
    );
  }

  return ListView.builder(
    padding: EdgeInsets.zero,
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: relatedArticles.length,
    itemBuilder: (context, index) {
      final item = relatedArticles[index];

      return InkWell(
        onTap: () {
          Navigator.pushReplacementNamed(
            context,
            Routes.detailArticle,
            arguments: item.id,
          );
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.symmetric(horizontal: 13, vertical: 15),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xFFE9E9E9)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.accentLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item.category,
                  style: AppTextStyles.categoryVideo.copyWith(
                    color: AppColors.textPink,
                    fontSize: 10,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                item.title,
                style: AppTextStyles.titleVideo.copyWith(fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 3),
              Row(
                children: [
                  Image.asset(icTime, height: 11),
                  SizedBox(width: 5),
                  Text(item.duration, style: AppTextStyles.durationDescVideo),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildParagraph(String text) {
  if (text.trim().isEmpty) return SizedBox();
  return Padding(
    padding: EdgeInsets.only(bottom: 12),
    child: Text(
      text,
      style: AppTextStyles.descVideo.copyWith(
        color: AppColors.textPrimary,
        height: 1.6,
      ),
    ),
  );
}
