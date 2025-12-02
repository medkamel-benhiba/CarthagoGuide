import 'package:flutter/material.dart';
import 'package:carthagoguide/constants/theme.dart';

class CircuitCard extends StatelessWidget {
  final AppTheme theme;
  final String title;
  final String subtitle;
  final String imgUrl;
  final VoidCallback? onTap;
  final bool fullWidth;

  const CircuitCard({
    super.key,
    required this.theme,
    required this.title,
    required this.subtitle,
    required this.imgUrl,
    this.onTap,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    double cardWidth = fullWidth ? double.infinity : 250;

    return Container(
      width: cardWidth,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Image background
              AspectRatio(
                aspectRatio: fullWidth ? 1.6 : 1.3,
                child: Image.asset(
                  imgUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),

              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.primary.withOpacity(0.93),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                    ),
                  ),
                ),
              ),

              // Text on top of image
              Positioned(
                left: 15,
                right: 15,
                bottom: 15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.6),
                            offset: const Offset(1, 1),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.6),
                            offset: const Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
