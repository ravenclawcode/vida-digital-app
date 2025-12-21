import 'package:flutter/material.dart';

enum EducationType { videoEducation, articleEducation }

class Education {
  final EducationType type;
  final List<EducationContent> educationContent;

  Education({required this.type, required this.educationContent});
}

abstract class EducationContent {
  final String id;
  final String title;
  final String description;
  final String category;
  final int duration;

  EducationContent({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.duration,
  });

  String get durationFormatted {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

mixin VisualContent {
  abstract final Widget thumbnail;
}

class VideoEdu extends EducationContent implements VisualContent {
  @override
  final Widget thumbnail;

  VideoEdu({
    required super.id,
    required super.title,
    required super.description,
    required super.category,
    required super.duration,
    required this.thumbnail,
  });
}

class ArticleEdu extends EducationContent {
  final DateTime date;
  final String? importantNote;

  ArticleEdu({
    required super.id,
    required super.title,
    required super.description,
    required super.category,
    required super.duration,
    required this.date,
    this.importantNote,
  });

  String get formattedTime {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays} hari lalu';
    if (diff.inHours > 0) return '${diff.inHours} jam lalu';
    if (diff.inMinutes > 0) return '${diff.inMinutes} menit lalu';
    return 'Baru saja';
  }

  @override
  String get durationFormatted {
    final minutes = duration ~/ 60;
    return '$minutes';
  }
}
