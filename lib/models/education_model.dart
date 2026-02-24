import 'package:flutter/material.dart';
import 'package:mindfullshelter/utils/app_colors.dart';

class EducationContent {
  final String id;
  final String title;
  final String type;
  final String category;
  final String duration;
  final String? description;
  final String? videoUrl;
  final String? importantNote;
  final String? thumbnail;
  int likes;
  final String publishedAt;
  bool isLiked;

  EducationContent({
    required this.id,
    required this.title,
    required this.type,
    required this.category,
    required this.duration,
    this.description,
    this.videoUrl,
    this.importantNote,
    this.thumbnail,
    required this.likes,
    required this.publishedAt,
    this.isLiked = false,
  });

  factory EducationContent.fromJson(Map<String, dynamic> json) {
    return EducationContent(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      category: json['category'],
      duration: json['duration'],
      description: json['description'],
      videoUrl: json['video_url'],
      importantNote: json['important_note'],
      thumbnail: json['thumbnail'],
      likes: json['likes'] ?? 0,
      isLiked: json['is_liked'] ?? false,
      publishedAt: json['published_at'],
    );
  }

  Widget get thumbnailWidget {
    if (thumbnail != null && thumbnail!.isNotEmpty) {
      return Image.network(thumbnail!, fit: BoxFit.cover);
    }
    return Container(color: AppColors.textLight);
  }

  String get durationFormatted => duration;
}
