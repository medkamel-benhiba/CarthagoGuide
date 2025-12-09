import 'package:CarthagoGuide/constants/theme.dart';
import 'package:CarthagoGuide/screens/destinationDetails_screen.dart';
import 'package:CarthagoGuide/widgets/category_row.dart';
import 'package:CarthagoGuide/widgets/circuit_card.dart';
import 'package:CarthagoGuide/widgets/destination_card.dart';
import 'package:CarthagoGuide/widgets/homeDestSection.dart';
import 'package:CarthagoGuide/widgets/event_card.dart';
import 'package:CarthagoGuide/widgets/experiences_section.dart';
import 'package:CarthagoGuide/widgets/gallery_section.dart';
import 'package:CarthagoGuide/widgets/search_bar.dart';
import 'package:CarthagoGuide/widgets/section_title.dart';
import 'package:CarthagoGuide/widgets/video_banner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:CarthagoGuide/providers/destination_provider.dart';
import 'package:CarthagoGuide/providers/event_provider.dart';
import 'package:CarthagoGuide/widgets/skeleton_box.dart';


final List<Map<String, dynamic>> experiencesReels = [
  {
    "title": "Kairouan Vibes",
    "preview_image": "assets/images/carthage.jpg",
    "segments": [
      {"type": "image", "url": "assets/images/circuit1.jpg"},
      {"type": "image", "url": "assets/images/circuit2.jpg"},
      {"type": "image", "url": "assets/images/circuit3.jpg"},
    ],
  },
  {
    "title": "Adventure",
    "preview_image": "assets/images/djerba.jpg",
    "segments": [
      {"type": "image", "url": "assets/images/event1.jpg"},
      {"type": "image", "url": "assets/images/event4.jpg"},
    ],
  },
  {
    "title": "Local Food",
    "preview_image": "assets/images/sidibou.jpg",
    "segments": [
      {"type": "image", "url": "assets/images/tozeur.jpg"},
      {"type": "image", "url": "assets/images/sousse.jpg"},
      {"type": "image", "url": "assets/images/event2.jpg"},
    ],
  },
  {
    "title": "Desert Trip",
    "preview_image": "assets/images/event2.jpg",
    "segments": [
      {"type": "image", "url": "assets/images/bizerte.jpg"},
      {"type": "image", "url": "assets/images/event3.jpg"},
    ],
  },
  {
    "title": "Beach Day",
    "preview_image": "assets/images/tozeur.jpg",
    "segments": [
      {"type": "image", "url": "assets/images/sousse.jpg"},
    ],
  },
  {
    "title": "Museums",
    "preview_image": "assets/images/event3.jpg",
    "segments": [
      {"type": "image", "url": "assets/images/sidibou.jpg"},
      {"type": "image", "url": "assets/images/tozeur.jpg"},
      {"type": "image", "url": "assets/images/circuit2.jpg"},
    ],
  },
];

final List<Map<String, String>> circuitTours = [
  {
    "title": "Sahara Desert Expedition",
    "subtitle": "3 Days | Tozeur, Douz",
    "image": "assets/images/circuit1.jpg",
  },
  {
    "title": "Ancient Carthage Route",
    "subtitle": "1 Day | Tunis, Carthage, Sidi Bou Said",
    "image": "assets/images/circuit2.jpg",
  },
  {
    "title": "Oasis Discovery",
    "subtitle": "4 Days | Mountain Oases, Chott El Djerid",
    "image": "assets/images/circuit3.jpg",
  },
];

final List<String> galleryImages = [
  "assets/images/bizerte.jpg",
  "assets/images/sidibou.jpg",
  "assets/images/djerba.jpg",
  "assets/images/tozeur.jpg",
  "assets/images/carthage.jpg",
  "assets/images/circuit1.jpg",
  "assets/images/sousse.jpg",
];

