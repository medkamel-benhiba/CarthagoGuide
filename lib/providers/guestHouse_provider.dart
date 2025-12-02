import 'package:carthagoguide/models/guestHouse.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class MaisonProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  final Map<String, List<GuestHouse>> _maisonsByDestination = {};
  List<GuestHouse> _allMaisons = [];
  GuestHouse? _selectedMaison;

  List<GuestHouse> get allMaisons => _allMaisons;
  GuestHouse? get selectedMaison => _selectedMaison;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchMaisons() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _allMaisons = await _apiService.getmaisons();
      for (var maison in _allMaisons) {
        final destId = maison.destinationId;
        _maisonsByDestination.putIfAbsent(destId, () => []);
        _maisonsByDestination[destId]!.add(maison);
      }
    } catch (e) {
      _allMaisons = [];
      _errorMessage = "Error fetching maisons: $e";
      debugPrint(_errorMessage);
    }
    _isLoading = false;
    notifyListeners();
  }

  List<GuestHouse> getMaisonsByDestination(String destinationId) {
    return _maisonsByDestination[destinationId] ?? [];
  }

  List<GuestHouse> getMaisonsByDestinationName(String name) {
    return _allMaisons
        .where((m) => m.destination.name.toLowerCase() == name.toLowerCase())
        .toList();
  }

  // fetch maison by slug
  Future<void> fetchMaisonBySlug(String slug) async {
    _isLoading = true;
    notifyListeners();

    // Find the maison in the cache
    try {
      _selectedMaison = _allMaisons.firstWhere(
            (m) => m.slug?.toLowerCase() == slug.toLowerCase(),
        orElse: () => null as GuestHouse,
      );
    } catch (e) {
      _selectedMaison = null;
      _errorMessage = "Erreur fetchMaisonBySlug: $e";
      debugPrint(_errorMessage);
    }

    _isLoading = false;
    notifyListeners();
  }



}
