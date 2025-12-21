import 'package:flutter/material.dart';
import 'package:mindfullshelter/provider/education_provider.dart';
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
  List<String> paragraphs = article.description.split('\n');
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 25),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(icTime, height: 12),
            SizedBox(width: 6),
            Text(
              '${article.durationFormatted} menit',
              style: AppTextStyles.durationDescVideo,
            ),
            SizedBox(width: 8),
            Text('•', style: AppTextStyles.durationDescVideo),
            SizedBox(width: 8),
            Text(article.formattedTime, style: AppTextStyles.durationDescVideo),
          ],
        ),
        SizedBox(height: 8),
        Text(
          article.title,
          style: AppTextStyles.durationDescVideo.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12),
        ...paragraphs.take(3).map((text) => _buildParagraph(text)),

        if (article.importantNote != null)
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
                  child: Expanded(
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
    return Center(child: Text('Tidak ada article terkait lainnya'));
  }
  return ListView.builder(
    padding: EdgeInsets.all(0),
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: relatedArticles.length,
    itemBuilder: (context, index) {
      final item = relatedArticles[index];

      return InkWell(
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                ],
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
                  Text(
                    '${item.durationFormatted} menit',
                    style: AppTextStyles.durationDescVideo,
                  ),
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
