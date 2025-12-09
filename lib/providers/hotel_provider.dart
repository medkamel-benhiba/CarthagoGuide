import 'package:flutter/material.dart';
import '../models/hotel.dart';
import '../models/hotel_details.dart';
import '../services/api_service.dart';

class HotelProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  /// All fetched hotels (raw data from API)
  List<Hotel> _allHotels = [];
  List<Hotel> get allHotels => _allHotels;

  /// Hotels shown on screen after filters + pagination
  List<Hotel> _hotels = [];
  List<Hotel> get hotels => _hotels;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _selectedDestinationId;
  String? get selectedDestinationId => _selectedDestinationId;


  /// Pagination
  int _pageSize = 10;
  int get pageSize => _pageSize;

  /// Hotels matching all active filters
  List<Hotel> _currentlyFilteredHotels = [];
  List<Hotel> get currentlyFilteredHotels => _currentlyFilteredHotels;

  int _currentPage = 1;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  /// Filters
  int? selectedStars;
  String? selectedDestination;
  String searchQuery = "";

  /// Hotel Details
  HotelDetail? _selectedHotel;
  HotelDetail? get selectedHotel => _selectedHotel;

  bool _isLoadingDetail = false;
  bool get isLoadingDetail => _isLoadingDetail;

  String? _errorDetail;
  String? get errorDetail => _errorDetail;

  /// Cached by destination
  final Map<String, List<Hotel>> _hotelsByDestination = {};

  /// Hotels by state (governorate)
  final Map<String, List<Hotel>> _hotelsByState = {};
  String? _currentState;

  List<Hotel> get hotelsByState =>
      _currentState != null ? _hotelsByState[_currentState!] ?? [] : [];

  // ---------------------------------------------------------------------------
  // 🚀 FETCH ALL HOTELS
  // ---------------------------------------------------------------------------
  Future<void> fetchAllHotels() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      _allHotels = await _apiService.gethotels();

      // Set initial filtered list to all hotels
      _currentlyFilteredHotels = _allHotels;

      // First page
      _hotels = _currentlyFilteredHotels.take(_pageSize).toList();

      _currentPage = 1;
      _hasMore = _hotels.length < _currentlyFilteredHotels.length;

    } catch (e) {
      _allHotels = [];
      _currentlyFilteredHotels = []; // Must clear this too
      _hotels = [];
      debugPrint("❌ Error fetching hotels: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // 🔎 SEARCH + FILTERS
  // ---------------------------------------------------------------------------
  void setSearchQuery(String value) {
    searchQuery = value.trim().toLowerCase();
    applyFilters();
  }

  void setStars(int? stars) {
    selectedStars = stars;
    applyFilters();
  }

  void setDestination(String? destination) {
    selectedDestination = destination;
    applyFilters();
  }

  void filterByDestination(String destinationId) {
    _selectedDestinationId = destinationId;
    applyFilters();
  }


  // Apply search + stars + destination
  void applyFilters() {
    _currentlyFilteredHotels = _allHotels.where((hotel) {
      final matchesSearch = hotel.name.toLowerCase().contains(searchQuery) ||
          (hotel.destinationName?.toLowerCase().contains(searchQuery) ?? false);

      final matchesStars =
          selectedStars == null ||
              (hotel.categoryCode?.toInt() ?? 0) == selectedStars;

      // 🔥 Correction ici : utiliser _selectedDestinationId si défini
      final matchesDestinationId =
          _selectedDestinationId == null ||
              hotel.destinationId == _selectedDestinationId;

      final matchesDestination =
          selectedDestination == null ||
              hotel.destinationName == selectedDestination;

      return matchesSearch &&
          matchesStars &&
          matchesDestination &&
          matchesDestinationId;
    }).toList();

    _currentPage = 1;
    _hasMore = _currentlyFilteredHotels.length > _pageSize;

    _hotels = _currentlyFilteredHotels.take(_pageSize).toList();

    notifyListeners();
  }


  /// Add a method to reinitialize filters
  void clearFilters() {
    selectedStars = null;
    selectedDestination = null;
    _selectedDestinationId = null;
    searchQuery = "";
    applyFilters();
  }

  // ---------------------------------------------------------------------------
  // 📄 PAGINATION
  // ---------------------------------------------------------------------------
  void loadMoreHotels() {
    if (!_hasMore || _isLoading) return;

    // Load more from the CURRENTLY FILTERED list
    final next = _currentlyFilteredHotels
        .skip(_currentPage * _pageSize)
        .take(_pageSize)
        .toList();

    if (next.isEmpty) {
      _hasMore = false;
    } else {
      _hotels.addAll(next);
      _currentPage++;
    }

    notifyListeners();
  }

  /// Load a specific page index
  void loadPage(int page) {
    final start = (page - 1) * _pageSize;
    // Use the currently filtered list length for bounds
    final filteredLength = _currentlyFilteredHotels.length;

    if (start >= filteredLength) return;

    final end = start + _pageSize;

    // Load from the currently filtered list
    _hotels = _currentlyFilteredHotels.sublist(
      start,
      end > filteredLength ? filteredLength : end,
    );

    _currentPage = page;
    _hasMore = _hotels.length < filteredLength;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // 🌍 FILTER BY DESTINATION CACHE
  // ---------------------------------------------------------------------------
  List<Hotel> getHotelsByDestination(String destId) {
    print("hotels by destinations : $destId ");
    return _hotelsByDestination[destId] ?? [];

  }

  void setHotelsByDestination(String? destId) {
    _hotels = _hotelsByDestination[destId] ?? [];
    notifyListeners();
  }

  String? getDestinationIdByCity(String cityName) {
    try {
      return _allHotels.firstWhere(
            (hotel) =>
        hotel.destinationName?.toLowerCase() == cityName.toLowerCase(),
      ).destinationId;
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // 🏨 HOTEL DETAILS
  // ---------------------------------------------------------------------------
  Future<void> fetchHotelDetail(String slug) async {
    _isLoadingDetail = true;
    _errorDetail = null;
    notifyListeners();

    try {
      final detail = await _apiService.gethoteldetail(slug);
      if (detail != null) {
        _selectedHotel = detail;
      } else {
        _errorDetail = "Hotel details not found.";
      }
    } catch (e) {
      _errorDetail = "Error: $e";
    }

    _isLoadingDetail = false;
    notifyListeners();
  }

  void clearSelectedHotel() {
    _selectedHotel = null;
    _errorDetail = null;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // 🗺 HOTELS BY STATE
  // ---------------------------------------------------------------------------
  Future<void> fetchHotelsByState(String state) async {
    _isLoading = true;
    _currentState = state;
    notifyListeners();

    try {
      final hotels = await _apiService.getHotelsByState(state);
      _hotelsByState[state] = hotels;
      _hotels = hotels;
    } catch (e) {
      _hotels = [];
      _hotelsByState[state] = [];
      debugPrint("❌ Error fetching hotels by state '$state': $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  List<Hotel> getCurrentStateHotels() {
    if (_currentState == null) return [];
    return _hotelsByState[_currentState!] ?? [];
  }
}
