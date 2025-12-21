import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mindfullshelter/models/audio.dart';
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
  bool isPlaying = false;
  double currentPosition = 0.0;
  Timer? _timer;

  void _startProgress() {
    _timer?.cancel();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (currentPosition < widget.audio.duration) {
        setState(() {
          currentPosition += 1;
        });
      } else {
        timer.cancel();
        setState(() {
          isPlaying = false;
        });
      }
    });
  }

  void _pauseProgress() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 560,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 8),
          Container(
            width: 50,
            height: 4,
            decoration: BoxDecoration(
              color: Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(height: 25),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                widget.audio.thumbnailUrl,
                style: TextStyle(fontSize: 85),
              ),
            ),
          ),
          SizedBox(height: 32),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                Text(
                  widget.audio.title,
                  style: AppTextStyles.detailTitleAudio,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
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
                SizedBox(height: 32),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4,
                      activeTrackColor: Color(0xFF57D1C9),
                      inactiveTrackColor: Color(0xFFF5F5F5),
                      thumbColor: Color(0xFF57D1C9),
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
                      overlayShape: SliderComponentShape.noOverlay,
                    ),
                    child: Slider(
                      value: currentPosition,
                      max: widget.audio.duration.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          currentPosition = value;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(currentPosition.toInt()),
                        style: AppTextStyles.descAudio,
                      ),
                      Text(
                        widget.audio.durationFormatted,
                        style: AppTextStyles.descAudio,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(icSkipPrevious, height: 21),
                    SizedBox(width: 38),
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
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
                          setState(() {
                            isPlaying = !isPlaying;
                          });

                          if (isPlaying) {
                            _startProgress();
                          } else {
                            _pauseProgress();
                          }
                        },
                        child: isPlaying
                            ? Padding(
                                padding: EdgeInsets.all(20),
                                child: Image.asset(icPause, height: 20),
                              )
                            : Padding(
                                padding: EdgeInsets.fromLTRB(22, 18, 18, 18),
                                child: Image.asset(icPlay, height: 20),
                              ),
                      ),
                    ),
                    SizedBox(width: 38),
                    Image.asset(icSkipNext, height: 21),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
