import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  String _query = "";
  String get query => _query;

  void updateQuery(String value) {
    _query = value.toLowerCase().trim();
    notifyListeners();
  }

  void clear() {
    _query = "";
    notifyListeners();
  }
}
