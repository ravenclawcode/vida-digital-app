import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  AudioPlayerService._internal();
  static final AudioPlayerService instance = AudioPlayerService._internal();

  final AudioPlayer _player = AudioPlayer();

  Future<void> setUrl(String url) async {
    await _player.setUrl(url);
  }

  Future<void> play() => _player.play();

  Future<void> pause() => _player.pause();

  Future<void> stop() => _player.stop();

  Future<void> seek(Duration position) => _player.seek(position);

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  Stream<Duration?> get durationStream => _player.durationStream;

  Stream<Duration> get positionStream => _player.positionStream;

  Duration? get duration => _player.duration;

  Future<void> dispose() => _player.dispose();
}
