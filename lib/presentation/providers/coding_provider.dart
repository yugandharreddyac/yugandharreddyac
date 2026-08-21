import 'package:flutter/foundation.dart';
import '../../data/models/coding_resource_model.dart';
import '../../data/models/beyond_academics_model.dart';
import '../../data/repositories/coding_repository.dart';

class CodingProvider extends ChangeNotifier {
  final CodingRepository _codingRepository;

  List<CodingResourceModel> _resources = [];
  List<CodingLanguageModel> _languages = [];
  List<DsaTopicModel> _dsaTopics = [];
  List<IndustryProjectModel> _codingProjects = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedPlatform = 'All';
  String _selectedDifficulty = 'All';

  CodingProvider(this._codingRepository);

  List<CodingResourceModel> get resources => _resources;
  List<CodingLanguageModel> get languages => _languages;
  List<DsaTopicModel> get dsaTopics => _dsaTopics;
  List<IndustryProjectModel> get codingProjects => _codingProjects;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedPlatform => _selectedPlatform;
  String get selectedDifficulty => _selectedDifficulty;

  List<String> get platforms {
    final list = _resources.map((r) => r.platform).toSet().toList();
    list.sort();
    return ['All', ...list];
  }

  List<CodingResourceModel> get filteredResources {
    return _resources.where((item) {
      final matchesPlatform =
          _selectedPlatform == 'All' || item.platform == _selectedPlatform;
      final matchesDifficulty = _selectedDifficulty == 'All' ||
          item.difficulty == _selectedDifficulty;
      return matchesPlatform && matchesDifficulty;
    }).toList();
  }

  Future<void> fetchCodingResources() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _resources = await _codingRepository.getCodingResources();
      _languages = await _codingRepository.getCodingLanguages();
      _dsaTopics = await _codingRepository.getDsaTopics();
      _codingProjects = await _codingRepository.getCodingProjects();
    } catch (e) {
      _errorMessage = 'Failed to load coding resources';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectPlatform(String platform) {
    _selectedPlatform = platform;
    notifyListeners();
  }

  void selectDifficulty(String difficulty) {
    _selectedDifficulty = difficulty;
    notifyListeners();
  }

  void toggleFavorite(String resourceId) {
    final index = _resources.indexWhere((r) => r.id == resourceId);
    if (index != -1) {
      final updated =
          _resources[index].copyWith(isFavorite: !_resources[index].isFavorite);
      _resources[index] = updated;
      notifyListeners();
    }
  }
}
