import 'package:CarthagoGuide/constants/theme.dart';
import 'package:CarthagoGuide/screens/mainScreen_container.dart';
import 'package:CarthagoGuide/utils/circuit_data_mapper.dart';
import 'package:CarthagoGuide/widgets/blinking_alert_button.dart';
import 'package:CarthagoGuide/widgets/dataFetch_status.dart';
import 'package:CarthagoGuide/widgets/category_row.dart';
import 'package:CarthagoGuide/widgets/circuit_card.dart';
import 'package:CarthagoGuide/widgets/homeDestSection.dart';
import 'package:CarthagoGuide/widgets/event_card.dart';
import 'package:CarthagoGuide/widgets/experiences_section.dart';
import 'package:CarthagoGuide/widgets/gallery_section.dart';
import 'package:CarthagoGuide/widgets/horizental_list_view.dart';
import 'package:CarthagoGuide/widgets/search_bar.dart';
import 'package:CarthagoGuide/widgets/section_title.dart';
import 'package:CarthagoGuide/widgets/skeleton_cards/circuit_card_skeleton.dart';
import 'package:CarthagoGuide/widgets/skeleton_cards/destination_card_skeleton.dart';
import 'package:CarthagoGuide/widgets/skeleton_cards/event_card_skeleton.dart';
import 'package:CarthagoGuide/widgets/video_banner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:CarthagoGuide/providers/destination_provider.dart';
import 'package:CarthagoGuide/providers/event_provider.dart';
import 'package:CarthagoGuide/providers/voyage_provider.dart';

final List<Map<String, dynamic>> experiencesReels = [
  {
    "title": "Adventure",
    "preview_image": "assets/images/djerba.jpg",
    "segments": [
      {"type": "image", "url": "assets/images/event1.jpg"},
      {"type": "image", "url": "assets/images/event4.jpg"},
    ],
  },
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
  const HomeScreen({super.key});

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
      Provider.of<VoyageProvider>(context, listen: false).fetchVoyages();
    });
  }

  void _toggleDrawer() {
    final containerState = context.findAncestorStateOfType<MainScreenContainerState>();
    containerState?.toggleDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final destinationProvider = Provider.of<DestinationProvider>(context);
    final destinations = destinationProvider.destinations;
    final eventProvider = Provider.of<EventProvider>(context);
    final events = eventProvider.events;
    final voyageProvider = Provider.of<VoyageProvider>(context);
    final voyages = voyageProvider.voyages;
    final locale = Localizations.localeOf(context);

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
              onPressed: _toggleDrawer,
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
              BlinkingAlertButton(
                baseColor: theme.primary,
                alertColor: Colors.grey,
                onPressed: () => context.go('/chatbot'),
              ),
              const SizedBox(width: 5),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchBarWidget(theme: theme),
                  const SizedBox(height: 20),
                  ExperiencesReelSection(
                    theme: theme,
                    experiencesReels: experiencesReels,
                  ),
                  const SizedBox(height: 20),

                  VideoBanner(theme: theme),
                  const SizedBox(height: 20),
                  CategoryRowWidget(
                    theme: theme,
                    onDestinationsTap: () => context.go('/destinations'),
                    onHotelsTap: () => context.go('/hotels'),
                    onRestaurantsTap: () => context.go('/restaurants'),
                    onCircuitsTap: () => context.go('/circuits'),
                    onChatBotTap: () => context.go('/chatbot'),
                  ),
                  const SizedBox(height: 20),

                  SectionTitleWidget(
                    title: "Destinations",
                    theme: theme,
                    showMore: true,
                    onTap: () => context.go('/destinations'),
                  ),
                  const SizedBox(height: 10),

                  // Destinations Section
                  if (destinationProvider.isLoading)
                    HorizontalListView(
                      height: 200,
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return DestinationCardSkeleton(theme: theme);
                      },
                    )
                  else if (!destinationProvider.isLoading &&
                      destinations.isNotEmpty)
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

                  const SizedBox(height: 20),

                  SectionTitleWidget(
                    title: "Circuits",
                    theme: theme,
                    showMore: true,
                    onTap: () => context.go('/circuits'),
                  ),
                  const SizedBox(height: 10),

                  if (voyageProvider.isLoading)
                    HorizontalListView(
                      height: 180,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return CircuitCardSkeleton(theme: theme);
                      },
                    ),

                  if (!voyageProvider.isLoading &&
                      voyageProvider.error == null &&
                      voyages.isNotEmpty)
                    HorizontalListView(
                      height: 180,
                      itemCount: voyages.length < 6 ? voyages.length : 6,
                      itemBuilder: (context, index) {
                        final voyage = voyages[index];
                        final circuit = voyageToCircuitCardData(voyage, locale);
                        return GestureDetector(
                          onTap: () {
                            context.push(
                              '/circuit-details/${voyage.id}',
                              extra: {'circuit': voyage},
                            );
                          },
                          child: CircuitCardWidget(
                            theme: theme,
                            title: circuit["title"]!,
                            subtitle: circuit["subtitle"]!,
                            imgUrl: circuit["image"]!,
                          ),
                        );
                      },
                    ),

                  DataFetchStatusWidget(
                    theme: theme,
                    errorMessage: voyageProvider.error,
                    isLoading: voyageProvider.isLoading,
                    itemCount: voyages.length,
                    onRetry: () => Provider.of<VoyageProvider>(
                      context,
                      listen: false,
                    ).fetchVoyages(),
                    emptyMessage: "Aucun circuit disponible pour le moment.",
                  ),

                  const SizedBox(height: 20),

                  SectionTitleWidget(
                    title: "Événements",
                    theme: theme,
                    showMore: true,
                    onTap: () => context.go('/events'),
                  ),
                  const SizedBox(height: 10),

                  // Events Section
                  if (eventProvider.isLoading)
                    HorizontalListView(
                      height: 250,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return EventCardSkeleton(theme: theme);
                      },
                    ),

                  if (!eventProvider.isLoading &&
                      eventProvider.errorMessage == null &&
                      events.isNotEmpty)
                    HorizontalListView(
                      height: 240,
                      itemCount: events.length < 6 ? events.length : 6,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return EventCardWidget(
                          theme: theme,
                          title: event.title ?? "Événement sans titre",
                          location: event.address ?? "Lieu non spécifié",
                          date: event.startDate ?? "Date non spécifiée",
                          imgUrl: event.cover ?? event.image ?? "",
                        );
                      },
                    ),

                  DataFetchStatusWidget(
                    theme: theme,
                    errorMessage: eventProvider.errorMessage,
                    isLoading: eventProvider.isLoading,
                    itemCount: events.length,
                    onRetry: () => Provider.of<EventProvider>(
                      context,
                      listen: false,
                    ).fetchEvents(),
                    emptyMessage: "Aucun événement disponible pour le moment.",
                  ),

                  const SizedBox(height: 20),

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
}