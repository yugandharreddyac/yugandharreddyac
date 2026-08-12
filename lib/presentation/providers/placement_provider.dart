import 'package:flutter/foundation.dart';
import '../../data/models/placement_model.dart';
import '../../data/repositories/placement_repository.dart';

class PlacementProvider extends ChangeNotifier {
  final PlacementRepository _placementRepository;

  List<PlacementModel> _items = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedCategory = 'All';

  PlacementProvider(this._placementRepository);

  List<PlacementModel> get items => _items;
  List<PlacementModel> get resources => _items;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;

  List<String> get categories {
    final cats = _items.map((i) => i.category).toSet().toList();
    cats.sort();
    return ['All', ...cats];
  }

  List<PlacementModel> get filteredItems {
    if (_selectedCategory == 'All') return _items;
    return _items.where((i) => i.category == _selectedCategory).toList();
  }

  List<PlacementModel> get filteredResources => filteredItems;

  void toggleSave(String id) {
    notifyListeners();
  }

  Future<void> fetchPlacementResources() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _items = await _placementRepository.getPlacementResources();
    } catch (e) {
      _errorMessage = 'Failed to load placement resources';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
