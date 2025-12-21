import 'package:flutter/material.dart';
import 'package:mindfullshelter/provider/education_provider.dart';
import 'package:mindfullshelter/routes/routes.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:provider/provider.dart';

class DetailVideoScreen extends StatelessWidget {
  final String videoId;
  const DetailVideoScreen({super.key, required this.videoId});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EducationProvider>(context, listen: false);
    final video = provider.videos.firstWhere((v) => v.id == videoId);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContentVideo(context, videoId, video),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: _buildDescVideo(context, videoId, video),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text('Video Terkait', style: AppTextStyles.titleVideo),
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: _buildRelateVideo(context, videoId),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

Widget _buildContentVideo(BuildContext context, String videoId, dynamic video) {
  return Stack(
    children: [
      SizedBox(
        height: 260,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: video.thumbnail,
                ),
              ),
            ),
          ],
        ),
      ),
      Positioned(
        top: 44,
        left: 14,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.textPrimary.withValues(alpha: 0.75),
            shape: BoxShape.circle,
          ),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Image.asset(
                icBackLeft2,
                height: 12,
                color: AppColors.textWhite,
              ),
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.textPrimary.withValues(alpha: 0.75),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 12),
            child: Row(
              children: [
                Image.asset(icPlay),
                SizedBox(width: 20),
                Expanded(
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.50),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Image.asset(icMute),
                SizedBox(width: 20),
                Image.asset(icFullscreen),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _buildDescVideo(BuildContext context, String videoId, dynamic video) {
  List<String> paragraphs = video.description.split('\n');
  return Column(
    children: [
      Row(
        children: [
          Image.asset(icTime, height: 12),
          SizedBox(width: 6),
          Text(video.durationFormatted, style: AppTextStyles.durationDescVideo),
        ],
      ),
      SizedBox(height: 6),
      Text(
        video.title,
        style: AppTextStyles.titleVideo.copyWith(fontSize: 16),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      SizedBox(height: 12),
      ...paragraphs.map((text) {
        if (text.trim().isEmpty) return SizedBox();
        return Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            text,
            style: AppTextStyles.descVideo.copyWith(
              color: AppColors.textPrimary,
              height: 1.6
            ),
          ),
        );
      }).toList(),
    ],
  );
}

Widget _buildRelateVideo(BuildContext context, String currentVideoId) {
  final provider = Provider.of<EducationProvider>(context, listen: false);
  final relatedVideos = provider.videos
      .where((v) => v.id != currentVideoId)
      .toList();

  if (relatedVideos.isEmpty) {
    return const Center(child: Text('Tidak ada video terkait lainnya'));
  }

  return ListView.builder(
    padding: EdgeInsets.all(0),
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: relatedVideos.length,
    itemBuilder: (context, index) {
      final item = relatedVideos[index];

      return InkWell(
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        onTap: () {
          Navigator.pushReplacementNamed(
            context,
            Routes.detailVideo,
            arguments: item.id,
          );
        },
        child: Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 76,
                  width: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: item.thumbnail,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.fromLTRB(30, 30, 28, 30),
                        child: Image.asset(icPlay),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Column(
                    children: [
                      Text(
                        item.title,
                        style: AppTextStyles.titleVideo.copyWith(fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Image.asset(icTime, height: 12),
                          SizedBox(width: 6),
                          Text(
                            item.durationFormatted,
                            style: AppTextStyles.durationDescVideo,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
