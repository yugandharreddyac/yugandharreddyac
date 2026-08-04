import 'package:flutter/foundation.dart';
import '../../data/models/career_model.dart';
import '../../data/repositories/career_repository.dart';

class CareerProvider extends ChangeNotifier {
  final CareerRepository _careerRepository;

  List<CareerModel> _technologies = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedCategory = 'All';

  CareerProvider(this._careerRepository);

  List<CareerModel> get technologies => _technologies;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;

  List<String> get categories {
    final cats = _technologies.map((t) => t.category).toSet().toList();
    cats.sort();
    return ['All', ...cats];
  }

  List<CareerModel> get filteredTechnologies {
    if (_selectedCategory == 'All') return _technologies;
    return _technologies.where((t) => t.category == _selectedCategory).toList();
  }

  Future<void> fetchCareerTechnologies() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _technologies = await _careerRepository.getCareerTechnologies();
    } catch (e) {
      _errorMessage = 'Failed to load career technologies';
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
