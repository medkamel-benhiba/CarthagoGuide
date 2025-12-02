import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../services/api_service.dart';

class RestaurantProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  final Map<String, List<Restaurant>> _restaurantsByDestination = {};

  List<Restaurant> allRestaurants = [];
  List<Restaurant> _restaurants = [];
  List<Restaurant> get restaurants => _restaurants;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Restaurant? _selectedRestaurant;
  Restaurant? get selectedRestaurant => _selectedRestaurant;
  final Map<String, List<Restaurant>> _restaurantsByState = {};
  List<Restaurant> get restaurantsByState =>
      _currentState != null ? _restaurantsByState[_currentState!] ?? [] : [];
  String? _currentState;



  // ** fetch all restaurants
  Future<void> fetchAllRestaurants() async {
    _isLoading = true;
    notifyListeners();

    try {
      allRestaurants = await _apiService.getAllRestaurants();
      // Pre-cache per destination
      for (var r in allRestaurants) {
        final destId = r.destinationId?.toString() ?? 'unknown';
        _restaurantsByDestination.putIfAbsent(destId, () => []);
        _restaurantsByDestination[destId]!.add(r);
      }
    } catch (e) {
      allRestaurants = [];
      debugPrint("Error fetching restaurants: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // get restaurant by destination from cache
  void setRestaurantsByDestination(String destinationId) {
    _restaurants = _restaurantsByDestination[destinationId] ?? [];
    notifyListeners();
  }

  //  get restaurants by destination
  List<Restaurant> getRestaurantsByDestination(String destinationId) {
    return _restaurantsByDestination[destinationId] ?? [];
  }

  Future<void> selectRestaurantBySlug(String slug) async {
    final i = allRestaurants.indexWhere(
          (r) => r.slug?.toLowerCase() == slug.toLowerCase(),
    );
    _selectedRestaurant = i != -1 ? allRestaurants[i] : null;
    notifyListeners();
  }


  //restaurants by state
  Future<void> fetchRestaurantsByState(String state) async {
    _isLoading = true;
    _currentState = state;
    notifyListeners();

    try {
      final restaurants = await _apiService.getRestaurantsByState(state);
      _restaurantsByState[state] = restaurants;
      _restaurants = restaurants;
    } catch (e) {
      debugPrint("Error fetching restaurants by state $state: $e");
      _restaurants = [];
      _restaurantsByState[state] = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // restaurants by current state
  List<Restaurant> getCurrentStateRestaurants() {
    if (_currentState == null) return [];
    return _restaurantsByState[_currentState!] ?? [];
  }




}
