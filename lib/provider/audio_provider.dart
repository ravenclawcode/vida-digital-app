import 'dart:async';
import 'package:flutter/material.dart';
import '../models/audio.dart';

class AudioProvider with ChangeNotifier {
  AudioMindfulness? _currentAudio;
  bool _isPlaying = false;
  double _currentPosition = 0.0;
  Timer? _timer;

  AudioMindfulness? get currentAudio => _currentAudio;
  bool get isPlaying => _isPlaying;
  double get currentPosition => _currentPosition;

  void playAudio(AudioMindfulness audio) {
    if (_currentAudio?.id == audio.id) {
      togglePlay();
    } else {
      _currentAudio = audio;
      _currentPosition = 0.0;
      _isPlaying = true;
      _startTimer();
    }
    notifyListeners();
  }

  void togglePlay() {
    _isPlaying = !_isPlaying;
    if (_isPlaying) {
      _startTimer();
    } else {
      _timer?.cancel();
    }
    notifyListeners();
  }

  void seek(double value) {
    _currentPosition = value;
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentAudio != null && _currentPosition < _currentAudio!.duration) {
        _currentPosition += 1;
        notifyListeners();
      } else {
        _isPlaying = false;
        timer.cancel();
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}