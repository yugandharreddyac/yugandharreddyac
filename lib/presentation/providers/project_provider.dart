import 'package:flutter/foundation.dart';
import '../../data/models/project_model.dart';
import '../../data/repositories/project_repository.dart';

class ProjectProvider extends ChangeNotifier {
  final ProjectRepository _projectRepository;

  List<ProjectModel> _projects = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedCategory = 'All';
  String _selectedDifficulty = 'All';

  ProjectProvider(this._projectRepository);

  List<ProjectModel> get projects => _projects;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;
  String get selectedDifficulty => _selectedDifficulty;

  List<String> get categories {
    final cats = _projects.map((p) => p.category).toSet().toList();
    cats.sort();
    return ['All', ...cats];
  }

  List<ProjectModel> get filteredProjects {
    return _projects.where((p) {
      final matchesCategory = _selectedCategory == 'All' || p.category == _selectedCategory;
      final matchesDifficulty = _selectedDifficulty == 'All' || p.difficulty == _selectedDifficulty;
      return matchesCategory && matchesDifficulty;
    }).toList();
  }

  Future<void> fetchProjects() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _projects = await _projectRepository.getProjects();
    } catch (e) {
      _errorMessage = 'Failed to load project guides';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void selectDifficulty(String difficulty) {
    _selectedDifficulty = difficulty;
    notifyListeners();
  }

  void toggleSave(String id) {
    notifyListeners();
  }
}
