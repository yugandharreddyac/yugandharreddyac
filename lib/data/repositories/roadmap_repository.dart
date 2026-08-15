import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_goal_model.dart';
import '../models/career_models.dart';
import '../models/personalized_roadmap_models.dart';

class RoadmapRepository {
  static const String _profileKey = 'cssed_user_goal_profile';
  static const String _progressKey = 'cssed_topic_progress_map';

  static const String _lastOpenedKey = 'cssed_last_opened_topic_id';
  static const String _recentTopicsKey = 'cssed_recent_topic_ids';
  static const String _bookmarkedTopicsKey = 'cssed_bookmarked_topic_ids';

  static const String _personalizedProfileKey = 'cssed_personalized_profile';
  static const String _personalizedRoadmapKey = 'cssed_personalized_roadmap';

  Future<UserGoalProfile?> loadGoalProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_profileKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final Map<String, dynamic> map = jsonDecode(jsonStr);
        return UserGoalProfile.fromJson(map);
      }
    } catch (_) {}
    return null;
  }

  Future<void> saveGoalProfile(UserGoalProfile profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(profile.toJson());
      await prefs.setString(_profileKey, jsonStr);
    } catch (_) {}
  }

  Future<Map<String, TopicProgressModel>> loadTopicProgressMap() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_progressKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final Map<String, dynamic> decoded = jsonDecode(jsonStr);
        final Map<String, TopicProgressModel> result = {};
        decoded.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            result[key] = TopicProgressModel.fromJson(value);
          }
        });
        return result;
      }
    } catch (_) {}
    return {};
  }

  Future<void> saveTopicProgress(TopicProgressModel progress) async {
    try {
      final map = await loadTopicProgressMap();
      map[progress.topicId] = progress;
      final prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> encodable = {};
      map.forEach((k, v) => encodable[k] = v.toJson());
      await prefs.setString(_progressKey, jsonEncode(encodable));
    } catch (_) {}
  }

  Future<String?> loadLastOpenedTopicId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_lastOpenedKey);
    } catch (_) {}
    return null;
  }

  Future<void> saveLastOpenedTopicId(String topicId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastOpenedKey, topicId);
    } catch (_) {}
  }

  Future<List<String>> loadRecentTopicIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_recentTopicsKey) ?? [];
    } catch (_) {}
    return [];
  }

  Future<void> saveRecentTopicIds(List<String> topicIds) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_recentTopicsKey, topicIds);
    } catch (_) {}
  }

  Future<List<String>> loadBookmarkedTopicIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_bookmarkedTopicsKey) ?? [];
    } catch (_) {}
    return [];
  }

  Future<void> saveBookmarkedTopicIds(List<String> topicIds) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_bookmarkedTopicsKey, topicIds);
    } catch (_) {}
  }

  static const String _resumeChecklistKey = 'cssed_resume_checklist';

  Future<ResumeReadinessModel> loadResumeChecklist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_resumeChecklistKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final Map<String, dynamic> decoded = jsonDecode(jsonStr);
        return ResumeReadinessModel.fromJson(decoded);
      }
    } catch (_) {}
    return const ResumeReadinessModel();
  }

  Future<void> saveResumeChecklist(ResumeReadinessModel checklist) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(checklist.toJson());
      await prefs.setString(_resumeChecklistKey, jsonStr);
    } catch (_) {}
  }

  // --- Personalized Roadmap Persistence ---

  Future<PersonalizedProfile?> loadPersonalizedProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_personalizedProfileKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        return PersonalizedProfile.fromJson(jsonStr);
      }
    } catch (_) {}
    return null;
  }

  Future<void> savePersonalizedProfile(PersonalizedProfile profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_personalizedProfileKey, profile.toJson());
    } catch (_) {}
  }

  Future<PersonalizedRoadmap?> loadPersonalizedRoadmap() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_personalizedRoadmapKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        return PersonalizedRoadmap.fromJson(jsonStr);
      }
    } catch (_) {}
    return null;
  }

  Future<void> savePersonalizedRoadmap(PersonalizedRoadmap roadmap) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_personalizedRoadmapKey, roadmap.toJson());
    } catch (_) {}
  }

  Future<void> clearPersonalizedRoadmap() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_personalizedRoadmapKey);
      await prefs.remove(_personalizedProfileKey);
    } catch (_) {}
  }

  Future<void> updateRoadmapItemStatus(String itemId, RoadmapItemStatus status) async {
    try {
      final roadmap = await loadPersonalizedRoadmap();
      if (roadmap == null) return;

      final updatedPhases = roadmap.phases.map((phase) {
        final updatedItems = phase.items.map((item) {
          if (item.id == itemId) {
            return item.copyWith(status: status);
          }
          return item;
        }).toList();
        return phase.copyWith(items: updatedItems);
      }).toList();

      final updatedRoadmap = roadmap.copyWith(
        phases: updatedPhases,
        lastUpdatedAt: DateTime.now(),
      );

      await savePersonalizedRoadmap(updatedRoadmap);
    } catch (_) {}
  }
}
