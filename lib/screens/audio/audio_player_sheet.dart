import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart'; // Library audio asli
import 'package:mindfullshelter/models/audio_model.dart';
import 'package:mindfullshelter/utils/app_assets.dart';
import 'package:mindfullshelter/utils/app_colors.dart';
import 'package:mindfullshelter/utils/app_theme.dart';

class AudioPlayerSheet extends StatefulWidget {
  final AudioMindfulness audio;

  const AudioPlayerSheet({super.key, required this.audio});

  @override
  State<AudioPlayerSheet> createState() => AudioPlayerSheetState();
}

class AudioPlayerSheetState extends State<AudioPlayerSheet> {
  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _setupAudio();
  }

  Future<void> _setupAudio() async {
    try {
      await _player.setUrl(widget.audio.audioUrl);
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
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
      child: Column(
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
                widget.audio.coverUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.music_note, size: 80, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                Text(
                  widget.audio.title,
                  style: AppTextStyles.detailTitleAudio,
                  textAlign: TextAlign.center,
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
                  stream: _player.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    final duration = _player.duration ?? Duration.zero;

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
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
                              value: position.inMilliseconds.toDouble(),
                              max: duration.inMilliseconds.toDouble() > 0
                                  ? duration.inMilliseconds.toDouble()
                                  : 1.0,
                              onChanged: (value) {
                                _player.seek(
                                  Duration(milliseconds: value.toInt()),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                StreamBuilder<PlayerState>(
                  stream: _player.playerStateStream,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;
                    final playing = playerState?.playing ?? false;
                    final processingState = playerState?.processingState;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(icSkipPrevious, height: 21),
                        const SizedBox(width: 38),
                        Container(
                          width: 58,
                          height: 58,
                          decoration: const BoxDecoration(
                            color: AppColors.textPrimary,
                            shape: BoxShape.circle,
                          ),
                          child: InkWell(
                            onTap: () {
                              if (playing) {
                                _player.pause();
                              } else {
                                _player.play();
                              }
                            },
                            child: Center(
                              child: processingState == ProcessingState.loading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : (playing // PAKAI LOGIKA PADDING ANDA DI SINI
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
                                          )),
                            ),
                          ),
                        ),
                        const SizedBox(width: 38),
                        Image.asset(icSkipNext, height: 21),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
