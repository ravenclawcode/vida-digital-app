import 'package:flutter/material.dart';
import 'package:mindfullshelter/data/dummy_data.dart';
import 'package:mindfullshelter/models/education.dart';

class EducationProvider extends ChangeNotifier {
  final List<Education> _educations = DummyData().educations;

  List<Education> get educations => _educations;

  List<VideoEdu> get videos {
    return _educations
        .where((e) => e.type == EducationType.videoEducation)
        .expand((e) => e.educationContent)
        .whereType<VideoEdu>()
        .toList();
  }

  List<ArticleEdu> get articles {
    return _educations
        .where((e) => e.type == EducationType.articleEducation)
        .expand((e) => e.educationContent)
        .whereType<ArticleEdu>()
        .toList();
  }
}
