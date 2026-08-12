class AppConstants {
  AppConstants._();

  static const String appName = 'UNIDOCS';
  static const String appTagline = 'Academic & Career Learning Management Platform';
  static const String appVersion = '1.0.0';

  // Local storage keys
  static const String themePrefKey = 'user_theme_mode';
  static const String bookmarksPrefKey = 'user_bookmarks_list';
  static const String pageBookmarksPrefKey = 'pdf_page_bookmarks';
  static const String recentReadsPrefKey = 'recent_reads_list';

  // Official 3 Resource Types
  static const String typeSyllabus = 'Syllabus';
  static const String typeNotes = 'Notes';
  static const String typePastPapers = 'Previous Question Papers';

  static const List<String> resourceTypes = [
    typeSyllabus,
    typeNotes,
    typePastPapers,
  ];

  // Contact & About Information
  static const String contactEmail = 'support@cssestudyhub.edu';
  static const String departmentName = 'Department of Computer Science & Software Engineering';
  static const String privacyPolicyUrl = 'https://cssestudyhub.web.app/privacy';
}
