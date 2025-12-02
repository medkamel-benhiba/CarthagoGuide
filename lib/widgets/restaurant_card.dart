import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carthagoguide/constants/theme.dart';

class RestaurantCardWidget extends StatelessWidget {
  final String title;
  final String location;
  final String imgUrl;
  final double rating;
  final VoidCallback onTap;

  const RestaurantCardWidget({
    super.key,
    required this.title,
    required this.location,
    required this.imgUrl,
    required this.rating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = Provider.of<ThemeProvider>(context).currentTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: theme.CardBG,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: theme.text.withOpacity(0.08),
              blurRadius: 13,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.asset(
                imgUrl,
                height: 130, // Taller image for the vertical card
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // 2. Details Section (Bottom)
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: theme.text,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Rating & Cuisine Row
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 18,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            rating.toStringAsFixed(1),
                            style: TextStyle(
                              color: theme.text,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Title
                  const SizedBox(height: 8),

                  // Location Row
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: theme.primary.withOpacity(0.8),
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        location,
                        style: TextStyle(
                          color: theme.text.withOpacity(0.8),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
