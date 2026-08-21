class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final String role;
  final bool isActive;
  final bool isAnonymous;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final List<String> bookmarkedResourceIds;
  final List<String> downloadedResourceIds;

  const UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.role = 'student',
    this.isActive = true,
    required this.isAnonymous,
    required this.createdAt,
    required this.lastLoginAt,
    this.bookmarkedResourceIds = const [],
    this.downloadedResourceIds = const [],
  });

  bool get isAdmin => role.toLowerCase() == 'admin' && isActive;

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    String? role,
    bool? isActive,
    bool? isAnonymous,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    List<String>? bookmarkedResourceIds,
    List<String>? downloadedResourceIds,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      bookmarkedResourceIds:
          bookmarkedResourceIds ?? this.bookmarkedResourceIds,
      downloadedResourceIds:
          downloadedResourceIds ?? this.downloadedResourceIds,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'role': role,
      'isActive': isActive,
      'isAnonymous': isAnonymous,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt.toIso8601String(),
      'bookmarkedResourceIds': bookmarkedResourceIds,
      'downloadedResourceIds': downloadedResourceIds,
    };
  }

  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    List<String> bookmarks = [];
    if (data['bookmarkedResourceIds'] != null &&
        data['bookmarkedResourceIds'] is List) {
      bookmarks = (data['bookmarkedResourceIds'] as List)
          .map((e) => e.toString())
          .toList();
    }

    List<String> downloads = [];
    if (data['downloadedResourceIds'] != null &&
        data['downloadedResourceIds'] is List) {
      downloads = (data['downloadedResourceIds'] as List)
          .map((e) => e.toString())
          .toList();
    }

    return UserModel(
      uid: uid,
      email: data['email'],
      displayName: data['displayName'],
      photoURL: data['photoURL'],
      role: data['role'] ?? 'student',
      isActive: data['isActive'] ?? true,
      isAnonymous: data['isAnonymous'] ?? true,
      createdAt: data['createdAt'] != null
          ? DateTime.tryParse(data['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      lastLoginAt: data['lastLoginAt'] != null
          ? DateTime.tryParse(data['lastLoginAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      bookmarkedResourceIds: bookmarks,
      downloadedResourceIds: downloads,
    );
  }
}
