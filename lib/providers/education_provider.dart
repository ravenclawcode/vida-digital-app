import 'package:flutter/material.dart';
import '../models/education_model.dart';
import '../services/education_service.dart';

class EducationProvider with ChangeNotifier {
  final EducationService _service = EducationService();

  List<EducationContent> _allContents = [];
  bool _isLoading = false;

  List<EducationContent> get videos =>
      _allContents.where((e) => e.type == 'video').toList();
  List<EducationContent> get articles =>
      _allContents.where((e) => e.type == 'artikel').toList();

  bool get isLoading => _isLoading;

  Future<void> initEducation() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      _allContents = await _service.fetchEducation();
    } catch (_) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleLike(String id) async {
    final index = _allContents.indexWhere((element) => element.id == id);
    if (index == -1) return;

    final bool oldStatus = _allContents[index].isLiked;
    final int oldLikes = _allContents[index].likes;

    _allContents[index].isLiked = !oldStatus;
    _allContents[index].isLiked
        ? _allContents[index].likes++
        : _allContents[index].likes--;
    notifyListeners();

    try {
      final result = await _service.postLike(id);

      if (result != null && result['success'] == true) {
        _allContents[index].likes = result['current_likes'];
        _allContents[index].isLiked = result['is_liked'];
      } else {
        _allContents[index].isLiked = oldStatus;
        _allContents[index].likes = oldLikes;
      }
    } catch (e) {
      _allContents[index].isLiked = oldStatus;
      _allContents[index].likes = oldLikes;
    } finally {
      notifyListeners();
    }
  }
}
