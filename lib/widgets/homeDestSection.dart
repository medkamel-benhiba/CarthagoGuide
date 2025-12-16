import 'dart:async';
import 'package:CarthagoGuide/models/destination.dart';
import 'package:CarthagoGuide/screens/destinationDetails_screen.dart';
import 'package:CarthagoGuide/widgets/homeDestCard.dart';
import 'package:flutter/material.dart';

class NearbyDestinationSection extends StatefulWidget {
  final List<Destination> destinations;
  final VoidCallback? onMenuTap;

  const NearbyDestinationSection({
    Key? key,
    required this.destinations,
    this.onMenuTap,
  }) : super(key: key);

  @override
  State<NearbyDestinationSection> createState() =>
      _NearbyDestinationSectionState();
}

class _NearbyDestinationSectionState extends State<NearbyDestinationSection> {
  int currentIndex = 0;
  Timer? _timer;
  final Duration _autoScrollDuration = const Duration(seconds: 5);

  void _startAutoScroll() {
    if (widget.destinations.length > 1) {
      _timer = Timer.periodic(_autoScrollDuration, (Timer timer) {
        setState(() {
          currentIndex = (currentIndex + 1) % widget.destinations.length;
        });
      });
    }
  }

  void _stopAutoScroll() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _stopAutoScroll();
    super.dispose();
  }

  void _navigateToDetails(BuildContext context, Destination destination) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DestinationDetailsScreen(
          title: destination.name,
          description: destination.descriptionMobile ?? "",
          gallery: destination.gallery,
          destinationId: destination.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.destinations.isEmpty) {
      _stopAutoScroll();
      return const SizedBox.shrink();
    }

    if (widget.destinations.length <= 1 && _timer != null) {
      _stopAutoScroll();
    } else if (widget.destinations.length > 1 && _timer == null) {
      _startAutoScroll();
    }

    final bool hasNext = currentIndex < widget.destinations.length - 1;
    final bool hasNextNext = currentIndex < widget.destinations.length - 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: SizedBox(
            height: 180,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                if (widget.destinations.length > 2)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 10,
                    height: 180,
                    child: SizedBox(
                      width: double.infinity,
                      height: 250,
                      child: Opacity(
                        opacity: 0.25,
                        child: HomeDestCard(
                          destination:
                              widget.destinations[(currentIndex + 2) %
                                  widget.destinations.length],
                          showText: false,
                        ),
                      ),
                    ),
                  ),

                if (widget.destinations.length > 1)
                  Positioned(
                    left: 0,
                    right: 30,
                    top: 10,
                    height: 180,
                    child: SizedBox(
                      width: double.infinity,
                      height: 250,
                      child: Opacity(
                        opacity: 0.45,
                        child: HomeDestCard(
                          destination:
                              widget.destinations[(currentIndex + 1) %
                                  widget.destinations.length],
                          showText: false,
                        ),
                      ),
                    ),
                  ),

                Positioned(
                  left: 0,
                  right: 60,
                  top: 10,
                  height: 180,
                  child: GestureDetector(
                    onHorizontalDragStart: (_) => _stopAutoScroll(),
                    onHorizontalDragEnd: (details) {
                      _startAutoScroll();
                      const double minVelocity = 600;

                      if (details.primaryVelocity! > minVelocity) {
                        if (currentIndex > 0) {
                          setState(() {
                            currentIndex--;
                          });
                        } else {
                          setState(() {
                            currentIndex = widget.destinations.length - 1;
                          });
                        }
                      } else if (details.primaryVelocity! < -minVelocity) {
                        if (currentIndex < widget.destinations.length - 1) {
                          setState(() {
                            currentIndex++;
                          });
                        } else {
                          setState(() {
                            currentIndex = 0;
                          });
                        }
                      }
                    },
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: SizedBox(
                        key: ValueKey(currentIndex),
                        width: double.infinity,
                        height: 280,
                        child: HomeDestCard(
                          destination: widget.destinations[currentIndex],
                          onTap: () => _navigateToDetails(
                            context,
                            widget.destinations[currentIndex],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),

        if (widget.destinations.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.destinations.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentIndex == index ? 12 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? const Color(0xFF2D3142)
                        : const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
