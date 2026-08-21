import 'package:cloud_firestore/cloud_firestore.dart';

class HigherEducationModel {
  final String id;
  final String
      title; // GATE, CAT, GRE, GMAT, IELTS, TOEFL, UPSC, SSC, Banking, RRB, PSU
  final String category; // 'Higher Studies' or 'Government & Public Sector'
  final String subtitle;
  final String overview;
  final String eligibilityCriteria;
  final String whoShouldApply;
  final String examPattern;
  final List<String> syllabusTopics;
  final List<String> preparationTimeline;
  final List<String> recommendedBooks;
  final List<String> youtubeChannels;
  final List<String> officialWebsites;
  final List<ExamNotificationItem> latestNotifications;
  final List<ExamFaqItem> faqs;
  final String salaryRange;
  final String careerOpportunities;
  final List<String> topInstitutes;
  final List<String> scholarships;
  final String applicationProcess;
  final String successStrategy;
  final String pdfGuideUrl;
  final bool isSaved;

  const HigherEducationModel({
    required this.id,
    required this.title,
    required this.category,
    required this.subtitle,
    required this.overview,
    required this.eligibilityCriteria,
    required this.whoShouldApply,
    required this.examPattern,
    required this.syllabusTopics,
    required this.preparationTimeline,
    required this.recommendedBooks,
    required this.youtubeChannels,
    required this.officialWebsites,
    this.latestNotifications = const [],
    this.faqs = const [],
    required this.salaryRange,
    required this.careerOpportunities,
    this.topInstitutes = const [],
    this.scholarships = const [],
    required this.applicationProcess,
    required this.successStrategy,
    this.pdfGuideUrl = '',
    this.isSaved = false,
  });

  factory HigherEducationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return HigherEducationModel.fromJson({'id': doc.id, ...data});
  }

  factory HigherEducationModel.fromJson(Map<String, dynamic> json) {
    return HigherEducationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? 'Higher Studies',
      subtitle: json['subtitle'] ?? '',
      overview: json['overview'] ?? '',
      eligibilityCriteria: json['eligibilityCriteria'] ?? '',
      whoShouldApply: json['whoShouldApply'] ?? '',
      examPattern: json['examPattern'] ?? '',
      syllabusTopics: List<String>.from(json['syllabusTopics'] ?? []),
      preparationTimeline: List<String>.from(json['preparationTimeline'] ?? []),
      recommendedBooks: List<String>.from(json['recommendedBooks'] ?? []),
      youtubeChannels: List<String>.from(json['youtubeChannels'] ?? []),
      officialWebsites: List<String>.from(json['officialWebsites'] ?? []),
      latestNotifications: (json['latestNotifications'] as List<dynamic>?)
              ?.map((e) =>
                  ExamNotificationItem.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      faqs: (json['faqs'] as List<dynamic>?)
              ?.map((e) => ExamFaqItem.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      salaryRange: json['salaryRange'] ?? '',
      careerOpportunities: json['careerOpportunities'] ?? '',
      topInstitutes: List<String>.from(json['topInstitutes'] ?? []),
      scholarships: List<String>.from(json['scholarships'] ?? []),
      applicationProcess: json['applicationProcess'] ?? '',
      successStrategy: json['successStrategy'] ?? '',
      pdfGuideUrl: json['pdfGuideUrl'] ?? '',
      isSaved: json['isSaved'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'subtitle': subtitle,
      'overview': overview,
      'eligibilityCriteria': eligibilityCriteria,
      'whoShouldApply': whoShouldApply,
      'examPattern': examPattern,
      'syllabusTopics': syllabusTopics,
      'preparationTimeline': preparationTimeline,
      'recommendedBooks': recommendedBooks,
      'youtubeChannels': youtubeChannels,
      'officialWebsites': officialWebsites,
      'latestNotifications':
          latestNotifications.map((e) => e.toJson()).toList(),
      'faqs': faqs.map((e) => e.toJson()).toList(),
      'salaryRange': salaryRange,
      'careerOpportunities': careerOpportunities,
      'topInstitutes': topInstitutes,
      'scholarships': scholarships,
      'applicationProcess': applicationProcess,
      'successStrategy': successStrategy,
      'pdfGuideUrl': pdfGuideUrl,
      'isSaved': isSaved,
    };
  }
}

class ExamNotificationItem {
  final String title;
  final String date;
  final String url;

  const ExamNotificationItem({
    required this.title,
    required this.date,
    required this.url,
  });

  factory ExamNotificationItem.fromJson(Map<String, dynamic> json) {
    return ExamNotificationItem(
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date,
      'url': url,
    };
  }
}

class ExamFaqItem {
  final String question;
  final String answer;

  const ExamFaqItem({
    required this.question,
    required this.answer,
  });

  factory ExamFaqItem.fromJson(Map<String, dynamic> json) {
    return ExamFaqItem(
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
    };
  }
}
