import 'package:flutter/material.dart';
import 'package:carthagoguide/constants/theme.dart';

class CategoryRowWidget extends StatelessWidget {
  final AppTheme theme;

  const CategoryRowWidget({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'icon': Icons.location_on, 'label': 'Destinations'},
      {'icon': Icons.hotel, 'label': 'Hotels'},
      {'icon': Icons.restaurant, 'label': 'Restaurants'},
      {'icon': Icons.map, 'label': 'Circuits'},

    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categories
          .map(
            (cat) => Column(
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
      )
          .toList(),
    );
  }
}