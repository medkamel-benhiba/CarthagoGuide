import 'dart:async'; // Import for Timer

import 'package:CarthagoGuide/models/destination.dart';
import 'package:CarthagoGuide/screens/destinationDetails_screen.dart';
import 'package:CarthagoGuide/widgets/homeDestCard.dart';
import 'package:flutter/material.dart';

class NearbyDestinationSection extends StatefulWidget {
  final List<Destination> destinations;

  const NearbyDestinationSection({Key? key, required this.destinations})
    : super(key: key);

  @override
  State<NearbyDestinationSection> createState() =>
      _NearbyDestinationSectionState();
}

class _NearbyDestinationSectionState extends State<NearbyDestinationSection> {
  int currentIndex = 0;
  // 1. Declare the Timer
  Timer? _timer;
  // 2. Define the scroll duration
  final Duration _autoScrollDuration = const Duration(seconds: 5);

  // Method to start the timer for automatic scrolling
  void _startAutoScroll() {
    // Only start the timer if there's more than one destination
    if (widget.destinations.length > 1) {
      _timer = Timer.periodic(_autoScrollDuration, (Timer timer) {
        setState(() {
          // Calculate the index of the next card
          currentIndex = (currentIndex + 1) % widget.destinations.length;
        });
      });
    }
  }

  // Method to stop the timer (useful when the user interacts or the widget is disposed)
  void _stopAutoScroll() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void initState() {
    super.initState();
    // 3. Start the auto-scroll when the widget is initialized
    _startAutoScroll();
  }

  @override
  void dispose() {
    // 4. Cancel the timer when the widget is removed from the widget tree
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
      // 5. If empty, ensure the timer is stopped (though unlikely to be running here)
      _stopAutoScroll();
      return const SizedBox.shrink();
    }

    // Check if auto-scroll should be active. If there is only one item, stop the scroll.
    if (widget.destinations.length <= 1 && _timer != null) {
      _stopAutoScroll();
    } else if (widget.destinations.length > 1 && _timer == null) {
      _startAutoScroll(); // Restart if more items are added dynamically
    }

    final bool hasNext = currentIndex < widget.destinations.length - 1;
    final bool hasNextNext = currentIndex < widget.destinations.length - 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: SizedBox(
            height: 200,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // 1. Third Card (Farthest Back)
                if (widget.destinations.length >
                    2) // Check if there are at least 3 items
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 10,
                    height: 200,
                    child: SizedBox(
                      width: double.infinity,
                      height: 250,
                      child: Opacity(
                        // Use modulo arithmetic for wrapping destinations
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

                // 2. Second Card (Middle Layer)
                if (widget.destinations.length >
                    1) // Check if there are at least 2 items
                  Positioned(
                    left: 0,
                    right: 30,
                    top: 10,
                    height: 200,
                    child: SizedBox(
                      width: double.infinity,
                      height: 250,
                      child: Opacity(
                        // Use modulo arithmetic for wrapping destinations
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
                  height: 200,
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
                        // Swiped left (to next card)
                        if (currentIndex < widget.destinations.length - 1) {
                          setState(() {
                            currentIndex++;
                          });
                        } else {
                          // Wrap around to the first card
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
                        // Use a key to enable AnimatedSwitcher to animate between different cards
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

        // Page indicators
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
