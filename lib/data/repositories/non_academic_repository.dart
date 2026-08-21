import '../datasources/non_academic_data.dart';
import '../models/hierarchy_node_model.dart';

class NonAcademicRepository {
  List<HubModel> getAllHubs() {
    return NonAcademicData.allHubs;
  }

  HubModel? getHubById(String id) {
    return NonAcademicData.getHubById(id);
  }

  CategoryModel? getCategoryById(String hubId, String categoryId) {
    final hub = getHubById(hubId);
    if (hub == null) return null;
    try {
      return hub.categories.firstWhere((c) => c.id == categoryId);
    } catch (_) {
      return null;
    }
  }

  HierarchicalTopicModel? getTopicById(
      String hubId, String categoryId, String topicId) {
    final cat = getCategoryById(hubId, categoryId);
    if (cat == null) return null;
    return _findTopicInList(cat.topics, topicId);
  }

  HierarchicalTopicModel? _findTopicInList(
      List<HierarchicalTopicModel> topics, String topicId) {
    for (final topic in topics) {
      if (topic.id == topicId) return topic;
      if (topic.hasSubtopics) {
        final found = _findTopicInList(topic.subtopics, topicId);
        if (found != null) return found;
      }
    }
    return null;
  }
}
