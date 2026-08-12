import 'package:flutter/foundation.dart';
import '../../data/models/beyond_academics_model.dart';
import '../../data/repositories/emerging_tech_repository.dart';

class EmergingTechProvider extends ChangeNotifier {
  final EmergingTechRepository _repository;

  List<EmergingTechDetailModel> _items = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  EmergingTechProvider(this._repository);

  List<EmergingTechDetailModel> get items => _items;
  List<EmergingTechDetailModel> get emergingTechItems => _items;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  List<String> get categories {
    final cats = _items.map((i) => i.category).toSet().toList();
    cats.sort();
    return ['All', ...cats];
  }

  List<EmergingTechDetailModel> get filteredItems {
    return _items.where((item) {
      final matchesCategory = _selectedCategory == 'All' || item.category == _selectedCategory;
      if (!matchesCategory) return false;

      if (_searchQuery.trim().isEmpty) return true;

      final query = _searchQuery.toLowerCase();
      final titleMatch = item.title.toLowerCase().contains(query);
      final catMatch = item.category.toLowerCase().contains(query);
      final overviewMatch = item.overview.toLowerCase().contains(query);
      final toolsMatch = item.tools.any((t) => t.toLowerCase().contains(query));
      final coreMatch = item.coreConcepts.any((c) => c.toLowerCase().contains(query));

      return titleMatch || catMatch || overviewMatch || toolsMatch || coreMatch;
    }).toList();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> fetchEmergingTechs() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _items = await _repository.getEmergingTechs();
    } catch (e) {
      _errorMessage = 'Failed to load emerging technologies';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
