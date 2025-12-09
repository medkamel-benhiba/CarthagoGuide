import 'package:CarthagoGuide/constants/theme.dart';
import 'package:CarthagoGuide/models/destination.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeDestCard extends StatefulWidget {
  final Destination destination;
  final bool showText;
  final VoidCallback? onTap;

  const HomeDestCard({
    Key? key,
    required this.destination,
    this.onTap,
    this.showText = true,
  }) : super(key: key);

  @override
  State<HomeDestCard> createState() => _HomeDestCardState();
}

class _HomeDestCardState extends State<HomeDestCard> {
  @override
  Widget build(BuildContext context) {
    final AppTheme theme = Provider.of<ThemeProvider>(context).currentTheme;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  widget.destination.gallery.first,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported, size: 50),
                    );
                  },
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(widget.showText ? 0.35 : 0.5),
                        Colors.black.withOpacity(widget.showText ? 0.6 : 0.7),
                      ],
                      stops: const [0.3, 1.0],
                    ),
                  ),
                ),
              ),
              if (widget.showText)
                Positioned(
                  left: 35,
                  right: 35,
                  top: 20,
                  bottom: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              /*Icon(
                                Icons.location_on,
                                size: 22,
                                color: theme.primary,
                                shadows: [
                                  Shadow(
                                    blurRadius: 4.0,
                                    color: Colors.white.withOpacity(0.6),
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),*/
                              Text(
                                '|',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: theme.primary,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 4.0,
                                      color: Colors.white.withOpacity(0.6),
                                      offset: Offset(1, 0),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  widget.destination.name,
                                  textAlign: TextAlign.center,
                                  style:  TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                    height: 1.2,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 4.0,
                                        color: Colors.white.withOpacity(0.2),
                                        offset: Offset(-5, -10),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),/*
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  widget.onTap?.call();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                  Colors.white.withOpacity(0.3),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Text(
                                  'Détails',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ),
                            ],
                          ),*/
                        ],
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