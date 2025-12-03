import 'package:carthagoguide/constants/theme.dart';
import 'package:carthagoguide/widgets/category_row.dart';
import 'package:carthagoguide/widgets/circuit_card.dart';
import 'package:carthagoguide/widgets/destination_card.dart';
import 'package:carthagoguide/widgets/event_card.dart';
import 'package:carthagoguide/widgets/experiences_section.dart';
import 'package:carthagoguide/widgets/gallery_section.dart';
import 'package:carthagoguide/widgets/search_bar.dart';
import 'package:carthagoguide/widgets/section_title.dart';
import 'package:carthagoguide/widgets/video_banner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/destination_provider.dart';


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

final List<Map<String, String>> events = [
  {
    "title": "Carthage International Festival",
    "location": "Amphitheater of Carthage",
    "date": "26 JULY",
    "image": "assets/images/event1.jpg",
  },
  {
    "title": "Jazz à Carthage",
    "location": "Cité de la Culture, Tunis",
    "date": "17 MAR",
    "image": "assets/images/event2.jpg",
  },
  {
    "title": "International Festival of Hammamet",
    "location": "Hammamet",
    "date": "05 AUG",
    "image": "assets/images/event3.jpg",
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


class HomeScreen extends StatelessWidget {
  final VoidCallback? onMenuTap;

  const HomeScreen({super.key, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;

    final destinationProvider = Provider.of<DestinationProvider>(context);
    final destinations = destinationProvider.destinations;

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
              onPressed: onMenuTap,
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

                  CategoryRowWidget(theme: theme),
                  const SizedBox(height: 30),

                  VideoBanner(theme: theme),
                  const SizedBox(height: 30),

                  // ------- DESTINATIONS --------
                  SectionTitleWidget(title: "Destinations", theme: theme,showMore: true),
                  const SizedBox(height: 15),

                  if (destinationProvider.isLoading)
                    Center(
                        child:
                        CircularProgressIndicator(color: theme.primary)),
                  if (destinationProvider.error != null)
                    Text(
                      destinationProvider.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  if (!destinationProvider.isLoading &&
                      destinationProvider.error == null)
                    _buildHorizontalList(
                      height: 220,
                      itemCount: destinations.length < 6
                          ? destinations.length
                          : 6,
                      itemBuilder: (context, index) {
                        final d = destinations[index];
                        return DestinationCardWidget(
                          theme: theme,
                          title: d.name,
                          imgUrl:
                          d.gallery.first ?? d.cover ?? "",
                        );
                      },
                    ),

                  const SizedBox(height: 30),

                  ExperiencesReelSection(
                    theme: theme,
                    experiencesReels: experiencesReels,
                  ),
                  const SizedBox(height: 30),

                  SectionTitleWidget(title: "Circuits", theme: theme,showMore: true),
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

                  SectionTitleWidget(title: "Événements", theme: theme,showMore: true),
                  const SizedBox(height: 15),
                  _buildHorizontalList(
                    height: 250,
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return EventCardWidget(
                        theme: theme,
                        title: event["title"]!,
                        location: event["location"]!,
                        date: event["date"]!,
                        imgUrl: event["image"]!,
                      );
                    },
                  ),

                  const SizedBox(height: 30),
                  GallerySectionWidget(
                      theme: theme, galleryImages: galleryImages),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable horizontal list builder
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
