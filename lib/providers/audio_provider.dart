import 'package:flutter/material.dart';
import 'package:mindfullshelter/models/audio_model.dart';
import '../services/audio_service.dart';

class AudioProvider with ChangeNotifier {
  final AudioService _service = AudioService();
  List<AudioMindfulness> _audios = [];
  bool _isLoading = false;

  List<AudioMindfulness> get audios => _audios;
  bool get isLoading => _isLoading;

  Future<void> getAudios({String? category}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _service.fetchAudios(category: category);
      _audios = data.map((item) => AudioMindfulness.fromJson(item)).toList();
    } catch (e) {
      debugPrint('Error Fetch Audio: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}