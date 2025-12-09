import 'package:CarthagoGuide/constants/theme.dart';
import 'package:CarthagoGuide/screens/activityDetails_screen.dart';
import 'package:CarthagoGuide/widgets/activity_card.dart';
import 'package:CarthagoGuide/widgets/hotels/hotel_searchbar.dart';
import 'package:CarthagoGuide/providers/activity_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActivitiesScreen extends StatefulWidget {
  final VoidCallback? onMenuTap;
  const ActivitiesScreen({super.key, this.onMenuTap});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ActivityProvider>(context, listen: false).fetchAllActivities();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: theme.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu_rounded, color: theme.text),
          onPressed: widget.onMenuTap,
        ),
        title: Text(
          "Activités",
          style: TextStyle(color: theme.primary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Consumer<ActivityProvider>(
        builder: (context, provider, child) {
          // 1. Loading State (MODIFIED: Display skeleton loading effect)
          if (provider.isLoading) {
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(), // Prevent scrolling while loading
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // A placeholder for the search bar
                    SkeletonContainer(
                      height: 50,
                      width: double.infinity,
                      borderRadius: 12,
                      theme: theme,
                    ),
                    const SizedBox(height: 25),

                    // Display 4 skeleton cards
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4, // Number of skeleton items to show
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: SkeletonActivityCard(theme: theme),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          // 2. Error State
          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                  const SizedBox(height: 10),
                  Text(provider.errorMessage!, style: TextStyle(color: theme.text)),
                  TextButton(
                    onPressed: () => provider.forceRefresh(),
                    child: const Text("Réessayer"),
                  )
                ],
              ),
            );
          }

          // 3. Data Loaded
          final activities = provider.activities.isNotEmpty
              ? provider.activities
              : provider.allActivities;

          // REMOVED RefreshIndicator and kept its child content
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchBarWidget(theme: theme),
                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Résultats (${activities.length})",
                        style: TextStyle(
                          color: theme.text.withOpacity(0.6),
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Animated List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      final activity = activities[index];
                      final imageUrl = (activity.vignette != null && activity.vignette!.isNotEmpty)
                          ? activity.vignette!
                          : (activity.cover ?? "");

                      // Animation wrapper
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 400 + (index * 100)), // Staggered effect
                        curve: Curves.easeOutQuart,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 50 * (1 - value)),
                            child: Opacity(
                              opacity: value,
                              child: child,
                            ),
                          );
                        },
                        child: ActivityCardWidget(
                          theme: theme,
                          title: activity.title ?? "Sans titre",
                          destId: activity.destinationId ?? "Tunisie",
                          imgUrl: imageUrl,
                          //price: priceString,
                          category: activity.subtype.toString(),
                          //rating: (activity.rate ?? 0).toDouble(),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ActivityDetailsScreen(activity: activity),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  // Add padding at bottom for scrolling clearance
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// --- SKELETON WIDGETS (SkeletonContainer is now Stateful) ---

/// A reusable container that provides the animated, pulsating skeleton effect.
/// CONVERTED TO STATEFUL WIDGET TO ACCESS 'mounted' and safely restart the animation.
class SkeletonContainer extends StatefulWidget {
  final double height;
  final double width;
  final double borderRadius;
  final AppTheme theme;

  const SkeletonContainer({
    super.key,
    required this.height,
    required this.width,
    this.borderRadius = 8,
    required this.theme,
  });

  @override
  State<SkeletonContainer> createState() => _SkeletonContainerState();
}

class _SkeletonContainerState extends State<SkeletonContainer> {
  // Key used to force the TweenAnimationBuilder to rebuild and restart the animation
  // without relying on context.reassemble() or a permanent setState loop.
  Key _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: _key, // Use the key to trigger the rebuild
      tween: Tween(begin: 0.2, end: 0.8), // Animate opacity from 0.2 to 0.8
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      onEnd: () {
        // Now 'mounted' is safe to use as we are in a State object.
        if (mounted) {
          setState(() {
            _key = UniqueKey(); // Change the key to restart the animation
          });
        }
      },
      builder: (context, opacity, child) {
        return Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            // Use a light version of the primary color for the skeleton effect
            color: widget.theme.primary.withOpacity(opacity * 0.2),
          ),
        );
      },
    );
  }
}

/// A skeleton card widget that mimics the layout of ActivityCardWidget.
class SkeletonActivityCard extends StatelessWidget {
  final AppTheme theme;

  const SkeletonActivityCard({super.key, required this.theme});

  static const double cardHeight = 220;
  static const double borderRadius = 16;
  static const double padding = 16;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Stack(
        children: [
          // Background/Image placeholder
          SkeletonContainer(
            height: cardHeight,
            width: double.infinity,
            borderRadius: borderRadius,
            theme: theme,
          ),

          // Title placeholder
          Positioned(
            left: padding,
            bottom: 40,
            child: SkeletonContainer(
              height: 20,
              width: 180, // A medium-sized line for the title
              borderRadius: 4,
              theme: theme,
            ),
          ),

          // Location placeholder
          Positioned(
            left: padding,
            bottom: padding,
            child: SkeletonContainer(
              height: 14,
              width: 120,
              borderRadius: 4,
              theme: theme,
            ),
          ),
        ],
      ),
    );
  }
}