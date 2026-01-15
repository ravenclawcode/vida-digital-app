import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'package:mindfullshelter/main.dart';
import 'package:mindfullshelter/models/audio_model.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';

class AudioPlayerSheet extends StatefulWidget {
  final AudioMindfulness audio;
  final List<AudioMindfulness> playlist;
  final int index;

  const AudioPlayerSheet({
    super.key,
    required this.audio,
    required this.playlist,
    required this.index,
  });

  @override
  State<AudioPlayerSheet> createState() => AudioPlayerSheetState();
}

class AudioPlayerSheetState extends State<AudioPlayerSheet> {
  @override
  void initState() {
    super.initState();
    _setupAudio();
  }

  Future<void> _setupAudio() async {
    if (audioHandler.mediaItem.value?.id != widget.audio.audioUrl) {
      audioHandler.setPlaylist(widget.playlist, widget.index);
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    final minutes = duration.inMinutes.remainder(60);
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 560,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: StreamBuilder<MediaItem?>(
        stream: audioHandler.mediaItem,
        builder: (context, mediaSnapshot) {
          final currentItem = mediaSnapshot.data;
          final title = currentItem?.title ?? widget.audio.title;
          final coverUrl =
              currentItem?.artUri?.toString() ?? widget.audio.coverUrl;

          return Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 50,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 25),
              Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.network(
                    coverUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.music_note, size: 80),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.detailTitleAudio,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 38,
                      child: Text(
                        widget.audio.description,
                        style: AppTextStyles.detailDescAudio,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 32),
                    StreamBuilder<Duration>(
                      stream: audioHandler.positionStream,
                      builder: (context, snapshot) {
                        final position = snapshot.data ?? Duration.zero;
                        final duration =
                            audioHandler.totalDuration ?? Duration.zero;

                        double maxDuration = duration.inMilliseconds.toDouble();
                        double currentPos = position.inMilliseconds.toDouble();

                        if (currentPos > maxDuration) currentPos = maxDuration;
                        if (maxDuration <= 0) maxDuration = 1.0;

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 4,
                                  activeTrackColor: const Color(0xFF57D1C9),
                                  inactiveTrackColor: const Color(0xFFF5F5F5),
                                  thumbColor: const Color(0xFF57D1C9),
                                  thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 10,
                                  ),
                                  overlayShape: SliderComponentShape.noOverlay,
                                ),
                                child: Slider(
                                  value: currentPos,
                                  max: maxDuration,
                                  onChanged: (value) {
                                    audioHandler.seek(
                                      Duration(milliseconds: value.toInt()),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatDuration(position),
                                    style: AppTextStyles.descAudio,
                                  ),
                                  Text(
                                    _formatDuration(duration),
                                    style: AppTextStyles.descAudio,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    StreamBuilder<PlaybackState>(
                      stream: audioHandler.playbackState,
                      builder: (context, snapshot) {
                        final playbackState = snapshot.data;
                        final playing = playbackState?.playing ?? false;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              overlayColor: WidgetStateProperty.all(
                                Colors.transparent,
                              ),
                              onTap: () => audioHandler.skipToPrevious(),
                              child: Image.asset(icSkipPrevious, height: 21),
                            ),
                            const SizedBox(width: 38),
                            Container(
                              width: 58,
                              height: 58,
                              decoration: const BoxDecoration(
                                color: AppColors.textPrimary,
                                shape: BoxShape.circle,
                              ),
                              child: InkWell(
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                overlayColor: WidgetStateProperty.all(
                                  Colors.transparent,
                                ),
                                onTap: () {
                                  if (playing) {
                                    audioHandler.pause();
                                  } else {
                                    audioHandler.play();
                                  }
                                },
                                child: Center(
                                  child: playing
                                      ? Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Image.asset(
                                            icPause,
                                            height: 20,
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            22,
                                            18,
                                            18,
                                            18,
                                          ),
                                          child: Image.asset(
                                            icPlay,
                                            height: 20,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 38),
                            InkWell(
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              overlayColor: WidgetStateProperty.all(
                                Colors.transparent,
                              ),
                              onTap: () => audioHandler.skipToNext(),
                              child: Image.asset(icSkipNext, height: 21),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
