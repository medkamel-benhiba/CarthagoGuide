import 'package:flutter/material.dart';
import 'package:CarthagoGuide/constants/theme.dart';

class CategoryRowWidget extends StatelessWidget {
  final AppTheme theme;
  final VoidCallback? onDestinationsTap;
  final VoidCallback? onHotelsTap;
  final VoidCallback? onRestaurantsTap;
  final VoidCallback? onCircuitsTap;

  const CategoryRowWidget({
    super.key,
    required this.theme,
    this.onDestinationsTap,
    this.onHotelsTap,
    this.onRestaurantsTap,
    this.onCircuitsTap,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'icon': Icons.location_on,
        'label': 'Destinations',
        'onTap': onDestinationsTap,
      },
      {
        'icon': Icons.hotel,
        'label': 'Hotels',
        'onTap': onHotelsTap,
      },
      {
        'icon': Icons.restaurant,
        'label': 'Restaurants',
        'onTap': onRestaurantsTap,
      },
      {
        'icon': Icons.map,
        'label': 'Circuits',
        'onTap': onCircuitsTap,
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categories
          .map(
            (cat) => GestureDetector(
          onTap: cat['onTap'] as VoidCallback?,
          child: Column(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: theme.surface,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  cat['icon'] as IconData,
                  color: theme.primary,
                  size: 26,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                cat['label'] as String,
                style: TextStyle(
                  color: theme.text.withOpacity(0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      )
          .toList(),
    );
  }
}