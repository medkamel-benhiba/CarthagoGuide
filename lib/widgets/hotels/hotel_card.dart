import 'package:flutter/material.dart';
import 'package:carthagoguide/constants/theme.dart';

class HotelCardWidget extends StatelessWidget {
  final AppTheme theme;
  final String title;
  final String destination;
  final String imgUrl;
  final double rating;
  final int price;

  final VoidCallback onTap;

  const HotelCardWidget({
    super.key,
    required this.theme,
    required this.title,
    required this.destination,
    required this.imgUrl,
    required this.rating,
    required this.price,
    required this.onTap,
  });

  // Calculate the number of filled stars (clamped between 1 and 5)
  int get starCount => rating.round().clamp(1, 5);

  @override
  Widget build(BuildContext context) {
    const double cardHeight = 220;
    const double borderRadius = 16;
    const double padding = 16;

    return GestureDetector(
      // ⭐️ FIX: Use the external onTap callback
      onTap: onTap,

      child: Container(
        height: cardHeight,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 1. Background image
            ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Image.asset(
                imgUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                  ),
                ),
              ),
            ),

            // 2. Gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    theme.primary.withOpacity(0.7),
                  ],
                  stops: const [0.3, 1.0],
                ),
              ),
            ),

            // 4. Hotel Name (Title)
            Positioned(
              left: padding,
              bottom: 40,
              right: padding,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // 5. Location / Star Rating Row
            Positioned(
              left: padding,
              bottom: padding,
              child: Row(
                children: [
                  // Stars rating
                  ...List.generate(
                    starCount,
                        (index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                  ),
                  // Border stars to complete 5 total
                  ...List.generate(
                    5 - starCount,
                        (index) => Icon(
                      Icons.star_border,
                      color: Colors.white.withOpacity(0.6),
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Location Icon and Text (Address)
                  Icon(
                    Icons.location_on,
                    color: Colors.white.withOpacity(0.8),
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    destination,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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