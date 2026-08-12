import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_goal_model.dart';

class RoadmapRepository {
  static const String _profileKey = 'cssed_user_goal_profile';
  static const String _progressKey = 'cssed_topic_progress_map';

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
}
