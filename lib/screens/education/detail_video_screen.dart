import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:mindfullshelter/providers/education_provider.dart';
import 'package:mindfullshelter/routes/routes.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';
import 'package:provider/provider.dart';

class DetailVideoScreen extends StatefulWidget {
  final String videoId;
  const DetailVideoScreen({super.key, required this.videoId});

  @override
  State<DetailVideoScreen> createState() => _DetailVideoScreenState();
}

class _DetailVideoScreenState extends State<DetailVideoScreen> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<EducationProvider>(context, listen: false);
    final video = provider.videos.firstWhere((v) => v.id == widget.videoId);

    String videoId = YoutubePlayer.convertUrlToId(video.videoUrl ?? '') ?? '';

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        hideControls: true,
      ),
    )..addListener(_listener);
  }

  void _listener() {
    if (mounted && _isPlayerReady) {
      setState(() {});
    }
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EducationProvider>(context, listen: false);
    final video = provider.videos.firstWhere((v) => v.id == widget.videoId);

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        onReady: () => setState(() => _isPlayerReady = true),
      ),
      builder: (context, player) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildContentVideo(context, widget.videoId, video, player),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: _buildDescVideo(context, widget.videoId, video),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    'Video Terkait',
                    style: AppTextStyles.titleVideo.copyWith(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: _buildRelateVideo(context, widget.videoId),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContentVideo(
    BuildContext context,
    String videoId,
    dynamic video,
    Widget player,
  ) {
    return Stack(
      children: [
        SizedBox(height: 260, width: double.infinity, child: player),

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
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.all(8),
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
              padding: const EdgeInsets.symmetric(horizontal: 23),
              child: Row(
                children: [
                  InkWell(
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    onTap: () => _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play(),
                    child: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 15),

                  ProgressBar(
                    controller: _controller,
                    isExpanded: true,
                    colors: ProgressBarColors(
                      playedColor: AppColors.primary,
                      handleColor: AppColors.primary,
                      bufferedColor: Colors.white.withValues(alpha: 0.3),
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  const SizedBox(width: 15),
                  InkWell(
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    onTap: () {
                      setState(() {
                        _isMuted = !_isMuted;
                        if (_isMuted) {
                          _controller.mute();
                        } else {
                          _controller.unMute();
                        }
                      });
                    },
                    child: Icon(
                      _isMuted ? Icons.volume_off : Icons.volume_up,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 15),
                  InkWell(
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    onTap: () => _controller.toggleFullScreenMode(),
                    child: const Icon(
                      Icons.fullscreen,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: AnimatedOpacity(
              opacity: _controller.value.isPlaying ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: InkWell(
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                onTap: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.textPrimary.withValues(alpha: 0.75),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: _controller.value.isPlaying
                        ? const EdgeInsets.all(16)
                        : const EdgeInsets.fromLTRB(20, 16, 16, 16),
                    child: Image.asset(
                      _controller.value.isPlaying ? icPause : icPlay,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescVideo(BuildContext context, String videoId, dynamic video) {
    final provider = context.watch<EducationProvider>();
    List<String> paragraphs = (video.description ?? 'Tidak ada deskripsi.')
        .split('\n');

    double likeButtonWidth(int likes) {
      if (likes < 10) return 49;
      if (likes < 100) return 56;
      return 63;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(icTime, height: 12),
            const SizedBox(width: 6),
            Text(
              video.duration ?? '00:00',
              style: AppTextStyles.durationDescVideo,
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          video.title ?? '',
          style: AppTextStyles.titleVideo.copyWith(fontSize: 16),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            InkWell(
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              onTap: () => provider.toggleLike(video.id),
              child: AnimatedSize(
                duration: const Duration(milliseconds: 180),
                child: Container(
                  width: likeButtonWidth(video.likes ?? 0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        (video.isLiked ?? false) ? icinThumbsUp : icunThumbsUp,
                        height: 10,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${video.likes ?? 0}',
                        style: AppTextStyles.actionButton,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              onTap: () {
                // ignore: deprecated_member_use
                Share.share(
                  'Lihat video edukasi ini: ${video.title}\n\nTonton di sini: ${video.videoUrl}',
                  subject: 'Edukasi HIV/AIDS',
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    Image.asset(icShare, height: 10),
                    const SizedBox(width: 6),
                    Text('bagikan', style: AppTextStyles.actionButton),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...paragraphs.map((text) {
          if (text.trim().isEmpty) return const SizedBox();
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              text.trim(),
              style: AppTextStyles.descVideo.copyWith(
                color: AppColors.textPrimary,
                fontSize: 13,
                height: 1.6,
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
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'Tidak ada video terkait lainnya',
            style: AppTextStyles.noContent.copyWith(fontSize: 12),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: 76,
                    width: 120,
                    child: Image.network(
                      item.thumbnail!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: AppTextStyles.titleVideo.copyWith(fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Image.asset(icTime, height: 12),
                          const SizedBox(width: 4),
                          Text(
                            item.duration,
                            style: AppTextStyles.durationDescVideo.copyWith(
                              fontSize: 12,
                            ),
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
      },
    );
  }
}
