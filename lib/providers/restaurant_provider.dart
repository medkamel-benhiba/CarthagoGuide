import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../services/api_service.dart';

class RestaurantProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  // All restaurants from API
  List<Restaurant> _allRestaurants = [];
  List<Restaurant> get allRestaurants => _allRestaurants;

  // Paginated / filtered restaurants
  List<Restaurant> _restaurants = [];
  List<Restaurant> get restaurants => _restaurants;

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

  int _totalRestaurantsCount = 0;
  int get totalRestaurantsCount => _totalRestaurantsCount;
  int get totalPages => (_totalRestaurantsCount / _pageSize).ceil();

  // Filters
  String _searchQuery = "";
  String? _currentState;
  double? _minRating;

  String get searchQuery => _searchQuery;
  String? get currentState => _currentState;
  double? get minRating => _minRating;

  final Map<String, List<Restaurant>> _restaurantsByDestination = {};
  List<Restaurant> getRestaurantsByDestination(String destinationId) =>
      _restaurantsByDestination[destinationId] ?? [];

  Restaurant? _selectedRestaurant;
  Restaurant? get selectedRestaurant => _selectedRestaurant;

  // --------------------------------------------------------------------------
  // Fetch all restaurants
  // --------------------------------------------------------------------------
  Future<void> fetchRestaurants() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allRestaurants = await _apiService.getAllRestaurants();

      // Cache by destination
      _restaurantsByDestination.clear();
      for (var r in _allRestaurants) {
        final destId = r.destinationId?.toString() ?? 'unknown';
        _restaurantsByDestination.putIfAbsent(destId, () => []);
        _restaurantsByDestination[destId]!.add(r);
      }

      _currentPage = 1;
      _applyFiltersAndPagination();

    } catch (e) {
      _allRestaurants = [];
      _restaurants = [];
      _errorMessage = "Error fetching restaurants: $e";
      _isLoading = false;
      notifyListeners();
    }
  }

  // --------------------------------------------------------------------------
  // Filters setters
  // --------------------------------------------------------------------------
  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _currentPage = 1;
    _applyFiltersAndPagination();
  }

  void setStateFilter(String? state) {
    _currentState = state;
    _currentPage = 1;
    _applyFiltersAndPagination();
  }

  void setMinRating(double? rating) {
    _minRating = rating;
    _currentPage = 1;
    _applyFiltersAndPagination();
  }

  void clearFilters() {
    _searchQuery = "";
    _currentState = null;
    _minRating = null;
    _currentPage = 1;
    _applyFiltersAndPagination();
  }

  // --------------------------------------------------------------------------
  // Pagination
  // --------------------------------------------------------------------------
  void loadPage(int page) {
    _currentPage = page;
    _applyFiltersAndPagination();
  }

  // --------------------------------------------------------------------------
  // Apply filters + paginate
  // --------------------------------------------------------------------------
  void _applyFiltersAndPagination() {
    List<Restaurant> filtered = List.from(_allRestaurants);

    // Filter by state
    if (_currentState != null) {
      filtered = filtered
          .where((r) =>
      r.destinationName?.toLowerCase() ==
          _currentState!.toLowerCase())
          .toList();
    }

    // Filter by min rating
    if (_minRating != null) {
      filtered = filtered
          .where((r) => (r.rate is num ? r.rate.toDouble() : 0.0) >= _minRating!)
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((r) {
        final name = r.getName(const Locale("fr")).toLowerCase();
        return name.contains(_searchQuery);
      }).toList();
    }

    _totalRestaurantsCount = filtered.length;

    // Pagination
    final startIndex = (_currentPage - 1) * _pageSize;
    final endIndex = startIndex + _pageSize;

    if (startIndex >= filtered.length) {
      _restaurants = [];
      _hasMore = false;
    } else {
      _restaurants = filtered.sublist(
        startIndex,
        endIndex.clamp(0, filtered.length),
      );
      _hasMore = endIndex < filtered.length;
    }

    _isLoading = false;
    notifyListeners();
  }

  // --------------------------------------------------------------------------
  // Select restaurant by slug
  // --------------------------------------------------------------------------
  Future<void> selectRestaurantBySlug(String slug) async {
    final i = _allRestaurants.indexWhere(
          (r) => r.slug?.toLowerCase() == slug.toLowerCase(),
    );
    _selectedRestaurant = i != -1 ? _allRestaurants[i] : null;
    notifyListeners();
  }
}