class HomeScreen extends StatefulWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onNavigateToDestinations;
  final VoidCallback? onNavigateToHotels;
  final VoidCallback? onNavigateToRestaurants;
  final VoidCallback? onNavigateToCircuits;

  const HomeScreen({
    super.key,
    this.onMenuTap,
    this.onNavigateToDestinations,
    this.onNavigateToHotels,
    this.onNavigateToRestaurants,
    this.onNavigateToCircuits,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  void _fetchInitialData() {
    Future.microtask(() {
      Provider.of<EventProvider>(context, listen: false).fetchEvents();
    });
  }

  Widget _buildDestinationCardSkeleton(AppTheme theme) {
    return Container(
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
            // Skeleton for image
            Positioned.fill(
              child: SkeletonBox(
                theme: theme,
                width: double.infinity,
                height: double.infinity,
                radius: 0,
              ),
            ),

            // Gradient overlay (same as HomeDestCard)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.25),
                      Colors.black.withOpacity(0.6),
                    ],
                    stops: const [0.3, 1.0],
                  ),
                ),
              ),
            ),

            // Skeleton for title/text
            Positioned(
              left: 35,
              right: 35,
              top: 20,
              bottom: 20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SkeletonBox(theme: theme, width: 120, height: 20, radius: 8),
                  const SizedBox(height: 8),
                  SkeletonBox(theme: theme, width: 80, height: 16, radius: 6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildEventCardSkeleton(AppTheme theme) {
    return AspectRatio(
      aspectRatio: 0.7,
      child: SkeletonBox(
        theme: theme,
        width: double.infinity,
        height: double.infinity,
        radius: 20,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(theme: theme, width: 100, height: 16, radius: 4),
              const SizedBox(height: 5),
              SkeletonBox(theme: theme, width: 60, height: 12, radius: 4),
            ],
          ),
        ),
      ),
    );
  }

  // New reusable widget for error/empty state
  Widget _buildErrorOrEmptyState({
    required AppTheme theme,
    required String? errorMessage,
    required bool isLoading,
    required int itemCount,
    required VoidCallback onRetry,
    required String emptyMessage,
  }) {
    // If loading, do nothing here (loading state is handled elsewhere)
    if (isLoading) return const SizedBox.shrink();

    // 1. Connection Error
    if (errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xff8d0d0d), size: 40),
            const SizedBox(height: 10),
            Text(
              "Erreur de Connexion",
              style: TextStyle(
                color: theme.text,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "Veuillez vérifier votre connexion Internet et réessayer.",
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.text.withOpacity(0.7)),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text("Réessayer"),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (itemCount == 0) {
      return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Text(
          emptyMessage,
          style: TextStyle(color: theme.text.withOpacity(0.6)),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final destinationProvider = Provider.of<DestinationProvider>(context);
    final destinations = destinationProvider.destinations;
    final eventProvider = Provider.of<EventProvider>(context);
    final events = eventProvider.events;

    return Scaffold(
      backgroundColor: theme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: theme.background,
            elevation: 0,
            floating: true,
            leading: IconButton(
              icon: Icon(Icons.menu_rounded, color: theme.text),
              onPressed: widget.onMenuTap,
            ),
            title: SizedBox(
              height: 50,
              child: Image.asset(
                'assets/images/carthagoBanner2.png',
                fit: BoxFit.contain,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: CircleAvatar(
                  backgroundColor: theme.primary.withOpacity(0.1),
                  child: Icon(Icons.person, color: theme.primary),
                ),
                onPressed: () {},
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchBarWidget(theme: theme),
                  const SizedBox(height: 25),

                  CategoryRowWidget(
                    theme: theme,
                    onDestinationsTap: widget.onNavigateToDestinations,
                    onHotelsTap: widget.onNavigateToHotels,
                    onRestaurantsTap: widget.onNavigateToRestaurants,
                    onCircuitsTap: widget.onNavigateToCircuits,
                  ),
                  const SizedBox(height: 30),

                  VideoBanner(theme: theme),
                  const SizedBox(height: 30),

                  // ------- DESTINATIONS --------
                  SectionTitleWidget(
                    title: "Destinations",
                    theme: theme,
                    showMore: true,
                    onTap: widget.onNavigateToDestinations,
                  ),
                  const SizedBox(height: 15),

                  if (destinationProvider.isLoading)
                    _buildHorizontalList(
                      height: 200,
                      itemCount: 1, // Number of skeleton cards to show
                      itemBuilder: (context, index) {
                        return _buildDestinationCardSkeleton(theme);
                      },
                    )
                  else if (!destinationProvider.isLoading && destinations.isNotEmpty)
                    NearbyDestinationSection(
                      destinations: destinations.take(10).toList(),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Aucune destination disponible pour le moment.",
                        style: TextStyle(color: theme.text.withOpacity(0.6)),
                      ),
                    ),

/*
                  if (destinationProvider.isLoading)
                    _buildHorizontalList(
                      height: 220,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return _buildDestinationCardSkeleton(theme);
                      },
                    ),

                  // Conditional rendering for Destinations
                  if (!destinationProvider.isLoading && destinationProvider.error == null && destinations.isNotEmpty)
                    _buildHorizontalList(
                      height: 220,
                      itemCount: destinations.length < 6 ? destinations.length : 6,
                      itemBuilder: (context, index) {
                        final d = destinations[index];
                        return DestinationCardWidget(
                          theme: theme,
                          title: d.name,
                          imgUrl: d.gallery.first ?? d.cover ?? "",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DestinationDetailsScreen(
                                  title: d.name,
                                  description: d.descriptionMobile ?? "",
                                  gallery: d.gallery,
                                  destinationId: d.id,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),

                  _buildErrorOrEmptyState(
                    theme: theme,
                    errorMessage: destinationProvider.error,
                    isLoading: destinationProvider.isLoading,
                    itemCount: destinations.length,
                    onRetry: () {
                      Provider.of<DestinationProvider>(context, listen: false).fetchDestinations();
                    },
                    emptyMessage: "Aucune destination disponible pour le moment.",
                  ),*/

                  const SizedBox(height: 20),

                  ExperiencesReelSection(
                    theme: theme,
                    experiencesReels: experiencesReels,
                  ),
                  const SizedBox(height: 30),

                  SectionTitleWidget(
                    title: "Circuits",
                    theme: theme,
                    showMore: true,
                  ),
                  const SizedBox(height: 15),
                  _buildHorizontalList(
                    height: 180,
                    itemCount: circuitTours.length,
                    itemBuilder: (context, index) {
                      final circuit = circuitTours[index];
                      return CircuitCardWidget(
                        theme: theme,
                        title: circuit["title"]!,
                        subtitle: circuit["subtitle"]!,
                        imgUrl: circuit["image"]!,
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  SectionTitleWidget(
                    title: "Événements",
                    theme: theme,
                    showMore: true,
                  ),
                  const SizedBox(height: 15),

                  if (eventProvider.isLoading)
                    _buildHorizontalList(
                      height: 250,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return _buildEventCardSkeleton(theme);
                      },
                    ),

                  // Conditional rendering for Events
                  if (!eventProvider.isLoading && eventProvider.errorMessage == null && events.isNotEmpty)
                    _buildHorizontalList(
                      height: 250,
                      itemCount: events.length < 6 ? events.length : 6,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return EventCardWidget(
                          theme: theme,
                          title: event.title ?? "Événement sans titre",
                          location: event.address ?? "Lieu non spécifié",
                          date: event.startDate ?? "Date non spécifiée",
                          imgUrl: event.cover ?? event.image ?? "",
                          // TODO: Implement navigation to EventDetailsScreen
                        );
                      },
                    ),

                  // NEW: Error/Empty State for Events
                  _buildErrorOrEmptyState(
                    theme: theme,
                    errorMessage: eventProvider.errorMessage,
                    isLoading: eventProvider.isLoading,
                    itemCount: events.length,
                    onRetry: () => Provider.of<EventProvider>(context, listen: false).fetchEvents(),
                    emptyMessage: "Aucun événement disponible pour le moment.",
                  ),

                  const SizedBox(height: 30),

                  GallerySectionWidget(
                    theme: theme,
                    galleryImages: galleryImages,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalList({
    required double height,
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
  }) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(width: 15),
        itemBuilder: itemBuilder,
      ),
    );
  }
}