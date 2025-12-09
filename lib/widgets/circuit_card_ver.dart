import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:CarthagoGuide/constants/theme.dart';

class CircuitCard extends StatelessWidget {
  final AppTheme theme;
  final String title;
  final String duration;
  final String startDestination;
  final String endDestination;
  final String imgUrl;
  final double progress;
  final VoidCallback? onTap;

  const CircuitCard({
    super.key,
    required this.theme,
    required this.title,
    required this.duration,
    required this.startDestination,
    required this.endDestination,
    required this.imgUrl,
    this.progress = 0.7,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isSmall = width < 360;
    final isTablet = width > 700;

    double f(double size) => size * (width / 390);

    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: isTablet ? 1.4 : 0.85,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(f(22)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 4,
                spreadRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(f(22)),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    imgUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: Colors.grey),
                  ),
                ),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                    child: Container(color: Colors.black.withOpacity(0.2)),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          theme.primary.withOpacity(0.2),
                          Colors.black.withOpacity(0.2),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(f(18)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _glassTag(duration, f),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: f(16),
                          height: 1.2,
                          fontWeight: FontWeight.bold,
                          shadows: const [
                            Shadow(color: Colors.black38, blurRadius: 3)
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
      ),
    );
  }

  Widget _glassTag(String text, double Function(double) f) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(f(12)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: f(10), vertical: f(5)),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(f(12)),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: f(13),
            ),
          ),
        ),
      ),
    );
  }
}