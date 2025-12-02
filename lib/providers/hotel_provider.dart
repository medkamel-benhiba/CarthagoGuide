import 'package:flutter/material.dart';
import '../models/hotel.dart';
import '../models/hotel_details.dart';
import '../services/api_service.dart';

class HotelProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  /// Cached hotels per destination
  final Map<String, List<Hotel>> _hotelsByDestination = {};

  /// All fetched hotels
  List<Hotel> _allHotels = [];
  List<Hotel> get allHotels => _allHotels;

  /// Current displayed hotels
  List<Hotel> _hotels = [];
  List<Hotel> get hotels => _hotels;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  HotelDetail? _selectedHotel;
  HotelDetail? get selectedHotel => _selectedHotel;

  bool _isLoadingDetail = false;
  bool get isLoadingDetail => _isLoadingDetail;

  String? _errorDetail;
  String? get errorDetail => _errorDetail;


  //optimised for pagination
  List<dynamic> _searchResults = [];
  List<dynamic> get searchResults => _searchResults;

  bool _hasMoreSearchResults = true;
  bool get hasMoreSearchResults => _hasMoreSearchResults;

  bool _isInitialSearchLoading = false;
  bool get isInitialSearchLoading => _isInitialSearchLoading;

  bool _isLoadingMoreResults = false;
  bool get isLoadingMoreResults => _isLoadingMoreResults;


  final Map<String, List<Hotel>> _hotelsByState = {};
  List<Hotel> get hotelsByState => _currentState != null ? _hotelsByState[_currentState!] ?? [] : [];
  String? _currentState;


  // ===== Fetch all hotels =====
  Future<void> fetchAllHotels() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allHotels = await _apiService.gethotels();
      // Pre-cache per destination
      for (var hotel in _allHotels) {
        final destId = hotel.destinationId;
        if (!_hotelsByDestination.containsKey(destId)) {
          _hotelsByDestination[destId] = [];
        }
        _hotelsByDestination[destId]!.add(hotel);
      }
    } catch (e) {
      _allHotels = [];
      debugPrint("Error fetching hotels: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // ===== Get hotels by destination from cache =======
  void setHotelsByDestination(String? destinationId) {
    _hotels = _hotelsByDestination[destinationId] ?? [];
    notifyListeners();
  }

  // ===== Fetch hotel details =====
  Future<void> fetchHotelDetail(String slug) async {
    _isLoadingDetail = true;
    _errorDetail = null;
    notifyListeners();

    try {
      final detail = await _apiService.gethoteldetail(slug);
      if (detail != null) {
        _selectedHotel = detail;
      } else {
        _errorDetail = "Hotel details not found";
        _selectedHotel = null;
      }
    } catch (e) {
      _errorDetail = e.toString();
      _selectedHotel = null;
      debugPrint("Error fetching hotel detail: $e");
    }

    _isLoadingDetail = false;
    notifyListeners();
  }

  // ===== Get hotels by destination from cache =====
  List<Hotel> getHotelsByDestination(String destinationId) {
    return _hotelsByDestination[destinationId] ?? [];
  }

  // ===== Clear selected hotel =====
  void clearSelectedHotel() {
    _selectedHotel = null;
    _errorDetail = null;
    notifyListeners();
  }

  // ===== Get destination ID by city name =====
  String? getDestinationIdByCity(String cityName) {
    try {
      return _allHotels.firstWhere(
            (hotel) => hotel.destinationName?.toLowerCase() == cityName.toLowerCase(),
      ).destinationId;
    } catch (e) {
      return null;
    }
  }


// 🚀 RESET SEARCH
  void resetSearch() {
    _searchResults.clear();
    _hasMoreSearchResults = true;
    _isInitialSearchLoading = false;
    _isLoadingMoreResults = false;
    notifyListeners();
  }

  //hotels by state
  Future<void> fetchHotelsByState(String state) async {
    _isLoading = true;
    _currentState = state;
    notifyListeners();

    try {
      debugPrint("🔍 Fetching hotels for state: '$state'");
      final hotels = await _apiService.getHotelsByState(state);
      debugPrint("✅ Received ${hotels.length} hotels for state: '$state'");

      _hotelsByState[state] = hotels;
      _hotels = hotels;
    } catch (e) {
      debugPrint("❌ Error fetching hotels by state '$state': $e");
      _hotels = [];
      _hotelsByState[state] = [];
    }

    _isLoading = false;
    notifyListeners();
  }


// hotels by current state
  List<Hotel> getCurrentStateHotels() {
    if (_currentState == null) return [];
    return _hotelsByState[_currentState!] ?? [];
  }


}