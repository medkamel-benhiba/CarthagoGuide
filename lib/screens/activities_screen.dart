import 'package:carthagoguide/constants/theme.dart';
import 'package:carthagoguide/widgets/activity_card.dart';
import 'package:carthagoguide/widgets/hotels/filters/filter_section.dart';
import 'package:carthagoguide/widgets/experiences_section.dart';
import 'package:carthagoguide/widgets/hotels/hotel_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

final List<Map<String, dynamic>> activitiesReels = [
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
final List<Map<String, dynamic>> activityList = [
  {
    "title": "Plongée sous-marine à Tabarka",
    "location": "Tabarka",
    "image": "assets/images/bizerte.jpg",
    "price": 80,
    "duration": "1/2 Journée",
  },
  {
    "title": "Randonnée dans l'Atlas Tunisien",
    "location": "Zaghouan",
    "image": "assets/images/circuit1.jpg",
    "price": 50,
    "duration": "Journée Complète",
  },
  {
    "title": "Visite du Musée du Bardo",
    "location": "Tunis",
    "image": "assets/images/carthage.jpg",
    "price": 10,
    "duration": "2 Heures",
  },
];


class ActivitiesScreen extends StatelessWidget {
  final VoidCallback? onMenuTap;

  const ActivitiesScreen({super.key, this.onMenuTap});

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
          onPressed: onMenuTap,
        ),
        title: Text(
          "Activités",
          style: TextStyle(color: theme.primary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBarWidget(theme: theme),
              const SizedBox(height: 25),

              /*ExperiencesReelSection(
                theme: theme,
                experiencesReels: activitiesReels,
              ),
              const SizedBox(height: 30),
*/
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Résultats (${activityList.length})",
                    style: TextStyle(
                      color: theme.text.withOpacity(0.6),
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                    ),
                  ),
                  FilterSection(theme: theme, type: FilterType.basic),

                ],
              ),
              const SizedBox(height: 15),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activityList.length,
                itemBuilder: (context, index) {
                  final activity = activityList[index];
                  return ActivityCardWidget(
                    theme: theme,
                    title: activity["title"],
                    location: activity["location"],
                    imgUrl: activity["image"],
                    price: activity["price"].toDouble(),
                    duration: activity["duration"],
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => ActivityDetailsScreen(...)));
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
