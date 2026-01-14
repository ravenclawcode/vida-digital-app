import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mindfullshelter/models/audio_model.dart';

class MyAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();

  List<AudioMindfulness> _playlist = [];
  int _currentIndex = -1;

  MyAudioHandler() {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);

    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        skipToNext();
      }
    });
  }

  void setPlaylist(List<AudioMindfulness> list, int index) {
    _playlist = list;
    _currentIndex = index;
    final audio = list[index];
    playAudio(audio.audioUrl, audio.title, audio.coverUrl);
  }

  @override
  Future<void> skipToNext() async {
    if (_currentIndex < _playlist.length - 1) {
      _currentIndex++;
      final nextAudio = _playlist[_currentIndex];
      await playAudio(nextAudio.audioUrl, nextAudio.title, nextAudio.coverUrl);
      play();
    }
  }

  @override
  Future<void> skipToPrevious() async {
    if (_currentIndex > 0) {
      _currentIndex--;
      final prevAudio = _playlist[_currentIndex];
      await playAudio(prevAudio.audioUrl, prevAudio.title, prevAudio.coverUrl);
      play();
    }
  }

  @override
  Future<void> play() => _player.play();
  @override
  Future<void> pause() => _player.pause();
  @override
  Future<void> seek(Duration position) => _player.seek(position);
  @override
  Future<void> stop() => _player.stop();

  Future<void> playAudio(String url, String title, String art) async {
    if (mediaItem.value?.id == url) return;

    final mediaItemValue = MediaItem(
      id: url,
      album: "Mindfulness",
      title: title,
      artUri: Uri.parse(art),
    );

    mediaItem.add(mediaItemValue);
    await _player.setUrl(url);
  }

  Stream<Duration> get positionStream => _player.positionStream;
  Duration? get totalDuration => _player.duration;

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
        MediaControl.stop,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.skipToNext,
        MediaAction.skipToPrevious,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
    );
  }
}
