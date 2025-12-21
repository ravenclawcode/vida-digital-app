import 'package:flutter/material.dart';
import 'package:mindfullshelter/models/education.dart';
import 'package:mindfullshelter/provider/education_provider.dart';
import 'package:mindfullshelter/routes/routes.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:provider/provider.dart';

class Article extends StatelessWidget {
  const Article({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [Expanded(child: buildArticleList(context))]),
    );
  }
}

Widget buildArticleList(BuildContext context) {
  return Consumer<EducationProvider>(
    builder: (_, provider, __) {
      final artikels = provider.articles;

      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        itemCount: artikels.length,
        itemBuilder: (_, index) {
          return buildArticleCard(context, artikels[index]);
        },
      );
    },
  );
}

Widget buildArticleCard(BuildContext context, ArticleEdu article) {
  return InkWell(
    focusColor: Colors.transparent,
    hoverColor: Colors.transparent,
    highlightColor: Colors.transparent,
    overlayColor: WidgetStateProperty.all(Colors.transparent),
    onTap: () =>
        Navigator.pushNamed(context, Routes.detailArticle, arguments: article.id),
    child: Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 3),
            blurRadius: 10,
            color: AppColors.shadow.withValues(alpha: 0.10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.accentLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  article.category,
                  style: AppTextStyles.categoryVideo.copyWith(
                    color: AppColors.textPink,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, size: 22, color: AppColors.textPrimary),
            ],
          ),
          SizedBox(height: 10),
          Text(
            article.title,
            style: AppTextStyles.titleVideo,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 6),
          Text(
            article.description,
            style: AppTextStyles.descVideo,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Image.asset(icTime, height: 12),
              SizedBox(width: 6),
              Text(
                '${article.durationFormatted} menit',
                style: AppTextStyles.durationDescVideo,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
