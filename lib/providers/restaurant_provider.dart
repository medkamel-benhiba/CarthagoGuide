import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../services/api_service.dart';

class RestaurantProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Restaurant> _allRestaurants = [];
  List<Restaurant> get allRestaurants => _allRestaurants;

  List<Restaurant> _restaurants = [];
  List<Restaurant> get restaurants => _restaurants;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final int _pageSize = 15;
  int get pageSize => _pageSize;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  // Pagination state
  int _lastFetchedPage = 0;
  bool _hasMorePages = true;
  bool get hasMorePages => _hasMorePages;

  String? _errorDetail;
  String? get errorDetail => _errorDetail;


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

  // ---------------------------------------------------------------------------
  Future<void> fetchAllRestaurants() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorDetail = null;
    _allRestaurants = [];
    _currentPage = 1;
    _lastFetchedPage = 0;
    _hasMorePages = true;
    notifyListeners();

    try {
      final fetchedRestaurants = await _apiService.getRestaurants(page: 1);
      _allRestaurants = fetchedRestaurants;
      _lastFetchedPage = 1;

      if (fetchedRestaurants.length < 15) {
        _hasMorePages = false;
      }

      _applyFiltersAndPagination();

    } catch (e) {
      _errorDetail = "Failed to load restaurants: $e";
      _allRestaurants = [];
      debugPrint("❌ Error fetching restaurants: $e");
    }

    _isLoading = false;
    notifyListeners();
  }


  // ---------------------------------------------------------------------------
  Future<void> loadMoreFromAPI() async {
    if (_isLoading || !_hasMorePages) return;

    _isLoading = true;
    notifyListeners();

    try {
      final nextPage = _lastFetchedPage + 1;
      final nextRestaurants = await _apiService.getRestaurants(page: nextPage);

      if (nextRestaurants.isEmpty || nextRestaurants.length < 15) {
        _hasMorePages = false;
      }

      if (nextRestaurants.isNotEmpty) {
        _allRestaurants.addAll(nextRestaurants);
        _lastFetchedPage = nextPage;
        _applyFiltersAndPagination();
      }
    } catch (e) {
      debugPrint("❌ Error loading more restaurants: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // Filters setters
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

  // Pagination
  // --------------------------------------------------------------------------
  void loadPage(int page) {
    _currentPage = page;
    _applyFiltersAndPagination();
  }

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
