// /utils/voyage_data_mapper.dart

import 'package:flutter/material.dart';
import 'package:CarthagoGuide/models/voyage.dart';

// Helper function to convert Voyage model to circuit card data for presentation
Map<String, dynamic> voyageToCircuitCardData(Voyage voyage, Locale locale) {
  // Get the duration from the number field (assuming it represents days)
  final duration = voyage.number.isNotEmpty
      ? '${voyage.number} ${locale.languageCode == 'fr' ? 'jours' : 'days'}'
      : '3 jours';

  // Extract destinations from the name
  final name = voyage.name;
  String startDest = 'Tunis';
  String endDest = 'Various';

  // Try to extract destinations from voyage name
  if (name.contains(' - ')) {
    final parts = name.split(' - ');
    if (parts.length >= 2) {
      endDest = parts.last.split(':').first.trim();
    }
  } else if (name.toLowerCase().contains('djerba')) {
    endDest = 'Djerba';
  } else if (name.toLowerCase().contains('douz')) {
    endDest = 'Douz';
  } else if (name.toLowerCase().contains('tozeur')) {
    endDest = 'Tozeur';
  } else if (name.toLowerCase().contains('tabarka')) {
    endDest = 'Tabarka';
  }

  final subtitle = '$duration | $startDest, $endDest';

  return {
    'id': voyage.id,
    'title': name,
    'subtitle': subtitle,
    'image': voyage.images.isNotEmpty ? voyage.images.first : 'assets/images/circuit1.jpg',
  };
}