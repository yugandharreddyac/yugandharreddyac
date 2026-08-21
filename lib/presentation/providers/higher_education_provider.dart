import 'package:flutter/foundation.dart';
import '../../data/models/higher_education_model.dart';
import '../../data/repositories/higher_education_repository.dart';

class HigherEducationProvider extends ChangeNotifier {
  final HigherEducationRepository _repository;

  List<HigherEducationModel> _items = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final Set<String> _savedIds = {};

  HigherEducationProvider(this._repository);

  List<HigherEducationModel> get items => _items;
  List<HigherEducationModel> get higherEducationItems => _items;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  List<String> get categories => const [
        'All',
        'Higher Studies',
        'Government & Public Sector',
      ];

  List<HigherEducationModel> get higherStudiesItems {
    return _items.where((i) => i.category == 'Higher Studies').toList();
  }

  List<HigherEducationModel> get governmentItems {
    return _items
        .where((i) => i.category == 'Government & Public Sector')
        .toList();
  }

  List<HigherEducationModel> get filteredItems {
    return _items.where((item) {
      final matchesCat =
          _selectedCategory == 'All' || item.category == _selectedCategory;
      if (!matchesCat) return false;
      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return item.title.toLowerCase().contains(q) ||
          item.subtitle.toLowerCase().contains(q) ||
          item.overview.toLowerCase().contains(q) ||
          item.category.toLowerCase().contains(q) ||
          item.syllabusTopics.any((t) => t.toLowerCase().contains(q));
    }).toList();
  }

  Future<void> fetchHigherEducationResources() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _items = await _repository.getHigherEducationResources();
    } catch (e) {
      _errorMessage = 'Failed to load higher education resources';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  bool isSaved(String id) => _savedIds.contains(id);

  void toggleSave(String id) {
    if (_savedIds.contains(id)) {
      _savedIds.remove(id);
    } else {
      _savedIds.add(id);
    }
    notifyListeners();
  }
}
