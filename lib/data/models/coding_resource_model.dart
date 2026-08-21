import 'package:cloud_firestore/cloud_firestore.dart';

class CodingResourceModel {
  final String id;
  final String title;
  final String
      platform; // LeetCode, HackerRank, CodeChef, Codeforces, GeeksforGeeks, SQL Practice, DSA Roadmap, Coding Sheets
  final String category;
  final String difficulty; // Easy, Medium, Hard, All Levels
  final String url;
  final String description;
  final String
      sheetName; // e.g., Striver SDE Sheet, Love Babbar 450, NeetCode 150
  final List<String> tags;
  final bool isFavorite;

  const CodingResourceModel({
    required this.id,
    required this.title,
    required this.platform,
    required this.category,
    required this.difficulty,
    required this.url,
    required this.description,
    required this.sheetName,
    required this.tags,
    this.isFavorite = false,
  });

  factory CodingResourceModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return CodingResourceModel.fromJson({'id': doc.id, ...data});
  }

  factory CodingResourceModel.fromJson(Map<String, dynamic> json) {
    return CodingResourceModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      platform: json['platform'] ?? 'Coding Platform',
      category: json['category'] ?? 'DSA',
      difficulty: json['difficulty'] ?? 'Medium',
      url: json['url'] ?? '',
      description: json['description'] ?? '',
      sheetName: json['sheetName'] ?? 'General',
      tags: List<String>.from(json['tags'] ?? []),
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'platform': platform,
      'category': category,
      'difficulty': difficulty,
      'url': url,
      'description': description,
      'sheetName': sheetName,
      'tags': tags,
      'isFavorite': isFavorite,
    };
  }

  CodingResourceModel copyWith({bool? isFavorite}) {
    return CodingResourceModel(
      id: id,
      title: title,
      platform: platform,
      category: category,
      difficulty: difficulty,
      url: url,
      description: description,
      sheetName: sheetName,
      tags: tags,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
