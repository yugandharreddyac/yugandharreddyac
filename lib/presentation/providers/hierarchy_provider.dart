import 'package:flutter/material.dart';
import '../../data/models/hierarchy_node_model.dart';
import '../../data/repositories/non_academic_repository.dart';

class HierarchyProvider extends ChangeNotifier {
  final NonAcademicRepository _repository;

  HierarchyProvider(this._repository);

  HubModel? _currentHub;
  CategoryModel? _currentCategory;
  LearningLevel? _selectedLevelFilter;
  HierarchicalTopicModel? _currentTopic;
  List<HierarchicalTopicModel> _topicBreadcrumbStack = [];

  HubModel? get currentHub => _currentHub;
  CategoryModel? get currentCategory => _currentCategory;
  LearningLevel? get selectedLevelFilter => _selectedLevelFilter;
  HierarchicalTopicModel? get currentTopic => _currentTopic;
  List<HierarchicalTopicModel> get topicBreadcrumbStack => List.unmodifiable(_topicBreadcrumbStack);

  void selectHub(String hubId) {
    _currentHub = _repository.getHubById(hubId);
    _currentCategory = null;
    _selectedLevelFilter = null;
    _currentTopic = null;
    _topicBreadcrumbStack = [];
    notifyListeners();
  }

  void selectCategory(CategoryModel category) {
    _currentCategory = category;
    _selectedLevelFilter = null;
    _currentTopic = null;
    _topicBreadcrumbStack = [];
    notifyListeners();
  }

  void setLevelFilter(LearningLevel? level) {
    _selectedLevelFilter = level;
    notifyListeners();
  }

  void selectTopic(HierarchicalTopicModel topic) {
    _currentTopic = topic;
    if (!_topicBreadcrumbStack.contains(topic)) {
      _topicBreadcrumbStack.add(topic);
    }
    notifyListeners();
  }

  void popTopicBreadcrumb(int index) {
    if (index >= 0 && index < _topicBreadcrumbStack.length) {
      _topicBreadcrumbStack = _topicBreadcrumbStack.sublist(0, index + 1);
      _currentTopic = _topicBreadcrumbStack.last;
      notifyListeners();
    }
  }

  void resetNavigation() {
    _currentHub = null;
    _currentCategory = null;
    _selectedLevelFilter = null;
    _currentTopic = null;
    _topicBreadcrumbStack = [];
    notifyListeners();
  }
}
