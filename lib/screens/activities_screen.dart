import 'package:carthagoguide/constants/theme.dart';
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

class ActivityCardWidget extends StatelessWidget {
  final AppTheme theme;
  final String title;
  final String location;
  final String imgUrl;
  final double price;
  final String duration;
  final VoidCallback onTap;

  const ActivityCardWidget({
    super.key,
    required this.theme,
    required this.title,
    required this.location,
    required this.imgUrl,
    required this.price,
    required this.duration,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.CardBG,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: theme.text.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imgUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: theme.text,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: theme.primary, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        location,
                        style: TextStyle(
                          color: theme.text.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          duration,
                          style: TextStyle(color: theme.primary, fontSize: 12),
                        ),
                      ),
                      Text(
                        "${price.toStringAsFixed(0)} TND",
                        style: TextStyle(
                          color: theme.text,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
