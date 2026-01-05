import 'package:CarthagoGuide/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../providers/destination_provider.dart';
import '../models/destination.dart';

class ActivityCardWidget extends StatelessWidget {
  final AppTheme theme;
  final String title;
  final String destId;
  final String category;
  final String imgUrl;
  final double rating;
  final VoidCallback onTap;

  const ActivityCardWidget({
    super.key,
    required this.theme,
    required this.title,
    required this.destId,
    required this.category,
    required this.imgUrl,
    this.rating = 0.0,
    required this.onTap,
  });

  String _getDestinationName(BuildContext context, DestinationProvider provider) {
    final Locale currentLocale = Localizations.localeOf(context);
    final Destination? destination = provider.getDestinationById(destId);
    return destination?.getName(currentLocale) ?? "Unknown Location";
  }

  @override
  Widget build(BuildContext context) {
    final destinationProvider = Provider.of<DestinationProvider>(context);
    final destinationName = _getDestinationName(context, destinationProvider);

    const double cardHeight = 180;
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
              color: Colors.black.withOpacity(0.3),
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
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ],
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

            Positioned(
              top: padding,
              right: padding,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: theme.primary.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
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
              bottom: padding,
              left: Directionality.of(context) == TextDirection.ltr ? padding : null,
              right: Directionality.of(context) == TextDirection.rtl ? padding : null,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: Directionality.of(context) == TextDirection.ltr
                    ? [
                  Icon(Icons.location_on, color: Colors.red.withOpacity(0.8), size: 14),
                  const SizedBox(width: 4),
                  Text(
                    destinationName,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ]
                    : [
                  Icon(Icons.location_on, color: Colors.red.withOpacity(0.8), size: 14),
                  const SizedBox(width: 4),
                  Text(
                    destinationName,
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