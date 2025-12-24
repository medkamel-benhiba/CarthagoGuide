import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:CarthagoGuide/constants/theme.dart';

class HotelCardWidget extends StatelessWidget {
  final AppTheme theme;
  final String title;
  final String destination;
  final String imgUrl;
  final double rating;
  final bool? isHotel;

  final VoidCallback onTap;

  const HotelCardWidget({
    super.key,
    required this.theme,
    required this.title,
    required this.destination,
    required this.imgUrl,
    required this.rating,
    required this.onTap,
    this.isHotel,
  });

  int get starCount => rating.round().clamp(1, 5);

  @override
  Widget build(BuildContext context) {
    const double cardHeight = 220;
    const double borderRadius = 16;
    const double padding = 16;

    return GestureDetector(
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
            CachedNetworkImage(
              imageUrl: imgUrl,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    gradient: LinearGradient(
                      colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                    ),
                  ),
                  padding: const EdgeInsets.all(15),
                ),
              ),
              placeholder: (context, url) => Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
              ),
            ),

            // 2. Bottom Gradient Overlay
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

            // 3. Stars rating
            if (isHotel != false)
              Positioned(
                top: padding,
                right: padding,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Filled Stars
                      ...List.generate(
                        starCount,
                            (index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 14,
                        ),
                      ),
                      // Bordered Stars
                      ...List.generate(
                        5 - starCount,
                            (index) => Icon(
                          Icons.star_border,
                          color: Colors.white.withOpacity(0.6),
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

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

            Positioned(
              left: padding,
              right: padding,
              bottom: padding,
              child: Row(
                mainAxisAlignment: Directionality.of(context) == TextDirection.rtl
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.white.withOpacity(0.8),
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      destination,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: Directionality.of(context) == TextDirection.rtl
                          ? TextAlign.right
                          : TextAlign.left,
                    ),
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