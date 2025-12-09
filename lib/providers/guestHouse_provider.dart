import 'package:flutter/material.dart';
import '../models/guestHouse.dart';
import '../services/api_service.dart';

class GuestHouseProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<GuestHouse> _allMaisons = [];
  List<GuestHouse> get allMaisons => _allMaisons;

  List<GuestHouse> _maisons = [];
  List<GuestHouse> get maisons => _maisons;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final int _pageSize = 10;
  int get pageSize => _pageSize;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  int _totalMaisonsCount = 0;
  int get totalMaisonsCount => _totalMaisonsCount;
  int get totalPages => (_totalMaisonsCount / _pageSize).ceil();

  int? selectedStars;
  String? selectedDestination;
  String searchQuery = "";

  final Map<String, List<GuestHouse>> _maisonsByDestination = {};
  List<GuestHouse> getMaisonsByDestination(String destinationId) => _maisonsByDestination[destinationId] ?? [];

  GuestHouse? _selectedMaison;
  GuestHouse? get selectedMaison => _selectedMaison;

  void setSearchQuery(String query) {
    searchQuery = query;
    _currentPage = 1;
    filterMaisons();
  }

  void setStars(int? stars) {
    selectedStars = stars;
    _currentPage = 1;
    filterMaisons();
  }

  void setDestination(String? destinationName) {
    selectedDestination = destinationName;
    _currentPage = 1;
    filterMaisons();
  }

  Future<void> fetchMaisons() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _allMaisons = await _apiService.getmaisons();
      _maisonsByDestination.clear();
      for (var maison in _allMaisons) {
        final destId = maison.destinationId;
        _maisonsByDestination.putIfAbsent(destId, () => []);
        _maisonsByDestination[destId]!.add(maison);
      }
      filterMaisons();
    } catch (e) {
      _allMaisons = [];
      _errorMessage = "Error fetching maisons: $e";
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterMaisons() {
    List<GuestHouse> filteredList = _allMaisons;

    if (selectedStars != null) {
      filteredList = filteredList
          .where((m) => (double.tryParse(m.noteGoogle) ?? 0.0) >= selectedStars!)
          .toList();
    }

    if (selectedDestination != null && selectedDestination != "Toutes") {
      filteredList = filteredList
          .where((m) => m.destination.name.toLowerCase() == selectedDestination!.toLowerCase())
          .toList();
    }

    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filteredList = filteredList
          .where((m) =>
      m.name.toLowerCase().contains(query) ||
          m.address.toLowerCase().contains(query) ||
          m.destination.name.toLowerCase().contains(query))
          .toList();
    }

    _totalMaisonsCount = filteredList.length;

    loadPage(_currentPage, filteredList: filteredList);

    _isLoading = false;
    notifyListeners();
  }

  void loadPage(int page, {List<GuestHouse>? filteredList}) {
    final listToPaginate = filteredList ?? _allMaisons;

    final startIndex = (page - 1) * _pageSize;
    final endIndex = startIndex + _pageSize;

    if (startIndex >= listToPaginate.length) {
      _maisons = [];
      _currentPage = page;
      _hasMore = false;
      notifyListeners();
      return;
    }

    _maisons = listToPaginate.sublist(
      startIndex,
      endIndex.clamp(0, listToPaginate.length),
    );

    _currentPage = page;
    _hasMore = endIndex < listToPaginate.length;
    notifyListeners();
  }

  // --------------------------------------------------------------------------
  // 🧹 CLEAR FILTERS
  // --------------------------------------------------------------------------
  void clearFilters() {
    selectedStars = null;
    selectedDestination = null;
    searchQuery = "";
    _currentPage = 1;
    filterMaisons();
  }
}