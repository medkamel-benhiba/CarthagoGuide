import 'package:CarthagoGuide/constants/theme.dart';
import 'package:CarthagoGuide/screens/activityDetails_screen.dart';
import 'package:CarthagoGuide/screens/mainScreen_container.dart';
import 'package:CarthagoGuide/widgets/activity_card.dart';
import 'package:CarthagoGuide/widgets/hotels/hotel_searchbar.dart';
import 'package:CarthagoGuide/providers/activity_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  void _toggleDrawer() {
    final containerState = context.findAncestorStateOfType<MainScreenContainerState>();
    containerState?.toggleDrawer();
  }

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
          onPressed: _toggleDrawer,
        ),
        title: Text(
          "Activités",
          style: TextStyle(color: theme.primary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Consumer<ActivityProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonContainer(
                      height: 50,
                      width: double.infinity,
                      borderRadius: 12,
                      theme: theme,
                    ),
                    const SizedBox(height: 25),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4,
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

          // ✅ FIXED: Just use provider.activities directly
          final activities = provider.activities;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchBarWidget(
                    theme: theme,
                    onChanged: (query) {
                      provider.setSearchQuery(query);
                    },
                  ),
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

                  // Show empty state if no results
                  if (activities.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: theme.text.withOpacity(0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Aucune activité trouvée",
                              style: TextStyle(
                                color: theme.text.withOpacity(0.6),
                                fontSize: 16,
                              ),
                            ),
                            if (provider.searchQuery.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () => provider.clearSearch(),
                                child: Text(
                                  "Effacer la recherche",
                                  style: TextStyle(color: theme.primary),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                  // Activity list with staggered animation
                  if (activities.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: activities.length,
                      itemBuilder: (context, index) {
                        final activity = activities[index];
                        final imageUrl = (activity.vignette != null && activity.vignette!.isNotEmpty)
                            ? activity.vignette!
                            : (activity.cover ?? "");

                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: Duration(milliseconds: 300 + (index * 50)),
                          curve: Curves.easeOutQuart,
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(0, 30 * (1 - value)),
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
                            category: activity.subtype.toString(),
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

// --- SKELETON WIDGETS ---

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
  Key _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: _key,
      tween: Tween(begin: 0.2, end: 0.8),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      onEnd: () {
        if (mounted) {
          setState(() {
            _key = UniqueKey();
          });
        }
      },
      builder: (context, opacity, child) {
        return Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            color: widget.theme.primary.withOpacity(opacity * 0.2),
          ),
        );
      },
    );
  }
}

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
          SkeletonContainer(
            height: cardHeight,
            width: double.infinity,
            borderRadius: borderRadius,
            theme: theme,
          ),
          Positioned(
            left: padding,
            bottom: 40,
            child: SkeletonContainer(
              height: 20,
              width: 180,
              borderRadius: 4,
              theme: theme,
            ),
          ),
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