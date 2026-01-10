import 'package:flutter/material.dart';
import 'package:mindfullshelter/models/education_model.dart';
import 'package:mindfullshelter/providers/education_provider.dart';
import 'package:mindfullshelter/routes/routes.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:provider/provider.dart';

class Video extends StatelessWidget {
  const Video({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [Expanded(child: buildVideoList(context))]),
    );
  }
}

Widget buildVideoList(BuildContext context) {
  return Consumer<EducationProvider>(
    builder: (_, provider, __) {
      if (provider.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      final videos = provider.videos;

      if (videos.isEmpty) {
        return const Center(child: Text('Belum ada video tersedia'));
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        itemCount: videos.length,
        itemBuilder: (_, index) {
          return buildVideoCard(context, videos[index]);
        },
      );
    },
  );
}

Widget buildVideoCard(BuildContext context, EducationContent video) {
  return InkWell(
    focusColor: Colors.transparent,
    hoverColor: Colors.transparent,
    highlightColor: Colors.transparent,
    overlayColor: WidgetStateProperty.all(Colors.transparent),
    onTap: () =>
        Navigator.pushNamed(context, Routes.detailVideo, arguments: video.id),
    child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            offset: const Offset(3, 3),
            blurRadius: 10,
            spreadRadius: 1,
            color: AppColors.shadow.withValues(alpha: 0.10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: video.thumbnail != null
                                ? Image.network(
                                    video.thumbnail!,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              color: Colors.grey[300],
                                              child: const Icon(
                                                Icons.broken_image,
                                              ),
                                            ),
                                  )
                                : Container(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE43371).withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    video.category,
                    style: AppTextStyles.categoryVideo,
                  ),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.textPrimary.withValues(alpha: 0.75),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(17, 13, 13, 13),
                      child: Image.asset(icPlay),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.textPrimary.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    video.duration,
                    style: AppTextStyles.durationVideo,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title,
                  style: AppTextStyles.titleVideo,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Image.asset(icTime, height: 12),
                    const SizedBox(width: 6),
                    Text(
                      video.duration,
                      style: AppTextStyles.durationDescVideo,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
